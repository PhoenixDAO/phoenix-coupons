/*
 * =================== 
 *   Marketplace API - a general compilation of functions that will ideally ease the writing process. Refactoring will go here
 * ===================
 *
 * 
 */

const common = require('../common.js')
const { sign, verifyIdentity } = require('../utilities')

const TestData = require('./test-data.js')

const util = require('util')

const BN = web3.utils.BN
const allEnums = require('../../enum_mappings/enums.js')
const enums = allEnums.CouponMarketPlaceResolverInterface;


class MarketplaceAPI {


  //Simply function to test for Solidity revert errors; optionally takes an "expectedErr" which simply looks for a string within
  // This function has limits, however; if a function can potentially return two or more reverts, we can't quite test for each of them through expectedErr and apply if/and/or logic
  async assertSolidityRevert(run, expectedErr = null) {
    let err;
    try {
      await run();
    } catch(_e) {
      err = _e.message;
    }
    assert.isTrue(err.includes('VM Exception while processing transaction: revert'));
    if(expectedErr != null) assert.isTrue(err.includes(expectedErr));

    return err;
  }


  /*
    =======================
      Identity Registry 
    =======================
  */

  
  //Convenience function, assumes instances is set with loaded contracts
/*  async addToIdentityRegistrySimple(userIdentity) {
    await this.addToIdentityRegistry(userIdentity, instances.IdentityRegistry, instances.PhoenixIdentity, instances.ClientPhoenixAuthentication)
  }*/

  //"Lower-level" convenience function
  /*static*/ async addToIdentityRegistry(userIdentity, IdentityRegistryInstance, PhoenixIdentityInstance, ClientPhoenixAuthenticationInstance){

    const timestamp = Math.round(new Date() / 1000) - 1
    const permissionString = web3.utils.soliditySha3(
      '0x19', '0x00', IdentityRegistryInstance.address,
      'I authorize the creation of an Identity on my behalf.',
      userIdentity.recoveryAddress,
      userIdentity.address,
      { t: 'address[]', v: [PhoenixIdentityInstance.address] },
      { t: 'address[]', v: [] },
      timestamp
    )

    const permission = await sign(permissionString, userIdentity.address, userIdentity.private)

    await PhoenixIdentityInstance.createIdentityDelegated(
      userIdentity.recoveryAddress, userIdentity.address, [], userIdentity.phoenixID, permission.v, permission.r, permission.s, timestamp
    )
    //console.log("EIN:    " + userIdentity.ein)
    userIdentity.identity = web3.utils.toBN(userIdentity.ein)

    await verifyIdentity(userIdentity.identity, IdentityRegistryInstance, {
      recoveryAddress:     userIdentity.recoveryAddress,
      associatedAddresses: [userIdentity.address],
      providers:           [PhoenixIdentityInstance.address],
      resolvers:           [ClientPhoenixAuthenticationInstance.address]
   })

  }

  /*
    ==========
      Items
    ==========
  */

   async getItemDelivery(Items, id) {
     return await Items.getItemDelivery.call(id);
   }

   async getItemTags(Items, id) {
     return await Items.getItemTags.call(id);     
   }

   async itemStructIsEqual(Items, id, intObj) {
      //Compare the values we can read via a straight-forward call
      assert.ok(this.structIsEqual(intObj, await Items.itemListings.call(id)));
      //Grab the struct arrays that aren't returned
      let delivery = await this.getItemDelivery(Items, id);
      let itemTags = await this.getItemTags(Items, id);
      //As both are uints, we compare taking returned BN.js object into account
      this.arrIsEqualBN(delivery, intObj.delivery);
      this.arrIsEqualBN(itemTags, intObj.itemTags);
      return true;
   }
  

  /*
    ============
      Coupons
    ============
  */

  async getCouponItemsApplicable(Coupons, id) {
    return await Coupons.getCouponItemsApplicable.call(id);
  }

  async couponStructIsEqual(Coupons, id, intObj) {
    assert.ok(this.structIsEqual(intObj, await Coupons.availableCoupons.call(id)));
    let itemsApplicable = await this.getCouponItemsApplicable(Coupons, id);
    this.arrIsEqualBN(itemsApplicable, intObj.itemsApplicable);
    return true;
  }


  // Idea is to provide a nice function to determine equality
  // between returned struct from web3, and ours;
  // Since the returned object contains a strange
  // mixture where values are represented as both
  // '1': __, '2': __, __:__, __:__ (as in, keys are shown alongside values, and numerical mapping to values; values are repeated)
  //[] values are ignored, since arrays will not appear in returned structs

  structIsEqual(intObj, retObj) {
    for(let key in intObj) {
      //[] == [] is false, so we try this as a hack workaround
      if(typeof intObj[key] != "object"){
        assert.equal(intObj[key], retObj[key], `Key: ${key} used to compare values (Internal Obj) ${intObj[key]} and (Returned Obj) ${retObj[key]} `);
      }
    }
    return true;
  }


  arrIsEqualBN(a, b) {
    //console.log("THIS IS A: " + a)
    //console.log("THIS IS B: " + b)

    if(a != undefined && b != undefined) {
      assert.equal(a.length, b.length)
      for(let i = 0; i < a.length; i++) {
        let elementA, elementB
        //"Cast" to BN
        typeof a[i] != "object" ? elementA = new BN(a[i], 10) : elementA = a[i]
        typeof b[i] != "object" ? elementB = new BN(b[i], 10) : elementB = b[i]
        //Use BN.js .eq function to test for equality
        assert.ok(elementA.eq(elementB))
      }
      return true;
    } else {
      if(typeof a != undefined) {
        assert.equal(a.length, 0) 
      } else if(typeof b != undefined) {
        assert.equal(b.length, 0)
      } else {
        //Logically both must be undefined, so this should result in true
        assert.equal(a, b);
      }
      return true; 
    }
  }


  /*
    =========================
      Item Listings to Args
    =========================

  */

  //Actually, to convert to args:
  //
  //  ...Object.values(myObj)
  //  As values() should return an array of the object

  /*
    ===========================
      Return Policies to Args
    ===========================

  */

  /*
    =============================
      Available Coupons to Args
    ============================

  */





}

module.exports = MarketplaceAPI;
