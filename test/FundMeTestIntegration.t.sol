import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {FundFundMe} from "../script/Interaction.s.sol";
import {FundMe} from "../src/FundMe.sol";
import {Test} from "forge-std/Test.sol";

contract FundMeTest is Test {


    FundMe fundMe;
    address USER = makeAddr("james");
    address OWNER = makeAddr("owner");
    function setUp() external {     
       vm.deal(USER, 100 ether);
       vm.deal(OWNER, 100 ether);
       DeployFundMe deployFundMe = new DeployFundMe();
       fundMe = deployFundMe.run();





    }


    function testIfUserCanFund()external{
        FundFundMe fundFundMe = new FundFundMe();


        

       
        fundFundMe.fundFundMe(address(fundMe));
        vm.stopBroadcast();

        

        address funder  = fundMe.getFunder(0);
        assertEq(funder, USER);

    }



}