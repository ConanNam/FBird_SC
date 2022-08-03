const hre = require("hardhat");
const fs = require('fs');

async function main() {

  // const FBT = await hre.ethers.getContractFactory("FBT");
  // const fbt = await FBT.deploy();
  // await fbt.deployed();
  // console.log("fbt deployed to:", fbt.address);

  // const NFTMarket = await hre.ethers.getContractFactory("NFTMarket");
  // const nftMarket = await NFTMarket.deploy(fbt.address);
  // await nftMarket.deployed();
  // console.log("nftMarket deployed to:", nftMarket.address);

  // const NFT = await hre.ethers.getContractFactory("NFT");
  // const nft = await NFT.deploy(fbt.address);
  // await nft.deployed();
  // console.log("nft deployed to:", nft.address);

  const FBB = await hre.ethers.getContractFactory("FBB");
  const fbb = await FBB.deploy("0xe31886503E732241A5465B5D5DE916651AFA5395");
  await fbb.deployed();
  console.log("fbb deployed to:", fbb.address);

  // const GameContract = await hre.ethers.getContractFactory("Game");
  // const gameContract = await GameContract.deploy(fbt.address);
  // await gameContract.deployed();
  // console.log("gameContract deployed to:", gameContract.address);

  let config = `export const fbbaddress = "${fbb.address}"`

  let data = JSON.stringify(config)
  fs.writeFileSync('config.js', JSON.parse(data))

}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
