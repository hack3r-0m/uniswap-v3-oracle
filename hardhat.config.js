/* Hardhat and module imports */

require('@nomiclabs/hardhat-ethers');
require('hardhat-deploy');
require('@nomiclabs/hardhat-etherscan');
require('dotenv').config();

/* Configurations */

module.exports = {
  defaultNetwork: 'rinkeby',
  networks: {
    rinkeby: {
      url: process.env.RPC,
      chainId: 4,
      accounts: [process.env.PRIVATE_KEY],
      saveDeployments: true,
    }
  },
  solidity: "0.7.6",
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts',
  },
  namedAccounts: {
    deployer: {
      default: process.env.ADDRESS,
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API,
  },
};
