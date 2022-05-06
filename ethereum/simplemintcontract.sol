//SPDX-License-Identifier Unlicensed
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract SimpleMintContract is ERC721, Ownable {
    uint256 public mintPrice = 0.05 ether; // price to mint
    uint256 public totalSupply; // tracks all minted nfts
    uint256 public maxSupply;
    bool public isMintEnabled; // boolean to flip to allow minting
    mapping(address => uint256) public mintedWallets; // like a dictionary

    constructor() payable ERC721('Simple Mint', 'SIMPLEMINT') {
        maxSupply = 2; // total that can be minted
    }

    function toggleIsMintEnabled() external onlyOwner {
        isMintEnabled = !isMintEnabled; // toggles if mintable
    }

    function setMaxSupply(uint256 maxSupply_) external onlyOwner {
        maxSupply = maxSupply_; // must equal the mint price
    }

    function mint() external payable {
        require(isMintEnabled, 'minting not enabled'); // toggled off
        require(mintedWallets[msg.sender] < 1, 'exceeds max per wallet'); // one 1 per wallet
        require(msg.value == mintPrice, 'wrong value'); // incorrect value
        require(maxSupply > totalSupply, 'sold out'); // see maxSupply

        mintedWallets[msg.sender]++;
        totalSupply++;
        uint256 tokenId = totalSupply;
        _safeMint(msg.sender, tokenId);
    }
}

// https://www.youtube.com/watch?v=8WPzUbJyoNg