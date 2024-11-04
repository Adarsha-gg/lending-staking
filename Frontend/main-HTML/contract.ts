import { privateKeyToAccount } from "viem/accounts"
import { createPublicClient, http, formatEther, Hex, createWalletClient, custom, publicActions, parseAbi, getContract } from "viem";

import {sepolia} from "viem/chains"
import dotenv from "dotenv";
import yielder from "../../out/lending.sol/YieldFarming.json";

dotenv.config();
const contract_abi = yielder["abi"];
const privateKey = process.env.PRIVATE_KEY;
const account = privateKeyToAccount(privateKey as Hex);

(async () => {
      const hash = "0x6874327be1339df98e6c471dd7495b72b259518b75a913f6c34445340885ce58";
  
      const WalletClient = createWalletClient({
        account: account,
        chain: sepolia,
        transport: http(process.env.SEPOLIA_RPC),
      });

      const clienter = createPublicClient({
        chain: sepolia,
        transport: http(process.env.SEPOLIA_RPC),
      });

      const {contractAddress} = await clienter.getTransactionReceipt({hash});

      if (contractAddress)
        {
          const contract = getContract({
            address: contractAddress,
            abi: contract_abi,
            client: WalletClient,
          });
          await contract.write.changeRewards([3]);

        }
})();