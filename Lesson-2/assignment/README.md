## 硅谷live以太坊智能合约 第二课作业
这里是同学提交作业的目录

### 第二课：课后作业
完成今天的智能合约添加100ETH到合约中
- 加入十个员工，每个员工的薪水都是1ETH
每次加入一个员工后调用calculateRunway这个函数，并且记录消耗的gas是多少？Gas变化么？如果有 为什么？
    Gas消耗如下：
    添加1个员工：
    transaction cost   22971 gas 
    execution cost     1699 gas 
     
    添加2个员工：
    transaction cost   23759 gas 
    execution cost     2487 gas 

    添加3个员工：
    transaction cost   24547 gas 
    execution cost     3275 gas 
     
    添加4个员工：
    transaction cost   25335 gas 
    execution cost     4063 gas 

    添加5个员工：
    transaction cost   26123 gas 
    execution cost     4851 gas 

    添加6个员工：
    transaction cost   26911 gas 
    execution cost     5639 gas 

    添加7个员工：
    transaction cost   27699 gas 
    execution cost     6427 gas 

    添加8个员工：
    transaction cost   28487 gas 
    execution cost     7215 gas 

    添加9个员工：
    transaction cost   29275 gas 
    execution cost     8003 gas 

    添加10个员工：
    transaction cost   30063 gas 
    execution cost     8791 gas 
    可以看到，随着员工数量的增加，调用calculateRunway函数消耗的Gas也逐渐增加。
    这是因为增加员工后，employees.length变大，calculateRunway函数中for循环执行次数变多，所做的运算也变多，所以消耗的Gas增加。

- 如何优化calculateRunway这个函数来减少gas的消耗？
    可以使用一个状态变量记录工资总额，在增删员工和更新工资时，修改这个变量。调用calculateRunway时，直接使用变量，减少运算。
    修改后每次调用消耗的Gas相同。
    transaction cost   22122 gas 
     execution cost     850 gas 
     hash   0x60ac96c1e71a0b0f8a351fbee90fb8b3d9129129c2e294c8b61b3a003087b04c
     input  0x4ec19512
     decoded input  {}
     decoded output     {
        "0": "uint256: 100"
    }

    transaction cost    22122 gas 
     execution cost     850 gas 
     hash   0x85cc8c223841b02e17aa42c5d9dfeb2aea4ae3c35b9b53e3d12f776cda541249
     input  0x4ec19512
     decoded input  {}
     decoded output     {
        "0": "uint256: 50"
    }

    transaction cost   22122 gas 
     execution cost     850 gas 
     hash   0xdcb33d7717f0fcee69a0437a0f9ea583a6e841ff75b24507f74272f2a9b11e97
     input  0x4ec19512
     decoded input  {}
     decoded output     {
        "0": "uint256: 33"
    }
提交：智能合约代码，gas变化的记录，calculateRunway函数的优化

