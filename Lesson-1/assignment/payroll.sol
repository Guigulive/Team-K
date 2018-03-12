pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 10 seconds;

    address owner;
    uint salary;
    address employee;
    uint lastPayday = now;

    function Payroll() {
        owner = msg.sender;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function setEmployeeAddressSalary(address newAddress, uint newSalary) {
        require(msg.sender == owner);        

        employee = newAddress;
        salary = newSalary * 1 ether;
    }

    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayday = lastPayday + payDuration;
        assert(nextPayday < now);
        uint payTimes = (now - lastPayday) / payDuration;

        lastPayday = lastPayday + payDuration * payTimes;
        employee.transfer(salary * payTimes);
    } 
}
