// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    // this happends first
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        console.log(fundMe.getVersion());
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(); // next line should revert !
        // assert(This tx fails/reverts)
        fundMe.fund(); // sends 0 value which is less than 5$
    }
}
