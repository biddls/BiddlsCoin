//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC_20_EXTERNAL_MINTER is IERC20{
    function decimals() external view returns (uint8);
    function externalMint(uint256 _amount, address _to) external;
    function updateMinter(address _address) external;
    function burn(uint256 amount) external;
}