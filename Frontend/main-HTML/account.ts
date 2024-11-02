import { privateKeyToAccount } from "viem/accounts"
import { createPublicClient, http, formatEther } from "viem";
import {sepolia} from "viem/chains"
import dotenv from "dotenv";

dotenv.config();

const privateKey = process.env.PRIVATE_KEY;

// Assert that privateKey is in the correct format
const account = privateKeyToAccount(privateKey as `0x${string}`);

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