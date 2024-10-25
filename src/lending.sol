//SPDX-Liscense Identifier: MIT
pragma solidity ^0.8.0;


import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/utils/ReentrancyGuard.sol";
import {Pausable} from "@openzeppelin/utils/Pausable.sol";
import {Ownable} from "@openzeppelin/access/Ownable.sol";
import {RewardToken} from "./RewardToken.sol";
import {StakingToken} from "./StakingToken.sol";

contract YieldFarming is Ownable, Pausable, ReentrancyGuard{

    RewardToken public immutable s_rewardingToken;
    StakingToken public immutable s_stakingToken;
    uint256 public immutable s_tokenPrice = 1e14;
    
    uint256 public lastTime;
    uint256 public s_rewardRate = 2;
    bool public isPaused = false;
    
    mapping(address => uint256) public s_stakedBalance;
    mapping(address => uint256) public s_totalRewards;
    address[] public s_stakers;

    
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
         
        if (s_stakedBalance[msg.sender] != 0){
            s_stakedBalance[msg.sender] += amount; // add the amount to the staked balance of user
        }
        else{
            s_stakedBalance[msg.sender] = amount; // set the amount to the staked balance of user
            s_stakers.push(msg.sender);
        }
        emit Staked(msg.sender, amount);
    }

/*I am also transfering rewards points here so that people do not lose 
the rewards if they call withdraw first and then getReward. */

    function withdraw(uint256 amount) public whenNotPaused nonReentrant{ //idk if we need the pause or no
        uint256 userBal = s_stakedBalance[msg.sender]; // doing this here to not call it multiple times
        require(userBal >= amount, "Insufficient balance");
        uint256 reward_points = calculateRewards(msg.sender);
        require(IERC20(s_stakingToken).transfer(msg.sender, amount),"Failed");
        require(IERC20(s_rewardingToken).transfer(msg.sender, reward_points),"Failed");
        s_stakedBalance[msg.sender] -= amount; 
        s_totalRewards[msg.sender] += reward_points; //add the rewards gathered
        emit Withdrawn(msg.sender, amount);
    }

    //idk how this function works need to check the math
    function calculateRewards(address person) public view returns(uint256){
        uint256 userBal = s_stakedBalance[person]; // doing this here to not call it multiple times
        uint256 timeSinceLastReward = block.timestamp - lastTime;
        require(timeSinceLastReward >= 1209600 , "Cannot allocate rewards so soon"); // this is 2 weeks btw
        uint256 annualRewardPercentage = s_rewardRate * 100; 
        uint256 rewardAmount = (userBal * annualRewardPercentage * timeSinceLastReward * 1e18) / 
                              (365 days * 10000);
        if (rewardAmount < 1e16) return 0; // Minimum 0.01 tokens threshold
        rewardAmount = rewardAmount / 1e18;
        if (rewardAmount > userBal) {rewardAmount = userBal;}
        return rewardAmount;   
    }

    function giveBackEth() public {
        require(s_stakedBalance[msg.sender] > 0) ;
        payable(msg.sender).transfer(s_stakedBalance[msg.sender] * s_tokenPrice);
        s_stakedBalance[msg.sender] = 0;
    }

    /* USE THIS FUNCTION IF YOU WANT TO ALLOCATE REWARDS TO ALL STAKERS AT ONCE (NEEDS FIXING BTW)*/
    //  function allocateRewards() public nonReentrant{
    //     uint256 timePassed = block.timestamp - lastTime;
    //     require(timePassed >= 1209600 , "Cannot allocate rewards so soon"); // this is 2 weeks btw
    //     for(uint256 i=0; i< s_stakers.length; i++){
    //         address staker = s_stakers[i];
    //         uint256 totalStaked = s_stakedBalance[staker];
    //         uint256 totalRewards = (totalStaked * s_rewardRate) / 1e18 ;
    //         IERC20(s_rewardingToken).transfer(payable(s_stakers[i]), totalRewards);
    //         s_totalRewards[staker] += totalRewards;
    //         emit RewardPaid(s_stakers[i], totalRewards);
    //     }
    //     lastTime = block.timestamp;
    // }

    function changeRewards(uint256 value) public onlyOwner{
        s_rewardRate = value; //change the reward rate by owner
    }

    function getStakingAmount() public view returns(uint256){
        return s_stakedBalance[msg.sender]; // view the staked amount of a person
    }
    
    function viewReward() public view returns(uint256){
        return s_totalRewards[msg.sender]; // view the total rewards of a person
    }
    
    function getStakers() public view returns(uint256){
        return s_stakers.length; // view the stakers
    }
    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function getStakeAddress() public view returns(address){
        return address(s_stakingToken);
    }

    function getRewardAddress() public view returns(address){
        return address(s_rewardingToken);
    }
    
    fallback() external payable{
    }

    receive() external payable{
    }


}