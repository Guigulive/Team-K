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

gas有变化。
gas的消耗变化在依次递增，且增加值固定，约800；
其主要原因则是在进行CalculateRunway时，
我们在利用for循环来计算总工资。因此每多一个员工，将多一个循环。
for循环会带来极大的gas消耗，
随着员工数量的增多，循环次数也相应的增加，导致gas的大量消耗。

优化思路：
考虑到题目中每个员工工资固定，其实我们可以直接利用员工数当作总工资的ether数。
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
        //因为存在一些情况不会自动返回0，比如需要返回的是storage类型时候
        return (Employee(0,0,0),0);
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
         // 往数组里添加员工
        employees.push(Employee(employeeId, salary * 1 ether, now));
        // 计算totalSalary
        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        // 计算totalSalary
        totalSalary -= employee.salary;
        // 删除该员工
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }

    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
         // 先进行结算
         _partialPaid(employee);
          // 计算totalSalary
        totalSalary += (employee.salary - salary);
          // 调薪
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
