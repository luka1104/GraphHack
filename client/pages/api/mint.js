// import { createAlchemyWeb3 } from '@alch/alchemy-web3';
import Web3 from 'web3'
import { initializeApp } from "firebase/app";
import { getFirestore, collection, doc, getDocs, setDoc } from "firebase/firestore/lite";

const firebaseConfig = {
  apiKey: "AIzaSyDPnRC0VToZsRcoXuDG7xq9alr1fXhi_g8",
  authDomain: "meetn-9cc66.firebaseapp.com",
  projectId: "meetn-9cc66",
  storageBucket: "meetn-9cc66.appspot.com",
  messagingSenderId: "774863347933",
  appId: "1:774863347933:web:3808cdbcf47ab0a785bb34"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// const connections = {"0x50B80aa3877fC852f3194a0331177FDDcF0891bf": Date.now()};

// const API_KEY = process.env.API_KEY;
const API_URL = process.env.API_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const PUBLIC_KEY = process.env.PUBLIC_KEY;
// const web3 = createAlchemyWeb3(
//   `https://polygon-mumbai.g.alchemy.com/v2/${API_KEY}`
// );
const provider = new Web3(new Web3.providers.HttpProvider(API_URL));
const contract = require('../../src/contracts/NNCard.json');
const contractAddress = process.env.CONTRACT_ADDRESS;
const Contract = new provider.eth.Contract(contract.abi, contractAddress, { from: PUBLIC_KEY });
const interactAddress = "0x3f7E10eD4eac8c4a9c54ffbcD632215Aa78D598E"

const getMetadata = async (db) => {
  const conCol = collection(db, 'users');
  const conSnap = await getDocs(conCol);
  const conList = conSnap.docs.map(doc => doc.data());
  const metadata = {};
  conList.forEach(con => metadata[con.address] = [con.name, con.email]);
  return metadata;
};

const addMetadata = async (address, timestamp) => {
  await setDoc(doc(db, 'users', address), {
    address: address,
    name: "luka",
    email: "test@test.com",
    timestamp: timestamp
  });
};

const MintCard = async (address, tokenURI, res) => {
  console.log("minting");
  const nonce = await provider.eth.getTransactionCount(PUBLIC_KEY, 'latest');
  const data = await Contract.methods
    .mintNFT(address, tokenURI)
    .encodeABI();
  const tx = {
    "gas": 500000,
    "to": contractAddress,
    "nonce": nonce,
    "data": data,
    "from": address
  };
  await provider.eth.accounts.signTransaction(tx, PRIVATE_KEY, async (err, signedTx) => {
    if (err) return console.log('SIGN ERROR', err);
    console.log('SIGNING', signedTx)
    await provider.eth.sendSignedTransaction(signedTx.rawTransaction, (err, resp) => {
      if (err) return console.log('MINT ERROR', err)
      console.log('MINTING', resp)
      res.status(200).send("success minting");
    });
  });
};

const getAddressLists = async (address) => {
  const addresses = [];
  await Contract.methods.getTokenUriFromAddress(address).call((err, tokenUris) => {
    if (err) {
      console.log("An error occured", err)
      return
    }
    console.log(tokenUris);
    for(let i = 0; i < tokenUris.length; i++) {
      const data = JSON.parse(tokenUris[i]);
      addresses.push(data.pocWith);
    }
  })
  console.log(addresses);
  return addresses
}

const checkConnection = async (address, res) => {
  const addresses = await getAddressLists(address);
  if (!addresses.includes(interactAddress)) {
    const poc_metadata = {
      "name": `POC of ${address}`,
      "holder": address,
      "pocWith": interactAddress,
      "timestamp": Date.now()
    }
    MintCard(address, JSON.stringify(poc_metadata), res);
  } else {
    console.log("already connected!");
  }
}

const handler = async (req, res) => {
  // await addMetadata(req.body, Date.now());
  // const metadata = await getMetadata(db);
  // console.log(metadata);
  // const now = Date.now();
  // console.log('CONNECTIONS', connections);
  console.log('REQ.BODY', req.body);
  checkConnection(req.body, res);
};
export default handler;
