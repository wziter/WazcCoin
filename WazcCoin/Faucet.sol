// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./WazcCoin.sol";

contract Faucet {
    uint8 private constant AMOUNTALLOWED = 10;

    address private wazcAddress;

    mapping(address => bool) private requestedAddress;

    event sendToken(address indexed receiver, uint256 indexed amount);

    constructor(address _wazcAddress){
        wazcAddress = _wazcAddress;
    }

    function requestToken() external  {
        require (!requestedAddress[msg.sender], "request twice!");
       
        WazcCoin wazc = WazcCoin(wazcAddress);
        require(wazc.balanceOf(address(this)) >= AMOUNTALLOWED, "Faucet empty");
        
        wazc.transfer( msg.sender, AMOUNTALLOWED);
        emit sendToken(msg.sender, AMOUNTALLOWED);
        requestedAddress[msg.sender] = true;
    }

}