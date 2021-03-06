const common = require('./common.js')
const { sign, verifyIdentity } = require('./utilities')

const Status = artifacts.require('./resolvers/Status.sol')

let instances
let user
contract('Testing Status', function (accounts) {
  const owner = {
    public: accounts[0]
  }

  const users = [
    {
      phoenixID: 'abc',
      address: accounts[1],
      recoveryAddress: accounts[1],
      private: '0x6bf410ff825d07346c110c5836b33ec76e7d1ee051283937392180b732aa3aff'
    }
  ]

  it('common contracts deployed', async () => {
    instances = await common.initialize(owner.public, [])
  })

  it('Identity can be created', async function () {
    user = users[0]
    const timestamp = Math.round(new Date() / 1000) - 1
    const permissionString = web3.utils.soliditySha3(
      '0x19', '0x00', instances.IdentityRegistry.address,
      'I authorize the creation of an Identity on my behalf.',
      user.recoveryAddress,
      user.address,
      { t: 'address[]', v: [instances.PhoenixIdentity.address] },
      { t: 'address[]', v: [] },
      timestamp
    )

    const permission = await sign(permissionString, user.address, user.private)

    await instances.PhoenixIdentity.createIdentityDelegated(
      user.recoveryAddress, user.address, [], user.phoenixID, permission.v, permission.r, permission.s, timestamp
    )

    user.identity = web3.utils.toBN(1)

    await verifyIdentity(user.identity, instances.IdentityRegistry, {
      recoveryAddress:     user.recoveryAddress,
      associatedAddresses: [user.address],
      providers:           [instances.PhoenixIdentity.address],
      resolvers:           [instances.ClientPhoenixAuthentication.address]
    })
  })

  it('can deposit Phoenix', async () => {
    const depositAmount = web3.utils.toBN(1e18).mul(web3.utils.toBN(2))
    await instances.PhoenixToken.approveAndCall(
      instances.PhoenixIdentity.address, depositAmount, web3.eth.abi.encodeParameter('uint256', user.identity.toString()),
      { from: accounts[0] }
    )

    const phoenixIdentityBalance = await instances.PhoenixIdentity.deposits(user.identity)
    assert.isTrue(phoenixIdentityBalance.eq(depositAmount), 'Incorrect balance')
  })

  describe('Checking Resolver Functionality', async () => {
    it('deploy Status', async () => {
      instances.Status = await Status.new(instances.PhoenixIdentity.address)
    })

    it('first user can add status', async () => {
      const allowance = web3.utils.toBN(1e18)

      await instances.PhoenixIdentity.addResolver(
        instances.Status.address, true, allowance, '0x00', { from: user.address }
      )

      const actualAllowance = await instances.PhoenixIdentity.resolverAllowances(user.identity, instances.Status.address)
      assert.isTrue(actualAllowance.eq(web3.utils.toBN(0)), 'Resolver has an incorrect allowance.')
    })
  })
})
