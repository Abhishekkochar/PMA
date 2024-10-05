// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {StandardTokenMock} from "../src/Mock/StandardTokenMock.sol";

contract DeployERC20 is Script {
    address factory = 0xeD7A35c4Ee06ea4e3203471d1b022019849F8EDA;
    string _name = "Test Token";
    string _symbol = "TT";

    function run() public returns (StandardTokenMock) {
        uint256 deployerPrivateKey = vm.envUint("MANAGER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        StandardTokenMock erc20 = new StandardTokenMock(factory, _name, _symbol);
        vm.stopBroadcast();
        console.log("erc20 address: %s", address(erc20));
        return erc20;
    }
}
