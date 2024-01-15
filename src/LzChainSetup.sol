// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {BaseChainSetup} from "./BaseChainSetup.sol";
import {ILayerZeroEndpoint} from "LayerZero/interfaces/ILayerZeroEndpoint.sol";
import {VmSafe} from "forge-std/Vm.sol";
import {console2} from "forge-std/console2.sol";

/// @title MockEndpoint
/// @notice This contract is used to mock LayerZero endpoints
abstract contract MockEndpoint is ILayerZeroEndpoint {
    address public defaultReceiveLibraryAddress;
}

/// @title LzChainSetup
/// @notice This contract is used to setup info for chains supported by LayerZero
contract LzChainSetup is BaseChainSetup {
    /// @title lzEndpointLookup
    /// @notice This mapping is used to lookup the LayerZero endpoint for a given chain alias
    mapping(string => MockEndpoint) lzEndpointLookup;
    /// @title lzIdLookup
    /// @notice This mapping is used to lookup the LayerZero chain id for a given chain alias
    mapping(string => uint16) lzIdLookup;

    /// @title configureLzChain
    /// @notice This function is used to populate the lzEndpointLookup and lzIdLookup mappings
    /// @param chain The chain alias
    /// @param lzId The LayerZero chain id
    /// @param lzEndpoint The LayerZero endpoint address
    function configureLzChain(string memory chain, uint16 lzId, address lzEndpoint) internal {
        // from here: https://layerzero.gitbook.io/docs/technical-reference/mainnet/supported-chain-ids
        lzEndpointLookup[chain] = MockEndpoint(lzEndpoint);
        vm.label(lzEndpoint, string.concat("lz_endpoint_", chain));
        lzIdLookup[chain] = lzId;
    }

    /// @title startRecordingLzMessages
    /// @notice This function is used to start recording the logs emitted by LayerZero, used to emulate cross-chain
    /// message delivery. Use this function before calling deliverLzMessageAtDestination.
    function startRecordingLzMessages() public {
        vm.recordLogs();
    }

    /// @title getPacket
    /// @notice This function is used to get the packet emitted by LayerZero, which then gets processed by the
    /// extractLzInfo and extractAppPayload functions.
    /// @param src The source of the packet
    /// @return packet The packet emitted by LayerZero
    function getPacket(string memory src) private returns (bytes memory) {
        VmSafe.Log[] memory entries = vm.getRecordedLogs();
        for (uint256 i = 0; i < entries.length; i++) {
            if (entries[i].topics[0] == keccak256("Packet(bytes)")) {
                console2.logBytes32(entries[i].topics[0]);
                console2.logBytes(entries[i].data);
                return entries[i].data;
            }
        }
        revert(string.concat("no packet was emitted at: ", src));
    }

    /// @title extractLzInfo
    /// @notice This function is used to extract the messages info from the packet emitted by LayerZero's stack
    /// it's needed to deliver it to the destination chain
    /// @param packet The app packet, this is a subset of the packet emitted by LayerZero
    /// @return nonce The nonce of the message
    /// @return localChainId The chain id of the source chain
    /// @return sourceUa The source user application
    /// @return dstChainId The layer zero chain id of the destination chain, you can look up their chain id's here:
    /// https://layerzero.gitbook.io/docs/technical-reference/mainnet/supported-chain-ids
    /// @return dstAddress The destination address
    function extractLzInfo(bytes memory packet)
        private
        returns (uint64 nonce, uint16 localChainId, address sourceUa, uint16 dstChainId, address dstAddress)
    {
        assembly {
            let start := add(packet, 64)
            nonce := mload(add(start, 8))
            localChainId := mload(add(start, 10))
            sourceUa := mload(add(start, 30))
            dstChainId := mload(add(start, 32))
            dstAddress := mload(add(start, 52))
        }
    }

    /// @title extractAppPayload
    /// @notice This function is used to extract the payload from the packet emitted by LayerZero's stack.
    /// @param packet The raw packet emitted by LayerZero, this is retrieved from the logs emitted by LayerZero
    /// on the source chain
    /// @return payload The app payload
    function extractAppPayload(bytes memory packet) private returns (bytes memory payload) {
        uint256 start = 64 + 52;
        uint256 payloadLength = packet.length - start;
        payload = new bytes(payloadLength);
        assembly {
            let payloadPtr := add(packet, start)
            let destPointer := add(payload, 32)
            for { let i := 32 } lt(i, payloadLength) { i := add(i, 32) } {
                mstore(destPointer, mload(add(payloadPtr, i)))
                destPointer := add(destPointer, 32)
            }
        }
    }

    /// @title deliverLzMessageAtDestination
    /// @notice This function is used to deliver a message to the destination chain, it's used to emulate cross-chain
    /// message delivery. Use this function after calling startRecordingLzMessages.
    /// @param src The source chain alias
    /// @param dst The destination chain alias
    /// @param gasLimit The gas limit to use when delivering the message
    function deliverLzMessageAtDestination(string memory src, string memory dst, uint256 gasLimit) public {
        bytes memory packet = getPacket(src);
        (uint64 nonce, uint16 localChainId, address sourceUa, uint16 dstChainId, address dstAddress) =
            extractLzInfo(packet);
        bytes memory payload = extractAppPayload(packet);
        receiveLzMessage(src, dst, sourceUa, dstAddress, gasLimit, payload);
    }

    /// @title receiveLzMessage
    /// @notice This function is used to deliver a message to the destination chain, it's called
    /// by deliverLzMessageAtDestination
    /// @param srcChain The source chain alias
    /// @param dstChain The destination chain alias
    /// @param srcUa The source user application, extracted from the packet
    /// @param dstUa The destination user application, extracted from the packet
    /// @param gasLimit The gas limit to use when delivering the message
    /// @param payload The payload to deliver
    function receiveLzMessage(
        string memory srcChain,
        string memory dstChain,
        address srcUa,
        address dstUa,
        uint256 gasLimit,
        bytes memory payload
    ) private {
        switchTo(dstChain);

        MockEndpoint dstEndpoint = lzEndpointLookup[dstChain];

        uint16 srcLzId = lzIdLookup[srcChain];

        bytes memory srcPath = abi.encodePacked(srcUa, dstUa);

        uint64 nonce = dstEndpoint.getInboundNonce(srcLzId, srcPath);

        address defaultLibAddress = dstEndpoint.defaultReceiveLibraryAddress();

        startImpersonating(defaultLibAddress);

        dstEndpoint.receivePayload(
            srcLzId, // src chain id
            srcPath, // src address
            dstUa, // dst address
            nonce + 1, // nonce
            gasLimit, // gas limit
            payload // payload
        );

        stopImpersonating();
    }
}
