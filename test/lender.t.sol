//SPDX-License-Identifier
pragma solidity ^0.8.0;


import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {YieldFarming} from "../src/lending.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

contract LenderTest is Test{
    address USER = makeAddr("Hello");
    YieldFarming lender;
    function setUp() public {
        lender = new YieldFarming();
        vm.deal(USER, 10000 ether);
    }

    function testStake() public { //test to see if the function works
        lender.stake{value:1 ether}();
        uint256 a = lender.getStakers();
        console.log(a);
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
        IERC20 token = IERC20((lender.s_stakingToken).address);
        console.log(token.balanceOf(msg.sender)); //this doesnt work right now btw
    }

    function testAfterPause() public { //this test works for both staking and withdrawing
        vm.prank(address(this));
        lender.pause();
        vm.prank(address(this));
        vm.expectRevert();
        lender.stake{value:1 ether}();

        vm.prank(address(this));
        vm.warp(12999999); //moving the time forward
        vm.expectRevert();
        lender.withdraw(1000);
        
    }


}
