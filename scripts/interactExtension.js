require('dotenv').config();

// Settings please adjust
const PUBLIC_KEY = "0x47Bc6404C6AeA11A9b8FC45A9DDd1d6907fFEd88";  // Wallet Address sender
const PRIVATE_KEY = process.env.PRIVATE_KEY; //Private Walled Key
const extensionContractAddress = "0x224684D97FA576a1636b41C132B21b922055fD6f"; // Contract Address
const API_URL = process.env.STAGING_ALCHEMY_KEY; // Alchemy API Url


const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(API_URL);

const contract = require("../artifacts/contracts/ExtensionMint1155.sol/ExtensionMint1155.json");

const nftContract = new web3.eth.Contract(contract.abi, extensionContractAddress);


async function mintNFT() {
  const nonce = await web3.eth.getTransactionCount(PUBLIC_KEY, 'latest'); //get latest nonce
  console.log("initialize");


  // HTMLFormControlsCollection.log(test)
  console.log("Minting");


  gasPrice = web3.eth.getGasPrice(function (error, gasPrice) {
    web3.eth.estimateGas({
      to: PUBLIC_KEY,
      nonce: nonce,

    }).then((estimatedGas) => {
      console.log("---------------------------------------------------------------------");
      console.log("Minting");
      console.log("Calculated GasPrice", gasPrice);
      console.log("Calculated estimatedGas", estimatedGas);

      const tx = {
        'from': PUBLIC_KEY,
        'to': extensionContractAddress,
        'nonce': nonce,
        'gasPrice': gasPrice * 2,
        'gas': estimatedGas * 20,
        'data': nftContract.methods.mint().encodeABI()
      };
      web3.eth.accounts.signTransaction(tx, PRIVATE_KEY)
        .then((signedTx) => {
          web3.eth.sendSignedTransaction(
            signedTx.rawTransaction,
            function (err, hash) {
              if (!err) {
                console.log(
                  "The hash of your transaction is: ",
                  hash,
                  "\nCheck Alchemy's Mempool to view the status of your transaction!"
                )
                console.log("Minted....");
              } else {
                console.log(
                  "Something went wrong when submitting your transaction:",
                  err.message
                )
              }
            }
          )
        })
        .catch((err) => {
          console.log(" Promise failed:", err)
        })
    })
    .catch((err) => {
      console.log('estimateGas Failed:', err)
    });
  });
}
mintNFT().then(data => {
  console.log(data)
});


