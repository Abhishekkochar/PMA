// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DPMAFactory} from "../src/DPMAFactory.sol";

contract DeployFactory is Script {
    function run() public returns (DPMAFactory) {
        uint256 deployerPrivateKey = vm.envUint("MANAGER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        DPMAFactory factory = new DPMAFactory();
        vm.stopBroadcast();
        console.log("DPMAFactory address: %s", address(factory));
        return factory;
    }
}
