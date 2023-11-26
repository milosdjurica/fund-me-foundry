// SPDF-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    // this happends first
    function setUp() external {
        // me -> FundMeTest -> FundMe()
        // FundMeTest == owner
        fundMe = new FundMe();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersionIsAccurate() public {
        console.log(fundMe.getVersion());
        assertEq(fundMe.getVersion(), 4);
    }
}
