pragma solidity ^0.5.2;

import "./AddressPhoenixIdentityERC721.sol";
import "../../../../zeppelin/access/roles/MinterRole.sol";

/**
 * @title PhoenixIdentityERC721Mintable
 * @dev PhoenixIdentity ERC721 minting logic
 */
contract AddressPhoenixIdentityERC721Mintable is AddressPhoenixIdentityERC721, MinterRole {

/*    constructor (address _phoenixIdentityAddress) public {
        _constructAddressPhoenixIdentityERC721Mintable(_phoenixIdentityAddress);
    }
*/
    function _constructAddressPhoenixIdentityERC721Mintable(address _phoenixIdentityAddress) internal {
        _constructAddressPhoenixIdentityERC721(_phoenixIdentityAddress);
    }

    /**
     * @dev Function to mint tokens
     * @param to The EIN that will receive the minted tokens.
     * @param tokenId The token id to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mintAddress(uint256 to, uint256 tokenId) public onlyMinter returns (bool) {
        _mint(to, tokenId);
        return true;
    }
}
