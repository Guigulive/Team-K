var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function(accounts) {
    it("should add employee", function() {
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;

            return payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
        }).then(function() {
            return payrollInstance.employees.call(accounts[1]);
        }).then((employee) => {
            assert.equal(employee[0], accounts[1], "The address of the added employee does not match");
            assert.equal(web3.fromWei(employee[1], "ether").toNumber(), 1, "The salary of the added employee does not match");
        });
    });

    it("should remove employee", function() {
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;

            return payrollInstance.removeEmployee(accounts[1], {from: accounts[0]});
        }).then(function() {
            return payrollInstance.employees.call(accounts[1]);
        }).then((employee) => {
            assert.equal(employee[0], "0x0000000000000000000000000000000000000000", "The employee is not removed");
        });
    });
});
