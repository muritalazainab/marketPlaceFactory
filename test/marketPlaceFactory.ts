const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MarketPlace and MarketPlaceFactory", function () {
  let MarketPlace;
  let MarketPlaceFactory;
  let factory;
  let owner, addr1, addr2;

  before(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    /
    MarketPlace = await ethers.getContractFactory("MarketPlace");
    MarketPlaceFactory = await ethers.getContractFactory("MarketPlaceFactory");

    factory = await MarketPlaceFactory.deploy();
    await factory.deployed();
  });

  it("Should deploy the MarketPlaceFactory contract", async function () {
    expect(factory.address).to.properAddress;
    expect(await factory.owner()).to.equal(owner.address);
  });

  it("Should create a new MarketPlace contract", async function () {
    const tx = await factory.createMarketPlace();
    const receipt = await tx.wait();

    const event = receipt.events.find(e => e.event === "MarketPlaceCreated");
    expect(event.args.marketplaceAddress).to.properAddress;

    const marketPlaceAddress = event.args.marketplaceAddress;
    const marketPlace = await ethers.getContractAt("MarketPlace", marketPlaceAddress);

    // Validate the owner of the new MarketPlace contract
    expect(await marketPlace.owner()).to.equal(owner.address);
  });

  it("Should list an item in a MarketPlace contract", async function () {
    const tx = await factory.createMarketPlace();
    const receipt = await tx.wait();
    const marketPlaceAddress = receipt.events.find(e => e.event === "MarketPlaceCreated").args.marketplaceAddress;

    const marketPlace = await ethers.getContractAt("MarketPlace", marketPlaceAddress);

    const listTx = await marketPlace.listItem("Item 1", 100);
    const listReceipt = await listTx.wait();

    const event = listReceipt.events.find(e => e.event === "ItemListed");
    expect(event.args.name).to.equal("Item 1");
    expect(event.args.price).to.equal(100);

    const item = await marketPlace.assets(0);
    expect(item.name).to.equal("Item 1");
    expect(item.price).to.equal(100);
    expect(item.status).to.equal(1); // Created
  });

  it("Should allow a buyer to purchase an item", async function () {
    const tx = await factory.createMarketPlace();
    const receipt = await tx.wait();
    const marketPlaceAddress = receipt.events.find(e => e.event === "MarketPlaceCreated").args.marketplaceAddress;

    const marketPlace = await ethers.getContractAt("MarketPlace", marketPlaceAddress);

  
    await marketPlace.listItem("Item 2", 200);

   