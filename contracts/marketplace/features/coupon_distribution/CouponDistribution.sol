pragma solidity ^0.5.0;

import "../../../ein/util/PhoenixIdentityEINOwnable.sol";
import "../../../interfaces/marketplace/features/coupon_distribution/CouponDistributionInterface.sol";
import "../CouponFeature.sol";
import "../../../interfaces/marketplace/PhoenixIdentityEINMarketplaceInterface.sol";

contract CouponDistribution is CouponDistributionInterface, PhoenixIdentityEINOwnable {

/*

Coupon generation function should take the following parameters:

    Item type - the type of item for which this coupon applies
    Discount rate - the percentage discount the coupon offers
    Distribution address - defines the logic for how coupons are distributed; must follow a standard interface with a function that can be called from the coupon-generation function to define the initial distribution of coupons once generated.
    Each coupon should have a uuid

    I think this contract could be call an external function like:
    "giveUserCoupon" from the Marketplace

*/    
    
    address public PhoenixIdentityEINMarketplaceAddress;


    constructor(address _PhoenixIdentityEINMarketplaceAddress, address _phoenixIdentityAddress) public {
        _constructCouponDistribution(_PhoenixIdentityEINMarketplaceAddress, _phoenixIdentityAddress);
    }

    function _constructCouponDistribution(address _PhoenixIdentityEINMarketplaceAddress, address _phoenixIdentityAddress) internal returns (bool) {

        _constructPhoenixIdentityEINOwnable(_phoenixIdentityAddress);

        //Actual internal construction
        PhoenixIdentityEINMarketplaceAddress = _PhoenixIdentityEINMarketplaceAddress;
    }

    //Function for the owner to switch the address of the CouponFeature, which is why this contract is PhoenixIdentityEINOwnable
    function setPhoenixIdentityEINMarketplaceAddress(address _PhoenixIdentityEINMarketplaceAddress) public onlyEINOwner returns (bool) {
        PhoenixIdentityEINMarketplaceAddress = _PhoenixIdentityEINMarketplaceAddress;
    }

    /*==== Distribution Logic ====*/

    //For manual logic here, perhaps we should add an optional bytes data parameter? 
    //This would just be ABI-encoded params
    function distributeCoupon(uint256 couponID, bytes memory data) public onlyPhoenixIdentityEINMarketplace returns (bool) {
        return _distributeCoupon(couponID, data);
    }
    
    function _distributeCoupon(uint256 couponID, bytes memory /*/data*/) internal returns (bool) {
        PhoenixIdentityEINMarketplaceInterface marketplace = PhoenixIdentityEINMarketplaceInterface(PhoenixIdentityEINMarketplaceAddress);
        //sample distribution of coupon to EIN 10
        uint256 arbitraryEIN = 10;
        marketplace.giveUserCoupon(arbitraryEIN, couponID);
        return true; 
   }   

    //Same set of functions as above, simply without data param    
    function distributeCoupon(uint256 couponID) public onlyPhoenixIdentityEINMarketplace returns (bool) {
        return _distributeCoupon(couponID);
    }
    
    function _distributeCoupon(uint256 couponID) internal returns (bool) {
        PhoenixIdentityEINMarketplaceInterface marketplace = PhoenixIdentityEINMarketplaceInterface(PhoenixIdentityEINMarketplaceAddress);
        //sample distribution of coupon to EINs 1-5
        for(uint i = 0; i < 5; i++){
            marketplace.giveUserCoupon(i+1, couponID);
        }
        return true; 
        
    }   
    


    
    modifier onlyPhoenixIdentityEINMarketplace() {
        require(msg.sender == PhoenixIdentityEINMarketplaceAddress, "Error [CouponDistribution.sol]: Sender is not PhoenixIdentityEINMarketplace address, as defined within the contract");
        _;
    }
    
    
    
}
