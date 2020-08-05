pragma solidity ^0.5.0;

import "../../ein/util/PhoenixIdentityEINOwnable.sol";
import "./Coupons.sol";


contract CouponFeature is Coupons, PhoenixIdentityEINOwnable {


    constructor(address _phoenixIdentityAddress) public {
        _constructCouponFeature(_phoenixIdentityAddress);
    
    }    

    function _constructCouponFeature(address _phoenixIdentityAddress) internal {
        _constructCoupons(_phoenixIdentityAddress);
        _constructPhoenixIdentityEINOwnable(_phoenixIdentityAddress);
    }

/*
===================================
AvailableCoupons add/update/delete
===================================
*/



   function addAvailableCoupon(
        uint256 ein,
        CouponType couponType,
        string memory title,
        string memory description,
        uint256 amountOff,
        uint[] memory itemsApplicable,
        uint expirationDate,
        address couponDistribution

    ) public onlyEINOwner returns (bool) {
        return _addAvailableCoupon(ein, couponType, title, description, amountOff, itemsApplicable, expirationDate, couponDistribution);
    }


    function updateAvailableCoupon(
        uint id,
        CouponType couponType,
        string memory title,
        string memory description,
        uint256 amountOff,
        uint[] memory itemsApplicable,
        uint expirationDate,
        address couponDistribution

    ) public onlyEINOwner returns (bool) {
        return _updateAvailableCoupon(id, couponType, title, description, amountOff, itemsApplicable, expirationDate, couponDistribution);
    }


    function deleteAvailableCoupon(uint id) public onlyEINOwner returns (bool) {
       return _deleteAvailableCoupon(id);
    }


/* ====================================================

       END OF ADD/UPDATE/DELETE FUNCTIONS

   ====================================================
*/










}
