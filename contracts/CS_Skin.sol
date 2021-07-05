//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./utility/users.sol";
import "./utility/minter.sol";
import "./utility/Skins.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";


// this version will assume that everyone is nice... for now
contract CS_Skin is users, minter, Skins, ERC1155Holder{
    constructor(address _FAH,
        address _CS_Case,
        address _SushiFactory,
        address _SushiRouter) minter(_FAH,
        _CS_Case,
        _SushiFactory,
        _SushiRouter){
    }

    function supportsInterface(bytes4 interfaceId)
    public view virtual override(AccessControlEnumerable,
    ERC1155PresetMinterPauser,
    ERC1155Receiver)
    returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // makes a new skin then sells the cases to the sushi pool so people can buy them
    function newSkin(uint256 _amount) public {
        _newSkin(_amount);
        CS_Case.externalMint(_amount, address(this));
    }

    // allows a user to update their score
    function updateScore(uint256 _score, string memory _id) public {
        uint256 change = _updateScore(_score, _id);
        FAH.externalMint(change, getAddress(_id));
    }
}