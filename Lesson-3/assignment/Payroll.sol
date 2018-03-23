pragma solidity ^0.4.14;

import './SafeMath.sol';
import './Ownable.sol';

/*
 * Payroll
 * 
 * @author 丰寅峰-102-PeerlessFYF Date 2018-03-20
 */
contract Payroll is Ownable {
    
    using SafeMath for uint;
    
    address owner;
    
    // 定义结构对象
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    mapping(address => Employee) public employees;
    
    uint constant payDuration = 10 seconds; // 30 days;
    
    uint totalSalary;
    
    // function Payroll() {
    //     owner = msg.sender;
    // }
    
    // modifier onlyOwner {
    //     require(msg.sender == owner);
    //     _;
    // }
    
    modifier employeeExist(address employeeId) {
        var employee = employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier deleteEmployee(address employeeId) {
        var employee =  employees[employeeId];
        
        _partialPaid(employee);
        
        _;
        
        // 用deleta删除数组对象，最后一个元素补齐，数组长度-1
        delete employees[employeeId];
    }
    
    // 内部私有方法
    function _partialPaid(Employee employee) private {
        // 先乘后除，因为solidity里除是取整的
        // uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        uint payment = employee.salary
            .mul(now.sub(employee.lastPayday))
            .div(payDuration);
        employee.id.transfer(payment);
    }
    
    // 更改员工的薪水支付地址
    function changePaymentAddress(address oldEmployeeId, address newEmployeeId) onlyOwner employeeExist(oldEmployeeId) deleteEmployee(oldEmployeeId) {
        employees[newEmployeeId] = Employee(newEmployeeId, employees[oldEmployeeId].salary, now);
    }
    
    function addEmployee(address employeeId, uint salary) onlyOwner {
        var employee =  employees[employeeId];
        assert(employee.id == 0x0);
        
        employees[employeeId] = Employee(employeeId, salary.mul(1 ether), now);
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) deleteEmployee(employeeId) {
        totalSalary = totalSalary.sub(employees[employeeId].salary);
    }
    
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId) {
        var employee =  employees[employeeId];
        
        _partialPaid(employee);
        
        totalSalary = totalSalary.sub(employees[employeeId].salary);
        // 直接更新storage存储上的值
        employees[employeeId].salary = salary.mul(1 ether);
        employees[employeeId].lastPayday = now;
        totalSalary = totalSalary.add(employees[employeeId].salary);
    }
    
    // 函数具有钱的功能用payable关键字
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance.div(totalSalary);
    }   
    
    function hasEnoughFund() returns (bool) {
        // 不加this，节约gas
        return calculateRunway() > 0;
    }
    
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday) { // 命名参数返回
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
        // 命名返回参数直接赋值，不用return
    }
    
    // 切换员工账号操作
    function getPaid() employeeExist(msg.sender) {
        var employee =  employees[msg.sender];
        
        uint nextPayDay = employee.lastPayday.add(payDuration);
        assert(nextPayDay < now);
        
        // 直接更新storage存储上的值
        employees[msg.sender].lastPayday = nextPayDay;
        employee.id.transfer(employee.salary);
    }
    
}
