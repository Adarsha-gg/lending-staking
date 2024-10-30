# A lending/staking protocol

**How it works?**

First the user sends some eth to the contract and as per the eth sent, the person gets sent a "Staking token" which is a proof that he has some part in the protocol.

User can start getting their rewards in 2 weeks. It calculates based on the time that it was staked.
For now the they cannot withdraw before 2 weeks because if they do they basically do not get any reward.


**All the function breakdown**

Stake- check if contract is unpaused and value is higher the price of token and then add it to staked if it doesnt exist before.

Withdraw - give rewards and all its staking token back which were in the contract 

finish this :) soon enough


First deployed transaction lfg = https://sepolia.etherscan.io/tx/0x6874327be1339df98e6c471dd7495b72b259518b75a913f6c34445340885ce58


**Questions**

1. I need to automatically send rewards to the user after 2 weeks how do I know how much to give them based on the time that they deposited the token. Do I pause the staking and withdrawl for some time and after that time is over give the rewards and then open the time for withdrawing? Or what other ways can we do?
       - no need to pause, just add timer for them and them give them reward based on the timer and then update the timer ezpz.

2. Now when the user withdraws a certain amount, his staked time goes to 0. So when he goes out to claim rewards, he can get ALOT more since his staking time is 0. How to fix this?
    - Make a different time calculator for reward and withdrawn time. WIthdrawn time depends on stake time and reward time is independent.

**Choices**
1. Made the stake function give out staking tokens because it makes more sense.
2. Made the withdraw function seprate the rewards functions and only giveout the eth back. (Maybe have to set limit at a single person's withdraw limit per week or smth)
3. Made the reward function seprate and make it give out rewards periodically ig.
4. Rewinded the last decision as if we do that if person withdraws first no rewards :(. (added a diff func for this tho )
5.  Couldnt use the same function call in another function call as it causes retrancy (basically can call inifinite time to short circuit kind of)


### TO Do for tommorow
1. ~~make a func to actually check the balance of the address to see if the ERC20 token is actually transfered. 
right now the functions transfers (according to the terminal testing interface atleast.)~~
2. ~~Make the reward function seprate than the withdraw function.~~  

3. Maybe start on the frontend now? Learn javascript? **In progress :)**


Goodbye :)
