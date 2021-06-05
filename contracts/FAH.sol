//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./utility/ERC_20_EXTERNAL_MINTER.sol";

// calls a function to make a ERC-20 token with certain parameters
contract FAH is ERC_20_EXTERNAL_MINTER{
    constructor (uint256 initialSupply, uint8 _decimals_TEMP, string memory _name, string memory _symbol)
    ERC_20_EXTERNAL_MINTER(initialSupply, _decimals_TEMP, _name, _symbol){
    }
}
