//SPDX-Liscense Identifier: MIT
pragma solidity ^0.8.0;


import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {RewardToken} from "./RewardToken.sol";
import {StakingToken} from "./StakingToken.sol";

contract YieldFarming{

    RewardToken public s_rewardingToken;
    StakingToken public s_stakingToken;
    uint256 public lastTime;

    address public owner;
    uint256 public immutable token_price = 1000000 wei;
    uint256 public s_rewardRate = 2;
    bool public isPaused = false;
    
    mapping(address => uint256) public s_stakedBalance;
    mapping(address => uint256) public s_totalRewards;
    address[] public stakers;

    constructor(){
        owner = msg.sender;
        lastTime = block.timestamp;
        s_rewardingToken = new RewardToken();
        s_stakingToken = new StakingToken();
    }

    event staked(address staker, uint256 amount);
    event withdrawn(address staker, uint256 amount);
    event paused(bool status);

    function stake() public payable{
        require(isPaused == false, "Contract is paused");
        uint256 amount = msg.value / token_price;
        s_stakedBalance[msg.sender] += amount; // add the amount to the staked balance of user
        stakers.push(msg.sender);
        emit staked(msg.sender, amount);
    }

/*I am also transfering rewards points here so that people do not lose 
the rewards if they call withdraw first and then getReward. */

    function withdraw(uint256 amount) public {
        uint256 userBal = s_stakedBalance[msg.sender]; // doing this here to not call it multiple times
        require(userBal < amount, "Insufficient balance");
        uint256 reward_points = (userBal * s_rewardRate) - userBal;
        payable(address(this)).transfer(amount * token_price); // give back the ether
        IERC20(s_stakingToken).transfer(msg.sender, amount);
        IERC20(s_rewardingToken).transfer(msg.sender, reward_points);
        s_stakedBalance[msg.sender] -= (amount*token_price);  //reducing the taken eth
        s_totalRewards[msg.sender] = 0;
        emit withdrawn(msg.sender, amount);
    }

    function getReward() public {
        uint256 userBal = s_stakedBalance[msg.sender]; // doing this here to not call it multiple times
        require(userBal > 0, "Nothing staked");
        uint256 reward_points = userBal * s_rewardRate - userBal;
        IERC20(s_rewardingToken).transfer(msg.sender, reward_points); 
        s_totalRewards[msg.sender] = 0;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function changeRewards(uint256 value) public onlyOwner{
        s_rewardRate = value; //change the reward rate by owner
    }

    function getStakingAmount() public view returns(uint256){
        return s_stakedBalance[msg.sender];
    }
    
    function viewReward() public view returns(uint256){
        return s_totalRewards[msg.sender];
    }

    function pause() public onlyOwner{
        isPaused = true;
        emit paused(isPaused);
    }

    function allocateRewards() public onlyOwner {
        uint256 timePassed = block.timestamp - lastTime;
        require(timePassed >= 1209600 , "Cannot allocate rewards so soon"); // this is 2 weeks btw
        for(uint256 i=0; i< stakers.length; i++){
            address staker = stakers[i];
            uint256 totalStaked = s_stakedBalance[staker];
            uint256 totalRewards = (totalStaked * s_rewardRate) / 1e18 ;
            IERC20(s_rewardingToken).transfer(payable(stakers[i]), totalRewards);
            s_totalRewards[staker] += totalRewards;
        }
        lastTime = block.timestamp;
    }

    fallback() external payable{
    }

    receive() external payable{
    }
}