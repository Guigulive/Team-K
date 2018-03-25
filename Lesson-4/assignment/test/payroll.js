var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

    var payrollInstance; // instance of the deployed Payroll contract
   

  it("Owner can add employee.", function() {
    return Payroll.deployed().then(function(instance) {
        payrollInstance = instance;
        return payrollInstance.addEmployee(accounts[1],2);
    }).then(function() {
        return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee){
        employee1 = employee[0];
    }).then(function(){
        return payrollInstance.addEmployee(accounts[2],3);
    }).then(function() {
        return payrollInstance.employees.call(accounts[2]);
    }).then(function(employee){
        employee2 = employee[0];

    }).then(function() {

      assert.equal(employee1, accounts[1], "employ1 add fail.");
      assert.equal(employees, accounts[2], "employ2 add fail.");

    });
  });

  it("Owner can remove employee.", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;
        payrollInstance.addEmployee(accounts[1],2);
    }).then(function() {
        payrollInstance.addFund.call({value:100});
    }).then(function(){
        return payrollInstance.removeEmployee(accounts[1]);
    }).then(function() {
        return payrollInstance.employees.call(accounts[1]);
    }).then(function(employee){
 
      assert.equal(employee[0], 0x0, "remove employ fail.");
      assert.equal(employee[1], 0, "remove salary fail");

    });
  });


});