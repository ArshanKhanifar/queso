# ChainsInfo
[Git Source](https://github.com/ArshanKhanifar/queso/blob/6e395efa3ba1ede04789349c7913763f72d9d714/src/ChainsInfo.sol)

**Inherits:**
[BaseChainSetup](/src/BaseChainSetup.sol/contract.BaseChainSetup.md)

This contract is used to populate the chain info for various chains


## State Variables
### OP_STACK_WETH

```solidity
address OP_STACK_WETH = 0x4200000000000000000000000000000000000006;
```


## Functions
### setupChainInfo

This function is used to populate the chain info for various chains, use it in the beginning of
your scripts and test cases to populate the chain info lookups.


```solidity
function setupChainInfo() public;
```

