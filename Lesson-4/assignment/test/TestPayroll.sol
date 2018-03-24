pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Payroll.sol";

contract TestPayroll {
  Payroll payroll = Payroll(DeployedAddresses.Payroll());
  address testId = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C;
  function testAddEmployee() public {
    
    payroll.addEmployee(testId, 1);
    Assert.equal(payroll.getEmployee(testId), testId, "Add employee failed!");
  }

  function testRemoveEmployee() public {
    payroll.removeEmployee(testId);
    Assert.equal(payroll.getEmployee(testId), 0x0, "Remove employee failed!");
  }

}
