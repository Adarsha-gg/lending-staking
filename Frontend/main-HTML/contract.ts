import { privateKeyToAccount } from "viem/accounts"
import { createPublicClient, http, formatEther, Hex, createWalletClient, custom, publicActions, parseAbi, getContract } from "viem";

import {sepolia} from "viem/chains"
import dotenv from "dotenv";
import yielder from "../../out/lending.sol/YieldFarming.json";

dotenv.config();
const contract_abi = yielder["abi"];

const privateKey = process.env.PRIVATE_KEY;

// Assert that privateKey is in the correct format
const account = privateKeyToAccount(privateKey as Hex);

(async () => {
    

      //I can use this but already deployed so no need. Just keeping it for reference
      // const contract_hash = await WalletClient.deployContract({
      //   abi: custom.abi,
      //   bytecode: custom.bytecode,
      //   args: [1000]
      // });

      const hash = "0x6874327be1339df98e6c471dd7495b72b259518b75a913f6c34445340885ce58";

      const clienter = createPublicClient({
        chain: sepolia,
        transport: http(process.env.SEPOLIA_RPC)
      });

      const WalletClient = createWalletClient({
        account: account,
        chain: sepolia,
        transport: http(process.env.SEPOLIA_RPC)
      });


      const {contractAddress} = await clienter.getTransactionReceipt({hash});
      console.log(contractAddress);

      const writeContract = getContract({
        address: contractAddress,
        abi: contract_abi,
        // Use a single client type
        client: clienter
    });

      if (contractAddress) {
       
        const read = await clienter.readContract({
          
          address: contractAddress,
          abi: contract_abi,
          functionName: 's_rewardRate',
        });

        console.log(read);
      }

})();