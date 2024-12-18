//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {YieldFarming} from "../src/lending.sol";
import {Script} from "forge-std/script.sol";
import {Helper} from "script/Helper.s.sol";

contract Deploy is Script{
    
    function run() external returns(YieldFarming){
        uint private_key = vm.envUint("PRIVATE_KEY");
        Helper helper = new Helper();
        address priceFeed = helper.active();
        vm.startBroadcast(private_key); //to deploy using this account
        YieldFarming yf = new YieldFarming(priceFeed); // make the account which needed to deploy
        vm.stopBroadcast();
        return yf;
    }

    // function selectChain() public {
    //     if (vm.rpc){
    //         address rpc = vm.rpc;
    //     }
    // }
    //just pass a different rpc to do it in different chains. Add the rpc to .env ez

}
