import React, { Component } from 'react'
import { Card, Col, Row } from 'antd';

class Common extends Component {
  constructor(props) {
    super(props);

    this.state = {};
  }


  componentDidMount() {
    const { payroll, web3 } = this.props;
    const updateInfo = (error, result) => {
      if (!error) {
        this.checkInfo();
      }
    }
    //上节课实现实时更新借鉴群里的大神方法：
    // this.timer = setInterval(() =>{
    //     this.checkInfo()
    // }, 1000)

    this.newFund1 = payroll.NewFund(updateInfo);
    this.getPaid1 = payroll.GetPaid(updateInfo);
    this.newEmployee1 = payroll.NewEmployee(updateInfo);
    this.updateEmployee1 = payroll.UpdateEmployee(updateInfo);
    this.removeEmployee1 = payroll.RemoveEmployee(updateInfo);

    this.checkInfo();
  }

   componentWillUnmount() {
     //  clearInterval(this.timer)

    this.newFund1.stopWatching();
    this.getPaid1.stopWatching();
    this.newEmployee1.stopWatching();
    this.updateEmployee1.stopWatching();
    this.removeEmployee1.stopWatching();
   }

  checkInfo = () => {
    const { payroll, account, web3 } = this.props;
    payroll.checkInfo.call({
      from: account,
    }).then((result) => {
      this.setState({
        balance: web3.fromWei(result[0].toNumber()),
        runway: result[1].toNumber(),
        employeeCount: result[2].toNumber()
      })
    });
  }


  render() {
    const { runway, balance, employeeCount } = this.state;
    return (
      <div>
        <h2>通用信息</h2>
        <Row gutter={16}>
          <Col span={8}>
            <Card title="合约金额">{balance} Ether</Card>
          </Col>
          <Col span={8}>
            <Card title="员工人数">{employeeCount}</Card>
          </Col>
          <Col span={8}>
            <Card title="可支付次数">{runway}</Card>
          </Col>
        </Row>
      </div>
    );
  }
}

export default Common