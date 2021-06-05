const { expect } = require("chai");
const { testing } = require("../scripts/testing.js");

describe("CS Skin", function () {

    let vars;

    beforeEach(async function () {
        vars = await testing();
    });

    describe("CSCase setup", async function () {
        it("Deployment checks", async function () {
            const ownerBalance = await vars.CS_Case.balanceOf(vars.owner.address);

            expect(await vars.CS_Case.totalSupply()).to.equal(ownerBalance);
            expect(await vars.CS_Case.name()).to.equal("CS:GO Case");
            expect(await vars.CS_Case.symbol()).to.equal("CSC");
            expect(await vars.CS_Case.decimals()).to.equal(18);
        });
    });
    describe("CS Skin setup", async function () {
        /*
        link to AMM
        link to test minter thingy
        */
    });
    describe("User management", async function () {
        it("Signup checks", async function () {
            expect(await vars.CS_Skin.userExists("test")).to.equal(false);

            await vars.CS_Skin.connect(vars.addr1).signUp(10, "test");

            expect(await vars.CS_Skin.userExists("test")).to.equal(true);
            expect(await vars.CS_Skin.getScore("test")).to.equal(10);
            expect(await vars.CS_Skin.getAddress("test")).to.equal(vars.addr1.address);
            await expect(
                vars.CS_Skin.connect(vars.addr1).signUp(10, "test")
            ).to.be.revertedWith("User exists");
        });
        it("Update Score checks", async function () {
            await vars.CS_Skin.connect(vars.addr1).signUp(10, "test");
            await vars.CS_Skin.connect(vars.addr2).signUp(0, "test2");

            expect(await vars.CS_Skin.userExists("test2")).to.equal(true);

            await vars.CS_Skin.connect(vars.addr1).updateScore(11, "test");

            expect(await vars.CS_Skin.getScore("test")).to.equal(11);
            await expect(vars.CS_Skin.connect(vars.addr1).updateScore(10, "test"))
                .to.be.revertedWith("Score too Low/ no change");
            await expect(vars.CS_Skin.connect(vars.addrs[0]).updateScore(10, "test3"))
                .to.be.revertedWith("User doesn't exist");
        });
    });
    describe("Minting", async function () {
        it("FAH coin minting", async function () {
            await vars.CS_Skin.connect(vars.addr1).signUp(0, "test");

            expect(await vars.CS_Skin.getScore("test")).to.equal(0);
            expect(await vars.CS_Skin.connect(vars.addr1).userExists("test"))
                .to.equal(true);

            await vars.CS_Skin.updateScore(10, "test");

            expect(await vars.CS_Skin.getScore("test")).to.equal(10);

            expect(await vars.FAH.balanceOf(vars.addr1.address)).to.equal(10);
        });
    });
});