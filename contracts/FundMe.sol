//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";
contract FundMe{
    using SafeMathChainlink for uint256;
    mapping(address=>uint256) public amountfundedarray;
    address[] public funders;
    address public owner;
    address funder;
    uint256 ans;
    uint256 leastamount=50;
    AggregatorV3Interface public pricefeed;
     constructor(address _priceFeed) public{
       pricefeed=AggregatorV3Interface(_priceFeed);
        owner=msg.sender;
    }
    function payme() payable public{
        require(usdtoethingwei(leastamount)<=msg.value,"You need to send more than 25 USD!");
        amountfundedarray[msg.sender]=amountfundedarray[msg.sender]+msg.value;
        funders.push(msg.sender);
    }
   
    function getlatestprice() public view returns(uint256){
        (,int256 answer,,,)=pricefeed.latestRoundData();
        return uint256 (answer*10**10);
    }
     function leastamountusd() public view returns(uint256)
    {
      //minimum usd
      uint256 minimumusd=50*10**18;
      uint256 percision=1*10**18;
      uint256 price=getlatestprice();
      uint256 leastamount1=(minimumusd*percision)/price;
      return leastamount1;
    }
    function usdtoethingwei(uint256 usdamount)public view returns(uint256)
    {
        uint256 price=getlatestprice();
        uint256 ethamount=(usdamount*10**18*10**10*10**8)/price;
        return ethamount;
    }
    function ethtousd(uint256 _ethamount) public view returns(uint256)
    {
        uint256 price=getlatestprice();
        uint256 usdamount=(price*_ethamount)/(10000000000000000000*10**8);
        return usdamount; 
    }
    modifier onlyowner{
      require(msg.sender==owner);
      _;
    }
    function withdraw() payable public onlyowner()
    {
      msg.sender.transfer(address(this).balance);
      for(uint256 funderindex;funderindex<funders.length;funderindex++)
      {
        funder=funders[funderindex];
        amountfundedarray[funder]=0;
      }
      funders=new address[](0);
    }
}