//SPDX-Liscense Identifier: MIT

pragma solidity ^0.8.0;


import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";

contract StakingToken is ERC20{
    constructor() ERC20("Reward","rwd") {
        _mint(msg.sender, 10000000);
    }
}