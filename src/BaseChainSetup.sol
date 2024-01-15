// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {console2} from "forge-std/console2.sol";
import {CommonBase} from "forge-std/Base.sol";
import {ERC20} from "solmate/tokens/ERC20.sol";

/// @title BaseChainSetup
/// @notice BaseChainSetup is a base contract for setting up chain specific
/// information. It is intended to be used as a base contract for
/// tests and scripts that need to interact with multiple chains.
/// It also provides an abstraction to reuse the same code for
/// both foundry tests, forknets, testnets, and mainnet.
contract BaseChainSetup is CommonBase {
    /// @notice runtime is used to determine which environment we're on.
    /// It is set by the inheriting contract.
    /// @dev runtime is set by the inheriting contract. possible values are
    /// ENV_FORGE_TEST, ENV_FORK, ENV_TESTNET, ENV_MAINNET
    string private runtime;

    /// @notice ENV_FORGE_TEST is the runtime value for foundry unit-tests
    string constant ENV_FORGE_TEST = "forge-test";
    /// @notice ENV_FORK is the runtime value for local anvil networks
    string constant ENV_FORK = "fork";
    /// @notice ENV_TESTNET is the runtime value for testnets
    string constant ENV_TESTNET = "testnet";
    /// @notice ENV_MAINNET is the runtime value for mainnet
    string constant ENV_MAINNET = "mainnet";

    /// @notice global variable to track if we're broadcasting
    /// @dev it's used when switching chains to stop broadcasting
    bool broadcasting = false;

    /// @notice forkLookup is a mapping of chain name to forkId
    /// @dev forkId is what's given back from vm.createFork
    mapping(string => uint256) forkLookup;

    /// @notice gasEthLookup is a mapping of chain name to whether or not
    ///         the chain uses eth as its gas token. Like rollups, for example.
    mapping(string => bool) gasEthLookup;
    /// @notice wethLookup is a mapping of chain name to the weth address on that chain
    mapping(string => address) wethLookup;
    /// @notice wrappedLookup is a mapping of chain name to the wrapped token on that chain
    /// on eth chains, this is the same as wethLookup
    mapping(string => address) wrappedLookup;
    /// @notice chainIdLookup is a mapping of chain alias to the chainId on that chain
    /// chain alias is defined in foundry.toml
    mapping(string => uint256) chainIdLookup;

    /// @notice wethBalance returns the weth balance of a user on a given chain
    /// @param chain is the chain alias
    /// @param user is the user address
    /// @return the weth balance of the user on the chain
    function wethBalance(string memory chain, address user) public view returns (uint256) {
        return ERC20(getWeth(chain)).balanceOf(user);
    }

    /// @notice wrappedBalance returns the wrapped balance of a user on a given chain on eth chains,
    /// this is the same as wethBalance
    /// @param chain is the chain alias
    /// @param user is the user address
    /// @return the wrapped balance of the user on the chain
    function wrappedBalance(string memory chain, address user) public view returns (uint256) {
        return ERC20(getWrapped(chain)).balanceOf(user);
    }

    /// @notice getWeth returns the weth address on a given chain
    /// @param chain is the chain alias
    /// @return the weth address on the chain
    function getWeth(string memory chain) public view returns (address payable) {
        return payable(_getTokenForChain(chain, "weth", wethLookup));
    }

    /// @notice getWrapped returns the wrapped address on a given chain, on eth chains,
    /// this is the same as getWeth
    /// @param chain is the chain alias
    /// @return the wrapped address on the chain
    function getWrapped(string memory chain) public view returns (address payable) {
        return payable(_getTokenForChain(chain, "wrapped", wrappedLookup));
    }

    /// @notice _getTokenForChain is a helper function to get the token address for a given chain
    /// @param chain is the chain alias
    /// @param tokenName is the name of the token
    /// @param lookup is the mapping to look up the token address
    function _getTokenForChain(string memory chain, string memory tokenName, mapping(string => address) storage lookup)
        private
        view
        returns (address)
    {
        address token = payable(lookup[chain]);
        require(token != address(0), string.concat("no ", tokenName, " found for chain: ", chain));
        return token;
    }

    /// @notice isMainnet returns true if we're running the script on mainnet
    function isMainnet() public returns (bool) {
        return vm.envOr("MAINNET", false) && strCompare(runtime, ENV_MAINNET);
    }

    /// @notice isTestnet returns true if we're running the script on testnet
    function isTestnet() public returns (bool) {
        return vm.envOr("TESTNET", false) && strCompare(runtime, ENV_TESTNET);
    }

    /// @notice strCompare compares two strings
    /// @param s1 is the first string
    /// @param s2 is the second string
    /// @return true if the strings are equal
    function strCompare(string memory s1, string memory s2) public pure returns (bool) {
        return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }

    /// @notice isForgeTest returns true if we're running the script in foundry unit-tests
    function isForgeTest() public view returns (bool) {
        return strCompare(runtime, ENV_FORGE_TEST);
    }

    /// @notice isForkRuntime returns true if we're running the script on a forknet
    function isForkRuntime() public view returns (bool) {
        return strCompare(runtime, ENV_FORK);
    }

    /// @notice setRuntime sets the runtime, the possible values are:
    /// ENV_FORGE_TEST, ENV_FORK, ENV_TESTNET, ENV_MAINNET
    function setRuntime(string memory _runtime) internal {
        runtime = _runtime;
    }

    /// @notice _forkAlias returns the fork alias for a given chain, if we're running on a forknet
    /// there is a prefix of "fork_" added to the chain alias in those cases, this is to be able to
    /// separate between rpc's defined for chains, as well as forknets in foundry.toml
    /// @param _chain is the chain alias
    function _forkAlias(string memory _chain) internal view returns (string memory) {
        return isForkRuntime() ? string.concat("fork_", _chain) : _chain;
    }

    /// @notice startImpersonating starts impersonating a given address on a given chain, this abstracts away
    /// the differences between foundry unit-tests, forknets, testnets, and mainnet so that the same
    /// code can be used for all of them.
    /// @param _as is the address to impersonate
    /// @dev it uses vm.startPrank for foundry unit-tests, and vm.startBroadcast for everything else
    function startImpersonating(address _as) internal {
        console2.log("impersonating as", _as);
        if (isForgeTest()) {
            vm.startPrank(_as);
        } else if (isForkRuntime()) {
            vm.stopBroadcast();
            vm.startBroadcast(_as);
        }
    }

    /// @notice an overloading of configureChain that defaults to using weth as the wrapped token
    /// @param chain is the chain alias
    /// @param isGasEth is true if the chain uses eth as its gas token
    /// @param chainId is the chainId for the chain
    /// @param weth is the weth address on the chain
    function configureChain(string memory chain, bool isGasEth, uint256 chainId, address weth) public {
        configureChain(chain, isGasEth, chainId, weth, weth);
    }

    /// @notice configureChain configures the chain specific information for a given chain,
    /// it's used to populate the mappings for wethlookup, wrappedLookup, chainIdLookup, and gasEthLookup
    /// @param chain is the chain alias
    /// @param isGasEth is true if the chain uses eth as its gas token
    /// @param chainId is the chainId for the chain
    /// @param weth is the weth address on the chain
    /// @param wrapped is the wrapped token address on the chain
    function configureChain(string memory chain, bool isGasEth, uint256 chainId, address weth, address wrapped)
        public
    {
        try vm.createFork(_forkAlias(chain)) returns (uint256 forkId) {
            forkLookup[chain] = forkId;
        } catch {}
        gasEthLookup[chain] = isGasEth;
        vm.label(weth, string.concat(chain, "_WETH"));
        wethLookup[chain] = weth;
        if (weth != wrapped) {
            vm.label(wrapped, string.concat(chain, "_WRAPPED"));
        }
        wrappedLookup[chain] = wrapped;
        chainIdLookup[chain] = chainId;
    }

    /// @notice stopImpersonating stops impersonating a given address on a given chain, this abstracts away
    /// the differences between foundry unit-tests, forknets, testnets, and mainnet so that the same
    /// code can be used for all of them.
    /// @dev it uses vm.stopPrank for foundry unit-tests, and vm.stopBroadcast for everything else
    function stopImpersonating() internal {
        if (isForgeTest()) {
            vm.stopPrank();
        } else {
            vm.stopBroadcast();
            vm.startBroadcast();
        }
    }

    /// @notice switchTo switches to a given chain, this abstracts away the differences between foundry unit-tests,
    /// forknets, testnets, and mainnet so that the same code can be used for all of them.
    /// @param chain is the chain alias
    /// @dev it uses vm.selectFork for everything, but ensures to stop broadcasting before switching forks in case we're
    /// not in a unit-test, and start broadcasting again after switching forks
    function switchTo(string memory chain) internal {
        if (bytes(chain).length == 0) {
            revert("no chain specified");
        }

        if (!isForgeTest() && broadcasting) {
            vm.stopBroadcast();
            broadcasting = false;
        }

        uint256 forkId = forkLookup[chain];

        vm.selectFork(forkId);

        if (block.chainid != chainIdLookup[chain]) {
            revert(string.concat("chainId mismatch for chain: ", chain));
        }

        if (!isForgeTest()) {
            vm.startBroadcast();
            broadcasting = true;
        }
    }

    /// @notice dealTo deals a given amount to a given user on a given chain, this abstracts away the differences
    /// between foundry unit-tests, forknets, testnets, and mainnet so that the same code can be used for all of them.
    /// In case of a unit-test, it uses vm.deal, otherwise it sends eth to the user from the deployer account.
    /// @param chain is the chain alias
    /// @param user is the user address
    /// @param amount is the amount to deal
    /// @return success true if the deal was successful
    function dealTo(string memory chain, address user, uint256 amount) internal returns (bool success) {
        success = true;
        switchTo(chain);
        if (isForgeTest()) {
            vm.deal(user, amount);
        } else {
            (success,) = user.call{value: amount}("");
        }
    }
}
