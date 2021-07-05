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
    IUniswapV2Factory factory;
    IUniswapV2Router02 router;
    IUniswapV2Pair pair_FAH_CS;
    address pair_FAH_CS_Addr;

    constructor(address _FAH,
        address _CS_Case,
        address _SushiFactory,
        address _SushiRouter) {
        _setupRole(LOCAL_MINTER_ROLE, _msgSender());

        //set up of sushi integration
        require(hasRole(LOCAL_MINTER_ROLE, _msgSender()), "Does not have role");
        FAH = IERC_20_EXTERNAL_MINTER(address(_FAH));
        CS_Case = IERC_20_EXTERNAL_MINTER(address(_CS_Case));
        factory = IUniswapV2Factory(address(_SushiFactory));
        router = IUniswapV2Router02(address(_SushiRouter));

//        pair_FAH_CS_Addr = SushiFactory.createPair(_FAH, _CS_Case);
//        pair_FAH_CS = IUniswapV2Pair(address(pair_FAH_CS_Addr));
        FAH.approve(_SushiRouter,10**18);
        CS_Case.approve(_SushiRouter,10**18);
    }

    function poolSetup(uint256 _FAH_amount) public {
        //adding the original liquidity
        FAH.externalMint(_FAH_amount, address(this));
//        router.addLiquidity(
//            address(FAH),
//            address(CS_Case),
//            1000,
//            1000,
//            1000,
//            1000,
//            address(0),
//            9999999999);
    }

    function CS_Cases_to_FAH(uint256 _amount, uint256 _slippage, uint256 deadline) internal {
        require(_slippage < 1000);
        (uint112 tok1, uint112 tok2,) = pair_FAH_CS.getReserves();
        uint out = router.getAmountOut(_amount,tok1,tok2);
        address[] memory path = new address[](2);
        path[0] = address(CS_Case);
        path[1] = address(FAH);
        router.swapExactTokensForTokens(_amount,
            (out*_slippage)/1000,
            path,
            address(this),
            deadline);
        FAH.burn(FAH.balanceOf(address(this)));
    }
}
