# SgChainsInfo
[Git Source](https://github.com/ArshanKhanifar/queso/blob/6e395efa3ba1ede04789349c7913763f72d9d714/src/SgChainsInfo.sol)

**Inherits:**
[LzChainSetup](/src/LzChainSetup.sol/contract.LzChainSetup.md)


## State Variables
### sgRouterLookup

```solidity
mapping(string => address) sgRouterLookup;
```


### sgBridgeLookup

```solidity
mapping(string => address) sgBridgeLookup;
```


### sgComposerLookup

```solidity
mapping(string => address) sgComposerLookup;
```


### sgPoolIdLookup

```solidity
mapping(string => mapping(address => uint120)) sgPoolIdLookup;
```


### TYPE_SWAP_REMOTE

```solidity
uint8 internal constant TYPE_SWAP_REMOTE = 1;
```


### STARGATE_COMMON_COMPOSER

```solidity
address constant STARGATE_COMMON_COMPOSER = 0xeCc19E177d24551aA7ed6Bc6FE566eCa726CC8a9;
```


## Functions
### addBridge


```solidity
function addBridge(string memory chain, address _address) private;
```

### addRouter


```solidity
function addRouter(string memory chain, address _address) private;
```

### addComposer


```solidity
function addComposer(string memory chain, address _address) private;
```

### setupSgChainInfo


```solidity
function setupSgChainInfo() public;
```

