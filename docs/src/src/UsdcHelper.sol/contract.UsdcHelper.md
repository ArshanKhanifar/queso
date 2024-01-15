# UsdcHelper
[Git Source](https://github.com/ArshanKhanifar/queso/blob/6e395efa3ba1ede04789349c7913763f72d9d714/src/UsdcHelper.sol)

**Inherits:**
[TokenHelper](/src/UsdcHelper.sol/contract.TokenHelper.md), [ChainAliases](/src/ChainAliases.sol/contract.ChainAliases.md)


## Functions
### getUsdc


```solidity
function getUsdc(string memory chain) public view returns (address);
```

### getUsdcOrZeroAddress


```solidity
function getUsdcOrZeroAddress(string memory chain) public view returns (address);
```

### usdcBalance


```solidity
function usdcBalance(string memory chain, address person) public view returns (uint256);
```

### mintUsdcTo


```solidity
function mintUsdcTo(string memory chain, address to, uint256 amount) public;
```

### setupUsdcInfo


```solidity
function setupUsdcInfo() public;
```

### _addTokenAddress


```solidity
function _addTokenAddress(string memory chain, address addy) private;
```

### _addWhaleAddress


```solidity
function _addWhaleAddress(string memory chain, address addy) private;
```

### _setupUsdcTokenAddress


```solidity
function _setupUsdcTokenAddress() private;
```

### _setupUsdcWhaleInfo


```solidity
function _setupUsdcWhaleInfo() private;
```

