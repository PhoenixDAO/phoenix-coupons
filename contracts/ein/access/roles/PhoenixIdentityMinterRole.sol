pragma solidity ^0.5.2;

import "../EINRoles.sol";
import "../../../phoenixIdentity_custom/PhoenixIdentityReader.sol";


/*
 * =========================
 * NOTE ABOUT THIS CONTRACT: This is a more of a "PhoenixIdentityMinterRole" contract
 * =========================
 */

contract PhoenixIdentityMinterRole is PhoenixIdentityReader {
    using EINRoles for EINRoles.EINRole;

    event PhoenixIdentityMinterAdded(uint256 indexed account);
    event PhoenixIdentityMinterRemoved(uint256 indexed account);

    EINRoles.EINRole private _einMinters;

    //TODO: Merge in msg.sender idea somehow in a good way; Identity Registry link, perhaps?
/*
    constructor (address _phoenixIdentityAddress) public {
        _constructPhoenixIdentityMinterRole(_phoenixIdentityAddress);
    }
*/
    function _constructPhoenixIdentityMinterRole(address _phoenixIdentityAddress) internal {
        _constructPhoenixIdentityReader(_phoenixIdentityAddress);
        _addPhoenixIdentityMinter(getEIN(msg.sender));
    }

    modifier onlyPhoenixIdentityMinter() {
        require(isPhoenixIdentityMinter(getEIN(msg.sender)));
        _;
    }

    function isPhoenixIdentityMinter(uint256 account) public view returns (bool) {
        return _einMinters.has(account);
    }

    function addPhoenixIdentityMinter(uint256 account) public onlyPhoenixIdentityMinter {
        _addPhoenixIdentityMinter(account);
    }

    function renouncePhoenixIdentityMinter() public {
        _removePhoenixIdentityMinter(getEIN(msg.sender));
    }

    function _addPhoenixIdentityMinter(uint256 account) internal {
        _einMinters.add(account);
        emit PhoenixIdentityMinterAdded(account);
    }

    function _removePhoenixIdentityMinter(uint256 account) internal {
        _einMinters.remove(account);
        emit PhoenixIdentityMinterRemoved(account);
    }
}
