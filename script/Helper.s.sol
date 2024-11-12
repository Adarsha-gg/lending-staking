//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {Script} from "forge-std/script.sol";

contract Helper is Script{

    struct NetworkConfig{
        address priceFeed;
    }

    NetworkConfig public active;

    constructor(){
        if (block.chainid == 11155111){
            active = getSepolia();
        }
        else if (block.chainid == 1){
            active = getMainnet();
        }
        else if (block.chainid == 137){ 
            active = getPolygon();
        }
        else{
            active = getAnvil();
        }
    }

    function getSepolia() public pure returns(NetworkConfig memory ){
        NetworkConfig memory sepolia = NetworkConfig({
            priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepolia;
    }

    function getMainnet() public pure returns(NetworkConfig memory){
        NetworkConfig memory main = NetworkConfig({
            priceFeed:0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return main;
    }

    function getPolygon() public pure returns(NetworkConfig memory){
        NetworkConfig memory polygon = NetworkConfig({
            priceFeed:0xF9680D99D6C9589e2a93a78A04A279e509205945
        });
        return polygon;
    }

    function getAnvil() public pure returns(NetworkConfig memory){
    }

}