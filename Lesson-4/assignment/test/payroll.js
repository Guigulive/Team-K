var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll addEmployee', function (accounts) {
  var ownerId = accounts[0];
  var salary = 1;
  var payrollIns;

  // test addEmployee  
  it("addEmployee", function() {
    let employeeId = accounts[1];
    return Payroll.deployed().then(function(instance) {
        payrollIns = instance;
        return payrollIns.addEmployee(employeeId, salary, {from: ownerId});
    }).then(function() {
        return payrollIns.employees.call(employeeId);
    }).then(function(newEmployee) {
        assert.ok(true, 'success');
        assert.equal(newEmployee[0], employeeId, 'need check2');
        assert.equal(newEmployee[1].valueOf(), web3.toWei(salary, 'ether'), 'need check2');
    });
  });

  // test removeEmployee
  it("removeEmployee", function() {
    let employeeId = accounts[2];
    return Payroll.deployed().then(function(instance) {
        payrollIns = instance;
        return payrollIns.addEmployee(employeeId, salary, {from: ownerId});
    }).then(function() {
        return payrollIns.removeEmployee(employeeId, {from: ownerId});
    }).then(function(removedEmployee) {
        assert.ok(true);
        assert.equal(payrollIns.employees[employeeId], undefined);
    });
  });
});
