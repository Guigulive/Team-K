pragma solidity ^0.4.14;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";

contract Test {
    address constant public employee = 0x361C818A6211b2Eb390FF7685E075E5E830AA319;
    Payroll payroll = Payroll(DeployedAddresses.Payroll());
    
  function testAddEmployee() {
    payroll.addEmployee(employee, 1);
    Assert.equal(payroll.getEmployee(employee), employee, "Employee id should be the same");
  }

   function testRemoveEmployee() {
    payroll.removeEmployee(employee);
    Assert.equal(payroll.getEmployee(employee), employee, "Return should be 0");
  }
}
