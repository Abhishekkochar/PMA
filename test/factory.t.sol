// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DeployFactory} from "../script/DeployFactory.s.sol";
import {DeployERC20} from "../script/DeployERC20.s.sol";
import {DeployController} from "../script/DeployController.s.sol";
import {DPMAFactory} from "../src/DPMAFactory.sol";
import {Controller} from "../src/Controller.sol";
import {StandardTokenMock} from "../src/Mock/StandardTokenMock.sol";
import {IController} from "../src/interface/interfaces.sol";

contract FactoryTest is Test {
    DPMAFactory factory;
    StandardTokenMock standardTokenMock;
    Controller controller;
    address owner;
    address propOwner = address(0x1);

    function setUp() public {
        // Deploying factory
        DeployFactory deployFactory = new DeployFactory();
        factory = deployFactory.run();
        owner = factory.owner();
        // Deploying ERC20
        DeployERC20 deployERC20 = new DeployERC20();
        standardTokenMock = deployERC20.run(address(factory), "Test Token", "TT");
        // Deploying Controller
        DeployController deployController = new DeployController();
        controller = deployController.run(address(factory), address(standardTokenMock));
        vm.startPrank(owner);
        factory.addController(IController(address(controller)));
        vm.stopPrank();
    }

    //----------------- Sucessfull cases ----------------
    function testController() public view {
        IController controllerAdd = factory.controller();
        assertEq(address(controller), address(controllerAdd));
    }

    function testDeployProperty() external returns (address) {
        vm.startPrank(owner);
        address propAddress = factory.deployProperty(100 ** 18, propOwner, "Property One");
        vm.stopPrank();
        return propAddress;
    }

    function testWithdrawErc20() public {
        uint256 beforebalance = standardTokenMock.balanceOf(address(factory));
        uint256 amount = 100 ** 18;
        vm.startPrank(owner);
        factory.withdrawERC20(address(standardTokenMock), amount);
        vm.stopPrank();
        uint256 afterbalance = standardTokenMock.balanceOf(address(factory));
        assertEq(beforebalance - amount, afterbalance);
    }
}
