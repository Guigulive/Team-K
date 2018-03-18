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
        employee.id.transfer(employee.salary * (now - employee.lastPayday) / payDuration);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if(employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
        return (Employee(0,0,0), 0);
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0); /*确认查找完后employee为空，即添加的地址是新地址*/
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);

        assert(employee.id != 0x0); /*确认查找到员工地址*/
        _partialPaid(employee);
        totalSalary -= employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeId);

        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary = totalSalary - employee.salary + salary * 1 ether;
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
        assert(nextPayday < now);
        uint payTimes = (now - employee.lastPayday) / payDuration;

        employees[index].lastPayday = employee.lastPayday + payDuration * payTimes;
        employee.id.transfer(employee.salary * payTimes);
    }
}
