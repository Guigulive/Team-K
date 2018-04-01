## payroll
A payroll system developed with React and Solidty for Ethereum Blockchain platform.

### Start step
1. Install dependencies `npm install -g truffle ethereumjs-testrpc`

1. Install [Metamask](https://metamask.io/)

1. Run `testrpc`  in the payroll project directory

1. Add first account in testrpc to Metamask by importing private key

1. Run `truffle compile` in the payroll project directory

1. `truffle migrate` ditto

1. `npm run start` ditto

## FAQ
###1. Failed to compile. Error in ./src/App.js Module not found: 'antd' 

* 需要安装antd库 `npm install antd --save`

###2. 为什么我addFund不用metamask能fire event，用了metamask就不行了，但fund都加成功了？  
* 这儿有个BUG，启动网页之后不要在metamask里切换网络，要先把metatask切到测试网络后，重启浏览器。 
> Finally, Metamask seems to have problems switching networks cleanly. After switching to the network you want to use, try closing all open Chrome windows (not just the window you're using Metamask in) and then open the browser again from scratch. 

【参考】 https://ethereum.stackexchange.com/questions/28747/cant-retrieve-event-logs-with-metamask-web3 

###3. 浏览器加载了前端页面之后总是显示loading，是啥原因？ 
* 首先打开console看看输出是什么，根据报错信息进行排查。 
* 其次，可能的问题有：
1. testrpc没打开 
2. truffle migrate需要带上--reset参数 
3. metamask有没有切换到private网络 


