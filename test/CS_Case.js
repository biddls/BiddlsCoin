const { expect } = require("chai");
const { testing } = require("../scripts/testing.js");

describe("CS_Case token", function () {

    let vars;

    beforeEach(async function () {
        vars = await testing();
    });

    describe("Token contract setup", async function () {
        it("Deployment checks", async function () {
            const ownerBalance = await vars.CS_Case.balanceOf(vars.owner.address);

            expect(await vars.CS_Case.totalSupply()).to.equal(ownerBalance + vars.amount);
            expect(await vars.CS_Case.name()).to.equal("CS:GO Case");
            expect(await vars.CS_Case.symbol()).to.equal("CSC");
            expect(await vars.CS_Case.decimals()).to.equal(18);
        });
    });
});