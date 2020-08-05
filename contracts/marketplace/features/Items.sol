pragma solidity ^0.5.0;

import '../../ein/token/ERC721/PhoenixIdentityERC721.sol';
import '../../ein/token/ERC721/PhoenixIdentityERC721Burnable.sol';
import '../../ein/token/ERC721/PhoenixIdentityERC721Mintable.sol';
import '../../ein/token/ERC721/address/AddressPhoenixIdentityERC721.sol';
import '../../interfaces/marketplace/ItemInterface.sol';

/*

ERC 721 ---> Coupon Interface ---> Coupon contract (w/ data + function implementations)
        ---> Item Interface ---> Item contract (w/data + function implementations)


//Use addresses to represent other ownership states; unlimited/claimable once

*/


contract Items is PhoenixIdentityERC721, PhoenixIdentityERC721Burnable, PhoenixIdentityERC721Mintable, AddressPhoenixIdentityERC721, ItemInterface {

    //ID, starting at 1
    uint public nextItemListingsID;

    //Mapping connecting ERC721 items to actual struct objects
    mapping(uint => Item) public itemListings;
/*
    constructor(address _phoenixIdentityAddress) public {
        _constructItems(_phoenixIdentityAddress);
    }
*/
    function _constructItems(address _phoenixIdentityAddress) internal {

        _constructPhoenixIdentityERC721(_phoenixIdentityAddress);
        _constructPhoenixIdentityERC721Burnable(_phoenixIdentityAddress);
        _constructPhoenixIdentityERC721Mintable(_phoenixIdentityAddress);
        _constructAddressPhoenixIdentityERC721(_phoenixIdentityAddress);

        //Actual Item constructing
        nextItemListingsID = 1;
    }

    struct Item {
        uint uuid;
        uint quantity;
        ItemType itemType;
        ItemStatus status;
        ItemCondition condition;
        string title;
        string description;
        uint256 price;
        uint[] delivery; //Simply holds the ID for the delivery method, done for saving space
        uint[] tags;
        uint returnPolicy;

    }

    function getItem(uint id) public view returns (
        uint uuid,
        uint quantity,
        ItemType itemType,
        ItemStatus status,
        ItemCondition condition,
        string memory title,
        string memory description,
        uint256 price,
        uint returnPolicy
    ){

        Item memory item = itemListings[id];
        return (item.uuid, item.quantity, item.itemType, item.status, item.condition, item.title, item.description, item.price, item.returnPolicy);
    }

    //This is simply more for convenience than not
    function getItemPrice(uint id) public view returns (uint256) {
        return itemListings[id].price;
    }

    function getItemDelivery(uint id) public view returns (uint[] memory) {
        return storageUintArrToMemory(itemListings[id].delivery);
    }
 
    function getItemTags(uint id) public view returns (uint[] memory) {
        return storageUintArrToMemory(itemListings[id].tags);
    }

    //Refactor this down the line
    /**
     *====================
     * GENERIC FUNCTION
     *====================
     * 
     * PLEASE REFACTOR!!!!!!!!!!!!
     */
    function storageUintArrToMemory(uint[] storage arr) internal view returns (uint[] memory) {
        uint[] memory memArr = new uint[](arr.length);
        for(uint i = 0; i < arr.length; i++){
            memArr[i] = arr[i];
        }
        return memArr;
    }



/*
==============================
ItemListing add/update/delete
==============================
*/


    function _addItemListing (
        uint256 ein,
        uint uuid,
        uint quantity,
        ItemType itemType,
        ItemStatus status,
        ItemCondition condition,
        string memory title,
        string memory description,
        uint256 price,
        uint[] memory delivery,
        uint[] memory tags,
        uint returnPolicy
    ) internal returns (bool) {

        //Mint it as an ERC721 owned by the creator
        _mint(ein, nextItemListingsID);

        //Add to itemListings
        itemListings[nextItemListingsID] = Item(uuid, quantity, itemType, status, condition, title, description, price, delivery, tags, returnPolicy);
        //advance item by one
        nextItemListingsID++;

        return true;
    }


    //NOTE: This can be changed in a way that does not re-create an entirely new item on every call, but more complex that perhaps needed

    function _updateItemListing (
        uint id,
        uint uuid,
        uint quantity,
        ItemType itemType,
        ItemStatus status,
        ItemCondition condition,
        string memory title,
        string memory description,
        uint256 price,
        uint[] memory delivery,
        uint[] memory tags,
        uint returnPolicy
    ) internal returns (bool) {

        //Update itemListing identified by ID
        itemListings[id] = Item(uuid, quantity, itemType, status, condition, title, description, price, delivery, tags, returnPolicy);
        return true;
    }


    function _deleteItemListing(uint id) internal returns (bool) {
        //Delete itemListing identified by ID
        delete itemListings[id];

        //Finally, burn it
        _burn(id);

        return true;
    }




}



