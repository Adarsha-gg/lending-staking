//SPDX-Liscense Identifier: MIT

pragma solidity ^0.8.0;


import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {RewardToken} from "./RewardToken.sol";
import {StakingToken} from "./StakingToken.sol";

contract YieldFarming{

    RewardToken public s_stakingToken = new RewardToken();
    StakingToken public s_rewardingToken = new StakingToken();
    uint256 public immutable token_price = 100 wei;
    uint256 public s_rewardRate = 2;
    
    mapping(address => uint256) public s_stakedBalance;
    mapping(address => uint256) public s_totalRewards;

    function stake() public payable{
        uint256 amount = msg.value / token_price;
        s_stakedBalance[msg.sender] += amount; // add the amount to the staked balance of user
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
    }

    function getReward() public {
        uint256 userBal = s_stakedBalance[msg.sender]; // doing this here to not call it multiple times
        require(userBal > 0, "Nothing staked");
        uint256 reward_points = userBal * s_rewardRate - userBal;
        IERC20(s_rewardingToken).transfer(msg.sender, reward_points); 
        s_totalRewards[msg.sender] = 0;
    }


}