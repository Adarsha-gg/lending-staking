import { privateKeyToAccount } from "viem/accounts"
import { createPublicClient, http, formatEther, Hex } from "viem";
import {sepolia} from "viem/chains"
import dotenv from "dotenv";

dotenv.config();

const privateKey = process.env.PRIVATE_KEY;
const account = privateKeyToAccount(privateKey as Hex);

(async () => {
    const client = createPublicClient({
        chain: sepolia,
        transport: http(process.env.SEPOLIA_RPC)
    });
    
    const balance = await client.getBalance({address: account.address});
    console.log(formatEther(balance));

    const nonce = await client.getTransactionCount({address: account.address});
    console.log(nonce);
})();