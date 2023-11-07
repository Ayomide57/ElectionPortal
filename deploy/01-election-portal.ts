import {HardhatRuntimeEnvironment} from 'hardhat/types';
import { DeployFunction } from 'hardhat-deploy/types';
import { ethers, network } from "hardhat";
import 'dotenv/config';
import networkConfig, { developmentChains } from '../helper-hardhat-config';
import verify from '../utils/verify';
import { deployContract } from '@nomicfoundation/hardhat-ethers/types';
import hre from "hardhat";
import { time } from '@nomicfoundation/hardhat-network-helpers';


const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY; 


const deployElectionPortal: DeployFunction = async () => {
    const ONE_YEAR_IN_SECS = 2 * 24 * 60 * 60;
    //const unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;
    const unlockTime = 1698164253

    const args: any = ["1698164253"];

    console.log('-------------------------------------------------------------------------------------');

    const ElectionPortal = await ethers.deployContract("ElectionPortal", [unlockTime]);

    await ElectionPortal.waitForDeployment();
        console.log('----------------------------------done---------------------------------------------------');


    if (!developmentChains.includes(network.name) && ETHERSCAN_API_KEY) {
        console.log('------------------------ Verifying ---------------------------------------------');
        await verify(ElectionPortal.getAddress(), args)
    }

        console.log('-------------------------------------------------------------------------------------');


}

export default deployElectionPortal;
deployElectionPortal.tags = ["all", "ElectionPortal"];

