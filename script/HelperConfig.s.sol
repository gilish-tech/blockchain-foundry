pragma solidity ^0.8.19;

import {Script,console} from "forge-std/Script.sol";

import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    uint8 public DECIMALS = 8;
    int256 public INITIAL_PRICE = 2000e8;


    NetworkConfig public activeConfig;

    struct NetworkConfig{
        address priceFeed;
    }


    constructor() {
        if (block.chainid == 11155111){
            activeConfig = getSepoliaEthConfig();
        }
        else if (block.chainid == 1 ){
            activeConfig = getMainetEthConfig();
        }
        else{
            activeConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory){

        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;

    }
    function getMainetEthConfig() public pure returns(NetworkConfig memory){

        NetworkConfig memory ethConfig = NetworkConfig({priceFeed:0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethConfig;

    }

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory){

        if (activeConfig.priceFeed != address(0)){
            return activeConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator  = new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed:address(mockV3Aggregator)});

        return anvilConfig;






    }


    function concatStrings(string memory a) public view  returns (string memory) {


        return string.concat(a,vm.toString(block.chainid));
    
    }


    function saveRecentDeployment(address _address, string memory _name) public {



        vm.setEnv( concatStrings( _name), vm.toString(_address));
        // console.log(vm.envAddress(_name));
    }


    function getRecentDeployment(string memory _name) public view returns (address) {
        return vm.envAddress( concatStrings( _name));
    }


}