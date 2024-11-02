const {ethers} = require("ethers");

// const provider = new ethers.providers.JsonRpcProvider("https://polygon-mainnet.g.alchemy.com/v2/4LrVvzGe-ZFBfc-9YsXT7JB48YuzjP33");
const provider = new ethers.JsonRpcProvider("https://eth-sepolia.g.alchemy.com/v2/4LrVvzGe-ZFBfc-9YsXT7JB48YuzjP33");
const address = "0x13E5de1dD7F313feD582288acd4a38C7d716150c"
const contract_address = "0x30F6B15c7F964237B41F066b0a5CB5117D4FAD9d";

const abi = ethers.abi
const contract = new ethers.Contract(contract_address, contract_abi, provider);

const main = async () => {
    // const balance = await provider.getBalance(address);

    // console.log(ethers.formatUnits(balance, "ether"));
    const name =await contract.owner();
    console.log(name);
}

main()