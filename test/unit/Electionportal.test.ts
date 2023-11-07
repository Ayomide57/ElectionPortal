import { assert, expect } from "chai";
import { network, deployments, getNamedAccounts, ethers } from "hardhat";
import { developmentChains } from "../../helper-hardhat-config";
import hre from "hardhat";
import { time } from "@nomicfoundation/hardhat-network-helpers";


!developmentChains.includes(network.name) ? describe.skip :
    describe("Election Portal Test", () => { 
        let electionPortal: any, ElectionPortal: any, deployer: any, player: any

        it("List and can be bought", async () => {
            //await nftMarketplace.listItem(basicNFT.address, TOKEN_ID, PRICE);
                        const ONE_YEAR_IN_SECS = 2 * 24 * 60 * 60;
            const unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;

            // deploy a lock contract where funds can be withdrawn
            // one year in the future
            const electionPortal = await ethers.deployContract("ElectionPortal", [unlockTime]);

        });
    })