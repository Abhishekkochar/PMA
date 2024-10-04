// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// Custom error
error NOT_THE_FACTORY();

contract Controller {
    modifier onlyFactory() {
        if (msg.sender != address(this)) revert NOT_THE_FACTORY();
        _;
    }
    // event

    event PROPERTY_ADDED(address property);
    event PROPERTY_REMOVED(address property);

    // Property contract ==> bool
    mapping(address => bool) internal activeProperty;
    // factory
    address immutable factory;
    // Supported Token
    address internal supportedToken;

    constructor(address _factory, address _supportedToken) {
        factory = _factory;
        supportedToken = _supportedToken;
    }

    /**
     * Adding property contract, Only callable by factory
     * @param _property property contract that has been added
     */
    function addPropertySet(address _property) external onlyFactory {
        activeProperty[_property] = true;
        emit PROPERTY_ADDED(_property);
    }

    /**
     * Adding property contract, Only callable by factory
     * @param _property property contract that has been added
     */
    function removePropertySet(address _property) external onlyFactory {
        activeProperty[_property] = false;
        emit PROPERTY_REMOVED(_property);
    }

    /**
     * @param _property Address to check if the property is valid
     */
    function isPropertyActive(address _property) external view returns (bool) {
        return activeProperty[_property];
    }

    /**
     * Supported token address
     */
    function getSupportedToken() public view returns (address) {
        return supportedToken;
    }
}
