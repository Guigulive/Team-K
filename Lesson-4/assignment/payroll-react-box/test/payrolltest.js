var Payroll = artifacts.require("./Payroll.sol");
var ins;
var accounts = web3.eth.accounts;

contract('Payroll addEmployee', function (accounts) {

  it("should match the input salary when checkEmployee", function () {
    return Payroll.deployed().then(function (instance) {
      ins = instance;
      return ins.addEmployee(accounts[1], 5);
    }).then(function () {
      return ins.checkEmployee.call(accounts[1]);
    }).then(function (ret) {
      assert.equal(web3.fromWei(ret[0], 'ether'), 5, "salary doesn't match");
    });
  });

});

contract('Payroll removeEmployee', function (accounts) {
  it("should throw error when checkEmployee", function () {
    return Payroll.deployed().then(function (instance) {
      ins = instance;
      return ins.addFund({
        from: '0x0d1d4e623D10F9FBA5Db95830F7d3839406C6AF2',
        value: web3.toWei(50, 'ether')
      });
    }).then(() => {
      return ins.addEmployee(accounts[1], 1);
    }).then(function () {
      return ins.removeEmployee(accounts[1]);
    }).then(function (ret) {
      expect(true).to.be.true;
    }).catch(() => {
      expect(false).to.be.true;
    });
  });
});

contract('Payroll getPaid', function (accounts) {
  it("should have more ether than before getPaid", async function (done) {
    const ins = await Payroll.deployed();
    await ins.addFund({
      from: '0x2191eF87E392377ec08E7c08Eb105Ef5448eCED5',
      value: web3.toWei(20, 'ether')
    });
    await ins.addEmployee(accounts[1], 2);
    setTimeout(async function() {
      const beforeAmount = await web3.eth.getBalance(accounts[1]).toNumber();
      await ins.getPaid({from:accounts[1]});
      const afterAmount = await web3.eth.getBalance(accounts[1]).toNumber();
      console.log('after:',afterAmount,';before:',beforeAmount);
      expect(afterAmount-beforeAmount>0).to.be.true;
      done();
    },11000);
  });
});