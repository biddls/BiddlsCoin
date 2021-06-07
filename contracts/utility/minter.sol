//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interfaces/IERC_20_EXTERNAL_MINTER.sol";
import "../contracts/SushiSwap/interfaces/IUniswapV2Factory.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract minter is AccessControlEnumerable{
    bytes32 public constant LOCAL_MINTER_ROLE = keccak256("MINTER_ROLE");
    IERC_20_EXTERNAL_MINTER FAH;
    IERC_20_EXTERNAL_MINTER CS_Case;
    IUniswapV2Factory Sushi;

    constructor() {
        _setupRole(LOCAL_MINTER_ROLE, _msgSender());
    }

    function setContracts(address _FAH, address _CS_Case, address _Sushi) public {
        require(hasRole(LOCAL_MINTER_ROLE, _msgSender()), "Does not have role");
        FAH = IERC_20_EXTERNAL_MINTER(address(_FAH));
        CS_Case = IERC_20_EXTERNAL_MINTER(address(_CS_Case));
        Sushi = IUniswapV2Factory(address(_Sushi));
    }

    function mintFAH(uint256 _amount, address _to) internal {
        uint256 _start_bal = FAH.balanceOf(_to);
        FAH.externalMint(_amount, _to);
        require(FAH.balanceOf(_to) - _start_bal == _amount, "Correct amount not minted");
    }
}
