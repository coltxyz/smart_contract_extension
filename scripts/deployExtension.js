async function main() {
  const contractFactory = await hre.ethers.getContractFactory('ExtensionMint1155');
  const mainContract = "0xb599FbB8a929B21714Af226a43eA91E5c6C5d636";
  const contract = await contractFactory.deploy(mainContract);
  await contract.deployed();
  console.log("Yout need this address for minting!");
  console.log("Contract deployed to:", contract.address);
  
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });