pragma solidity ^0.4.14;

contract Payroll {
    uint constant payDuration = 5 seconds;
    
    address owner;
    uint salary = 1 ether;
    address public employee = 0x0;
    uint public lastPayday = now;
    
    event TransferSalary(uint salary);
    
    function Payroll() {
        owner = msg.sender;
    }
    
    function updateEmployeeSalary(address e, uint  s) {
	    require(msg.sender == owner);
		
		if (0x0  == e ){
            revert();
        }
        
        //清算给上个地址
        if( 0x0 != employee ) {
            uint payment = salary * (now - lastPayday) / payDuration;
            if (payment > 0 && hasEnoughtFund() ) {
                employee.transfer(payment);
                TransferSalary(payment);
            }
        }
        
		employee = e;
        salary = s * 1 ether;
        lastPayday = now;
	
	}
    
    //1 给合约账户充值 2 查看合约余额
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    //查看账户余额能发几次薪水
    function caculateRunway() returns (uint) {
        return this.balance / salary;
    }
    
    //是否拥有足够的钱发薪水
    function hasEnoughtFund() returns (bool) {
        return caculateRunway() > 0;
    }
    
    //雇员自己获取薪水
    function getPaid() {
        require(msg.sender == employee);
        
        uint nextPayDay = lastPayday + payDuration;
        
        if (0x0 == employee ) {
            revert();
        }
        
        //未到发薪水日期
        if (nextPayDay > now ) {
            revert();
        }
        
        if( 0x0 != employee &&  hasEnoughtFund() ) {
            lastPayday = nextPayDay;
            employee.transfer(salary);
            TransferSalary(salary);
        }
    }
}