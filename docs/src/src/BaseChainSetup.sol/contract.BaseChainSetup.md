# BaseChainSetup
[Git Source](https://github.com/ArshanKhanifar/queso/blob/6e395efa3ba1ede04789349c7913763f72d9d714/src/BaseChainSetup.sol)

**Inherits:**
CommonBase

BaseChainSetup is a base contract for setting up chain specific
information. It is intended to be used as a base contract for
tests and scripts that need to interact with multiple chains.
It also provides an abstraction to reuse the same code for
both foundry tests, forknets, testnets, and mainnet.


## State Variables
### runtime
runtime is used to determine which environment we're on.
It is set by the inheriting contract.

*runtime is set by the inheriting contract. possible values are
ENV_FORGE_TEST, ENV_FORK, ENV_TESTNET, ENV_MAINNET*


```solidity
string private runtime;
```


### ENV_FORGE_TEST
ENV_FORGE_TEST is the runtime value for foundry unit-tests


```solidity
string constant ENV_FORGE_TEST = "forge-test";
```


### ENV_FORK
ENV_FORK is the runtime value for local anvil networks


```solidity
string constant ENV_FORK = "fork";
```


### ENV_TESTNET
ENV_TESTNET is the runtime value for testnets


```solidity
string constant ENV_TESTNET = "testnet";
```


### ENV_MAINNET
ENV_MAINNET is the runtime value for mainnet


```solidity
string constant ENV_MAINNET = "mainnet";
```


### broadcasting
global variable to track if we're broadcasting

*it's used when switching chains to stop broadcasting*


```solidity
bool broadcasting = false;
```


### forkLookup
forkLookup is a mapping of chain name to forkId

*forkId is what's given back from vm.createFork*


```solidity
mapping(string => uint256) forkLookup;
```


### gasEthLookup
gasEthLookup is a mapping of chain name to whether or not
the chain uses eth as its gas token. Like rollups, for example.


```solidity
mapping(string => bool) gasEthLookup;
```


### wethLookup
wethLookup is a mapping of chain name to the weth address on that chain


```solidity
mapping(string => address) wethLookup;
```


### wrappedLookup
wrappedLookup is a mapping of chain name to the wrapped token on that chain
on eth chains, this is the same as wethLookup


```solidity
mapping(string => address) wrappedLookup;
```


### chainIdLookup
chainIdLookup is a mapping of chain alias to the chainId on that chain
chain alias is defined in foundry.toml


```solidity
mapping(string => uint256) chainIdLookup;
```


## Functions
### wethBalance

wethBalance returns the weth balance of a user on a given chain


```solidity
function wethBalance(string memory chain, address user) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|is the chain alias|
|`user`|`address`|is the user address|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|the weth balance of the user on the chain|


### wrappedBalance

wrappedBalance returns the wrapped balance of a user on a given chain on eth chains,
this is the same as wethBalance


```solidity
function wrappedBalance(string memory chain, address user) public view returns (uint256);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|is the chain alias|
|`user`|`address`|is the user address|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|the wrapped balance of the user on the chain|


### getWeth

getWeth returns the weth address on a given chain


```solidity
function getWeth(string memory chain) public view returns (address payable);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|is the chain alias|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address payable`|the weth address on the chain|


### getWrapped

getWrapped returns the wrapped address on a given chain, on eth chains,
this is the same as getWeth


```solidity
function getWrapped(string memory chain) public view returns (address payable);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|is the chain alias|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`address payable`|the wrapped address on the chain|


### _getTokenForChain

_getTokenForChain is a helper function to get the token address for a given chain


```solidity
function _getTokenForChain(string memory chain, string memory tokenName, mapping(string => address) storage lookup)
    private
    view
    returns (address);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|is the chain alias|
|`tokenName`|`string`|is the name of the token|
|`lookup`|`mapping(string => address)`|is the mapping to look up the token address|


### isMainnet

isMainnet returns true if we're running the script on mainnet


```solidity
function isMainnet() public returns (bool);
```

### isTestnet

isTestnet returns true if we're running the script on testnet


```solidity
function isTestnet() public returns (bool);
```

### strCompare

strCompare compares two strings


```solidity
function strCompare(string memory s1, string memory s2) public pure returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`s1`|`string`|is the first string|
|`s2`|`string`|is the second string|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|true if the strings are equal|


### isForgeTest

isForgeTest returns true if we're running the script in foundry unit-tests


```solidity
function isForgeTest() public view returns (bool);
```

### isForkRuntime

isForkRuntime returns true if we're running the script on a forknet


```solidity
function isForkRuntime() public view returns (bool);
```

### setRuntime

setRuntime sets the runtime, the possible values are:
ENV_FORGE_TEST, ENV_FORK, ENV_TESTNET, ENV_MAINNET


```solidity
function setRuntime(string memory _runtime) internal;
```

### _forkAlias

_forkAlias returns the fork alias for a given chain, if we're running on a forknet
there is a prefix of "fork_" added to the chain alias in those cases, this is to be able to
separate between rpc's defined for chains, as well as forknets in foundry.toml


```solidity
function _forkAlias(string memory _chain) internal view returns (string memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_chain`|`string`|is the chain alias|


### startImpersonating

startImpersonating starts impersonating a given address on a given chain, this abstracts away
the differences between foundry unit-tests, forknets, testnets, and mainnet so that the same
code can be used for all of them.

*it uses vm.startPrank for foundry unit-tests, and vm.startBroadcast for everything else*


```solidity
function startImpersonating(address _as) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_as`|`address`|is the address to impersonate|


### configureChain

an overloading of configureChain that defaults to using weth as the wrapped token


```solidity
function configureChain(string memory chain, bool isGasEth, uint256 chainId, address weth) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|is the chain alias|
|`isGasEth`|`bool`|is true if the chain uses eth as its gas token|
|`chainId`|`uint256`|is the chainId for the chain|
|`weth`|`address`|is the weth address on the chain|


### configureChain

configureChain configures the chain specific information for a given chain,
it's used to populate the mappings for wethlookup, wrappedLookup, chainIdLookup, and gasEthLookup


```solidity
function configureChain(string memory chain, bool isGasEth, uint256 chainId, address weth, address wrapped) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|is the chain alias|
|`isGasEth`|`bool`|is true if the chain uses eth as its gas token|
|`chainId`|`uint256`|is the chainId for the chain|
|`weth`|`address`|is the weth address on the chain|
|`wrapped`|`address`|is the wrapped token address on the chain|


### stopImpersonating

stopImpersonating stops impersonating a given address on a given chain, this abstracts away
the differences between foundry unit-tests, forknets, testnets, and mainnet so that the same
code can be used for all of them.

*it uses vm.stopPrank for foundry unit-tests, and vm.stopBroadcast for everything else*


```solidity
function stopImpersonating() internal;
```

### switchTo

switchTo switches to a given chain, this abstracts away the differences between foundry unit-tests,
forknets, testnets, and mainnet so that the same code can be used for all of them.

*it uses vm.selectFork for everything, but ensures to stop broadcasting before switching forks in case we're
not in a unit-test, and start broadcasting again after switching forks*


```solidity
function switchTo(string memory chain) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|is the chain alias|


### dealTo

dealTo deals a given amount to a given user on a given chain, this abstracts away the differences
between foundry unit-tests, forknets, testnets, and mainnet so that the same code can be used for all of them.
In case of a unit-test, it uses vm.deal, otherwise it sends eth to the user from the deployer account.


```solidity
function dealTo(string memory chain, address user, uint256 amount) internal returns (bool success);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|is the chain alias|
|`user`|`address`|is the user address|
|`amount`|`uint256`|is the amount to deal|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`success`|`bool`|true if the deal was successful|


