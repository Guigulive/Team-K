pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 5 seconds;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    address owner;
    Employee[] employees;
    
    event TransferSalary(uint salary);
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
         uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
         if (payment > 0 && hasEnoughtFund() ) {
            employee.id.transfer(payment);
            TransferSalary(payment);
        }
    }
    
    function _findEmployee(address employee) private returns (Employee, uint) {
         for(uint i =0; i< employees.length; i++)
        {
            if(employees[i].id == employee)
            {
                return (employees[i], i);
            }
        }
    }
    
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var ( employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employee.id, salary, now));
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner); 
        
        var ( employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        delete employees[index];
        employees[index] = employees[employees.length -1];
        employees.length -=1;
    }
    
    function updateEmployeeSalary(address employeeId, uint  salary) {
	    require(msg.sender == owner);
        
        var ( employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        employees[index].salary = salary;
        employees[index].lastPayday = now;
	}
    
    //1 给合约账户充值 2 查看合约余额
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    //查看账户余额能发几次薪水
    function caculateRunway() returns (uint) {
        uint totalSalary = 0;
         for(uint i =0; i< employees.length; i++)
        {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    }
    
    //是否拥有足够的钱发薪水
    function hasEnoughtFund() returns (bool) {
        return caculateRunway() > 0;
    }
    
    //雇员自己获取薪水
    function getPaid() {
        var ( employee, index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        
        uint nextPayDay = employee.lastPayday + payDuration;
        

        //未到发薪水日期
        if (nextPayDay > now ) {
            revert();
        }
        
        if( 0x0 != employee.id &&  hasEnoughtFund() ) {
            employees[index].lastPayday = nextPayDay;
            employee.id.transfer(employee.salary);
            TransferSalary(employee.salary);
        }
    }
}