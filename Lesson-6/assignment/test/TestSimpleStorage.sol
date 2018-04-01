pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SimpleStorage.sol";

contract TestSimpleStorage is SimpleStorage{

  function testItStoresAValue() {
    setInternal(10);
    Assert.equal(get(), 10, "failed value 89.");
  }

}
