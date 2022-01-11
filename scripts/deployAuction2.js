// scripts/deploy.js
async function main() {
    // We get the contract to deploy
    const HorseToken = await ethers.getContractFactory('HorseAuction2');
    console.log('Deploying HorseAuction2...');
    const horseToken = await HorseToken.deploy();
    await horseToken.deployed();
    console.log('HorseAuction2 deployed to:', horseToken.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });