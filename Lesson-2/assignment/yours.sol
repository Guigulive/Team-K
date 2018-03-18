/*作业请提交在这个目录下*/
/* 用原来的calculateRunway消耗会逐渐增多，s调用记录：新增第一个人时,ec消耗1694,tc消耗22966;新增第一个人时,ec消耗2475,tc消耗23747;新增第一个人时,ec消耗3256,tc消耗24528。ec消耗是因为数组扩大，需要遍历的次数增多，语句执行就变多了;但tc为什么会消耗增多我没明白？ */
/*  用优化后的，每次调用ec消耗852,tc消耗22124。不过在update\add\remove操作时消耗会增多，不过鉴于calculate是比较高频的操作，优化还是值得的 */
pragma solidity ^0.4.14;

contract Payroll {
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    uint constant payDuration = 10 seconds;
    uint totalSalary = 0;

    address owner;
    Employee[] employees;

    function Payroll() {
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function _findEmployee(address employeeId) private returns (Employee storage, uint) {
        for(uint i = 0;i<employees.length;i++){
            if(employees[i].id == employeeId){
                return (employees[i],i);
            }
        }
    }

    function addEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        require(employeeId != 0x0);
        require(salary > 0);

        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id == 0x0);

        // 往数组里添加员工
        employees.push(Employee(employeeId,salary * 1 ether,now));

        // 计算totalSalary
        totalSalary += salary * 1 ether;
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == owner);
        require(employeeId != 0x0);
        
        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);

        _partialPaid(employee);

        // 删除该员工
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -= 1;

        // 计算totalSalary
        totalSalary -= employee.salary;
    }
    
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == owner);
        require(employeeId != 0x0);
        require(salary > 0);

        var (employee,index) = _findEmployee(employeeId);
        assert(employee.id != 0x0);

        // 先进行结算
        _partialPaid(employee);
        
        // 计算totalSalary
        totalSalary = totalSalary - employee.salary + salary * 1 ether;

        // 调薪
        employee.salary = salary * 1 ether;
        employee.lastPayday = now;
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() >= 1;
    }
    
    function getPaid() {
        var (employee,index) = _findEmployee(msg.sender);
        assert(employee.id != 0x0);

        uint nextPayday = employee.lastPayday + payDuration;

        assert(nextPayday < now);

        employee.lastPayday = nextPayday;
        employee.id.transfer(employee.salary);
    }
}
