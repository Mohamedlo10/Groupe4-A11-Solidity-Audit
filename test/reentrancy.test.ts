// Tests d'acceptation du cas pratique « coffre et réentrance » (cahier des charges §6.3).
// Réseau Hardhat local uniquement. Lancement : npx hardhat test
import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { network } from "hardhat";
import { formatEther, parseEther } from "viem";

// Scénario borné et déterministe (§6.2)
const DEPOT_VICTIME = parseEther("10"); // déposant légitime (« Alice »)
const MISE_ATTAQUANT = parseEther("1"); // mise du contrat attaquant (« Modou »)
const MAX_TENTATIVES = 20n;             // borne de sécurité dans Attacker
const REENTREES_ATTENDUES = 10n;        // 10 ETH de la victime / 1 ETH par retrait

type NomCoffre = "VulnerableVault" | "SecureVault";

describe("Réentrance : coffre du cours (Ch08)", async function () {
  const { viem } = await network.create();
  const publicClient = await viem.getPublicClient();
  const [, alice, modou] = await viem.getWalletClients();

  const solde = (address: `0x${string}`) => publicClient.getBalance({ address });

  // Déploie le coffre, fait déposer Alice puis l'attaquant (étapes 1-2 du scénario).
  async function preparer(nom: NomCoffre) {
    const coffre = await viem.deployContract(nom);
    await coffre.write.deposer({ value: DEPOT_VICTIME, account: alice.account });

    const attaquant = await viem.deployContract(
      "Attacker",
      [coffre.address, MAX_TENTATIVES],
      { client: { wallet: modou } },
    );
    await attaquant.write.deposer({ value: MISE_ATTAQUANT, account: modou.account });
    return { coffre, attaquant };
  }

  async function attaquer(nom: NomCoffre) {
    const { coffre, attaquant } = await preparer(nom);
    const avant = { coffre: await solde(coffre.address), attaquant: await solde(attaquant.address) };
    const blocDepart = await publicClient.getBlockNumber();

    await attaquant.write.attaquer({ account: modou.account });

    const apres = { coffre: await solde(coffre.address), attaquant: await solde(attaquant.address) };
    const traces = await publicClient.getContractEvents({
      address: attaquant.address,
      abi: attaquant.abi,
      eventName: "Reentree",
      fromBlock: blocDepart,
      strict: true,
    });

    console.log(`\n  [${nom}] soldes ETH avant / après l'attaque`);
    console.table({
      coffre: { avant: formatEther(avant.coffre), apres: formatEther(apres.coffre) },
      attaquant: { avant: formatEther(avant.attaquant), apres: formatEther(apres.attaquant) },
    });
    console.log(
      `  [${nom}] réentrées : ` +
        traces.map((t) => `#${t.args.numero} (coffre = ${formatEther(t.args.soldeCoffreAvant)} ETH)`).join(", "),
    );

    return { coffre, attaquant, avant, apres, traces };
  }

  for (const nom of ["VulnerableVault", "SecureVault"] as const) {
    it(`${nom} : accepte les dépôts et enregistre les soldes (critères 1-2)`, async function () {
      const { coffre, attaquant } = await preparer(nom);
      assert.equal(await coffre.read.soldes([alice.account.address]), DEPOT_VICTIME);
      assert.equal(await coffre.read.soldes([attaquant.address]), MISE_ATTAQUANT);
      assert.equal(await solde(coffre.address), DEPOT_VICTIME + MISE_ATTAQUANT);
    });

    it(`${nom} : un utilisateur honnête peut retirer ses fonds`, async function () {
      const coffre = await viem.deployContract(nom);
      await coffre.write.deposer({ value: DEPOT_VICTIME, account: alice.account });
      await coffre.write.retirer({ account: alice.account });
      assert.equal(await coffre.read.soldes([alice.account.address]), 0n);
      assert.equal(await solde(coffre.address), 0n);
    });
  }

  it("VulnerableVault : la réentrance vide le coffre (critères 3-4)", async function () {
    const { coffre, attaquant, avant, apres, traces } = await attaquer("VulnerableVault");

    assert.equal(avant.coffre, DEPOT_VICTIME + MISE_ATTAQUANT);
    // Appels imbriqués : 1 retrait initial + 10 réentrées
    assert.equal(await attaquant.read.tentatives(), REENTREES_ATTENDUES);
    assert.equal(await attaquant.read.echecs(), 0n);
    assert.equal(BigInt(traces.length), REENTREES_ATTENDUES);
    // Le coffre est vide et l'attaquant a pris plus que sa mise : les 10 ETH d'Alice
    assert.equal(apres.coffre, 0n);
    assert.equal(apres.attaquant, DEPOT_VICTIME + MISE_ATTAQUANT);
    assert.ok(apres.attaquant > MISE_ATTAQUANT);
    // Le registre du coffre croit toujours qu'Alice possède 10 ETH : fonds introuvables
    assert.equal(await coffre.read.soldes([alice.account.address]), DEPOT_VICTIME);
    await assert.rejects(coffre.write.retirer({ account: alice.account }));
  });

  it("SecureVault : le même scénario ne vole pas le déposant légitime (critère 5)", async function () {
    const { coffre, attaquant, avant, apres, traces } = await attaquer("SecureVault");

    assert.equal(avant.coffre, DEPOT_VICTIME + MISE_ATTAQUANT);
    // Une seule tentative de réentrée, bloquée, sans faire échouer le retrait de la mise
    assert.equal(await attaquant.read.tentatives(), 1n);
    assert.equal(await attaquant.read.echecs(), 1n);
    assert.equal(traces.length, 1);
    // L'attaquant ne récupère que sa mise, les 10 ETH d'Alice restent dans le coffre
    assert.equal(apres.attaquant, MISE_ATTAQUANT);
    assert.equal(apres.coffre, DEPOT_VICTIME);
    assert.equal(await coffre.read.soldes([attaquant.address]), 0n);
    // Alice peut toujours retirer ses fonds
    await coffre.write.retirer({ account: alice.account });
    assert.equal(await solde(coffre.address), 0n);
  });

  it("SecureVault : la tentative est bloquée par le verrou nonReentrant", async function () {
    const { attaquant } = await attaquer("SecureVault");
    const [bloquee] = await publicClient.getContractEvents({
      address: attaquant.address,
      abi: attaquant.abi,
      eventName: "ReentreeBloquee",
      fromBlock: 0n,
      strict: true,
    });
    assert.ok(bloquee, "aucune réentrée bloquée");
    // Sélecteur de l'erreur ReentrancyGuardReentrantCall() d'OpenZeppelin
    assert.equal(bloquee.args.raison, "0x3ee5aeb5");
  });
});
