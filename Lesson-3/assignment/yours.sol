/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

contract Payroll is Ownable {
	using SafeMath for uint;
	
    uint constant payDuration = 300 seconds;
    uint totalSalary = 0;
    
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
	mapping(address => Employee) public employees;
    
    event TransferSalary(uint salary);
    event TransferSalaryWillPay(uint salary);
    
    function Payroll() {
    }

    
	modifier employeeExist(address employeeId) {
		var employee = employees[employeeId];
        assert(employee.id != 0x0);
		_;
	}
	
	modifier employeeNotExist(address employeeId) {
		var employee = employees[employeeId];
        assert(employee.id == 0x0);
		_;
	}
	
    //支付之前的部分
    function _partialPaid(Employee employee) private {
         uint payment = employee.salary.mul( (now.sub( employee.lastPayday ) ) ).div(payDuration);
         if (payment > 0) {
            TransferSalaryWillPay(payment);
            employee.id.transfer(payment);
            TransferSalary(payment);
        }
    }
        
    function addEmployee(address employeeId, uint salary) onlyOwner {
        
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        
        employees[employeeId] = Employee(employeeId, salary.mul( 1 ether ), now);
        totalSalary = totalSalary.add( employees[employeeId].salary );
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId){ 
		var employee = employees[employeeId];
		
        _partialPaid(employee);
        totalSalary = totalSalary.sub( employee.salary );
        
        delete employees[employeeId];
    }
    
    function updateEmployeeSalary(address employeeId, uint  salary) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
		
        _partialPaid(employee);
        totalSalary = totalSalary.sub( employee.salary );
        
        employees[employeeId].salary = salary.mul( 1 ether );
        employees[employeeId].lastPayday = now;
        totalSalary += employees[employeeId].salary;
	}
	
	function changePaymentAddress(address employeeIdNew)  employeeExist(msg.sender) employeeNotExist(employeeIdNew) {
		employees[employeeIdNew] = Employee(employees[msg.sender].id, employees[msg.sender].salary, employees[msg.sender].lastPayday);		 
	
		delete employees[msg.sender];
	}	
    
    //1 给合约账户充值 2 查看合约余额
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    //查看账户余额能发几次薪水
    function caculateRunway() returns (uint) {
        assert(totalSalary != 0);
        return this.balance.div( totalSalary );
    }
	
    //是否拥有足够的钱发薪水
    function hasEnoughtFund() returns (bool) {
        return caculateRunway() > 0;
    }
    
    //雇员自己获取薪水
    function getPaid() employeeExist(msg.sender) {
	    var employee = employees[msg.sender];
	
        uint nextPayDay = employee.lastPayday.add( payDuration );
        

        //未到发薪水日期
        if (nextPayDay > now ) {
            revert();
        }
        
        if( 0x0 != employee.id ) {
            employees[msg.sender].lastPayday = nextPayDay;
            employee.id.transfer(employee.salary);
            TransferSalary(employee.salary);
        }
    }
}