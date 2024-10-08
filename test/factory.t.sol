// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {DeployFactory} from "../script/DeployFactory.s.sol";
import {DeployERC20} from "../script/DeployERC20.s.sol";
import {DeployController} from "../script/DeployController.s.sol";
import {DPMAFactory} from "../src/DPMAFactory.sol";
import {Property} from "../src/Property.sol";
import {Controller} from "../src/Controller.sol";
import {StandardTokenMock} from "../src/Mock/StandardTokenMock.sol";
import {IController} from "../src/interface/interfaces.sol";

contract FactoryTest is Test {
    DPMAFactory factory;
    StandardTokenMock standardTokenMock;
    Controller controller;
    address owner;
    address propOwner = address(0x1);
    address userOne = address(0x2);
    address userTwo = address(0x3);
    address[] members = [userOne, userTwo];

    function setUp() public {
        // Deploying factory
        factory = new DPMAFactory();
        owner = factory.owner();
        // Deploying ERC20
        standardTokenMock = new StandardTokenMock(
            address(factory),
            "Test Token",
            "TT"
        );
        vm.startPrank(owner);
        // Deploying Controller
        controller = new Controller(
            address(factory),
            address(standardTokenMock)
        );

        factory.addController(IController(address(controller)));
        vm.stopPrank();
    }

    //----------------- Sucessfull cases ----------------
    function testController() public view {
        IController controllerAdd = factory.controller();
        assertEq(address(controller), address(controllerAdd));
    }

    function testDeployProperty() external {
        vm.startPrank(owner);
        address propAddress = factory.deployProperty(
            100 ** 18,
            propOwner,
            "Property One"
        );
        vm.stopPrank();

        Property property = Property(propAddress);
        vm.startPrank(propOwner);
        uint256 fee = 10 ** 18;
        uint8 currMonth = 9;
        // Adding member here
        property.addMembers(members, currMonth, fee);
        vm.stopPrank();
        // Checking member status
        Property.FeeStatus memory status = property.getMemberStatus(
            userOne,
            currMonth
        );
        assertTrue(status.isActive);
        assertFalse(status.isPaid);
        // Pay the fee
        vm.startPrank(userOne);
        standardTokenMock.mint(userOne, 100 ** 18);
        uint256 beforebal = standardTokenMock.balanceOf(userOne);
        standardTokenMock.approve(propAddress, UINT256_MAX);
        property.payFee(currMonth);
        uint256 afterBal = standardTokenMock.balanceOf(userOne);
        assertEq(beforebal - fee, afterBal);
        vm.stopPrank();
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
