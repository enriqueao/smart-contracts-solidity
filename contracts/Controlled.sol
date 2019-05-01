pragma solidity ^0.4.13;

contract Controller {
  function proxyPayment(address _th) payable returns (bool);
}

contract Controlled {
  modifier onlyController() {
    require (msg.sender == controller);
    _;
  }

  address public controller;

  function Controlled() {
    controller = msg.sender;
  }

  function changeController(address _newController) onlyController {
    controller = _newController;
  }
}
