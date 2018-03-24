var Payroll = artifacts.require("./Payroll.sol");

//contract这儿等同于mocha的describe
contract('Payroll', function(accounts){   
    it("addEmployee test ", function() {
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            payrollInstance.addFund({from: accounts[0], value: 1});

            return payrollInstance.addEmployee(accounts[1], 1);
        }).then(function() {
            return payrollInstance.employees.call(accounts[1]);
        }).then(function(employee){
            console.log(employee);
            assert.equal(employee[0], accounts[1], "The value " + accounts[1] + " was not stored.");
        }).then(function() { 
            assert(false, "exception is supposed to throw but didn't.");
        }).catch(function(err) {
            // TODO: can do more careful validation by comparing the invalid opcode
            assert(true);
        });
    });

    it("removeEmployee test ", function() {
        return Payroll.deployed().then(function(instance) {
            payrollInstance = instance;
            payrollInstance.addFund({from: accounts[0], value: 1});

            return payrollInstance.employees.call(accounts[1]);
        }).then(function(employee){
            //console.log(employee);
            assert.equal(employee[0], accounts[1], "The value " + accounts[1] + " was not stored.");
        }).then(function(){
            payrollInstance.removeEmployee(accounts[1]);
        }).then(function() {
            return payrollInstance.employees.call(accounts[1]);
        }).then(function(employee){
            console.log(employee);
            assert.equal(employee[0], 0, "The value " + employee[0] + " was not null.");
        }).then(function() { 
            assert(false, "exception is supposed to throw but didn't.");
        }).catch(function(err) {
            // TODO: can do more careful validation by comparing the invalid opcode
            assert(true);
        });
    });



});