pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 5 seconds;
    uint totalSalary = 0;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    address owner;
    Employee[] public employees;
    
    event TransferSalary(uint salary);
    
    function Payroll() {
        owner = msg.sender;
    }
    
    //支付之前的部分
    function _partialPaid(Employee employee) private {
         uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
         if (payment > 0) {
            employee.id.transfer(payment);
            TransferSalary(payment);
        }
    }
    
    //寻找数组是否存在雇员地址
    function _findEmployee(address employee) private returns (Employee, uint) {
         for(uint i =0; i< employees.length; i++)
        {
            if(employees[i].id == employee)
            {
                return (employees[i], i);
            }
        }
		return (Employee(0,0,0), 0);
    }
    
    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        
        var ( employee, index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);
        
        employees.push(Employee(employeeId, salary  * 1 ether, now));
        totalSalary += salary  * 1 ether;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner); 
        
        var ( employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary -= employee.salary;
        
        delete employees[index];
        employees[index] = employees[employees.length -1];
        employees.length -=1;
    }
    
    function updateEmployeeSalary(address employeeId, uint  salary) {
	    require(msg.sender == owner);
        
        var ( employee, index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);
        
        _partialPaid(employee);
        totalSalary -= employee.salary;
        
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
        totalSalary += employees[index].salary;
	}
    
    //1 给合约账户充值 2 查看合约余额
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    //查看账户余额能发几次薪水
    function caculateRunway() returns (uint) {
        assert(totalSalary != 0);
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
        
        if( 0x0 != employee.id ) {
            employees[index].lastPayday = nextPayDay;
            employee.id.transfer(employee.salary);
            TransferSalary(employee.salary);
        }
    }
}