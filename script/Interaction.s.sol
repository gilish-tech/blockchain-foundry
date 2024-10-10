// SPDX-License-Identifier: MIT


pragma solidity ^0.8.19;

import {Script,console} from "forge-std/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script{

    uint256 constant SEND_VALUE = 1 ether;


    function fundFundMe(address _recentlyDeployedAddress )public{
        vm.startBroadcast();
        FundMe(_recentlyDeployedAddress).fund{value:SEND_VALUE}();
        vm.stopBroadcast();
        console.log("fudede boss");

    }

    function run() external{



        HelperConfig helperConfig =  HelperConfig(vm.envAddress("HELPER_CONFIG_ADDRESS"));
        address mostRecentlyDeployed = helperConfig.getRecentDeployment("FUNDME");
        fundFundMe(mostRecentlyDeployed);


    }

}


contract withdrawlFundMe is Script{

}