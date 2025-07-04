// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";

contract Auction is ERC721URIStorage, Ownable {

    struct AuctionItem {
        uint256 tokenId;
        uint256 minPrice;
        uint256 highestBid;
        address highestBidder;
        uint256 endTime;
        bool ended;
    }

    mapping(uint256 => AuctionItem) public auctions;
    mapping(address => uint256) public pendingReturns;

    constructor() ERC721("Auction", "ANFT") Ownable(msg.sender) {}

    function startAuction(
        uint256 tokenId,
        uint256 minPrice,
        uint256 duration,
        string memory tokenURI
    ) public onlyOwner {
        require(auctions[tokenId].endTime == 0, "Auction already exists");

        auctions[tokenId] = AuctionItem({
            tokenId: tokenId,
            minPrice: minPrice,
            highestBid: 0,
            highestBidder: address(0),
            endTime: block.timestamp + duration,
            ended: false
        });

        // store metadata in advance
        _setTokenURI(tokenId, tokenURI);
    }

    /**
    * @notice Place a bid on an active auction.
    * @dev 
    *  - A bid must be higher than the current highest bid and at least equal to the minimum price.
    *  - If there is an existing highest bidder, their previous bid amount is stored in `pendingReturns` 
    *    so they can withdraw it later using the `withdraw` function.
    *  - The auction must still be active (current time is before `endTime`).
    * @param tokenId The unique identifier of the token being auctioned.
    * 
    * Emits no events directly, but changes the auction state and `pendingReturns` mapping.
    * 
    * Requirements:
    *  - The auction for the tokenId must exist and be active.
    *  - The bid value must be greater than the current highest bid.
    *  - The bid value must be greater than or equal to the auction's minimum price.
    * 
    * Security:
    *  - Uses the pull-over-push pattern to prevent reentrancy on refunds.
    */
    function bid(uint256 tokenId) external payable {
        AuctionItem storage auction = auctions[tokenId];
        require(block.timestamp < auction.endTime, "Auction has ended");
        require(msg.value > auction.highestBid && msg.value >= auction.minPrice, "Bid too low");

        if (auction.highestBidder != address(0)) {
            // Instead of transferring immediately, store amount
            pendingReturns[auction.highestBidder] += auction.highestBid;
        }

        auction.highestBid = msg.value;
        auction.highestBidder = msg.sender;
    }

    function finalizeAuction(uint256 tokenId) external {
        AuctionItem storage auction = auctions[tokenId];
        require(block.timestamp >= auction.endTime, "Auction not yet ended");
        require(!auction.ended, "Auction already finished");

        auction.ended = true;

        if (auction.highestBidder != address(0)) {
            _safeMint(auction.highestBidder, tokenId);
            payable (owner()).transfer(auction.highestBid);
        }
    }

    function withdraw() external {
        uint256 amount = pendingReturns[msg.sender];
        require(amount > 0, "Nothing to withdraw");

        pendingReturns[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
