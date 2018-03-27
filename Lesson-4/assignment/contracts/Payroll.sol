pragma solidity ^0.4.18;

import './SafeMath.sol';

contract Payroll {
    using SafeMath for uint;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }

    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;
    address owner;

    mapping(address => Employee) public employees;

    function Payroll() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;

    }
    modifier employeeExist(address employeeId) {
        Employee storage employee = employees[employeeId];
        assert(employee.id != 0x0); /*确认取到的员工地址是存在的*/
        _;

    }
    function _partialPaid(Employee employee) private {
        employee.id.transfer(employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration));
    }

    function addEmployee(address employeeId, uint salary) public onlyOwner  {
        Employee storage employee = employees[employeeId];
        assert(employee.id == 0x0); /*确认取到的employee为空，即添加的地址是新地址*/
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);

        totalSalary = totalSalary.add(employee.salary);
    }
    function getEmployee(address employeeId) public view returns (address) {
        return employees[employeeId].id;
    }

    function removeEmployee(address employeeId) public onlyOwner employeeExist(employeeId) {
        Employee storage employee = employees[employeeId];
        _partialPaid(employee);

        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary) public onlyOwner employeeExist(employeeId) {
        Employee storage employee = employees[employeeId];
        _partialPaid(employee);

        totalSalary = totalSalary.sub(employee.salary).add(salary.mul(1 ether));
        employees[employeeId].salary = salary.mul(1 ether);
        employees[employeeId].lastPayday = now;
    }

    function changePaymentAddress(address employeeId, address newAddress) public employeeExist(employeeId) {
        Employee storage oldEmployee = employees[employeeId];
        assert(employees[newAddress].id == 0x0);

        employees[newAddress] = Employee(oldEmployee.id, oldEmployee.salary, oldEmployee.lastPayday);
        delete employees[employeeId];
    }

    function addFund() public payable returns (uint) {
        return address(this).balance;
    }

    function calculateRunway() public view returns (uint)  {
        return address(this).balance.div(totalSalary);
    }

    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public employeeExist(msg.sender) {
        Employee storage employee = employees[msg.sender];
        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);
        uint payTimes = now.sub(employee.lastPayday).div(payDuration);

        employees[msg.sender].lastPayday = employee.lastPayday.add(payDuration.mul(payTimes));
        employee.id.transfer(employee.salary.mul(payTimes));
    }
}
