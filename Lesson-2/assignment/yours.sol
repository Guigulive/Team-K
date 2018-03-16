pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    
    address owner;
    Employee[] employees;
    
    uint allSalary;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee, uint) {
        for (uint i=0; i< employees.length; i++){
            if (employees[i].id == employeeId)
                return (employees[i], i);
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        require(employeeId != 0x0);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        uint salaryEther = salary * 1 ether;
        employees.push(Employee(employeeId, salaryEther, now));
        allSalary += salaryEther;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        require(employeeId != 0x0);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        allSalary -= employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length - 1];
        employees.length -= 1;
    }
    
    function updateEmployee(address employeeId, address employeeIdNew, uint salary) {
        require(msg.sender == owner);
        require(employeeId != 0x0);
        require(employeeIdNew != 0x0);
        var (employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        allSalary -= employee.salary;
        _partialPaid(employee);
        
        uint salaryEther = salary * 1 ether;
        employees[index] = Employee(employeeIdNew, salaryEther, now);
        allSalary += salaryEther;
    }
    
    function addFund() payable returns (uint){
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        uint totalSalary = 0;
       for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    function calculateRunwayPlus() returns (uint) {
        return this.balance / allSalary;
    }
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
            
        uint nextPayday = employee.lastPayday + payDuration;
        assert(nextPayday < now);
            
        employees[index].lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}

/*
加入十个员工以后，调用calculateRunway消耗的gas如下：

1694 gas
2475 gas
3256 gas
4037 gas
4818 gas
5599 gas
6380 gas
7161 gas
7942 gas
8723 gas

可以看出，每次加入一个员工，调用calculateRunway消耗的gas就多800左右，产生这个现象的原因是在计算totalSalary的时候，需要把所有员工的salary都加一遍，每加一次，就损耗多一点gas。

可以考虑在addEmployee，removeEmployee和updateEmployee的时候先计算好totalSalary然后存储起来，在调用calculateRunway的时候直接使用即可。

加入新的function calculateRunwayPlus来使用这个方法。使用后每次调用calculateRunwayPlus的时候消耗962 gas。
*/
