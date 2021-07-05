const { expect } = require("chai");
const { testing } = require("../scripts/testing.js");

describe("FAH token", function () {

    let vars;

    beforeEach(async function () {
        vars = await testing();
    });

    describe("Token contract setup", async function () {
        it("Deployment checks", async function () {
            const balance = parseInt(await vars.FAH.balanceOf(vars.owner.address)) + parseInt(vars.amount);

            expect(await vars.FAH.totalSupply()).to.equal(balance);
            expect(await vars.FAH.name()).to.equal("Folding@Home");
            expect(await vars.FAH.symbol()).to.equal("F@H");
            expect(await vars.FAH.decimals()).to.equal(0);
        });
    });
});