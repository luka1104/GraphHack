const { ethers } = require("hardhat")

async function main() {
  const NNCard = await ethers.getContractFactory("NNCard")

  const nNCard = await NNCard.deploy()
  await nNCard.deployed()
  console.log("Contract deployed to address:", nNCard.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
