//SPDX-Liscense Identifier: MIT

pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract YieldFarming{

    IERC20 public s_stakingToken;
    IERC20 public s_rewardingToken;
}