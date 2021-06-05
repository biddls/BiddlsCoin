const { expect } = require("chai");

describe("Token contract", function () {

    let Token;
    let hardhatToken;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    beforeEach(async function () {
        [owner] = await ethers.getSigners();
        Token = await ethers.getContractFactory("CSCoin");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        hardhatToken = await Token.deploy(100);
    });

    describe("Token contract setup", async function () {
        it("temp1", async function () {
            //IDFK dude
        });
        it("temp2", async function () {
            //IDFK dude
        })
    });
});