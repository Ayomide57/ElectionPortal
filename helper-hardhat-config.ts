import { ethers, BigNumberish, parseEther } from "ethers";


export interface networkConfigItem {
  name?: string;
  vrfCoordinatorV2?: string;
  entranceFee: BigNumberish;
  gasLane?: string;
  subscriptionId?: string;
  callbackGasLimit?: string;
  interval?: string;
  mintFee?: string;
  ethUsdFeedFeed?: string;
}

export interface networkConfigInfo {
  [key: string]: networkConfigItem
}


const networkConfig: networkConfigInfo = {
  5: {
    name: 'goerli',
    entranceFee: parseEther("0.01"),
    interval: "30",
  },
  31337: {
    name: 'hardhat',
    entranceFee: parseEther("0.01"),
    interval: "30",
  }
}

export const developmentChains = ['hardhat', 'localhost'];
export const BASE_FEE = parseEther("0.25"); // 0.25 is for premium which 0.25 per request in chainlink 
export const GAS_PRICE_LINK =  1e9 // 1e9 = 1000000000 // link per gas. Calculated gas price based on the gas price

 

export default networkConfig;