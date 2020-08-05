pragma solidity ^0.5.2;

import "./AddressPhoenixIdentityERC721.sol";

/**
 * @title PhoenixIdentity ERC721 Burnable Token
 * @dev PhoenixIdentity ERC721 Token that can be irreversibly burned (destroyed).
 */
contract AddressPhoenixIdentityERC721Burnable is AddressPhoenixIdentityERC721 {

/*    constructor(address _phoenixIdentityAddress) public {
        _constructAddressPhoenixIdentityERC721Burnable(_phoenixIdentityAddress);
    }
  */
    function _constructAddressPhoenixIdentityERC721Burnable(address _phoenixIdentityAddress) internal {
        _constructAddressPhoenixIdentityERC721(_phoenixIdentityAddress);
    }

    /**
     * @dev Burns a specific PhoenixIdentity ERC721 token.
     * @param tokenId uint256 id of the PhoenixIdentity ERC721 token to be burned.
     */
    function burnAddress(uint256 tokenId) public {
        require(_isApprovedAddress(msg.sender, tokenId));
        _burn(tokenId);
    }
}
