// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract StakeManageETH {
    event LogReceive(address account, uint256 amount);
    event LogTrans(address account, uint256 amount);
    
    receive() external payable { 
        emit LogReceive(msg.sender, msg.value);
    }

    function getBalance() external view returns(uint256){
        return address(this).balance;
    }

    function trans(address payable _account, uint256 _amount) external {
        _account.transfer(_amount);
        emit LogTrans(_account, _amount);
    }
}