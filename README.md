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


### TO DO
1. ~~make a func to actually check the balance of the address to see if the ERC20 token is actually transfered. 
right now the functions transfers (according to the terminal testing interface atleast.)~~
2. ~~Make the reward function seprate than the withdraw function.~~  

3. Maybe start on the frontend now? Learn javascript? **In progress :)**
 I AM DEF NOT MADE FOR FRONTEND

4. ~~Since I cant do frontend lets add the value of ether according to usd. so its get better kind of~~

5. The tests are all written to check in my own enviornmnet. Maybe make different tests for real testing and mock testing inside foundry?



