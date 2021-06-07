//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interfaces/IERC_20_EXTERNAL_MINTER.sol";
import "../SushiSwap/interfaces/IUniswapV2Factory.sol";
import "../SushiSwap/interfaces/IUniswapV2Router02.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract minter is AccessControlEnumerable{
    bytes32 public constant LOCAL_MINTER_ROLE = keccak256("MINTER_ROLE");
    IERC_20_EXTERNAL_MINTER FAH;
    IERC_20_EXTERNAL_MINTER CS_Case;
    IUniswapV2Factory SushiFactory;
    IUniswapV2Router02 SushiRouter;
    address pair_FAH_CS;

    constructor() {
        _setupRole(LOCAL_MINTER_ROLE, _msgSender());
    }

    function setContracts(address _FAH,
        address _CS_Case,
        address _SushiFactory,
        address _SushiRouter) public {
        require(hasRole(LOCAL_MINTER_ROLE, _msgSender()), "Does not have role");
        FAH = IERC_20_EXTERNAL_MINTER(address(_FAH));
        CS_Case = IERC_20_EXTERNAL_MINTER(address(_CS_Case));
        SushiFactory = IUniswapV2Factory(address(_Sushi));

        SushiFactory.createPair(_FAH, _CS_Case);
        SushiFactory.getPair(_FAH, _CS_Case);

        SushiRouter = IUniswapV2Router02(address(_SushiRouter));
    }

    function mintFAH(uint256 _amount) internal {
        uint256 _start_bal = FAH.balanceOf(address(this));
        FAH.externalMint(_amount, address(this));
        require(FAH.balanceOf(address(this)) - _start_bal == _amount, "Correct amount not minted");
    }

    function mintCS_Cases(uint256 _amount) internal {
        CS_Case.externalMint(_amount, address(this));
        //getAmountOut(1,2,3)
//        SushiRouter.swapExactTokensForTokens(_amount,
//        1);
    }
}
