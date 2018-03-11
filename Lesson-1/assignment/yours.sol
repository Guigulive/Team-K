/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;
contract Payroll {
    uint salary = 1 ether;
    address addr = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address constant FRANK = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function addFund() payable returns (uint){
        return this.balance;
    }
 
    function calculateRunway() returns (uint){
        return this.balance / salary;
    }  
    
    function hasEnoughFund() returns (bool){
        return calculateRunway() >= 1;
    }
    
    function getPaid(){
        if(msg.sender != FRANK){
            revert();
        }
        
        uint nextPayDay = lastPayday + payDuration;
        
        if(nextPayDay > now){
            revert();
        }
        
        lastPayday = nextPayDay;
        addr.transfer(salary);
    }
    
    // 发现在remix里面的input输入5*10^18是会报错的
    function resetSalary(uint sal) returns (uint){
        return salary = sal * 1 ether;
    }
    
    function resetAddress(address newAddr) returns (address){
        return addr = newAddr;
    }
}