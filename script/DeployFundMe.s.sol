// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {FundMe}  from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {

    function run() public returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
       
        
        console.log("kkk",vm.toString(address(helperConfig)));
        vm.setEnv("HELPER_CONFIG_ADDRESS", vm.toString(address(helperConfig)));
        address networkConfig = helperConfig.activeConfig();

        
        vm.startBroadcast();
        FundMe fundMe = new FundMe(networkConfig);
        helperConfig.saveRecentDeployment(address(fundMe), "FUNDME");

        vm.stopBroadcast();

        return fundMe;

        // vm.s("FUNDME_CONTRACT_ADDRESS_" + block.chainid, address(fundMe));

    }


    // function run() public returns (FundMe){
    //     vm.broadcast();
    // }
}
