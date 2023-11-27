// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    // address USER2 = makeAddr("user2");
    uint constant SEND_VALUE = 0.1 ether;
    uint constant STARTING_BALANCE = 10 ether;

    // this happends first
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
        // vm.deal(USER2, STARTING_BALANCE);
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
        // its like assert(This tx fails/reverts)
        fundMe.fund(); // sends 0 value which is less than 5$
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // next tx will be sent by user
        fundMe.fund{value: SEND_VALUE}();
        // console.log(fundMe.getFunder(0));

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        // ! It restarts after every test method and calls setUp() method again before every test method
        // ! EVEN if i execute whole test file at once !!!!!!!!!!!!
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        // console.log(fundMe.getFunder(0));

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        // ! This will be successfull test, but who is the msg.sender ???
        vm.expectRevert();
        // ! expectRevert() ignores this line bcz its not a transaction, it is vm cheatcode
        vm.prank(USER);
        fundMe.withdraw();
    }
}
