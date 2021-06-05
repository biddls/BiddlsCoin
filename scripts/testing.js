const testing = async function() {
    // setup for the
    let [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    const balance = await owner.getBalance();

    // deploys everything
    let Token = await ethers.getContractFactory('FAH');
    // todo: change that amount that is being minted here as it will need to be managed
    // Decimals are set to 0 as its not supposed to be divisible
    const FAH = await Token.deploy(10000, 0, "Folding@Home", "F@H");
    Token = await ethers.getContractFactory('CS_Case');
    // You cant open 0.5 of a case so there will need to be checks to ensure that is handled appropriately
    const CS_Case = await Token.deploy(0, 18, "CS:GO Case", "CSC");
    Token = await ethers.getContractFactory('CS_Skin');
    const CS_Skin = await Token.deploy();

    // Contract interactions for everything to run nicely
    await CS_Case.updateMinter(CS_Skin.address); // sets the external minter
    await FAH.updateMinter(CS_Skin.address); // sets the external minter
    await CS_Skin.setContracts( FAH.address, CS_Case.address);

    return {balance: balance,
        FAH: FAH,
        CS_Case: CS_Case,
        CS_Skin: CS_Skin,
        owner: owner,
        addr1: addr1,
        addr2: addr2,
        addrs: addrs};
}

const testingGeneral = async function(decimals) {
    let [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    const balance = await owner.getBalance();

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