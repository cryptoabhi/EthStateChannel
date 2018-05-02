const StateChannel = artifacts.require('./StateChannel.sol')

module.exports = async deployer => {
  deployer.deploy(StateChannel, { value: 1337 })
}
