/*
 *==============
 * Migrations - Written specifically for deploying CouponMarketplaceResolver and related contracts to Rinkeby.
 *==============
 *
 */



//Settings

const phoenixIdentityAddress = '0xB0D5a36733886a4c5597849a05B315626aF5222E';
const instances = {};


module.exports = async function (deployer, network, accounts) {



  if(network == "rinkeby"){

  console.log(accounts);

  //Set up "settings"
  const seller = {
    address: accounts[0],
    paymentAddress: accounts[1],
    recoveryAddress: accounts[1]
  }


  //Import contract artifacts
  const PhoenixIdentity = artifacts.require('PhoenixIdentity')
  const IdentityRegistry = artifacts.require('IdentityRegistry')
  const ItemFeature = artifacts.require('ItemFeature')
  const CouponFeature = artifacts.require('CouponFeature')
  const CouponMarketplaceVia = artifacts.require('CouponMarketplaceVia')
  const CouponMarketplaceResolver = artifacts.require('CouponMarketplaceResolver')
  const CouponDistribution = artifacts.require('CouponDistribution')




  //Grab PhoenixIdentity contract deployed at this address
  instances.PhoenixIdentity = await PhoenixIdentity.at(phoenixIdentityAddress)

  //Get IdentityRegistryAddress
  const identityRegistryAddress = await instances.PhoenixIdentity.identityRegistryAddress.call()

  //Grab IdentityRegistry
  instances.IdentityRegistry = await IdentityRegistry.at(identityRegistryAddress)

  //If we need to, register seller to IdentityRegistry
  if(!(await instances.IdentityRegistry.hasIdentity(seller.address))){
    console.log("Seller has no identity; attempting to create one")
    await instances.IdentityRegistry.createIdentity(seller.recoveryAddress, [], [], { from: seller.address })
    //ensure we have an identity, else, throw
    if(!(await instances.IdentityRegistry.hasIdentity(seller.address))){
      throw "Adding identity to IdentityRegistry failed, despite createAddress line running"
    }
  }
  

  //Deploy ItemFeature, CouponFeature, CouponMarketplaceVia, CouponMarketplaceResolver
  await deployer.deploy(ItemFeature, instances.PhoenixIdentity.address, { from: seller.address })
  await deployer.deploy(CouponFeature, instances.PhoenixIdentity.address, { from: seller.address })
  await deployer.deploy(CouponMarketplaceVia, instances.PhoenixIdentity.address, { from: seller.address })
  await deployer.deploy(
        CouponMarketplaceResolver, 
        "Coupon-Marketplace-Resolver",
        "A test Coupon Marketplace Resolver built on top of Phoenix PhoenixIdentity",
        instances.PhoenixIdentity.address,
        false, false,
        seller.paymentAddress,
        CouponMarketplaceVia.address, //According to the docs, the regular "imports" should have this populated by the "deployer"
        CouponFeature.address,
        ItemFeature.address
)

  //Set CouponMarketplaceResolver address within Coupon Marketplace Via
  instances.CouponMarketplaceVia = await CouponMarketplaceVia.at(CouponMarketplaceVia.address)
  await instances.CouponMarketplaceVia.setCouponMarketplaceResolverAddress(CouponMarketplaceResolver.address, { from: seller.address })

  //Deploy Coupon Distribution contract
  await deployer.deploy(CouponDistribution, CouponMarketplaceResolver.address, instances.PhoenixIdentity.address, { from: seller.address })

  //Set Coupon Distribution address within PhoenixIdentityEINMarketplace contract (i.e. the Resolver)
  instances.CouponMarketplaceResolver = await CouponMarketplaceResolver.at(CouponMarketplaceResolver.address)
  await instances.CouponMarketplaceResolver.setCouponDistributionAddress(CouponDistribution.address, { from: seller.address })


  console.log("Neat, we ran!")

  } else {

    const AddressSet = artifacts.require('./_testing/AddressSet/AddressSet.sol')
    const IdentityRegistry = artifacts.require('./_testing/IdentityRegistry.sol')

    const PhoenixToken = artifacts.require('./_testing/PhoenixToken.sol')

    const SafeMath = artifacts.require('./zeppelin/math/SafeMath.sol')
    const PhoenixIdentity = artifacts.require('./PhoenixIdentity.sol')
    // const Status = artifacts.require('./resolvers/Status.sol')

    const StringUtils = artifacts.require('./resolvers/ClientPhoenixAuthentication/StringUtils.sol')
    const ClientPhoenixAuthentication = artifacts.require('./resolvers/ClientPhoenixAuthentication/ClientPhoenixAuthentication.sol')
    const OldClientPhoenixAuthentication = artifacts.require('./_testing/OldClientPhoenixAuthentication.sol')

    await deployer.deploy(AddressSet)
    deployer.link(AddressSet, IdentityRegistry)

    await deployer.deploy(SafeMath)
    deployer.link(SafeMath, PhoenixToken)
    deployer.link(SafeMath, PhoenixIdentity)

    await deployer.deploy(StringUtils)
    deployer.link(StringUtils, ClientPhoenixAuthentication)
    deployer.link(StringUtils, OldClientPhoenixAuthentication)


  }
}

