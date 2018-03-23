pragma solidity ^0.4.14;

import "./SafeMath.sol";
import "./Ownable.sol";

contract Payroll is Ownable{
    using SafeMath for uint;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    mapping (address => Employee) public employees;
    uint allSalary;
    
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier employeeNotExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday).div(payDuration));
        employee.id.transfer(payment);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) {
        var employee = employees[employeeId];
        uint salaryEther = salary.mul(1 ether);
        employees[employeeId] = Employee(employeeId, salaryEther, now);
        allSalary = allSalary.add(salaryEther);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        allSalary = allSalary.sub(employee.salary);
        delete employees[employeeId];
    }
    
    function updateEmployee(address employeeId, address employeeIdNew, uint salary) onlyOwner employeeExist(employeeId) employeeNotExist(employeeIdNew) {
        removeEmployee(employeeId);
        addEmployee(employeeIdNew, salary);
    }
    
    function changePaymentAddress(address employeeIdNew) employeeExist(msg.sender)  employeeNotExist(employeeIdNew){
        var employee = employees[msg.sender];
        employees[employeeIdNew] = Employee(employeeIdNew, employee.salary, employee.lastPayday);
        delete employees[msg.sender];
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance.div(allSalary);
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];
            
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
            
        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
