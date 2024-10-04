// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IController} from "./interface/interfaces.sol";

// custom errors
error INVALID_ADDRESS();
error INVALID_AMOUNT();
error NOT_THE_OWNER();
error INVALID_MEMBERS();
error PROPERTY_IS_NOT_ACTIVE();
error MEMBER_IS_NOT_ACTIVE();
error MEMBER_IS_ALREADY_ACTIVE();
error MEMBER_ALREADY_PAID();
error INSUFFICENT_BALANCE();
error TRANSFER_FAILED();

contract Property {
    modifier onlyOwner() {
        if (msg.sender != address(this)) revert NOT_THE_OWNER();
        _;
    }

    modifier isPropertyActive() {
        if (!getPropertyStatus()) revert PROPERTY_IS_NOT_ACTIVE();
        _;
    }

    // events
    event ADD_MEMBERS(address[] members, uint8 currentMonth, uint256 fee);
    event FEE_PAID(address member, uint8 currMonth, uint256 feeAmount);
    event PAID_EXPENSES(address from, address to, uint256 amount);

    // Owner of the property
    address internal owner;
    IController controller;
    // property name
    string name;

    struct feeStatus {
        bool isActive;
        bool isPaid;
        uint256 feeAmount;
    }

    IERC20 supportedToken;
    // member => month => feeStatus
    mapping(address => mapping(uint8 => feeStatus)) internal activeMember;

    constructor(address _owner, string memory _name, IERC20 _supportedToken, IController _controller) {
        owner = _owner;
        name = _name;
        supportedToken = _supportedToken;
        controller = _controller;
    }

    /**
     * Member will call this function to pay the monthly maintaince fees
     * @param _currMonth Month the member paying the fee of
     */
    function payFee(uint8 _currMonth) external isPropertyActive {
        if (!activeMember[msg.sender][_currMonth].isActive) {
            revert MEMBER_IS_NOT_ACTIVE();
        }
        if (activeMember[msg.sender][_currMonth].isPaid) {
            revert MEMBER_ALREADY_PAID();
        }
        uint256 feeAmount = activeMember[msg.sender][_currMonth].feeAmount;
        supportedToken.transferFrom(msg.sender, address(this), feeAmount);
        emit FEE_PAID(msg.sender, _currMonth, feeAmount);
    }

    /**
     * Owner will call this function to pay expenses
     * @param _to Address recieving supported token
     * @param _amount Amount paid `_to`
     */
    function payExpenses(address _to, uint256 _amount) external onlyOwner isPropertyActive {
        if (_to == address(0)) revert INVALID_ADDRESS();
        if (_amount == 0) revert INVALID_AMOUNT();
        uint256 beforeBalance = getBalance();
        if (beforeBalance < _amount) revert INSUFFICENT_BALANCE();
        supportedToken.transferFrom(address(this), _to, _amount);
        emit PAID_EXPENSES(msg.sender, _to, _amount);
    }

    /**
     * Owner will call this function to add new members
     * @param _members Address that being added as a member
     * @param _currMonth Current month such as 1 for Jan
     * @param _feeAmount Maintaince fee this member has to pay
     */
    function addMembers(address[] calldata _members, uint8 _currMonth, uint256 _feeAmount)
        external
        onlyOwner
        isPropertyActive
    {
        if (_members.length == 0) revert INVALID_MEMBERS();
        if (activeMember[msg.sender][_currMonth].isActive) {
            revert MEMBER_IS_ALREADY_ACTIVE();
        }
        for (uint256 i = 0; i < _members.length; ++i) {
            if (_members[i] != address(0)) {
                activeMember[_members[i]][_currMonth].isActive = true;
                activeMember[_members[i]][_currMonth].feeAmount = _feeAmount;
            }
        }
        emit ADD_MEMBERS(_members, _currMonth, _feeAmount);
    }

    /**
     * Owner call this function to withdraw any erc20 token
     * @param _erc20 Token to transfer
     * @param _amount Amount to transfer to
     */
    function withdrawERC20(address _erc20, uint256 _amount) external onlyOwner {
        if (_erc20 == address(0)) revert INVALID_ADDRESS();
        if (_amount == 0) revert INVALID_AMOUNT();
        bool success = IERC20(_erc20).transferFrom(address(this), owner, _amount);
        if (success == false) revert TRANSFER_FAILED();
    }

    function getPropertyStatus() internal view returns (bool) {
        return controller.isPropertyActive(address(this));
    }

    // Get current balance of this contract
    function getBalance() public view returns (uint256) {
        return supportedToken.balanceOf(address(this));
    }
}
