const testing = async function() {
    // setup for the
    let [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    const balance = await owner.getBalance();

    let factory = "0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac";
    let router = "0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F";

    // my stuff
    Token = await ethers.getContractFactory('FAH');
    const FAH = await Token.deploy(10000, 0, "Folding@Home", "F@H");

    Token = await ethers.getContractFactory('CS_Case');
    // You cant open 0.5 of a case so there will need to be checks to ensure that is handled appropriately
    const CS_Case = await Token.deploy(0, 18, "CS:GO Case", "CSC");

    Token = await ethers.getContractFactory('CS_Skin');
    const CS_Skin = await Token.deploy(FAH.address,
        CS_Case.address,
        factory,
        router);

    // Contract interactions for everything to run nicely
    await CS_Case.updateMinter(CS_Skin.address); // sets the external minter
    await FAH.updateMinter(CS_Skin.address); // sets the external minter
    let Amount = 2000;
    await CS_Skin.poolSetup(Amount); // sets up the sushi pool and sends the LP tokens to the 0 address


    return {balance: balance,
        FAH: FAH,
        CS_Case: CS_Case,
        CS_Skin: CS_Skin,
        owner: owner,
        addr1: addr1,
        addr2: addr2,
        addrs: addrs,
        amount: Amount};
}

const testingGeneral = async function(decimals) {
    let [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    const balance = await owner.getBalance();

    // my stuff
    let Token = await ethers.getContractFactory('ERC_20_EXTERNAL_MINTER');
    const TEST = await Token.deploy(10000, decimals, "test", "TST");

    await TEST.updateMinter(owner.address); // sets the external minter

    return {balance: balance,
        TEST: TEST,
        owner: owner,
        addr1: addr1,
        addr2: addr2,
        addrs: addrs};
}

module.exports = {
    testing,
    testingGeneral
}