const RemainToken = artifacts.require("RemainToken");

module.exports = function(deployer) {
  deployer.deploy(RemainToken);
};
