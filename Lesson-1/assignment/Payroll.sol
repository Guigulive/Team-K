pragma solidity ^0.4.14;

/*
 * Payroll
 * 
 * @author 丰寅峰-102-PeerlessFYF Date 2018-03-11
 */
contract Payroll {
    address owner;
    
    address employee;
    uint salary;
    uint lastPayday = now;
    
    uint constant payDuration = 10 seconds; // 30 days;
    
    function Payroll() {
        owner = msg.sender;
    }
    
    // 函数具有钱的功能用payable关键字
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        if (salary == 0) {
            revert();
        }
        return this.balance / salary;
    }   
    
    function hasEnoughFund() returns (bool) {
        // 不加this，节约gas
        return calculateRunway() > 0;
    }
    
    // 切换员工账号操作
    function getPaid() {
        if (msg.sender != employee) {
            revert();
        }
        
        // 运算结果赋给新变量，避免重复计算
        uint nextPayDay = lastPayday + payDuration;
        if (nextPayDay > now) {
            revert();
        }
        
        // 下面2句顺序很重要，不能互换。
        // 智能合约所有函数当中，如果你对智能合约内部变量进行修改，以及你要对外部给钱，
        // 一定要把内部变量修改完之后，再给外部钱。
        lastPayday = nextPayDay;
        employee.transfer(salary);
    }
    
    // 切换雇主账号操作 "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c",2 （注意在Remix中输入地址务必加双引号）
    // 更改员工地址和薪水（2个入参一起，可以表达调薪是针对哪位员工）
    function changeEmployee(address newAddress, uint newSalary) {
        if (msg.sender != owner) {
            revert();
        }
        
        // 对象不为空
        if (employee != 0x0) {
            // 如果是调薪，那需要先结算之前薪水，之后按新的工资报酬支付。（这里假定调薪即可生效，不考虑每月固定每月低发工资的场景）
            if (salary != newSalary) {
                uint payment = salary * (now - lastPayday) / payDuration;
                employee.transfer(payment);
    
                // 更改最后更新时间，以防getPaid重复领工资
                lastPayday = now;
            }
        }
        
        employee = newAddress;
        salary = newSalary * 1 ether;
    }
    
}
