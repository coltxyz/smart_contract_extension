require('dotenv').config();


const { createAlchemyWeb3 } = require("@alch/alchemy-web3");

async function main() {
  const contractFactory = await hre.ethers.getContractFactory('ExtensionMint1155');
  const mainContract = process.env.MANIFOLD_CONTRACT_ADDRESS;
  const contract = await contractFactory.deploy(mainContract);
  const { address:contractAddress } = await contract.deployed();
  
  console.log("You need this address for minting!");
  console.log("Contract deployed to:", contractAddress);
  
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });