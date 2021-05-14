// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Testament {
    mapping(address => mapping(address => uint256)) private _delegations;
    mapping(address => address) private _doctors;
    mapping(address => bool) private _dead;
    uint256 private _secondPerDay = 86400;

    function delegate(address account) public payable {
        _delegations[account][msg.sender] += msg.value;
    }

    function setDoctor(address account) public {
        _doctors[msg.sender] = account;
    }

    function death(address account) public {
        require(
            _doctors[account] == msg.sender,
            "Testament: you are not his doctor"
        );
        _dead[account] = true;
    }

    function withdrawDelegation(address account) public {
        require(_dead[account], "Testament: user is alive");
        uint256 amount = _delegations[msg.sender][account];
        _delegations[msg.sender][account] = 0;
        payable(msg.sender).transfer(amount);
    }

    function checkDelegation(address account) public view returns (uint256) {
        return _delegations[msg.sender][account];
    }
}
