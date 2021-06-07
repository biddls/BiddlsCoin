require("@nomiclabs/hardhat-waffle");

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true
    }
  },
  solidity: {
    compilers: [
      {
        version: "0.8.0"
      },
      {
        version: "0.6.12"
      }
    ],
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      },
    }
  },
};