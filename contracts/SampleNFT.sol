//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SampleNFT is ERC721 {
    constructor() ERC721("SampleNFT", "SNFT") {
        console.log("Deploying a SampleNFT");
    }

    // Dev only minting function
    function mint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }
}
