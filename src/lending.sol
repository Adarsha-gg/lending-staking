//SPDX-Liscense Identifier: MIT
pragma solidity ^0.8.0;


import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/utils/ReentrancyGuard.sol";
import {Pausable} from "@openzeppelin/utils/Pausable.sol";
import {Ownable} from "@openzeppelin/access/Ownable.sol";
import {RewardToken} from "./RewardToken.sol";
import {StakingToken} from "./StakingToken.sol";
import {AggregatorV3Interface} from "@chainlink/lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract YieldFarming is Ownable, Pausable, ReentrancyGuard{

    struct Staker{
        uint256 stakedBalance;
        uint256 totalRewards;
        uint256 stakedTime;
        uint256 lastClaimedTime;
    }

    RewardToken public immutable s_rewardingToken;
    StakingToken public immutable s_stakingToken;
    uint256 public immutable s_tokenPrice = 1e14;
    
    uint256 public lastTime;
    uint256 public s_rewardRate = 2;
    bool public isPaused = false;
    
    mapping(address => Staker) public s_infoStakers;
   
    event Staked(address staker, uint256 amount);
    event Withdrawn(address staker, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor() Ownable(msg.sender){
        lastTime = block.timestamp;
        s_rewardingToken = new RewardToken();
        s_stakingToken = new StakingToken();
    }

    function stake() public payable whenNotPaused nonReentrant{
        require(isPaused == false, "Contract is paused");
        require(msg.value >= s_tokenPrice, "Insufficient amount");
        uint256 amount = msg.value / s_tokenPrice;
        Staker storage staker = s_infoStakers[msg.sender]; 
        if (staker.stakedBalance != 0){
            require(IERC20(s_stakingToken).transfer(msg.sender, amount),"Failed"); //stakking token according to eth
            staker.stakedBalance += amount; // add the amount to the staked balance of user
            staker.stakedTime = block.timestamp; // set the time of staking

        }
        else{
            require(IERC20(s_stakingToken).transfer(msg.sender, amount),"Failed");
            staker.stakedBalance = amount; // set the amount to the staked balance of user
           
            staker.stakedTime = block.timestamp; // set the time of staking
            staker.lastClaimedTime = block.timestamp; // set the time of last claimed reward
        }
        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) public whenNotPaused nonReentrant{ //idk if we need the pause or no
        Staker storage staker = s_infoStakers[msg.sender];
        require(staker.stakedBalance >= amount, "Insufficient balance");
        require(staker.stakedTime + 1209600 <= block.timestamp, "Cannot withdraw so soon"); // this is 2 weeks btw  
        uint256 value = amount * s_tokenPrice;
        payable(msg.sender).transfer(value); //transfer the eth to the user
        staker.stakedBalance -= amount; // subtract the amount from the staked balance of user
        staker.stakedTime = block.timestamp; //reset the staked time 
        
        uint256 reward = calculateRewards(msg.sender);
        require(reward > 0, "No rewards to claim");
        IERC20(s_rewardingToken).transfer(payable(msg.sender), reward);
        s_infoStakers[msg.sender].totalRewards += reward;
        IERC20(s_stakingToken).transfer(payable(msg.sender), reward); //transfer the staking token to the user
        
        emit Withdrawn(msg.sender, value);
        emit RewardPaid(msg.sender, reward);
    }

    function claimReward() public nonReentrant{
        uint256 reward = calculateRewards(msg.sender);
        require(reward > 0, "No rewards to claim");
        IERC20(s_rewardingToken).transfer(payable(msg.sender), reward);
        s_infoStakers[msg.sender].totalRewards += reward;
        emit RewardPaid(msg.sender, reward);
    }

    //idk how this function works need to check the math
    function calculateRewards(address person) public view returns(uint256){
        Staker storage staker = s_infoStakers[person];
        uint256 userBal = staker.stakedBalance; // doing this here to not call it multiple times
        uint256 timeSinceLastReward = block.timestamp - staker.lastClaimedTime;
        require(timeSinceLastReward >= 1209600 , "Cannot allocate rewards so soon"); // this is 2 weeks btw
        uint256 annualRewardPercentage = s_rewardRate * 100; 
        uint256 rewardAmount = (userBal * annualRewardPercentage * timeSinceLastReward * 1e18) / 
                              (365 days * 10000);
        if (rewardAmount < 1e16) return 0; // Minimum 0.01 tokens threshold
        rewardAmount = rewardAmount / 1e18;
        if (rewardAmount > userBal) {rewardAmount = userBal;}
        return rewardAmount;   
    }

    function changeRewards(uint256 value) public onlyOwner{
        s_rewardRate = value; //change the reward rate by owner
    }

    function pricer() public view returns (int256){
       AggregatorV3Interface dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306 // for sepolia testnet
        );
        (, int256 answer, , ,) = dataFeed.latestRoundData();
        answer = answer/ (10**8); // it gives some random hex number so 🤷🏻‍♂️
        return answer;
    }

    function getStakingAmount() public view returns(uint256){
        return s_infoStakers[msg.sender].stakedBalance; // view the staked amount of a person
    }
    
    function viewReward() public view returns(uint256){
        return s_infoStakers[msg.sender].totalRewards; // view the total rewards of a person
    }
    
     function getStakeAddress() public view returns(address){
        return address(s_stakingToken);
    }

    function getRewardAddress() public view returns(address){
        return address(s_rewardingToken);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    fallback() external payable{
    }

    receive() external payable{
    }
}