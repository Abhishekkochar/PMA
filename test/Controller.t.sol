// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DeployController} from "../script/DeployController.s.sol";
import {Controller} from "../src/Controller.sol";

contract ControllerTest is Test {
    Controller controller;
    address factory = address(0);
    address supportedToken = address(0);

    function setUp() public {
        DeployController controllerScript = new DeployController();
        controller = controllerScript.run(factory, supportedToken);
    }

    function testSupportedToken() public view {
        address token = controller.getSupportedToken();
        assertEq(supportedToken, token);
    }
}
