//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interfaces/IERC_20_EXTERNAL_MINTER.sol";
import "../SushiSwap/interfaces/IUniswapV2Factory.sol";
import "../SushiSwap/interfaces/IUniswapV2Router02.sol";
import "../SushiSwap/interfaces/IUniswapV2Pair.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract LP_manager is AccessControlEnumerable{
    bytes32 public constant LOCAL_MINTER_ROLE = keccak256("MINTER_ROLE");
    IERC_20_EXTERNAL_MINTER FAH;
    IERC_20_EXTERNAL_MINTER CS_Case;
    IUniswapV2Factory factory;
    IUniswapV2Router02 router;
    IUniswapV2Pair pair_FAH_CS;
    address pair_FAH_CS_Addr;

    constructor(address _FAH,
        address _CS_Case,
        address _factory,
        address _router) {
        _setupRole(LOCAL_MINTER_ROLE, _msgSender());

        //set up of sushi integration
        require(hasRole(LOCAL_MINTER_ROLE, _msgSender()), "Does not have role");
        FAH = IERC_20_EXTERNAL_MINTER(address(_FAH));
        CS_Case = IERC_20_EXTERNAL_MINTER(address(_CS_Case));
        factory = IUniswapV2Factory(address(_factory));
        router = IUniswapV2Router02(address(_router));

        pair_FAH_CS_Addr = factory.createPair(_FAH, _CS_Case);
        pair_FAH_CS = IUniswapV2Pair(address(pair_FAH_CS_Addr));
    }

    function _poolSetup(uint256 _amount) internal {
        require(FAH.approve(address(router), _amount), 'approve failed FAH');
        require(CS_Case.approve(address(router), _amount), 'approve failed CS_CASE');
        FAH.externalMint(_amount, address(this));
        router.addLiquidity(
            address(FAH),
            address(CS_Case),
            _amount,
            _amount,
            _amount,
            _amount,
            address(0),
            9999999999);
        require(pair_FAH_CS.balanceOf(address(0)) == _amount, 'LP token not burned');
    }

    // sells CS cases into the pool
    function CS_Cases_to_FAH(uint256 _amount, uint256 _slippage, uint256 deadline) internal {
        require(_slippage < 1000);
        require(CS_Case.approve(address(router), _amount), 'approve failed CS_CASE');
        (uint112 tok1, uint112 tok2,) = pair_FAH_CS.getReserves();
        uint out = router.getAmountOut(_amount,tok1,tok2);
        address[] memory path = new address[](2);
        path[0] = address(CS_Case);
        path[1] = address(FAH);
        router.swapExactTokensForTokens(
            _amount,
            1,//(out*_slippage)/1000,
            path,
            address(0),
            block.timestamp);
    }
}
