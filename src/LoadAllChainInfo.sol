// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {ChainsInfo} from "./ChainsInfo.sol";
import {LzChainsInfo} from "./LzChainsInfo.sol";
import {SgChainsInfo} from "./SgChainsInfo.sol";

/// @title LoadAllChainInfo
/// @notice This contract is used to load all chain info
contract LoadAllChainInfo is ChainsInfo, LzChainsInfo, SgChainsInfo {
    /// @title loadAllChainInfo
    /// @notice This function is used to load all chain info, including basic chain info, information regarding
    /// LayerZero and information regarding Stargate
    function loadAllChainInfo() public virtual {
        setupChainInfo();
        setupLzChainInfo();
        setupSgChainInfo();
    }
}
