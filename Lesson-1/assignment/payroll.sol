pragma solidity ^0.4.14;

contract payroll {
    uint salary;
    address owner;
    address employee;
    uint constant payDuration = 10 seconds;
    uint lastPayTime;

    function payroll() public {
        owner = msg.sender;
        salary = 1 ether;
    }

    function addFund() public payable returns (uint) {
        return this.balance;
    }
    function calculateRunaway() public view returns (uint) {
        return owner.balance / salary;
    }
    function getMyBalance() public view returns (uint) {
        return msg.sender.balance;
    }
    function getAddress(uint t) public view returns (address) {
        if(t == 1){
            return this;
        }else if(t == 2){
            return owner;
        }else{
            return employee;
        }
    }
    function hasEnoughFund() public view returns (bool) {
        return calculateRunaway() > 0;
    }
    function setEmployee(address newEmployee,uint newSalary) public {
        require(msg.sender == owner);
        if(newEmployee != 0x0){
            uint payment = salary * (now - lastPayTime) / payDuration;
            employee.transfer(payment);
        }
        employee = newEmployee;
        lastPayTime = now;
        salary = newSalary * 1 ether;
    }
    function getPaid() public {
        require(msg.sender == employee);
        uint nextPayTime = lastPayTime + payDuration;
        require(nextPayTime < now);
        uint payment = salary * (now - lastPayTime) / payDuration;
        lastPayTime = now;
        employee.transfer(payment);
    }

}
