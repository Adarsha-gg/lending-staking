# A lending/staking protocol

**How it works?**

First the user sends some eth to the contract and as per the eth sent, the person gets sent a "Staking token" which is a proof that he has some part in the protocol.

User can start getting their rewards in 2 weeks. It calculates based on the time that it was staked.
For now the they cannot withdraw before 2 weeks because if they do they basically do not get any reward.

**How to run it**
``forge build``
To just simulate it in your environmnet you can use this. You need to have a sepolia rpc to access this
``cast call 0xBdAa707720D6Dc7AB2Ebf5566F4b702cE50AEc4C --rpc-url $SEPOLIA_RPC "any func"`` 
To test the functions just run all the tests
``forge test --rpc-url $SEPOLIA_RPC``


First deployed transaction lfg = https://sepolia.etherscan.io/tx/0x6874327be1339df98e6c471dd7495b72b259518b75a913f6c34445340885ce58

Latest Contract: 0xBdAa707720D6Dc7AB2Ebf5566F4b702cE50AEc4C



