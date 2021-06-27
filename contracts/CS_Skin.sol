//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./utility/users.sol";
import "./utility/minter.sol";
import "./utility/Skins.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";


// this version will assume that everyone is nice... for now
contract CS_Skin is users, minter, Skins, ERC1155Holder{
    constructor(){
    }

    function supportsInterface(bytes4 interfaceId)
    public view virtual override(AccessControlEnumerable,
    ERC1155PresetMinterPauser,
    ERC1155Receiver)
    returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function newItem(uint256 _amount) public {
        _newSkin(_amount);
        mintCS_Cases(_amount * (10**CS_Case.decimals()), 97, 10000000000);
    }

    function updateScore(uint256 _score, string memory _id) public {
        uint256 change = _updateScore(_score, _id);
        mintFAH(change);
    }

    function updateSwap(uint256 _score, string memory _id) public {
        updateScore(_score, _id);
    }
}