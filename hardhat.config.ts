import hardhatToolboxViemPlugin from "@nomicfoundation/hardhat-toolbox-viem";
import { defineConfig } from "hardhat/config";

// Groupe 4 - A11. Reseau Hardhat local uniquement (cahier des charges 10.3) :
// aucune cle privee, aucun RPC mainnet ou testnet public.
export default defineConfig({
  plugins: [hardhatToolboxViemPlugin],
  solidity: {
    profiles: {
      default: {
        // Version figee pour la reproductibilite ; compatible avec le pragma ^0.8.20 du cours (Ch08).
        version: "0.8.28",
      },
    },
  },
  networks: {
    hardhatMainnet: {
      type: "edr-simulated",
      chainType: "l1",
    },
  },
});
