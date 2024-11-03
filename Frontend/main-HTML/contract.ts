import { privateKeyToAccount } from "viem/accounts"
import { createPublicClient, http, formatEther, Hex, createWalletClient, custom, publicActions, parseAbi } from "viem";
import {sepolia} from "viem/chains"
import dotenv from "dotenv";

dotenv.config();

const privateKey = process.env.PRIVATE_KEY;

// Assert that privateKey is in the correct format
const account = privateKeyToAccount(privateKey as Hex);

(async () => {
    const WalletClient = createWalletClient({
        account: account,
        chain: sepolia,
        transport: http(process.env.SEPOLIA_RPC)
      }).extend(publicActions);

      //I can use this but already deployed so no need. Just keeping it for reference
      // const contract_hash = await WalletClient.deployContract({
      //   abi: custom.abi,
      //   bytecode: custom.bytecode,
      //   args: [1000]
      // });

      const hash = "0x6874327be1339df98e6c471dd7495b72b259518b75a913f6c34445340885ce58";

      const {contractAddress} = await WalletClient.getTransactionReceipt({hash});
      console.log(contractAddress);

      if (contractAddress) {
       
        const read = await WalletClient.readContract({
          
          address: contractAddress,
          abi: parseAbi(['function s_rewardRate() view returns (uint256)']),
          functionName: 's_rewardRate',
        });

        console.log(read);
      }

})();