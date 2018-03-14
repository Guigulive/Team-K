/*作业请提交在这个目录下*/
pragma solidity ^0.4.14;

contract Payroll {

    //老板frank的地址
    address frank = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    //员工地址
    address employee;

    uint constant payDuration = 10 seconds;
    uint salary = 1 ether;
    uint lastPayday = now;


  function setEmployeeAddress(address newAddress) {
	    //只有老板frank可以修改员工地址
	    if(msg.sender != frank || newAddress == 0x0){
	        revert();
	    }
      //修改地址前应该按旧地址支付一下之前未领薪水
      if (hasEnoughtFund() && employee != 0x0) {
         uint payment = salary * (now - lastPayday) / payDuration;
         lastPayday = now;
         employee.transfer(payment);
      } else {
         revert();
      }
      employee = newAddress;
    }

    function setEmployeeSalary(uint s) {
        //只有老板frank可以修改员工薪水
        if(msg.sender != frank || s == 0){
              revert();
        }
        //修改薪水前应该按旧工资支付一下之前未领薪水
        if (hasEnoughtFund() && employee != 0x0) {
           uint payment = salary * (now - lastPayday) / payDuration;
           lastPayday = now;
           employee.transfer(payment);
        } else {
           revert();
        }
        salary = s * 1 ether;
    }


    //payable: 表明调用函数可以接受以太币
    function addFund() payable returns (uint) {
        return this.balance;
    }

    //查看账户余额能发几次薪水
    function caculateRunway() returns (uint) {
        return this.balance / salary;
    }

    //是否拥有足够的钱发薪水
    function hasEnoughtFund() returns (bool) {
        // 不加this，节约gas
        return caculateRunway() > 0;
    }

    //员工自己获取薪水
    function getPaid() {
        //检查地址是否有效：地址必须是员工
        if(msg.sender != employee){
            revert();
        }

        uint nextPayDay = lastPayday + payDuration;

        //未到发薪水日期
        if (nextPayDay > now ) {
            revert();
        }

        if(hasEnoughtFund() ) {
            //应该将先修改内部变量，再 transfer。
            lastPayday = nextPayDay;
            //给员工地址打钱
            employee.transfer(salary);
        }
    }
}
