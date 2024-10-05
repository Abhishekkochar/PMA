// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Controller} from "../src/Controller.sol";

contract DeployController is Script {
    function run(
        address factory,
        address supportedToken
    ) public returns (Controller) {
        vm.startBroadcast();
        Controller controller = new Controller(factory, supportedToken);
        vm.stopBroadcast();
        console.log("Controller address: %s", address(controller));
        return controller;
    }
}
