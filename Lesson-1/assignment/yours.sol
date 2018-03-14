pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary = 1 ether;
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint lastPayday;

    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployee (address e) {
        require(msg.sender == owner);
        
        employee = e;
        lastPayday = now;
    }
    
    function updateSalary (uint s) {
        require(msg.sender == owner);
        
        salary = s;
    }
    
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayDay = lastPayday + payDuration;
        if (nextPayDay > now) {
            revert();
        }
        
        lastPayday = nextPayDay;
        employee.transfer(salary);
    }
}
