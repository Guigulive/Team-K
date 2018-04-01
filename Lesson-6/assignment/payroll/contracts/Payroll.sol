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
    
    uint constant                   payDuration = 20 seconds;
    address                         owner;
    uint                            totalSalary = 0;
    uint                            totalEmployee = 0;
    address[]                       employeeList;
    mapping(address => Employee)    public employees;


    /////////////////////////////////////////////////////////////////
    /////////////////////////// Modifier ////////////////////////////
    /////////////////////////////////////////////////////////////////

    modifier employeeExit(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }

    modifier idNotExist(address emplid){
        var employee = employees[emplid];
        assert(employee.id == 0x0);
        _;
    }

    /////////////////////////////////////////////////////////////////
    /////////////////////////// Event ///////////////////////////////
    /////////////////////////////////////////////////////////////////

    event NewEmployee(
        address employee
    );

    event UpdateEmployee(
        address employee
    );

    event RemoveEmployee(
        address employee
    );

    event NewFund(
        uint balance
    );

    event GetPaid(
        address employee
    );

    /////////////////////////////////////////////////////////////////
    /////////////////////////// Functions ///////////////////////////
    /////////////////////////////////////////////////////////////////


    function _hasEnoughToPayPersonally(Employee employee) private view returns(bool){
        if(employee.salary == 0){
            return true;
        }else{
            return this.balance.div(employee.salary) > 0;
        }
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary.mul(now.sub(employee.lastPayday)).div(payDuration);
        assert(_hasEnoughToPayPersonally(employee));
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeId) private view returns (address, uint){
        for(uint i=0;i<employeeList.length;i++){
            if(employeeList[i]==employeeId){
                return (employeeList[i], i);
            }
        }
    }

    function checkEmployee(uint index) public view returns (address employeeId, uint salary, uint lastPayday) {
        employeeId = employeeList[index];
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }

    
    function addEmployee(address employeeId, uint salary) onlyOwner idNotExist(employeeId) public {
        var employee = employees[employeeId];
        totalSalary = totalSalary.add(salary.mul(1 ether));
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalEmployee = totalEmployee.add(1);
        employeeList.push(employeeId);

        NewEmployee(employeeId);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExit(employeeId) public {
        var employee = employees[employeeId];

        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        delete employees[employeeId];
        totalEmployee = totalEmployee.sub(1);

        var (employee_temp_address, index)=_findEmployee(employeeId);
        assert(index>=0);
        delete employeeList[index];
        employeeList[index]=employeeList[employeeList.length-1];
        employeeList.length=employeeList.length.sub(1);

        RemoveEmployee(employeeId);
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExit(employeeId) public {
        var employee = employees[employeeId];

        _partialPaid(employee);
        totalSalary = totalSalary.sub(employee.salary);
        employee.salary = salary.mul(1 ether);
        employee.lastPayday = now;
        totalSalary = totalSalary.add(employee.salary);

        UpdateEmployee(employeeId);
    }
    
    function addFund() payable public returns (uint) {
        NewFund(this.balance);

        return this.balance;
    }
    
    function calculateRunway() public view returns (uint) {
        return this.balance.div(totalSalary);
    }
    
    function hasEnoughFund() public view returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() employeeExit(msg.sender) public {
        var employee = employees[msg.sender];

        uint nextPayday = employee.lastPayday.add(payDuration);
        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);

        GetPaid(employee.id);
    }

    function checkInfo() public view returns (uint balance, uint runway, uint employeeCount) {
        balance = this.balance;
        employeeCount = totalEmployee;

        if (totalSalary > 0) {
            runway = calculateRunway();
        }
    }
}