// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Property} from "./Property.sol";
import {IController} from "./interface/interfaces.sol";

// Custom errors
error INVALID_ADDRESS();
error INVALID_AMOUNT();
error TRANSFER_FAILED();
error INIT_CONTROLLER();
error INSUFFICENT_BALANCE();

contract DPMAFactory is Ownable {
    IController controller;

    constructor() Ownable(msg.sender) {}

    /**
     * Owner can deploy new property
     * @param initBalance Amount to send to the property
     * @param _owner Owner of the property
     * @param _name Name of the property
     */
    function deployProperty(
        uint256 initBalance,
        address _owner,
        string memory _name
    ) external onlyOwner returns (address) {
        if (address(controller) == address(0)) revert INIT_CONTROLLER();
        address supportedTokenAddress = controller.getSupportedToken();
        if (initBalance == 0) revert INVALID_AMOUNT();
        IERC20 supportedToken = IERC20(supportedTokenAddress);
        Property property = new Property(
            _owner,
            _name,
            supportedToken,
            controller
        );
        controller.addPropertySet(address(property));
        bool success = supportedToken.transferFrom(
            address(this),
            address(property),
            initBalance
        );
        if (!success) revert TRANSFER_FAILED();
        return address(property);
    }

    /**
     * Owner can call this function to add controller
     * @param _controller Contoller address
     */
    function addController(IController _controller) external onlyOwner {
        if (address(controller) == address(0)) revert INVALID_ADDRESS();
        controller = _controller;
    }

    /**
     * Owner call this function to withdraw any erc20 token
     * @param _erc20 Token to transfer
     * @param _amount Amount to transfer to
     */
    function withdrawERC20(address _erc20, uint256 _amount) external onlyOwner {
        if (_erc20 == address(0)) revert INVALID_ADDRESS();
        if (_amount == 0) revert INVALID_AMOUNT();
        bool success = IERC20(_erc20).transferFrom(
            address(this),
            owner(),
            _amount
        );
        if (!success) revert TRANSFER_FAILED();
    }
}
