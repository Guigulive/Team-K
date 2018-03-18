pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    uint totalSalary;
    uint constant payDuration = 10 seconds;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for(uint i = 0; i < employees.length; i++){
            if(employeeId == employees[i].id){
                return (employees[i],i);
            }
        }
        return (Employee(0,0,0),0);
    }

    function addEmployee(address employeeId, uint salary) public {
        require(employeeId != 0x0);
        require(salary > 0);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId,salary * 1 ether,now));
        totalSalary += salary * 1 ether;
    }

    function removeEmployee(address employeeId) public {
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        delete(employees[index]);
        employees[index] = employees[employees.length-1];
        employees.length -= 1;
        totalSalary -= employee.salary;
    }

    function updateEmployee(address employeeId, uint salary) public {
        require(employeeId != 0x0);
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        totalSalary -= employee.salary;
        _partialPaid(employee);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
        totalSalary += salary * 1 ether;
    }

    function addFund() public payable returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint) {
        return address(this).balance / totalSalary;
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var (employee,index) = _findEmployee(msg.sender);
        _partialPaid(employee);
        employees[index].lastPayday = now;
    }
}
