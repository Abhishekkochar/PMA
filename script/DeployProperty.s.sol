// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DPMAFactory} from "../src/DPMAFactory.sol";
import {IController} from "../src/interface/interfaces.sol";

// prop Three: 0xE89DffB424aBf51A64935663947F0349C8c462c3
contract DeployProperty is Script {
    address factoryAdd = 0x2C3A5ad03e766CFF6fa7911eFa184cFe04235382;
    uint256 initBal = 1 ** 18;
    address owner = 0xfeB42b6c3c4250F435c20cFF22eA2FE386A830F2;
    IController controller =
        IController(0x64934671E64C6d1EEb92eF9085B72bA6aF9c69fB);
    string name = "Property Three";

    function run() public returns (address) {
        uint256 deployerPrivateKey = vm.envUint("MANAGER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        DPMAFactory factory = DPMAFactory(factoryAdd);
        // Adding conytroller
        factory.addController(controller);
        address propertyAdd = factory.deployProperty(initBal, owner, name);
        vm.stopBroadcast();
        console.log("Property address: %s", propertyAdd);
        return propertyAdd;
    }
}
