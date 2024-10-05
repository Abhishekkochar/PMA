// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Controller} from "../src/Controller.sol";

contract DeployController is Script {
    address factory = 0xeD7A35c4Ee06ea4e3203471d1b022019849F8EDA;
    address supportedToken = 0x5920257792dBba08dfadD34607B781E3C2CDb3cF;

    function run() public returns (Controller) {
        uint256 deployerPrivateKey = vm.envUint("MANAGER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Controller controller = new Controller(factory, supportedToken);
        vm.stopBroadcast();
        console.log("Controller address: %s", address(controller));
        return controller;
    }
}
