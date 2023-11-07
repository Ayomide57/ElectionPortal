import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import 'dotenv/config';
import 'hardhat-gas-reporter';
import 'solidity-coverage';
import "@nomiclabs/hardhat-ethers";
import "@typechain/hardhat"; 
import "hardhat-deploy";

const GOERLI_RPC_URL = "https://eth-goerli.g.alchemy.com/v2/S63AjmBAqcRvUiUQgIqBEBAHYg-8dKJM"
const PRIVATE_KEY = process.env.PRIVATE_KEY || '0xkey'
const chainID = 5;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || 'key'; 



const config: HardhatUserConfig = {
  solidity: {
    compilers: [
        { version: '0.8.18' },
        { version: '0.6.6' }
      ],
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
    },
    goerli: {
      url: GOERLI_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: chainID
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  gasReporter: {
    enabled: false,
    //outputFile: "gas-report.txt",
    noColors: true,
    currency: "USD",
    //coinmarketcap: COIN_MARKET_CAP, 
  },
  mocha: {
    timeout: 500000, // 500 seconds max for running tests
  },
};

export default config;

