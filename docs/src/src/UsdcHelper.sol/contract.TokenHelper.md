# TokenHelper
[Git Source](https://github.com/ArshanKhanifar/queso/blob/6e395efa3ba1ede04789349c7913763f72d9d714/src/UsdcHelper.sol)

**Inherits:**
[BaseChainSetup](/src/BaseChainSetup.sol/contract.BaseChainSetup.md)


## State Variables
### TOKEN_NAME

```solidity
string TOKEN_NAME;
```


### tokenLookup

```solidity
mapping(string => address) tokenLookup;
```


### whaleLookup

```solidity
mapping(string => address) whaleLookup;
```


## Functions
### constructor


```solidity
constructor(string memory tokenName);
```

### mintTokenTo


```solidity
function mintTokenTo(string memory chain, address to, uint256 amount) internal;
```

### getTokenAddress


```solidity
function getTokenAddress(string memory chain) internal view returns (address);
```

### getTokenAddress


```solidity
function getTokenAddress(string memory chain, bool revertOnFailure) internal view returns (address);
```

