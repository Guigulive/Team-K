/*
gas消耗对比如下

优化前gas：
 员工数量  transcation execution
    1       22966       1694
    2       23747       2475
    3       24528       3256
    4       25309       4037
    5       26090       4818
    6       26871       5599
    7       27652       6380
    8       28433       7161
    9       29214       7942
    10      29995       8723

优化后的gas：
 员工数量  transcation execution
    1       22124       852
    2       22124       852
    3       22124       852
    4       22124       852
    5       22124       852
    6       22124       852
    7       22124       852
    8       22124       852
    9       22124       852
    10      22124       852

优化思路：
for循环会带来极大的gas消耗，
随着员工数量的增多，循环次数也相应的增加，导致gas的大量消耗。
用一个全局变量记录着当前总工资的数量，
并在更新员工，增加员工，删除员工的时候，
同时更新总工资，能够极大的节约gas成本。
*/

pragma solidity ^0.4.14;

contract Payroll {

    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;
    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday)/payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
         for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
               return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employee.salary * 1 ether;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
         _partialPaid(employee);
        totalSalary += (employee.salary - salary);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
    }

    function addFund() payable returns (uint) {
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {

        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayday = employee.lastPayday + payDuration;
        if (nextPayday > now) {
            revert();
        }
        employees[index].lastPayday = nextPayday;
        employees[index].id.transfer(employee.salary);
    }
}
