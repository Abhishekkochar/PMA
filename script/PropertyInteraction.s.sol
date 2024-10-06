// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {DPMAFactory} from "../src/DPMAFactory.sol";
import {Property} from "../src/Property.sol";
import {IController} from "../src/interface/interfaces.sol";
import {StandardTokenMock} from "../src/Mock/StandardTokenMock.sol";

contract PropertyInteraction is Script {
    address factoryAdd = 0x2C3A5ad03e766CFF6fa7911eFa184cFe04235382;
    IController controller =
        IController(0x64934671E64C6d1EEb92eF9085B72bA6aF9c69fB);
    address mockToken = 0x5920257792dBba08dfadD34607B781E3C2CDb3cF;

    address propAddressThree = 0x724487C57deFa836188cC84ef78C1373EA35Bf2F;
    address userOne = 0xa9d392cDC8cf47564776113f6515bfe3dD2eAf6c;
    address userTwo = 0x207B35ab2ad7d0b498c955eAaE8bCAC683B0Dfd4;
    // This is demo add
    address userThree = 0x87f603924309889B39687AC0A1669b1E5a506E74;
    address[] members = [userOne, userTwo, userThree];
    uint8 currMonth = 10;

    // Employer
    address employerOne = 0x00fBd18efDE748E1B3f7Bb01C79FbC318610b807;

    function run() public {
        // MintToken();
        // AddMember();
        PayFee();
        PayExpense();
    }

    function MintToken() public {
        uint256 deployerPrivateKey = vm.envUint("MANAGER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        StandardTokenMock standardTokenMock = StandardTokenMock(mockToken);
        // Adding member
        console.log("..Minting tokens");
        standardTokenMock.mint(propAddressThree, 1000 ** 18);
        console.log("Finsihed Minting tokens");
        vm.stopBroadcast();
    }

    function AddMember() public {
        uint256 deployerPrivateKey = vm.envUint("PROP_MANAGER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Property property = Property(propAddressThree);
        address owner = property.owner();
        console.log("Owner address: ", owner);
        // Adding member
        property.addMembers(members, currMonth, 100);
        vm.stopBroadcast();
    }

    function PayExpense() public {
        uint256 deployerPrivateKey = vm.envUint("PROP_MANAGER_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        Property property = Property(propAddressThree);
        // Paying expenses
        property.payExpenses(employerOne, 100);
        vm.stopBroadcast();
    }

    function PayFee() public {
        uint256 deployerPrivateKey = vm.envUint("UserOne");
        vm.startBroadcast(deployerPrivateKey);
        StandardTokenMock standardTokenMock = StandardTokenMock(mockToken);
        standardTokenMock.approve(propAddressThree, UINT256_MAX);
        Property property = Property(propAddressThree);
        // Paying Fee
        property.payFee(10);
        vm.stopBroadcast();
    }
}
