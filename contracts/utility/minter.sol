//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "../interfaces/IERC_20_EXTERNAL_MINTER.sol";

contract minter is AccessControlEnumerable{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    IERC_20_EXTERNAL_MINTER FAH;
    IERC_20_EXTERNAL_MINTER CS_Case;

    constructor() {
        _setupRole(MINTER_ROLE, _msgSender());
    }

    function setContracts(address _FAH, address _CS_Case) public {
        require(hasRole(MINTER_ROLE, _msgSender()), "Does not have role");
        FAH = IERC_20_EXTERNAL_MINTER(address(_FAH));
        CS_Case = IERC_20_EXTERNAL_MINTER(address(_CS_Case));
    }

    function mintFAH(uint256 _amount, address _to) internal {
        uint256 _start_bal = FAH.balanceOf(_to);
        FAH.externalMint(_amount, _to);
        require(FAH.balanceOf(_to) - _start_bal == _amount, "Correct amount not minted");
    }
}
