var SimpleStorage = artifacts.require("./SimpleStorage.sol");

contract('SimpleStorage', function(accounts) {

  it("...should value 10.", function() {
    return SimpleStorage.deployed().then(function(instance) {
      simpleStorageInstance = instance;

      return simpleStorageInstance.set(89, {from: accounts[0]});
    }).then(function() {
      return simpleStorageInstance.get.call();
    }).then(function(storedData) {
      assert.equal(storedData, 10, "failed value 10.");
    });
  });

});
