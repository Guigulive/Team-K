import React, { Component } from 'react'
import { Card, Col, Row, Layout, Alert, message, Button } from 'antd';

import Common from './Common';

class Employer extends Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  componentDidMount() {
    this.checkEmployee();
  }

  checkEmployee(){
    const { account, payroll, web3 } = this.props;

    payroll.employees.call(
      account,
      {from: account, gas: 5000000}
    )
    .then((res)=> {
      this.setState({
        salary:web3.fromWei(res[1].toNumber()),
        lastPayDay:new Date(res[2].toNumber()*1000).toString()
      })
      web3.eth.getBalance(account, (error, result) => {
        if (!error) {
          this.setState({
            balance: web3.fromWei(result.toNumber()),
          })
        } else {
          console.error(error);
        }
      });
      
    });
  }

  getPaid = () => {
    const {payroll, web3,account} =this.props;
        payroll.getPaid({
            from:account,
            gas:1000000
        }).then((result)=>{
            alert("You have been paid.");
        });
  }

  renderContent() {
    const { salary, lastPayDay, balance } = this.state;

    if (!salary || salary === '0') {
      return   <Alert message="你不是员工" type="error" showIcon />;
    }

    return (
      <div>
        <Row gutter={16}>
          <Col span={8}>
            <Card title="薪水">{salary} Ether</Card>
          </Col>
          <Col span={8}>
            <Card title="上次支付">{lastPayDay}</Card>
          </Col>
          <Col span={8}>
            <Card title="帐号金额">{balance} Ether</Card>
          </Col>
        </Row>

        <Button
          type="primary"
          icon="bank"
          onClick={this.getPaid}
        >
          获得酬劳
        </Button>
      </div>
    );
  }

  render() {
    const { account, payroll, web3 } = this.props;

    return (
      <Layout style={{ padding: '0 24px', background: '#fff' }}>
        <Common account={account} payroll={payroll} web3={web3} />
        <h2>个人信息</h2>
        {this.renderContent()}
      </Layout >
    );
  }
}

export default Employer
