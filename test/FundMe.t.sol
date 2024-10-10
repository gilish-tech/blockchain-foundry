
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";





contract FundMeTest is Test {

    FundMe fundMe;
    address USER = makeAddr("james");
    address OWNER = makeAddr("owner");
    uint256 GASPRICE = 1;


    function setUp() external {
        
       vm.deal(USER, 100 ether);
       vm.deal(OWNER, 100 ether);
       DeployFundMe deployFundMe = new DeployFundMe();
       fundMe = deployFundMe.run();



    }

    function testCheckIfOwnerIsDeployer() external{


        console.log(address(msg.sender).balance);

        
        
        assertEq(fundMe.getOwner(), msg.sender);

    }

    function testRevertIfEnoughEthIsNotSent() external{
        vm.expectRevert();
        fundMe.fund();
    }

    function testIfUsersThatPayedAreSaved()public{

        vm.prank(USER);
        

        fundMe.fund{value:1 ether}();

        console.log(USER);
        console.log(fundMe.getFunder(0));
        assertEq(fundMe.getFunder(0), USER);

    }


    function testIfUserIsMatchedToTheAmountPaid() public{
        vm.prank(USER);
        fundMe.fund{value:1 ether}();
        // fundMe.fund{value:5 ether}();


        assertEq(fundMe.getAddressToAmountFunded(USER), 1 ether);
    }

    modifier funded {
        vm.prank(USER);
        fundMe.fund{value:1 ether}();
        _;

    }


    function testCheckIfOnlyOwnerCanithdrawl()external funded(){


        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();

        
    }



    function testIfOwnerCanWithdraw()external funded(){

        uint256  startingBalance = fundMe.getOwner().balance;
        uint256 startingContractBalace = address(fundMe).balance;

        uint256 gasStart = gasleft();
        vm.txGasPrice(GASPRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        uint256 gasEnd = gasleft();

        uint256 gasUsed =  (gasStart - gasEnd) * tx.gasprice;
        console.log("gs",gasUsed);
        console.log("gsps",tx.gasprice);
        
        uint256  endingBalance = fundMe.getOwner().balance;
        uint256 endingContractBalance = address(fundMe).balance;
        assertEq(startingBalance + startingContractBalace, endingBalance);
        assertEq(endingContractBalance, 0);


    }


    function testWithdrawlFromMultipleFunders()external{
        // uint256 i = 1
        for(uint160 i = 1; i <= 10; i++){

            hoax(address(i), 10 ether);
            fundMe.fund{value:1 ether}();

            
        }


        uint256 startingContractBalance = address(fundMe).balance;
        uint256 startingBalance = fundMe.getOwner().balance;

        assertEq(startingContractBalance,1 ether * 10);

 
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();


        assertEq(address(fundMe).balance, 0);
        assertEq(startingBalance + startingContractBalance, fundMe.getOwner().balance);
        
    }

}

