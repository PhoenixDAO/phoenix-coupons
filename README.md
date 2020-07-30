# Phoenix Snowflake - Marketplace Coupons

## Introduction
Snowflake is an [ERC-1484 `Provider`](https://erc1484.org/) that provides on-/off-chain identity management. For more details

This project is essentially a chain of smart contracts built on top of the Phoenix Snowflake protocol, aiming to provide a marketplace platform for sellers to launch their own stores and sell to users. Coupons are also featured, allowing users to use globally defined coupons guaranteed to expire within a certain time period, or assigning coupons per Snowflake EIN, manageable via multiple addresses.

The marketplace itself is a Snowflake Resolver contract, which interacts with a Snowflake Via contract to handle the transaction (and thus coupon discount) logic. 

This project is still under development, and dramatic changes will likely occur quickly. The full scope of the prospective completed project 


## Testing With Truffle
- This folder has a suite of tests created through [Truffle](https://github.com/trufflesuite/truffle).
- To run these tests:
  - Clone this repo
  - Run `npm install`
  - Build dependencies with `npm run build`
  - Spin up a development blockchain: `npm run chain`
  - In another terminal tab, run the test suite: `npm test`


## Copyright & License
© The Phoenix Technology Corporation 2018, under the GNU General Public License v3.0.
