pragma solidity ^0.4.13;

import "./Controlled.sol";

contract DekaToken is Controlled{

  function DekaToken() {
    controller = msg.sender;
  }

  mapping (address => uint256) balances;
  uint256 public totalSupply;

  function balanceOf(address _owner) constant returns (uint256 balance) {
    if (balances[_owner] == 0) {
      return 0;
    } else {
      return balances[_owner];
    }
  }

  function transfer(address _to, uint256 _value) returns (bool success) {
    return doTransfer(msg.sender, _to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) onlyController returns (bool success) {
    return doTransfer(_from, _to, _value);
  }

  function doTransfer (address _from, address _to, uint256 _value) internal returns (bool) {
    if (_value == 0) {
      return true;
    }

    require ((_to != 0) && (_to != address(this)));

    var previousBalanceFrom = balanceOf(_from);
    if (previousBalanceFrom < _value) {
      return false;
    }
    balances[_from] = balances[_from] - _value;

    var previousBalanceTo = balanceOf(_to);
    require(previousBalanceTo + _value >= previousBalanceTo);
    balances[_to] = balances[_to] + _value;

    Transfer(_from, _to, _value);
  }

  function isContract(address _addr) constant internal returns(bool) {
    uint size;
    if (_addr == 0) return false;
    assembly {
        size := extcodesize(_addr)
    }
    return size>0;
  }

  function () payable {
    require(isContract(controller));

    Controller c = Controller(controller);
    require(c.proxyPayment.value(msg.value)(msg.sender));
  }

  function generateTokens(address _owner, uint _amount) onlyController returns (bool) {
    uint curTotalSuply = totalSupply;
    require(curTotalSuply + _amount >= curTotalSuply);
    uint previousBalanceTo = balanceOf(_owner);
    require(previousBalanceTo + _amount >= previousBalanceTo);
    totalSupply = curTotalSuply + _amount;
    balances[_owner] = previousBalanceTo + _amount;
    Transfer(0, _owner, _amount);
    return true;
  }

  event Transfer (address indexed _from, address indexed _to, uint256 _value);

}
