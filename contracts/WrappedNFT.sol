//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract WrappedNFT is ERC721, ReentrancyGuard, ERC721Holder {
    address _originalNFT;
    ERC721 _originalNFTContract;

    event Wrap(address indexed from, address indexed to, uint256 indexed tokenId);
    event Unwrap(address indexed from, address indexed to, uint256 indexed tokenId);

    constructor(address originalNFT) ERC721("WrappedNFT", "WNFT") {
        console.log("Deploying a WrappedNFT of address:", originalNFT);

        _originalNFT = originalNFT;
        _originalNFTContract = ERC721(_originalNFT);
    }

    function wrap(address to, uint256 tokenId) public nonReentrant {
        console.log("Wrapping nft with tokenid:, to:, msg.sender:", tokenId, to, msg.sender);

        require(to != address(0), "wrap to the zero address");
        require(!_exists(tokenId), "token already wrapped");

        _originalNFTContract.safeTransferFrom(msg.sender, address(this), tokenId);
        _safeMint(to, tokenId);

        emit Wrap(msg.sender, to, tokenId);
    }

    function unwrap(address to, uint256 tokenId) public nonReentrant {
        console.log("Unwrapping nft with tokenid:, to:, msg.sender:", tokenId, to, msg.sender);

        require(to != address(0), "unwrap to the zero address");
        require(_exists(tokenId), "token is not wrapped");

        _originalNFTContract.safeTransferFrom(address(this), to, tokenId);
        _burn(tokenId);

        emit Unwrap(msg.sender, to, tokenId);
    }
}
