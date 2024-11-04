import { privateKeyToAccount } from "viem/accounts"
import { createPublicClient, http, formatEther, Hex, createWalletClient, custom, getContract, parseEther, } from "viem";
import {sepolia, mainnet} from "viem/chains"
import 'viem/window'
import dotenv from "dotenv";
import yielder from "../../out/lending.sol/YieldFarming.json";

dotenv.config();
const contract_abi = yielder["abi"];
let contract: any;
let WalletClient: any;

async function connect()
{
    // WalletClient = createWalletClient({
    //     chain: sepolia,
    //     transport: custom(window.ethereum!)
    //   });
    
    // const address = WalletClient.requestAddresses();
    // console.log(address);

    // contract = getContract({
    //     address: '0x30f6b15c7f964237b41f066b0a5cb5117d4fad9d',
    //     abi: contract_abi,
    //     client: WalletClient, // or walletClient,
    // });  
    console.log("Clcikerkerkekrer");
    
}

async function stake(){
    const stakeAmount = (document.getElementById("stakeAmount") as HTMLInputElement)?.value;
      const amount = parseEther(stakeAmount)
      await contract.write.stake([amount]);
}

async function claim(){
    await contract.write.claimReward();
}

async function withdraw(){
    const withdrawAmount = (document.getElementById("withdrawAmount") as HTMLInputElement)?.value;
    const amount = parseEther(withdrawAmount)
    await contract.write.withdraw([amount]);
}

document.addEventListener("DOMContentLoaded", () => {
    const connectButton = document.getElementById("connectButton");
    const stakeButton = document.getElementById("stakeButton");
    const withdrawButton = document.getElementById("withdrawButton");
    const claimButton = document.getElementById("claimButton");

    connectButton?.addEventListener("click", connect);
    stakeButton?.addEventListener("click", stake);
    withdrawButton?.addEventListener("click", withdraw);
    claimButton?.addEventListener("click", claim);
});