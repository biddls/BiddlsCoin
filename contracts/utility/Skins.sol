//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/presets/ERC1155PresetMinterPauser.sol";

// this version will assume that everyone is nice... for now
contract Skins is ERC1155PresetMinterPauser{

    uint256[] public skinQuantities;
    uint256 public skinCount = 0;  // the total of skins in existence
    uint256 public uniqueSkinCount = 0;  // the number of types of skins in existence

    constructor() ERC1155PresetMinterPauser(""){
        grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function _newSkin(uint256 _amount) internal virtual {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "No permission to mint");
        mint(address(this), uniqueSkinCount, _amount, "");
        uniqueSkinCount++;
        skinCount += _amount;
        skinQuantities.push(_amount);
    }

    function getSkinAvailability(uint256 _id) public view virtual returns (uint256) {
        require(_id < skinQuantities.length, "ID to large, skin does not exist");
        return skinQuantities[_id];
    }
}