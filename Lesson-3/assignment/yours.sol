/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
    
    using SafeMath for uint;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;

    mapping(address => Employee) public employees;
    
    modifier employeeExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id != address(0));
        _;
    }
    
    modifier employeeNotExist(address employeeId){
        var employee = employees[employeeId];
        assert(employee.id == address(0));
        _;
    }
  
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now - employee.lastPayday).div(payDuration);
        employee.id.transfer(1 ether);
    }

    function addEmployee(address employeeId, uint salary) onlyOwner employeeNotExist(employeeId) {

        // 往数组里添加员工
        employees[employeeId] = Employee(employeeId,salary * 1 ether,now);

        // 计算totalSalary
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        _partialPaid(employee);
        
        // 计算totalSalary
        totalSalary -= employee.salary;

        // 删除该员工
        delete employees[employeeId];  
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        // 先进行结算
        _partialPaid(employee);
        
        // 计算totalSalary
        totalSalary = totalSalary - employee.salary + salary * 1 ether;

        // 调薪
        employee.salary = salary * 1 ether;
        employee.lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() >= 1;
    }
    
    function checkEmployee(address employeeId) returns (uint salary,uint lastPayday){
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function getPaid() employeeExist(msg.sender) {
        var employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday + payDuration;

        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
    
    function changePaymentAddress(address oldAddr,address newAddr) onlyOwner{
        var employee = employees[oldAddr];
        employee.id = newAddr;
        employees[newAddr] = employee;
        delete employees[oldAddr];
    }
}
