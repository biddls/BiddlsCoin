//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./utility/users.sol";
import "./utility/minter.sol";

// this version will assume that everyone is nice... for now
contract CS_Skin is users, minter{
    constructor(){
    }

    function updateScore(uint256 _score, string memory _id) public {
        uint256 change = _updateScore(_score, _id);
        mintFAH(change, getAddress(_id));
    }
}
