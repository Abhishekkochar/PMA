// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Controller} from "../src/Controller.sol";

contract ControllerTest is Test {
    Controller controller;
    address factory = address(0x1);
    address supportedToken = address(0x2);
    address prop = address(0x3);

    function setUp() public {
        controller = new Controller(factory, supportedToken);
    }

    function testSupportedToken() public view {
        address token = controller.getSupportedToken();
        assertEq(supportedToken, token);
    }

    function testSfactoryAddress() public view {
        address factoryAdd = controller.factory();
        assertEq(factory, factoryAdd);
    }

    //----------------- Sucessfull cases ----------------
    function testAddProperty() public {
        vm.startPrank(factory);
        controller.addPropertySet(prop);
        vm.stopPrank();
        bool isActive = controller.isPropertyActive(prop);
        assertTrue(isActive);
    }

    function testRemoveProperty() public {
        testAddProperty();
        vm.startPrank(factory);
        controller.removePropertySet(prop);
        vm.stopPrank();
        bool isActive = controller.isPropertyActive(prop);
        assertFalse(isActive);
    }

    //----------------- UnSucessfull cases ----------------

    function testAddPropertyRevertOnZeroAddress() public {
        vm.startPrank(factory);
        vm.expectRevert(Controller.INVALID_ADDRESS.selector);
        controller.addPropertySet(address(0));
        vm.stopPrank();
    }

    function testAddPropertyRevertOnUnAuthAcess() public {
        vm.expectRevert(Controller.NOT_THE_FACTORY.selector);
        controller.addPropertySet(prop);
    }
}
