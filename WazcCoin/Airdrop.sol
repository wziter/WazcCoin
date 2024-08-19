// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./WazcCoin.sol";

contract Airdrop {

    address private waczAddr;

    mapping (address => uint256) private addrAmount;
    address[] private addrArr;

    event LogmultiTransferToken(address _from, uint256 amount);

    constructor(address _addr){
        waczAddr = _addr;
    }

    function getSum() internal view returns (uint256 sums) {
        sums = 0;
        for (uint256 i = 0; i < addrArr.length; i++) {
            sums += addrAmount[addrArr[i]];
        }
    }

    // todo: use multisignature to ensure only serveral accounts can use this function
    function setAirdropAddrAndAmount(address _address, uint256 _amount) external {
        if (addrAmount[_address] == 0) {
            addrArr.push(_address);
        }
        addrAmount[_address] += _amount;
    }

    function multiTransferToken() external {
        WazcCoin wazc = WazcCoin(waczAddr);
        uint256 totalAmount = getSum();
        require (wazc.balanceOf(address(this)) >= totalAmount, "not enough balance");

        for (uint256 i = 0; i < addrArr.length; i ++) {
             wazc.transfer(addrArr[i], addrAmount[addrArr[i]]);
        }

        emit LogmultiTransferToken(address(this), totalAmount);
    }
}