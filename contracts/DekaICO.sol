pragma solidity ^0.4.13;

import "./Controlled.sol";
import "./Owned.sol";
import "./DekaToken.sol";

contract DekaICO is Owned, Controller {

  uint256 constant public limit = 100 ether;
  uint256 constant public exchange = 10;
  uint256 public totalCollected;

  DekaToken public dekaToken;
  address public destEthers;

  function DekaICO() {
    owner = msg.sender;
    totalCollected = 0;
  }

  modifier initialized() {
    require(address(dekaToken) != 0x0);
    _;
  }

  function initialize ( address _token,
                        address _destEth) {
    require(address(dekaToken) == 0x0);

    dekaToken = DekaToken(_token);
    require(dekaToken.totalSupply() == 0);
    require(dekaToken.controller() == address(this));
    destEthers = _destEth;
  }

  function proxyPayment(address _th) public payable returns (bool) {
    return doBuy(_th, msg.value);
  }

  function doBuy(address _sender, uint _amount) public returns (bool) {
    uint256 tokensGenerated = _amount * exchange;

    require (totalCollected + _amount <= limit);

    assert(dekaToken.generateTokens(_sender, tokensGenerated));
    destEthers.transfer(_amount);

    totalCollected = totalCollected + _amount;

    return true;
  }



  function() public payable {
    proxyPayment(msg.sender);
  }

}
