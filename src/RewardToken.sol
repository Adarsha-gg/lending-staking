//SPDX-Liscense Identifier: MIT
pragma solidity ^0.8.0;


import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";

contract RewardToken is ERC20{
    constructor() ERC20("Staker", "stk") {
        _mint(msg.sender, 1e18);
    }
}