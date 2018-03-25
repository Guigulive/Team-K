var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("Test addEmployee", function() {
      return Payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.addFund({from: accounts[0], value: 100});
      }).then(function() {
        return payroll.addEmployee(accounts[1], 1);
      }).then(function() {
        return payroll.getEmployee(accounts[1]);
      }).then(function(employeeId) {
        assert.equal(employeeId, accounts[1], "Add employee failed!");
      });
    });

  it("Test removeEmployee", function() {
    return Payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.removeEmployee(accounts[1]);
      }).then(function() {
        return payroll.getEmployee(accounts[1]);
      }).then(function(employeeId) {
        assert.equal(employeeId, 0, "Remove employee failed!");
      });
    });
});
