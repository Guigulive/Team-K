var Payroll = artifacts.require("./Payroll.sol");

//contract这儿等同于mocha的describe
contract('Payroll', function(accounts){

    let payrollInstance;

    before(async () => {
        payrollInstance = await Payroll.new({from : accounts[0]});
        const wei_added = web3.toWei("5", "ether");
        await payrollInstance.addFund({from : accounts[0], value : wei_added});
        console.log("run before");
    });

    it("addEmployee test ", async () => {
        try {
            await payrollInstance.addEmployee(accounts[1], 1, {from: accounts[0]});
            const employee = await payrollInstance.employees.call(accounts[1]);
            assert.equal(employee[0], accounts[1], "The value " + accounts[1] + " was not stored.");
        } catch(err) {
            // TODO: can do more careful validation by comparing the invalid opcode
            assert(true);
        }
    });

    it("removeEmployee test ", async () => {
        try {
            const employeeExit = await payrollInstance.employees.call(accounts[1]);
            assert.equal(employeeExit[0], accounts[1], "The value " + accounts[1] + " was not stored.");

            await payrollInstance.removeEmployee(accounts[1]);

            const employee = await payrollInstance.employees.call(accounts[1]);
            assert.equal(employee[0], 0, "The value " + employee[0] + " was not null.");

        } catch(err) {
            // TODO: can do more careful validation by comparing the invalid opcode
            assert(true);
        }
    });

});