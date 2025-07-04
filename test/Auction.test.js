const { ethers } = require("hardhat");

describe("Auction", function () {
  it("should start a mock auction", async function () {
    const [owner] = await ethers.getSigners();

    const Auction = await ethers.getContractFactory("Auction");
    const auction = await Auction.deploy();
    await auction.deployed();

    const tokenId = 1;
    const minPrice = ethers.utils.parseEther("0.1");
    const duration = 86400; // 1 day
    const tokenURI = "ipfs://mockURI";

    // call startAuction
    await auction.startAuction(tokenId, minPrice, duration, tokenURI);

    // verify stored data
    const item = await auction.auctions(tokenId);

    console.log("mocked auction data:", item);
    expect(item.minPrice).to.equal(minPrice);
    expect(item.endTime).to.be.gt(0);
    expect(item.ended).to.equal(false);
  });
});
