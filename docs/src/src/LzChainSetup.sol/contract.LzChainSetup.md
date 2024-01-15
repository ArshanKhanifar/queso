# LzChainSetup
[Git Source](https://github.com/ArshanKhanifar/queso/blob/6e395efa3ba1ede04789349c7913763f72d9d714/src/LzChainSetup.sol)

**Inherits:**
[BaseChainSetup](/src/BaseChainSetup.sol/contract.BaseChainSetup.md)

This contract is used to setup info for chains supported by LayerZero


## State Variables
### lzEndpointLookup
This mapping is used to lookup the LayerZero endpoint for a given chain alias


```solidity
mapping(string => MockEndpoint) lzEndpointLookup;
```


### lzIdLookup
This mapping is used to lookup the LayerZero chain id for a given chain alias


```solidity
mapping(string => uint16) lzIdLookup;
```


## Functions
### configureLzChain

This function is used to populate the lzEndpointLookup and lzIdLookup mappings


```solidity
function configureLzChain(string memory chain, uint16 lzId, address lzEndpoint) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`chain`|`string`|The chain alias|
|`lzId`|`uint16`|The LayerZero chain id|
|`lzEndpoint`|`address`|The LayerZero endpoint address|


### startRecordingLzMessages

This function is used to start recording the logs emitted by LayerZero, used to emulate cross-chain
message delivery. Use this function before calling deliverLzMessageAtDestination.


```solidity
function startRecordingLzMessages() public;
```

### getPacket

This function is used to get the packet emitted by LayerZero, which then gets processed by the
extractLzInfo and extractAppPayload functions.


```solidity
function getPacket(string memory src) private returns (bytes memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`src`|`string`|The source of the packet|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bytes`|packet The packet emitted by LayerZero|


### extractLzInfo


```solidity
function extractLzInfo(bytes memory packet)
    private
    returns (uint64 nonce, uint16 localChainId, address sourceUa, uint16 dstChainId, address dstAddress);
```

### extractAppPayload


```solidity
function extractAppPayload(bytes memory packet) private returns (bytes memory payload);
```

### deliverLzMessageAtDestination


```solidity
function deliverLzMessageAtDestination(string memory src, string memory dst, uint256 gasLimit) public;
```

### receiveLzMessage


```solidity
function receiveLzMessage(
    string memory srcChain,
    string memory dstChain,
    address srcUa,
    address dstUa,
    uint256 gasLimit,
    bytes memory payload
) public;
```

