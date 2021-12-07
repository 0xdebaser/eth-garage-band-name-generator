require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: "0.8.0",
  networks: {
    rinkeby: {
      url: process.env.NETWORK_URL,
      accounts: [process.env.NETWORK_ACCOUNT],
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  }

};
