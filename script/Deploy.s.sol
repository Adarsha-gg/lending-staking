//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {YieldFarming} from "../src/lending.sol";
import {Script} from "forge-std/script.sol";

contract Deploy is Script{
    
    function run() external{
        vm.broadcast();
        YieldFarming yf = new YieldFarming();
        
        vm.stopBroadcast();
    }

}
