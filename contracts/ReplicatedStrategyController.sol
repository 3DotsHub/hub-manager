// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import './Membership.sol';
import 'hardhat/console.sol';

struct MemberInfo {
	uint256 id;
	address depositEth;
	string depositBtc;
}

contract ReplicatedStrategyController {
	Membership public immutable member;

	mapping(address member => MemberInfo infoDetails) public info;
	mapping(address token => bool isDepositable) public isDepositToken;

	// ---------------------------------------------------------------------------------------
	modifier onlyExecutors() {
		require(member.hasRole(member.EXECUTOR_ROLE(), msg.sender) == true, 'No Executor');
		_;
	}
	modifier onlyMembers() {
		require(member.hasRole(member.MEMBER_ROLE(), msg.sender) == true, 'No Member');
		_;
	}

	// ---------------------------------------------------------------------------------------
	event DepositToken(address token, bool usable);
	event MemberRegistered(address member, address executor);
	event DepositAndSwap(address member, address token, uint256 amount, uint32 swapPrice);

	error NothingChanged();
	error AlreadyRegistered();
	error NotDepositToken();

	// ---------------------------------------------------------------------------------------
	constructor(address _member, address _usdc, address _usdt) {
		member = Membership(_member);
		_setDepositToken(_usdc, true);
		_setDepositToken(_usdt, true);
	}

	// ---------------------------------------------------------------------------------------
	function setDepositToken(address token, bool usable) public onlyExecutors {
		_setDepositToken(token, usable);
	}

	function _setDepositToken(address token, bool usable) internal {
		if (isDepositToken[token] == usable) revert NothingChanged();
		isDepositToken[token] = usable;
		emit DepositToken(token, usable);
	}

	// ---------------------------------------------------------------------------------------
	function registerMember(address _newMember, uint256 _id, address _depositEth, string calldata _depositBtc) public onlyExecutors {
		if (info[_newMember].id != 0) revert AlreadyRegistered();
		info[_newMember].id = _id;
		info[_newMember].depositEth = _depositEth;
		info[_newMember].depositBtc = _depositBtc;
		member.grantRole(member.MEMBER_ROLE(), _newMember);
		emit MemberRegistered(_newMember, msg.sender);
	}

	// ---------------------------------------------------------------------------------------
	function depositAndSwap(address token, uint256 amount, uint32 swapPrice) public onlyMembers {
		if (isDepositToken[token] == false) revert NotDepositToken();
		ERC20(token).transferFrom(msg.sender, info[msg.sender].depositEth, amount); // @dev: needs correct allowance "depositEth"
		emit DepositAndSwap(msg.sender, token, amount, swapPrice);
	}
}
