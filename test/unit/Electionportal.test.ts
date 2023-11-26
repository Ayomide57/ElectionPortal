import { assert, expect } from "chai";
import { network, deployments, getNamedAccounts, ethers } from "hardhat";
import { developmentChains } from "../../helper-hardhat-config";
import hre from "hardhat";
import { time } from "@nomicfoundation/hardhat-network-helpers";


!developmentChains.includes(network.name) ? describe.skip :
    describe("Election Portal Test", () => { 
        let electionPortal: any, deployer: any, account1: any, account2: any, unlockTime: any

        beforeEach(async () => {
            const ONE_YEAR_IN_SECS = 2 * 24 * 60 * 60;
            unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;
            electionPortal = await ethers.deployContract("ElectionPortal", [unlockTime]);
            [deployer, account1, account2] = await ethers.getSigners();
        })

        it("Should set the right unlockTime", async function () {
            expect(await electionPortal.lock_time()).to.equal(unlockTime);
        });

        it("Should add position list", async () => {
            await electionPortal.addPosition("President");
            await electionPortal.addPosition("Governor");
            const response = await electionPortal.getPostion(1)
            expect("Governor").to.equal(response[1])
        });


        it("Should register a candidate", async () => {
            const name = "Ayomide";
            const position = 2;
            const party = "PDP";
            await electionPortal.connect(account1).registerCandidate(name, position, party);
            const response = await electionPortal.getCandidateInformation(account1);
            expect(name).to.equal(response[2])
        });

        it("Should be able to vote for a candidate", async() => {
            const name = "Olatunji";
            const position = 2;
            const year = "2023";
            await electionPortal.connect(account2).registerVote(name, account1, year, position);
            const response = await electionPortal.connect(account2).getVotingRecord(year, position)
            expect(true).to.equal(response[4])
        });


    })

