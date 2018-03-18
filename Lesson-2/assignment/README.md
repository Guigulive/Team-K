## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
- 如何优化calculateRunway这个函数来减少gas的消耗？
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化


------------------------------------------------------------------------
分析原因：
在calculateRunway()中，每次都是循环数组获得totalSalary，而随着数组增大，循环执行表达式的次数也增多，导致该方法执行后cost gas一直在递增。

优化思路：
将totalSalary从function抽取为全局变量，在执行add、update、remove用户时，改变totalSalary。使得calculateRunway()执行的是一个固定表达式，而cost gas也是恒定的。

优化前：
addEmployee | transaction cost | execution cost 
1	|	22971 gas	|	1699 gas
2	|	23759 gas	|	2487 gas
3	|	24547 gas	|	3275 gas
4	|	25335 gas	|	4063 gas
5	|	26123 gas	|	4851 gas
6	|	26911 gas	|	5639 gas
7	|	27699 gas	|	6427 gas
8	|	28487 gas	|	7215 gas
9	|	29275 gas	|	8003 gas
10	|	30063 gas	|	8791 gas

优化后：
addEmployee | transaction cost | execution cost 
1	|	22122 gas	|	850 gas
2	|	22122 gas	|	850 gas
3	|	22122 gas	|	850 gas
4	|	22122 gas	|	850 gas
5	|	22122 gas	|	850 gas
6	|	22122 gas	|	850 gas
7	|	22122 gas	|	850 gas
8	|	22122 gas	|	850 gas
9	|	22122 gas	|	850 gas
10	|	22122 gas	|	850 gas
