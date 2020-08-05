pragma solidity ^0.5.2;

import "./PhoenixIdentityERC721.sol";
import "../../access/roles/PhoenixIdentityMinterRole.sol";

/**
 * @title PhoenixIdentityERC721Mintable
 * @dev PhoenixIdentity ERC721 minting logic
 */
contract PhoenixIdentityERC721Mintable is PhoenixIdentityERC721, PhoenixIdentityMinterRole {

/*    constructor (address _phoenixIdentityAddress) public {
        _constructPhoenixIdentityERC721Mintable(_phoenixIdentityAddress);
    }
*/
    function _constructPhoenixIdentityERC721Mintable(address _phoenixIdentityAddress) internal {
        _constructPhoenixIdentityERC721(_phoenixIdentityAddress);
        _constructPhoenixIdentityMinterRole(_phoenixIdentityAddress);
    }

    /**
     * @dev Function to mint tokens
     * @param to The EIN that will receive the minted tokens.
     * @param tokenId The token id to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(uint256 to, uint256 tokenId) public onlyPhoenixIdentityMinter returns (bool) {
        _mint(to, tokenId);
        return true;
    }
}
