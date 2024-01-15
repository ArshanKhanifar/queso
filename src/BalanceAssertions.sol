// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {BaseChainSetup} from "./BaseChainSetup.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";
import {Test} from "forge-std/Test.sol";

/// @title BalanceAssertions
/// @notice This contract is used to assert balances of tokens and ETH
/// @dev This contract is used by the tests
contract BalanceAssertions is BaseChainSetup, Test {
    /// @title assertTokenBalanceEq
    /// @notice Asserts that the balance of a token is equal to the given amount
    /// @param chain The chain to switch to, this is an alias according to what's
    /// defined in foundry.toml
    /// @param user The user whose balance is being asserted
    /// @param token The token whose balance is being asserted
    /// @param amount Expected amount
    function assertTokenBalanceEq(string memory chain, address user, address token, uint256 amount) internal {
        switchTo(chain);
        assertEq(ERC20(token).balanceOf(user), amount);
    }

    /// @title assertWethBalanceEq
    /// @notice Asserts that the balance of WETH is equal to the given amount
    /// @param chain The chain to switch to, this is an alias according to what's
    /// defined in foundry.toml
    /// @param user The user whose balance is being asserted
    /// @param amount Expected amount
    function assertWethBalanceEq(string memory chain, address user, uint256 amount) internal {
        assertTokenBalanceEq(chain, user, wethLookup[chain], amount);
    }

    /// @title assertEthBalanceEq
    /// @notice Asserts that the balance of ETH is equal to the given amount
    /// @param chain The chain to switch to, this is an alias according to what's
    /// defined in foundry.toml
    /// @param user The user whose balance is being asserted
    /// @param amount Expected amount
    function assertEthBalanceEq(string memory chain, address user, uint256 amount) internal {
        assertEq(ethBalance(chain, user), amount);
    }

    /// @title ethBalance
    /// @notice Switches to the given chain and returns the balance of ETH for the given user on that chain
    /// @param chain The chain to switch to, this is an alias according to what's
    /// defined in foundry.toml
    /// @param user The user whose balance is being asserted
    function ethBalance(string memory chain, address user) internal returns (uint256) {
        switchTo(chain);
        return user.balance;
    }
}
