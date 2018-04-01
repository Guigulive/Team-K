var Payroll = artifacts.require("./Payroll.sol");
var SafeMath= artifacts.require("./SafeMath.sol");
var Ownable = artifacts.require("./Ownable.sol");


contract('作业:对addEmployee和removeEmployee进行单元测试', function(accounts) {

    // addEmployee
    // 1) whether msg.sender is Owner ? Pass : Error
    // 2) whether ID exists           ? Pass : Error
     
    it("1. addEmployee() --> whether msg.sender is Owner", function(){
        return Payroll.deployed(
        ).then(function(instance){
            console.log( "\n    1.addEmployee()")
            PayrollInstance = instance;
            return instance.owner.call()
        }).then(function(checkaddress){
            if(checkaddress == accounts[0]){
                console.log( "         Pass  -> msg.sender is Owner.");
            }else{
                console.log( "         Error -> msg.sender is not Owner.");
            }
        });
    });


    it("1. addEmployee() --> whether ID exists", function(){
        return Payroll.deployed(
        ).then(function(instance){
            PayrollInstance.addEmployee(accounts[2],2,{from:accounts[0]})
            PayrollInstance2 = instance
            return PayrollInstance2.addEmployee(accounts[2],1,{from:accounts[0]});
        }).then(function(){ console.log( "         Pass  -> There is no IDs conflict error.");},
                function(){ console.log( "         Error -> the ID has already existed");
        });
    });


    // removeEmployee
    // 1) whether msg.sender is Owner ? Pass : Error
    // 2) whether ID exists           ? Error : Pass
    // 3) whether fund is enough      ? Pass : Error

    it("2. removeEmployee() --> whether msg.sender is Owner", function(){
        return Payroll.deployed(
        ).then(function(instance){
            console.log( "\n    2.removeEmployee()")
            PayrollInstance = instance;
            return instance.owner.call()
        }).then(function(checkaddress){
            if(checkaddress == accounts[0]){
                console.log( "         Pass  -> msg.sender is Owner.");
            }else{
                console.log( "         Error -> msg.sender is not Owner.");
            }
        });
    });




    it("2. removeEmployee() --> whether this employee exists", function(){
        return Payroll.deployed(
        ).then(function(instance){
            PayrollInstance = instance;
            PayrollInstance.addEmployee(accounts[5],1,{from:accounts[0]});
            return PayrollInstance.employees(accounts[6]);
        }).then(function(returnData){
            if(returnData[0] != 0){
                console.log( "         Pass  -> This employee exists.");
            }else{
                console.log( "         Error -> This employee doesnt exists.");
            }
        });
    });

    it("2. removeEmployee() --> whether fund is enough", function(){
        return Payroll.deployed(
        ).then(function(instance){
            PayrollInstance = instance;
            return PayrollInstance.addFund({value: 10000000000})
        }).then(function(){    
            return PayrollInstance.employees(accounts[0]);
        }).then(function(Ow){
            return Ow[1];
        }).then(function(fund){
            Fund = fund.toNumber();
            PayrollInstance.addEmployee(accounts[7],2,{from:accounts[0]});
        }).then(function(){ 
            return PayrollInstance.employees(accounts[7]);
        }).then(function(empc){ 
            return empc[1];
        }).then(function(em){ 
            payment_c = em.toNumber();
            //console.log(Fund);
            //console.log(payment_c);
            return payment_c;
        }).then(()=>{
            if(payment_c <= Fund){
                console.log( "         Pass  -> This employee can be checked out before removed.");
            }else{
                console.log( "         Error -> This employee should not be removed before payed.");
            }
        });
    });

});
