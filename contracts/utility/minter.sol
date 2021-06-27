//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interfaces/IERC_20_EXTERNAL_MINTER.sol";
import "../SushiSwap/interfaces/IUniswapV2Factory.sol";
import "../SushiSwap/interfaces/IUniswapV2Router02.sol";
import "../SushiSwap/interfaces/IUniswapV2Pair.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract minter is AccessControlEnumerable{
    bytes32 public constant LOCAL_MINTER_ROLE = keccak256("MINTER_ROLE");
    IERC_20_EXTERNAL_MINTER FAH;
    IERC_20_EXTERNAL_MINTER CS_Case;
    IUniswapV2Factory SushiFactory;
    IUniswapV2Router02 SushiRouter;
    IUniswapV2Pair pair_FAH_CS;
    address pair_FAH_CS_Addr;

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
        SushiFactory = IUniswapV2Factory(address(_SushiFactory));
        SushiRouter = IUniswapV2Router02(address(_SushiRouter));

        pair_FAH_CS_Addr = SushiFactory.createPair(_FAH, _CS_Case);
    }

    function mintFAH(uint256 _amount) internal {
        uint256 _start_bal = FAH.balanceOf(address(this));
        FAH.externalMint(_amount, address(this));
        require(FAH.balanceOf(address(this)) - _start_bal == _amount, "Correct amount not minted");
    }

    function mintCS_Cases(uint256 _amount, uint256 _slippage, uint256 deadline) internal {
        require(_slippage < 1000);
        CS_Case.externalMint(_amount, address(this));
        (uint112 tok1, uint112 tok2,) = pair_FAH_CS.getReserves();
        uint out = SushiRouter.getAmountOut(_amount,tok1,tok2);
        SushiRouter.swapExactTokensForTokens(_amount,
            (out*_slippage)/1000,
            [address(CS_Case), address(FAH)],
            address(this),
            deadline);
        FAH.burn(FAH.balanceOf(address(this)));
    }

    function FAH_2_CS(uint256 _amount, uint256 _slippage, uint256 deadline) internal {
        require(_slippage < 1000);
        (uint112 tok1, uint112 tok2,) = pair_FAH_CS.getReserves();
        uint out = SushiRouter.getAmountOut(_amount,tok2,tok1);
        SushiRouter.swapExactTokensForTokens(_amount,
            (out*_slippage)/1000,
            [address(FAH), address(CS_Case)],
            address(this),
            deadline);
    }
}
