pragma solidity ^0.5.0;

import "./EINOwnable.sol";
import "../../phoenixIdentity_custom/PhoenixIdentityReader.sol";

/**
* @title PhoenixIdentityEINOwnable
* @dev The PhoenixIdentityEINOwnable contract has an owner EIN, and provides basic authorization control
* functions, this simplifies the implementation of "user permissions".
*
* This extends the EINOwnable contract and provides the EIN authentication used through PhoenixIdentity (uses the abstraction PhoenixIdentity provides; the minor disadvantage is that this is indirectly connected to the IdentityRegistry, but could arugably be good design)
*/
contract PhoenixIdentityEINOwnable is EINOwnable, PhoenixIdentityReader {

    /**
    * @dev The PhoenixIdentityEINOwnable constructor sets the original `owner` of the contract to the sender
    * account.
    */
/*    constructor(address _phoenixIdentityAddress) public {
        _constructPhoenixIdentityEINOwnable(_phoenixIdentityAddress);
    }
*/
    function _constructPhoenixIdentityEINOwnable(address _phoenixIdentityAddress) internal {
       _constructPhoenixIdentityReader(_phoenixIdentityAddress);       
       _constructEINOwnable(constructorEINOwnable(msg.sender));
    }

    /**
    * @return true if address resolves to owner of the contract.
    */
    function isEINOwner() public returns(bool){
        return _isEINOwner();
    }

    function _isEINOwner() internal returns(bool) {
        return getEIN(msg.sender) == ownerEIN();
    }


    /*==========================================================================
     * Function reserved for modifying parent constructor input for EINOwnable
     *==========================================================================
     */

    function constructorEINOwnable(address sender) private returns (uint256 ein) {
        return getEIN(sender);
    }

}
