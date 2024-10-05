// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DPMAFactory} from "../src/DPMAFactory.sol";

contract DeployFactory is Script {
    address factoryAdd;
    uint256 initBal = 1000 ** 18;
    address owner = address(0);
    string name = "Property One";

    function run() public returns (address) {
        uint256 deployerPrivateKey = vm.envUint("MANAGER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        DPMAFactory factory = DPMAFactory(factoryAdd);
        vm.startBroadcast();
        address propertyAdd = factory.deployProperty(initBal, owner, name);
        vm.stopBroadcast();
        console.log("Property address: %s", propertyAdd);
        return propertyAdd;
    }
}
