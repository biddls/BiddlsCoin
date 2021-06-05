const { expect } = require("chai");
const { testingGeneral } = require("../scripts/testing.js");


describe("Base External minter", function () {

    let vars;

    beforeEach(async function () {
        vars = await testingGeneral(0);
    });

    describe("Token contract setup", async function () {
        it("Deployment checks", async function () {
            const ownerBalance = await vars.TEST.balanceOf(vars.owner.address);

            expect(await vars.TEST.totalSupply()).to.equal(ownerBalance);
            expect(await vars.TEST.name()).to.equal("test");
            expect(await vars.TEST.symbol()).to.equal("TST");

            for (let decimal = 0; decimal <= 18; decimal+= 18) {
                let temp = await testingGeneral(decimal);
                expect(await temp.TEST.decimals()).to.equal(decimal);
            }
        });
        it("Burn checks", async function () {

        })
    });
    describe("Minter tests", async function () {
        it("Update minter", async function () {
            // set minter role
            expect(await vars.TEST.EXTERNAL_MINTER_ADDRESS()).to.equal(vars.owner.address);
            await vars.TEST.updateMinter(vars.addr1.address);
            expect(await vars.TEST.EXTERNAL_MINTER_ADDRESS()).to.equal(vars.addr1.address);

            // allowed to mint
            expect(await vars.TEST.balanceOf(vars.addr1.address)).to.equal(0);
            await vars.TEST.connect(vars.addr1).externalMint(100, vars.addr1.address);
            expect(await vars.TEST.balanceOf(vars.addr1.address)).to.equal(100);

            // not allowed to mint
            await vars.TEST.updateMinter(vars.addr2.address);
            expect(await vars.TEST.balanceOf(vars.addr2.address)).to.equal(0);
            expect(vars.TEST.connect(vars.addr1).externalMint(100, vars.addr1.address))
                .to.be.revertedWith("Minter Address only");
            expect(await vars.TEST.balanceOf(vars.addr2.address)).to.equal(0);
        });
    });
});