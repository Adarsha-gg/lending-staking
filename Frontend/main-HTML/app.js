const {ethers} = require("ethers");

// const provider = new ethers.providers.JsonRpcProvider("https://polygon-mainnet.g.alchemy.com/v2/4LrVvzGe-ZFBfc-9YsXT7JB48YuzjP33");
const provider = new ethers.JsonRpcProvider("https://polygon-mainnet.g.alchemy.com/v2/4LrVvzGe-ZFBfc-9YsXT7JB48YuzjP33");
const address = "0x13E5de1dD7F313feD582288acd4a38C7d716150c"

const main = async () => {
    const balance = await provider.getBalance(address)

    console.log(ethers.formatUnits(balance, "ether"))
}

main()