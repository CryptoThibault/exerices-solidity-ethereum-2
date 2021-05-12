// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Testament {
    mapping(address => mapping(address => uint256)) private _delegations;
    mapping(address => mapping(address => uint256)) private _time;
    uint256 private _secondPerDay = 86400;

    function delegate(address account) public payable {
        _delegations[account][msg.sender] += msg.value;
    }

    function setTime(address account, uint256 day) public {
        _time[account][msg.sender] = day * _secondPerDay + block.timestamp;
    }

    function withdrawDelegation(address account) public {
        require(
            _time[msg.sender][account] < block.timestamp,
            "Testament: is not delegation time"
        );
        uint256 amount = _delegations[msg.sender][account];
        _delegations[msg.sender][account] = 0;
        payable(msg.sender).transfer(amount);
    }

    function checkDelegation(address account) public view returns (uint256) {
        return _delegations[msg.sender][account];
    }
}
