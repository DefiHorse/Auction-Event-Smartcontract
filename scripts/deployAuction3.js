// scripts/deploy.js
async function main() {
    // We get the contract to deploy
    const HorseToken = await ethers.getContractFactory('HorseAuction3');
    console.log('Deploying HorseAuction3...');
    const horseToken = await HorseToken.deploy();
    await horseToken.deployed();
    console.log('HorseAuction3 deployed to:', horseToken.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });