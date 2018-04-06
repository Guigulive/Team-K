var Payroll = artifacts.require("./Payroll.sol");
var SafeMath = artifacts.require("./SafeMath.sol");
var Ownable = artifacts.require("./Ownable.sol");

module.exports = function(deployer) {
  deployer.deploy(Payroll);
  deployer.deploy(SafeMath);
  deployer.deploy(Ownable);

  deployer.link(Ownable, Payroll);
  deployer.link(SafeMath, Payroll);
};
