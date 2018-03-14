/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll{
    uint salary = 1 ether;
    address employer = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    
    uint constant payDuration = 5 seconds;
    uint lastPayday = now;
    
    function addFund() payable returns (uint) {
        if(msg.sender != employer) {
            revert();
        }
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() >= 1;
    }
    
    function getPaid() returns (uint){
        if(msg.sender != employee) {
            revert();
        }
        uint nextPayday = lastPayday + payDuration;
        if( nextPayday > now) {
            revert();
        }
        lastPayday = nextPayday;
        employee.transfer(salary);
        return this.balance;
    }
    
    function payPervious() private{
        uint shoudPay = salary*(now-lastPayday)/payDuration;
        if(this.balance < shoudPay) {
            revert();
        }
        employee.transfer(shoudPay);
    }
    
    function changeEmployee(address newEmployee, uint newSalary) returns (address) {
        if(msg.sender != employer){
            revert();
        }
        payPervious();
        employee = newEmployee;
        salary = newSalary;
        lastPayday = now;
    }
}