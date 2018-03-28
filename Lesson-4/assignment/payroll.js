var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {

  it("...add Employee...", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      console.log("accounts[0]: ",accounts[0]);
      console.log("accounts[1]: ",accounts[1]);
      return payrollInstance.addEmployee(accounts[1], 2, {from: accounts[0]});
    }).then(function() {
      console.log("get employee accounts[1]: ",accounts[1]);
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(result) {
      console.log("add Employee result: ", result);
      assert.equal(result[0], accounts[1], "add Employee failed!");
    }).catch(function(error) {
      console.log(error);
    });
  });

  it("...add Fund...", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      console.log("add Fund: 10 ether.");
      return payrollInstance.addFund({from: accounts[0], value:web3.toWei('10', 'ether')});
    }).then(function() {
      console.log("call hasEnoughFund");
      return payrollInstance.hasEnoughFund.call();
    }).then(function(result) {
      console.log("add Fund result: ", result);
      assert.equal(result, true, "add Fund failed!");
    }).catch(function(error) {
      console.log(error);
    });
  });

  it("...get Paid...", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [12], id: 0});
      console.log("get Paid: 2 ether.");
      return payrollInstance.getPaid({from: accounts[1]});
    }).then(function() {
      console.log("get employee accounts[1]: ",accounts[1]);
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(result) {
      console.log("get Paid result: ", result);
      assert.equal(result[1], "2000000000000000000", "get Paid failed!");
    }).catch(function(error) {
      console.log(error);
    });
  });

  it("...remove Employee...", function() {
    return Payroll.deployed().then(function(instance) {
      payrollInstance = instance;

      console.log("accounts[1]: ",accounts[1]);
      return payrollInstance.removeEmployee(accounts[1]);
    }).then(function() {
      console.log("get employee accounts[1]: ",accounts[1]);
      return payrollInstance.employees.call(accounts[1]);
    }).then(function(result) {
      console.log("remove Employee result: ", result);
      assert.equal(result[0], '0x0000000000000000000000000000000000000000', "remove Employee failed!");
    }).catch(function(error) {
      console.log(error);
    });
  });

});
