//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./utility/users.sol";
import "./utility/LP_manager.sol";
import "./utility/Skins.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";


// this version will assume that everyone is nice... for now
contract CS_Skin is users, LP_manager, Skins, ERC1155Holder{
    constructor(address _FAH,
        address _CS_Case,
        address _factory,
        address _router) LP_manager(_FAH,
        _CS_Case,
        _factory,
        _router){
    }

    function supportsInterface(bytes4 interfaceId)
    public view virtual override(AccessControlEnumerable,
    ERC1155PresetMinterPauser,
    ERC1155Receiver)
    returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // makes a new skin then sells the cases to the sushi pool so people can buy them
    function newSkin(uint256 _amount, uint256 _deadline) public {
        _newSkin(_amount);
        CS_Case.externalMint(_amount, address(this));
        CS_Cases_to_FAH(_amount,970,_deadline);
    }

    // allows a user to update their score
    function updateScore(uint256 _score, string memory _id) public {
        uint256 change = _updateScore(_score, _id);
        FAH.externalMint(change, getAddress(_id));
    }

    function poolSetup(uint256 _amount) public {
        _newSkin(_amount);
        CS_Case.externalMint(_amount, address(this));
        _poolSetup(_amount);
    }
}