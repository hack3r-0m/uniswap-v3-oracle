// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.6;

import {IUniswapV3Pool} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {OracleLibrary} from "./libraries/Oracle.sol";

/**
 * @title  UniV3SpotPrice
 * @notice A contract for getting the spot price from a Uniswap V3 pool
 */

interface IUniV3SpotPrice {
    function getSpotPrice(address pool, uint32 period, uint128 baseAmount, address baseToken, address quoteToken) external view returns(uint256 quoteAmount);
}

contract UniV3SpotPrice is IUniV3SpotPrice {

    /** 
     * @notice Fetches time-weighted average tick using Uniswap V3 oracle
     * @param pool Address of Uniswap V3 pool that we want to observe
     * @param period Number of seconds in the past to start calculating time-weighted average
     * @return timeWeightedAverageTick The time-weighted average tick from (block.timestamp - period) to block.timestamp
     */
    function _consult(address pool, uint32 period) internal view returns (int24 timeWeightedAverageTick) {
        return OracleLibrary.consult(pool, period);
    }

    /**
     * @notice Given a tick and a token amount, calculates the amount of token received in exchange
     * @param tick Tick value used to calculate the quote
     * @param baseAmount Amount of token to be converted
     * @param baseToken Address of an ERC20 token contract used as the baseAmount denomination
     * @param quoteToken Address of an ERC20 token contract used as the quoteAmount denomination
     * @return quoteAmount Amount of quoteToken received for baseAmount of baseToken
     */
    function _getQuoteAtTick(int24 tick, uint128 baseAmount, address baseToken, address quoteToken) internal pure returns (uint256 quoteAmount) {
        return OracleLibrary.getQuoteAtTick(tick, baseAmount, baseToken, quoteToken);
    }
    
    /**
     * @param pool Address of Uniswap V3 pool that we want to observe
     * @param period Number of seconds in the past to start calculating time-weighted average
     * @param baseAmount Amount of token to be converted
     * @param baseToken Address of an ERC20 token contract used as the baseAmount denomination
     * @param quoteToken Address of an ERC20 token contract used as the quoteAmount denomination
     * @return quoteAmount Amount of quoteToken received for baseAmount of baseToken
     */
    function getSpotPrice(address pool, uint32 period, uint128 baseAmount, address baseToken, address quoteToken) external view override returns(uint256 quoteAmount){
        int24 timeWeightedAverageTick = _consult(pool, period);
        return _getQuoteAtTick(timeWeightedAverageTick, baseAmount, baseToken, quoteToken);
    }
}
