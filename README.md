# Decentralized NFT Auction System (Smart Contract)

## Overview

This project delivers a decentralized NFT auction platform built on Solidity, leveraging the ERC721 standard. It empowers NFT owners to launch auctions, bidders to compete transparently, and guarantees a secure settlement of funds on-chain.

## Features

- NFT owners can start auctions with a minimum price and a defined duration
- Bidders place offers in ETH
- The highest bid at auction end wins the NFT
- If no bids are received, the NFT is returned to its original owner
- Losing bidders can withdraw their bids safely using the pull payment pattern
- Emits events for:
  - Auction creation
  - New bids
  - Auction conclusion (sold/unsold)

## Technical Highlights

- Written in Solidity `^0.8.x`
- Follows security best practices:
  - Checks-Effects-Interactions pattern
  - Reentrancy protection
- Automated tests included with Hardhat or Foundry
- Minimal documentation included for deployment and testing
- **Optional enhancement**: a front-end with React + ethers.js to display auctions and enable bidding

## Expected Smart Contract Functions

- `startAuction(tokenId, minPrice, duration)` — initialize a new NFT auction
- `bid(auctionId)` — place a bid
- `endAuction(auctionId)` — finalize the auction
- `withdraw()` — withdraw funds from unsuccessful bids

## Evaluation Criteria

Recruiters and reviewers will assess:

- Mastery of the ERC721 token standard
- Use of events, structs, mappings, and enums
- Secure handling of ETH within the contract
- Accurate time-based auction logic using `block.timestamp`
- Defensive coding practices to prevent reentrancy
- Comprehensive test coverage
- Clean, maintainable, and well-organized code structure
