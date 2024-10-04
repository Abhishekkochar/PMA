// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IController {
    function getSupportedToken() external view returns (address);

    function addPropertySet(address _property) external;

    function isPropertyActive(address _property) external view returns (bool);
}
