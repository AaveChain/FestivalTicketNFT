// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CurrencyToken is ERC20 {
    constructor() ERC20("CurrencyToken", "CT") {
        _mint(msg.sender, 10 * 10 ** 18); // Mint 1,000,000 tokens to the contract deployer
    }
}
