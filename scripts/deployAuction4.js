// scripts/deploy.js
async function main() {
    // We get the contract to deploy
    const HorseToken = await ethers.getContractFactory('HorseAuction4');
    console.log('Deploying HorseAuction4...');
    const horseToken = await HorseToken.deploy();
    await horseToken.deployed();
    console.log('HorseAuction4 deployed to:', horseToken.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });