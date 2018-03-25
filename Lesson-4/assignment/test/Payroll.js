var Payroll = artifacts.require("./Payroll.sol")

contract("Payroll",function(accounts){
    it(" add employee",function(){
        
                return Payroll.deployed().then(
                    function(instance) {
                        Payroll = instance;
                        instance.addEmployee(accounts[0],1)
                        employee = Payroll.getEmployee.call(accounts[0])
                        assert.equal(employee,accounts[0])
                    }
                ).then(
                    function(instance) {
                        Payroll = instance;
                        instance.removeEmployee(accounts[0])
                        employee = Payroll.getEmployee.call(accounts[0])
                        assert.equal(employee,accounts[0])
                    })
        })


        it(" Remove employee",function(){
            
                    return Payroll.deployed().then(
                        function(instance) {
                            Payroll = instance;
                            instance.removeEmployee(accounts[0])
                            employee = Payroll.getEmployee.call(accounts[0])
                            assert.equal(employee,accounts[0])
                        })
            })

})
