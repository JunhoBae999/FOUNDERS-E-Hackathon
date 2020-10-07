const RemainToken = artifacts.require("RemainToken");
const Funding = artifacts.require("Funding")

module.exports = function(_deployer) {
  _deployer.deploy(RemainToken);
  _deployer.deploy(Funding);
  // Use deployer to state migration tasks.
};
