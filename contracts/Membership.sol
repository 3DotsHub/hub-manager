// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import '@openzeppelin/contracts/access/AccessControl.sol';

contract Membership is AccessControl {
	bytes32 public constant ADMIN_ROLE = keccak256('ADMIN_ROLE');
	bytes32 public constant EXECUTOR_ROLE = keccak256('EXECUTOR_ROLE');
	bytes32 public constant MEMBER_ROLE = keccak256('MEMBER_ROLE');

	// ---------------------------------------------------------------------------------------
	constructor(address admin) {
		_setRoleAdmin(ADMIN_ROLE, ADMIN_ROLE);
		_setRoleAdmin(EXECUTOR_ROLE, ADMIN_ROLE);
		_setRoleAdmin(MEMBER_ROLE, EXECUTOR_ROLE);

		_grantRole(ADMIN_ROLE, admin);

		_grantRole(EXECUTOR_ROLE, admin);
		_grantRole(EXECUTOR_ROLE, msg.sender);
		
		_grantRole(MEMBER_ROLE, msg.sender);
	}
}
