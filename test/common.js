const IdentityRegistry = artifacts.require('./_testing/IdentityRegistry.sol')
const PhoenixToken = artifacts.require('./_testing/PhoenixToken.sol')
const PhoenixIdentity = artifacts.require('./PhoenixIdentity.sol')
const ClientPhoenixAuthentication = artifacts.require('./resolvers/ClientPhoenixAuthentication/ClientPhoenixAuthentication.sol')
const OldClientPhoenixAuthentication = artifacts.require('./_testing/OldClientPhoenixAuthentication.sol')

const CouponMarketplaceResolver = artifacts.require('./resolvers/CouponMarketplaceResolver.sol')
const CouponMarketplaceVia = artifacts.require('./CouponMarketplaceVia.sol')

const ItemFeature = artifacts.require('./marketplace/features/ItemFeature.sol')
const CouponFeature = artifacts.require('./marketplace/features/CouponFeature.sol')
const CouponDistribution = artifacts.require('./marketplace/features/coupon_distribution/CouponDistribution.sol')



async function initialize (owner, users) {
  const instances = {}

  instances.PhoenixToken = await PhoenixToken.new({ from: owner })
  for (let i = 0; i < users.length; i++) {
    await instances.PhoenixToken.transfer(
      users[i].address,
      web3.utils.toBN(1000).mul(web3.utils.toBN(1e18)),
      { from: owner }
    )
  }
  instances.IdentityRegistry = await IdentityRegistry.new({ from: owner })

  instances.PhoenixIdentity = await PhoenixIdentity.new(
    instances.IdentityRegistry.address, instances.PhoenixToken.address, { from: owner }
  )

  instances.OldClientPhoenixAuthentication = await OldClientPhoenixAuthentication.new({ from: owner })
  instances.ClientPhoenixAuthentication = await ClientPhoenixAuthentication.new(
    instances.PhoenixIdentity.address, instances.OldClientPhoenixAuthentication.address, 0, 0, { from: owner }
  )  
  await instances.PhoenixIdentity.setClientPhoenixAuthenticationAddress(instances.ClientPhoenixAuthentication.address, { from: owner })

  /*instances.CouponMarketplace = await CouponMarketplace.new(1, "Test_Name", "Test_Desc", instances.PhoenixIdentity.address, false, false, {from: owner })*/

  return instances
}


async function deployCouponMarketplaceResolver (owner, phoenixIdentityAddress, phoenixIdentityName = "Test_Name", phoenixIdentityDescription = "Test_Desc", callOnAddition = false, callOnRemoval = false, paymentAddress = owner, CouponMarketplaceViaAddress = "0xcD01CD6B160D2BCbeE75b59c393D0017e6BBF427") {

  let cmprContract = await CouponMarketplaceResolver.new(phoenixIdentityName, phoenixIdentityDescription, phoenixIdentityAddress, callOnAddition, callOnRemoval, paymentAddress, CouponMarketplaceViaAddress, {from: owner })
  return cmprContract

}

async function deployCouponMarketplaceVia (owner, phoenixIdentityAddress) {
  let cmpvContract = await CouponMarketplaceVia.new(phoenixIdentityAddress, { from: owner })
  return cmpvContract
}


module.exports = {
  initialize: initialize,
  deploy: {
    couponMarketplaceResolver: deployCouponMarketplaceResolver,
    couponMarketplaceVia: deployCouponMarketplaceVia
  },
  'ItemFeature': ItemFeature,
  'CouponFeature': CouponFeature,
  'CouponMarketplaceResolver': CouponMarketplaceResolver,
  'CouponDistribution': CouponDistribution
}
