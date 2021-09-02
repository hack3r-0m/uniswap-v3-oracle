// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

import {IUniV3SpotPrice} from './TokenPrice.sol';
import {IERC20} from './interfaces/IERC20.sol';

import {PoolAddress} from './libraries/PoolAddress.sol';

contract MockUniV3SpotPrice {

    address immutable tokenPrice;

    constructor(address _tokenPrice) {
        tokenPrice = _tokenPrice;
    }

    // rinkeby specific variables, change as required

    address constant FACTORY = 0x1F98431c8aD98523631AE4a59f267346ea31F984; // Uniswap Factory
    address constant WETH    = 0xc778417E063141139Fce010982780140Aa0cD5Ab; // WETH
    address constant DAI     = 0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735; // DAI
    address constant POOL    = 0x0f04024bdA15F6e5D48Ed92938654a6449F483ed; // WETH/DAI pool
    uint24  constant FEE     = 3000;                                       // fee
    uint32  constant PERIOD  = 1;                                          // 1 second period

    function checkIfCorrectPoolAddress() pure external returns (bool value) {

        PoolAddress.PoolKey memory poolkey = PoolAddress.getPoolKey(WETH, DAI, FEE);
        
        address determinedAddress = PoolAddress.computeAddress(FACTORY, poolkey);
        address determinedAddressReversed = PoolAddress.computeAddress(FACTORY, poolkey);

        require(determinedAddress != address(0), "Should not happen");
        require(determinedAddress == determinedAddressReversed, "Should never mismatch");
        require(determinedAddress == POOL, "Should never mismatch");

        value =  true;
    }

    function get1EthPriceInTermsOfDai() view external returns (uint256) {
        return IUniV3SpotPrice(tokenPrice).getSpotPrice(POOL, PERIOD, 10**18, DAI, WETH);
    }

    function get1TokenAPriceInTermsOfTokenB(address tokenA, address tokenB) view external returns (uint256) {
        uint8 decimals = IERC20(tokenB).decimals();

        PoolAddress.PoolKey memory poolkey = PoolAddress.getPoolKey(tokenA, tokenB, FEE);
        
        address poolAddress = PoolAddress.computeAddress(FACTORY, poolkey);
        require(poolAddress != address(0), "Pool doesn't exist for given pair");

        return IUniV3SpotPrice(tokenPrice).getSpotPrice(poolAddress, PERIOD, uint128(10**decimals), tokenB, tokenA);


    }
}