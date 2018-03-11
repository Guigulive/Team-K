pragma solidity ^0.4.14;

contract Payroll {
    
    uint salary ;
    address frank ;
    uint constant payrollDuraton = 10 seconds;
    uint lastPayDay = now;
    
    function setAddress(){
        frank = msg.sender;
    }

     function setAddress(address newAddress){
        frank = newAddress;
    }
    
    function getAddress() returns(address){
        return frank;
    }
     
    function setSalary(uint money){
        salary = money;
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
        frank.transfer(salary);
    }
    
    
}