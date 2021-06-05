const { testing } = require("../scripts/testing.js");

async function main() {
    let vars = await testing();
    console.log(`Deploying contracts with the account: ${vars.deployer.address}`);
    console.log(`Account balance: ${vars.balance.toString()}`);
    console.log(`Token Address for F@H: ${vars.FAH.address}`);
    console.log(`Token Address for CS_Case: ${vars.CS_Case.address}`);
    console.log(`Token Address for CS_Skin: ${vars.CS_Skin.address}`);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.log(error);
        process.exit(1);
    })