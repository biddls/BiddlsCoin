//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

// this extends the ERC-20 contract from openZeppelin but adds the ability for another address to mint tokens
contract ERC_20_EXTERNAL_MINTER is ERC20PresetMinterPauser {
    bytes32 public constant EXTERNAL_MINTER = keccak256("MINTER_CONTRACT");
    uint8 private _decimals;
    address public EXTERNAL_MINTER_ADDRESS;

    constructor(uint256 initialSupply, uint8 _decimals_TEMP, string memory _name, string memory _symbol)
    ERC20PresetMinterPauser(_name, _symbol) {
        _mint(_msgSender(), initialSupply);
        _decimals = _decimals_TEMP;
    }

    // overrides a function that declares how many decimals something has
    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    // this allows for the updating of the minting address so that things can be upgraded
    function updateMinter(address _address) public {
        // Ensures only admin can change anything
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()), "Admin only");
        // Optimistically grands role to new address
        grantRole(EXTERNAL_MINTER, _address);
        // This ensures that the hang over was successful
        require(hasRole(EXTERNAL_MINTER, _address), "role has been received");
        // This removes the role from the previous minter
        revokeRole(EXTERNAL_MINTER, EXTERNAL_MINTER_ADDRESS);
        // This ensures that the role has been removed
        require(!hasRole(EXTERNAL_MINTER, EXTERNAL_MINTER_ADDRESS), "role has been removed prom pervious");
        // This updates the address of the Minter so it can be kept track of and removed later on
        // if an update is needed
        EXTERNAL_MINTER_ADDRESS = _address;
    }

    function externalMint(uint256 _amount, address _to) public {
        // This ensures that the address asking to mint coins has the right to
        require(hasRole(EXTERNAL_MINTER, _msgSender()), "Minter Address only");
        _mint(_to, _amount);
    }
    //address("address").call{value: 0 ether}(abi.encodeWithSignature("function_name(value_type1, value_type2)", value1, value2));
}