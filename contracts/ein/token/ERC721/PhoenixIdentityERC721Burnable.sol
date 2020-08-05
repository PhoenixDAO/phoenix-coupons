pragma solidity ^0.5.2;

import "./PhoenixIdentityERC721.sol";

/**
 * @title PhoenixIdentity ERC721 Burnable Token
 * @dev PhoenixIdentity ERC721 Token that can be irreversibly burned (destroyed).
 */
contract PhoenixIdentityERC721Burnable is PhoenixIdentityERC721 {
/*
    constructor(address _phoenixIdentityAddress) public {
        _constructPhoenixIdentityERC721Burnable(_phoenixIdentityAddress);
    }
  */
    function _constructPhoenixIdentityERC721Burnable(address _phoenixIdentityAddress) internal {
        _constructPhoenixIdentityERC721(_phoenixIdentityAddress);
    }

    /**
     * @dev Burns a specific PhoenixIdentity ERC721 token.
     * @param tokenId uint256 id of the PhoenixIdentity ERC721 token to be burned.
     */
    function burn(uint256 tokenId) public {
        require(_isApprovedOrOwner(getEIN(msg.sender), tokenId));
        _burn(tokenId);
    }
}
