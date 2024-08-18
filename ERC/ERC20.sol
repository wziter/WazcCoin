// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./IERC20.sol";

contract ERC20 is IERC20{
    mapping (address => uint256) private _balances;
    
    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    string private _name;

    string private _symbol;

    uint8 private _decimal;

    error NotEnough(address from, uint256 balances, uint value);
    error ZeroAddress();
    error NotApproved(address from, address to, address msgSender, uint256 balances,uint value);

    constructor(string memory vName, string memory vSymbol, uint8 vDecimal){
        _name = vName;
        _symbol = vSymbol;
        _decimal = vDecimal;
    } 

    function name() external view override returns (string memory) {
        return _name;
    }

     function symbol() external view override returns (string memory) {
        return _symbol;
    }

     function decimals() external view override returns (uint8) {
        return _decimal;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) external view override returns (uint256) {
        return _balances[_owner];
    }

    function transfer(address _to, uint256 _value) external override returns (bool) {
         if (_to == address(0)) {
            revert ZeroAddress();
        }
        
        if (_balances[msg.sender] < _value) {
            revert NotEnough(msg.sender, _balances[msg.sender], _value);
        }

        _balances[msg.sender] -= _value;
        _balances[_to] += _value;
    
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function allowance(address _owner, address _spender) external view override returns (uint256) {
        return _allowed[_owner][_spender];
    }

    function approve(address _spender, uint256 _value) external override returns (bool) {
        if (_spender == address(0)) {
            revert ZeroAddress();
        }

        _allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external override returns (bool) {
        if (_to == address(0)) {
            revert ZeroAddress();
        }
        // check if approved
        if (_value > _allowed[_from][msg.sender]) {
            revert NotApproved(_from, _to, msg.sender, _allowed[_from][msg.sender], _value);
        }
        // check if _from has enough value
        if (_value > _balances[_from]) {
            revert NotEnough(_from, _allowed[_from][msg.sender], _value);
        }

        _allowed[_from][msg.sender] -= _value;
        _balances[_from] -= _value;
        _balances[_to] += _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    function _mint(address _account, uint256 _amount) internal returns (bool) {
        if (_account == address(0)) {
            revert ZeroAddress();
        }

        _totalSupply += _amount;
        _balances[_account] += _amount;
        emit Transfer(address(0), _account, _amount);
        return true;
    }

    function _burn(address _account, uint256 _amount) internal {
        if (_account == address(0)) {
            revert ZeroAddress();
        }
        if (_amount > _balances[_account]) {
            revert NotEnough(_account, _balances[_account], _amount);
        }

        _totalSupply -= _totalSupply;
        _balances[_account] -= _amount;
        emit Transfer(_account, address(0), _amount);
    }

}