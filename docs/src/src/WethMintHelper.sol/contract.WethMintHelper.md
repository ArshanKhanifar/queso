# WethMintHelper
[Git Source](https://github.com/ArshanKhanifar/queso/blob/6e395efa3ba1ede04789349c7913763f72d9d714/src/WethMintHelper.sol)

**Inherits:**
[BaseChainSetup](/src/BaseChainSetup.sol/contract.BaseChainSetup.md)


## State Variables
### wethWhaleLookup

```solidity
mapping(string => address) wethWhaleLookup;
```


## Functions
### _setupWhaleInfo


```solidity
function _setupWhaleInfo() private;
```

### setupWethHelperInfo


```solidity
function setupWethHelperInfo() public;
```

### mintWrappedTo


```solidity
function mintWrappedTo(string memory chain, address to, uint256 amount) public;
```

### mintWethTo


```solidity
function mintWethTo(string memory chain, address to, uint256 amount) public;
```

