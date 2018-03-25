var Payroll = artifacts.require("./Payroll.sol");

contract('Payroll', function (accounts) {
    it("add employee:",function(){
        return Payroll.deployed().then(function(instance){
            payRollInstance = instance;
            payRollInstance.addFund({from:accounts[0],value:1});
            payRollInstance.addEmployee(accounts[1],1);
            return payRollInstance.employees.call(accounts[1]);
        }).then(function(employee){
            assert().equal(employee[0],accounts[1],"employee:" + accounts[1] + " add failed.");
        }).catch(function(err){
            console.log(err);
        });
    });
    it("remove employee",function(){
        return Payroll.deployed().then(function(instance){
            payRollInstance = instance;
            payRollInstance.addFund({from:accounts[0],value:1});
            return payRollInstance.employees.call(accounts[1]);
        }).then(function(employee){
            payRollInstance.removeEmployee(employee[0]);
            return employee;
        }).then(function(employee){
            assert(employee[0],0,"employee:" + employee[0] + " delete failed");
        }).catch(function(err){
            console.log(err);
        });
    });
});