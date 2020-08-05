pragma solidity ^0.5.0;

import "../interfaces/PhoenixIdentityInterface.sol";
import "../interfaces/IdentityRegistryInterface.sol";

/**
* @title PhoenixIdentityReader
* @dev Intended to provide a simple thing for contracts to extend and do things such as read EINs. For now, this is its only function, but this is needed for design purposes, IMO
*
*/
contract PhoenixIdentityReader {
    address public phoenixIdentityAddress;

/*    constructor(address _phoenixIdentityAddress) public {
        _constructPhoenixIdentityReader(_phoenixIdentityAddress);
    }
*/
    //Function to avoid double-constructor in inheriting, sort of a work-around
    function _constructPhoenixIdentityReader(address _phoenixIdentityAddress) internal {
        phoenixIdentityAddress = _phoenixIdentityAddress;
    }

    function getEIN(address einAddress) internal returns (uint256 ein) {
        //Grab an instance of IdentityRegistry to work with as defined in PhoenixIdentity
        PhoenixIdentityInterface si = PhoenixIdentityInterface(phoenixIdentityAddress);
        address iAdd = si.identityRegistryAddress();

        IdentityRegistryInterface identityRegistry = IdentityRegistryInterface(iAdd);
        //Ensure the address exists within the registry
        require(identityRegistry.hasIdentity(einAddress), "Address non-existent in IdentityRegistry");

        return identityRegistry.getEIN(einAddress);
    }


}

