# UniswapRouterHelpers
[Git Source](https://github.com/ArshanKhanifar/queso/blob/6e395efa3ba1ede04789349c7913763f72d9d714/src/UniswapRouterHelpers.sol)

**Inherits:**
[BaseChainSetup](/src/BaseChainSetup.sol/contract.BaseChainSetup.md), [ChainAliases](/src/ChainAliases.sol/contract.ChainAliases.md), [UsdcHelper](/src/UsdcHelper.sol/contract.UsdcHelper.md)


## State Variables
### uniQuoterLookup

```solidity
mapping(string => IQuoterV2) uniQuoterLookup;
```


### uniRouterLookup

```solidity
mapping(string => address) public uniRouterLookup;
```


### TICK_SIZE_1

```solidity
uint24 constant TICK_SIZE_1 = 100;
```


### TICK_SIZE_2

```solidity
uint24 constant TICK_SIZE_2 = 300;
```


### TICK_SIZE_3

```solidity
uint24 constant TICK_SIZE_3 = 500;
```


### COMMON_SWAP_ROUTER_02

```solidity
address constant COMMON_SWAP_ROUTER_02 = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;
```


### COMMON_QUOTER

```solidity
address constant COMMON_QUOTER = 0x61fFE014bA17989E743c5F6cB21bF9697530B21e;
```


### AVAX_SWAPROUTER

```solidity
address constant AVAX_SWAPROUTER = 0xbb00FF08d01D300023C629E8fFfFcb65A5a578cE;
```


### AVAX_QUOTER

```solidity
address constant AVAX_QUOTER = 0xbe0F5544EC67e9B3b2D979aaA43f18Fd87E6257F;
```


## Functions
### getUniRouter


```solidity
function getUniRouter(string memory chain) public view returns (address);
```

### _switchAndGetQuoter


```solidity
function _switchAndGetQuoter(string memory chain) private returns (IQuoterV2 quoter);
```

### pathIn


```solidity
function pathIn(string memory chain, address srcToken, address dstToken, uint24 tickSize)
    public
    view
    returns (bytes memory path);
```

### pathOut


```solidity
function pathOut(string memory chain, address srcToken, address dstToken, uint24 tickSize)
    public
    view
    returns (bytes memory path);
```

### quoteIn


```solidity
function quoteIn(string memory chain, bytes memory path, uint256 amountIn)
    public
    returns (uint256 amountOut, bool success);
```

### quoteOut


```solidity
function quoteOut(string memory chain, bytes memory path, uint256 amountOut)
    public
    returns (uint256 amountIn, bool success);
```

### tryTickSize


```solidity
function tryTickSize(string memory chain, address srcToken, address dstToken, uint24 tickSize) private returns (bool);
```

### pathIn


```solidity
function pathIn(string memory chain, address srcToken, address dstToken) public returns (bytes memory path);
```

### pathOutPolygon


```solidity
function pathOutPolygon(address srcToken, address dstToken) public view returns (bytes memory path, bool overrode);
```

### pathOut


```solidity
function pathOut(string memory chain, address srcToken, address dstToken) public returns (bytes memory path);
```

### loadAllUniRouterInfo


```solidity
function loadAllUniRouterInfo() public;
```

