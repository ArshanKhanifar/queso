# BalanceAssertions
[Git Source](https://github.com/ArshanKhanifar/queso/blob/6e395efa3ba1ede04789349c7913763f72d9d714/src/BalanceAssertions.sol)

**Inherits:**
[BaseChainSetup](/src/BaseChainSetup.sol/contract.BaseChainSetup.md), Test

This contract is used to assert balances of tokens and ETH

*This contract is used by the tests*


## Functions
### assertTokenBalanceEq

Asserts that the balance of a token is equal to the given amount


```solidity
function assertTokenBalanceEq(string memory chain, address user, address token, uint256 amount) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|The chain to switch to, this is an alias according to what's defined in foundry.toml|
|`user`|`address`|The user whose balance is being asserted|
|`token`|`address`|The token whose balance is being asserted|
|`amount`|`uint256`|Expected amount|


### assertWethBalanceEq

Asserts that the balance of WETH is equal to the given amount


```solidity
function assertWethBalanceEq(string memory chain, address user, uint256 amount) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|The chain to switch to, this is an alias according to what's defined in foundry.toml|
|`user`|`address`|The user whose balance is being asserted|
|`amount`|`uint256`|Expected amount|


### assertEthBalanceEq

Asserts that the balance of ETH is equal to the given amount


```solidity
function assertEthBalanceEq(string memory chain, address user, uint256 amount) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|The chain to switch to, this is an alias according to what's defined in foundry.toml|
|`user`|`address`|The user whose balance is being asserted|
|`amount`|`uint256`|Expected amount|


### ethBalance

Switches to the given chain and returns the balance of ETH for the given user on that chain


```solidity
function ethBalance(string memory chain, address user) internal returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|The chain to switch to, this is an alias according to what's defined in foundry.toml|
|`user`|`address`|The user whose balance is being asserted|


