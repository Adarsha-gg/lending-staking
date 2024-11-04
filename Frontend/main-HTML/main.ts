import { privateKeyToAccount } from "viem/accounts"
import { createPublicClient, http, formatEther, Hex, createWalletClient, custom, getContract, } from "viem";
import {sepolia, mainnet} from "viem/chains"
import 'viem/window'
import dotenv from "dotenv";
import yielder from "../../out/lending.sol/YieldFarming.json";

dotenv.config();
const contract_abi = yielder["abi"];

(async () => {
    
    const WalletClient = createWalletClient({
        chain: sepolia,
        transport: custom(window.ethereum!)
      })

    const address = await WalletClient.requestAddresses();
    console.log(address)

    const contract = getContract({
        address: '0x30f6b15c7f964237b41f066b0a5cb5117d4fad9d',
        abi: contract_abi,
        client: WalletClient // or walletClient
    })  

    const stake = await contract.write.stake([1e15]);
    const claim = await contract.write.claimReward();
    const withdraw = await contract.write.withdraw([1e15]);
    const event = await contract.getEvents.staked();

    console.log(event)

})();    