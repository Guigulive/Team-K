pragma solidity ^0.4.14;

contract Payroll {
    
    uint salary ;
    address frank ;
    address employee;
    
    uint constant payrollDuraton = 10 seconds;
    uint lastPayDay = now;
    
    function Payroll(){
        frank = msg.sender;
    }

     function setAddress(address newAddress){
         if(msg.sender == frank){
              employee = newAddress;
         }
       
    }
    
    function getAddress() returns(address){
        return employee;
    }
     
    function setSalary(uint money){
        if(msg.sender == frank){
            salary = money;
        }
    }
    
    function getSalary() returns(uint){
        return salary;
    }
    function addFound() payable returns(uint){
        return this.balance;
    }
    
    function calculateRunWay() returns(uint){
        return this.balance / salary;
    }
    
    function hasEnoughFound() returns(bool){
        return calculateRunWay() > 0;
    }
    
    function getPaid(){
        uint nextPayDay = lastPayDay +payrollDuraton ;
        if(nextPayDay>now){
            revert();
        }
        lastPayDay = nextPayDay;
        employee.transfer(salary);
    }
    
    
}