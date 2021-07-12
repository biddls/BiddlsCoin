require("@nomiclabs/hardhat-waffle");

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
      forking: {
        url: "https://eth-mainnet.alchemyapi.io/v2/3VNBx5EqWpYkNwy_egU0BxpH96kFYBJp",
        blockNumber: 12773771
      }
    }
  },
  solidity: {
    compilers: [
      {
        version: "0.8.0"
      },
      {
        version: "0.6.12"
      },
      {
        version: "0.5.0"
      }
    ],
    settings: {
      optimizer: {
        enabled: false,
        runs: 200
      },
    }
  },
};