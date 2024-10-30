//SPDX-License-Identifier
pragma solidity ^0.8.0;


import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {YieldFarming} from "../src/lending.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {Deploy} from "../script/Deploy.s.sol";

contract LenderTest is Test{
    address USER = makeAddr("Hello");
    YieldFarming lender;
    Deploy deployer;
    
    function setUp() public {
        deployer = new Deploy();
        lender = deployer.run();
        vm.deal(USER, 10000 ether);
    }

    function testStake() public { //test to see if the function works
        lender.stake{value:1 ether}();
    }

    function testZeroStake() public { //testing with no value 
        vm.expectRevert(); // always put this at the top of the msg that you want to revert
        lender.stake();
    }

    function testWithdraw() public {
        vm.prank(USER);
        lender.stake{value:1 ether}();
        vm.prank(USER);
        vm.warp(12999999); //moving the time forward
        lender.withdraw(1000);

        /*The following things can be used when testing erc20 tokens */
        // address token = lender.getStakeAddress();
        // address reward = lender.getRewardAddress();
        // console.log(token);
        // console.log(IERC20(token).balanceOf(USER)); //works now 
        // console.log(IERC20(reward).balanceOf(USER));
    }
    
    function testAfterPause() public { //this test works for both staking and withdrawing
        vm.prank(0xd78f1216cd75AA99A6E263c04043623A3d1DcA4a); // public key correspending to priv key
        lender.pause();
        vm.prank(USER);
        vm.expectRevert();
        lender.stake{value:1 ether}();
        vm.prank(USER);
        vm.warp(12999999); //moving the time forward
        vm.expectRevert();
        lender.withdraw(1000);
    }

    function testClaim() public {
        vm.prank(USER);
        lender.stake{value:1 ether}();
        vm.prank(USER);
        vm.warp(12999999); //moving the time forward
        lender.claimReward();
        /*The following things can be used when testing erc20 tokens */
        address stake = lender.getStakeAddress();
        address reward = lender.getRewardAddress();
        console.log("Staking balance = ", IERC20(stake).balanceOf(USER)); //works now 
        console.log("Reward balance = ", IERC20(reward).balanceOf(USER));
    }

    function testClaimAfterWithdraw() public  {
        vm.prank(USER);
        lender.stake{value:1 ether}();
        vm.prank(USER);
        vm.warp(12999999); //moving the time forward
        lender.withdraw(1000);
        vm.expectRevert();
        lender.claimReward();
        /*The following things can be used when testing erc20 tokens */
        address stake = lender.getStakeAddress();
        address reward = lender.getRewardAddress();
        console.log("Staking balance = ", IERC20(stake).balanceOf(USER)); //works now 
        console.log("Reward balance = ", IERC20(reward).balanceOf(USER));
    }

}
