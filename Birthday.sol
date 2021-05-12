// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Birthday {
    mapping(address => uint256) private _birthdays;
    mapping(address => uint256) private _setbirthdays;
    mapping(address => uint256) private _hideBalance;
    mapping(address => uint256) private _avaibleBalance;
    uint256 private _secondPerDay = 86400;

    function setBirthday(address account, uint256 day) public {
        require(_birthdays[account] == 0, "Birthday: birthday already defined");
        _birthdays[account] = block.timestamp + day * _secondPerDay;
        _setbirthdays[account] = block.timestamp;
    }

    function getPresent() public {
        require(
            _birthdays[msg.sender] < block.timestamp,
            "Birthday: is not your birthday"
        );
        _avaibleBalance[msg.sender] += _hideBalance[msg.sender];
        _hideBalance[msg.sender] = 0;
        _birthdays[msg.sender] = 0;
    }

    function deposit() public payable {
        _avaibleBalance[msg.sender] += msg.value;
    }

    function offer(address account, uint256 amount) public {
        require(
            _avaibleBalance[msg.sender] >= amount,
            "Birthday: not enought in you account"
        );
        _avaibleBalance[msg.sender] -= amount;
        _hideBalance[account] += amount;
    }

    function offer(address account) public payable {
        _hideBalance[account] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(
            _avaibleBalance[msg.sender] <= amount,
            "Birthday: not enought in your account"
        );
        _avaibleBalance[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function withdraw() public {
        uint256 amount = _avaibleBalance[msg.sender];
        _avaibleBalance[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function birthdayOf(address account) public view returns (uint256) {
        return (_birthdays[account] - _setbirthdays[account]) / _secondPerDay;
    }

    function checkBalance() public view returns (uint256) {
        return _avaibleBalance[msg.sender];
    }
}
