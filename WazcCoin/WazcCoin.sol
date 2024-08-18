// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../ERC/ERC20.sol";
import "./StakeManageETH.sol";

contract WazcCoin is ERC20 {
    address private _stakeAddress;
    constructor(address stakeManageAddr) ERC20("WazcCoin", "WAZC", 18){
        _stakeAddress = stakeManageAddr;
    }

    mapping (address => uint256) private _stake;

    uint64 constant STAKEVALUE = 1 ether;
    uint8 constant MintCoinNumber = 10;
    
    event LogStakeAddress(address addr);
    
    error notEnoughStake(uint256 amount);
    error notEnoughValue(uint256 value, uint256 amount);
    event LogIncStake(address account, uint256 amount);
    event LogDescStake(address account, uint256 amount);

    modifier checkStake() {
        if (_stake[msg.sender] < STAKEVALUE) {
            revert notEnoughStake(_stake[msg.sender]);
        }
        _;
    }

    function increaseStake(uint256 _amount) external payable {
        if (msg.value < _amount) {
            revert notEnoughValue(msg.value, _amount);
        }

        emit LogStakeAddress(_stakeAddress);
        payable(_stakeAddress).transfer(_amount);
        _stake[msg.sender] += _amount;
        emit LogIncStake(msg.sender, _amount);
    }

    function decreaseStake(uint256 _amount) external payable {
        if (_stake[msg.sender] < _amount) {
            revert notEnoughValue(_stake[msg.sender], _amount);
        }
        StakeManageETH(payable(_stakeAddress)).trans(payable(msg.sender), _amount);
        _stake[msg.sender] -= _amount;
        emit LogDescStake(msg.sender, _amount);
    }

    function getStake(address _account) external view returns(uint256) {
        return _stake[_account];
    }

    function mint() external checkStake {
        bool res = _mint(msg.sender, MintCoinNumber);
        if (res) {
            StakeManageETH(payable(_stakeAddress)).trans(payable(msg.sender), STAKEVALUE);
            _stake[msg.sender] -= STAKEVALUE;
            emit LogDescStake(msg.sender, STAKEVALUE);
        }
    }

}