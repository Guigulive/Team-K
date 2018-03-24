var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("Test addEmployee", function() {
      return Payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.addEmployee(accounts[2], 1);
      }).then(function() {
        return payroll.getEmployee.call(accounts[2]);
      }).then(function(employeeId) {
        assert.equal(employeeId, accounts[2], "add employee wrong");
      });
    });

  it("Test removeEmployee", function() {
    return Payroll.deployed().then(function(instance) {
        payroll = instance;
        return payroll.addEmployee(accounts[2], 1);        
      }).then(function() {
        return payroll.removeEmployee(accounts[2]);
      }).then(function() {
        return payroll.getEmployee.call(accounts[2]);
      }).then(function(employeeId) {
        assert.equal(employeeId, 0, "remove employee wrong");
      });
    });
});
