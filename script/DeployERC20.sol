// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {StandardTokenMock} from "../src/Mock/StandardTokenMock.sol";

contract DeployERC20 is Script {
    function run(string memory _name, string memory _symbol) public returns (StandardTokenMock) {
        vm.startBroadcast();
        StandardTokenMock erc20 = new StandardTokenMock(_name, _symbol);
        vm.stopBroadcast();
        console.log("erc20 address: %s", address(erc20));
        return erc20;
    }
}
