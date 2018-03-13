/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract Payroll {
    address BOSS;
    
    uint salary = 1 ether;
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function Payroll() payable{
        BOSS = msg.sender;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
 
    function calculateRunway() returns (uint){
        return this.balance / salary;
    }  
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() >= 1;
    }
    
    function getPaid(){
        // only employee can getpaid
        require(msg.sender == employee);
        
        uint nextPayDay = lastPayday + payDuration;
        
        require(nextPayDay < now);
        
        lastPayday = nextPayDay;
        
        employee.transfer(salary);
    }
    
    function settlePreviousEmployee() private{
        employee.transfer((now - lastPayday)/payDuration * salary);
    }
    
    function updateEmployeeSalary(address newEmployee,uint sal) returns (address){
        // only boss can update
        require(msg.sender == BOSS);
        
        // settle previous account
        settlePreviousEmployee();
        
        employee = newEmployee;
        salary = sal;
        lastPayday = now;
    }
}