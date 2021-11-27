const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SampleNFT", function () {
  it("Should mint, wrap and unwrap a nft", async function () {
    const tokenId = 1;
    const user = "0xA188442993652bba655483219317E1201FAC5FC5";
    const [cyan] = await ethers.getSigners();

    // Minting a nft
    const SampleNFT = await ethers.getContractFactory("SampleNFT");
    const sampleNFT = await SampleNFT.deploy();
    const WrappedNFT = await ethers.getContractFactory("WrappedNFT");
    await sampleNFT.deployed();
    const wrappedNFT = await WrappedNFT.deploy(sampleNFT.address);
    await wrappedNFT.deployed();

    const mintTx = await sampleNFT.mint(cyan.address, tokenId);
    await mintTx.wait();
    expect(await sampleNFT.ownerOf(tokenId)).to.equal(cyan.address);

    const approveTx = await sampleNFT.approve(wrappedNFT.address, tokenId);
    await approveTx.wait();
    expect(await sampleNFT.getApproved(tokenId)).to.equal(wrappedNFT.address);

    // Wrapping a NFT
    const wrapTx = await wrappedNFT.wrap(user, tokenId);
    await wrapTx.wait();
    expect(await wrappedNFT.ownerOf(tokenId)).to.equal(user);
    expect(await sampleNFT.ownerOf(tokenId)).to.equal(wrappedNFT.address);

    // Unwrapping a NFT
    const unwrapTx = await wrappedNFT.unwrap(user, tokenId);
    await unwrapTx.wait();
    expect(await sampleNFT.ownerOf(tokenId)).to.equal(user);
    await expect(wrappedNFT.ownerOf(tokenId)).to.be.revertedWith('ERC721: owner query for nonexistent token');
  });
});
