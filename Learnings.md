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




### Current Problems
1. So since now I have a private key to deploy using deploy script. THe testAfterPause doesnt work since I need to get the address of the private key but I do not know how to get it right now. I cannot convert the private key into its address directly for some reason.
    - So I solved this by hardcoding the public key to the prank of pause fucntion. Seems like there isnt a function to directly change it form a priv key to public key unless u import something. But vm.broadcast(privkey) seems to deploy it using public key easily. Maybe this is a function that I've not found yet?
    


### Discoveries
1. I also learned that public key and address are different. Public key is derived from private key and address is derived from public key. 

2. Foundry/Solidity automatically creates a getter function for any storage variable in the contract. So if you want to get the ABI you could just put the variable name as function as get it as a normal getter.

3. ALWAYS check the config files, there may be subtle things that may interfere with ur code that you'll never know. I found it by scrolling through discord so 🤷🏻‍♂️.

4. Learned that we need to pass RPC_URL even in the test to get any kind of real data, always deploying to sepolia and then quering it is bad practice
Goodbye :)