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

    function updateScore(uint256 _score, string memory _id) public {
        uint256 change = _updateScore(_score, _id);
        mintFAH(change, getAddress(_id));
    }

    function supportsInterface(bytes4 interfaceId)
    public view virtual override(AccessControlEnumerable, ERC1155PresetMinterPauser, ERC1155Receiver)
    returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}