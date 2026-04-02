// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract MovieRentalPlatform is VRFConsumerBaseV2Plus {

    struct Movie {
        uint256 id;
        address owner;
        string title;
        uint256 pricePerDay;
        bool listed;
    }

    struct Rental {
        uint256 rentalId;
        uint256 movieId;
        address renter;
        uint256 rentedAt;
        uint256 daysCount; // Tracked for refunds
        bool active;
    }

    struct MemeNFT {
        uint256 id;
        address creator;
        bool spotlight;
    }

    mapping(uint256 => Movie) public movies;
    mapping(uint256 => Rental) public rentals;
    mapping(uint256 => MemeNFT) public memes;
    
    uint256 public movieCount;
    uint256 public rentalCount;
    uint256 public memeCount;

    uint256 public spotlightMemeId;
    
    // VRF Variables
    uint256 private s_subscriptionId;
    bytes32 private s_keyHash;
    
    // THE VRF SNAPSHOT
    uint256 public activeSpotlightSnapshot; 

    event MovieUploaded(uint256 id, address owner, uint256 price);
    event RefundIssued(address renter, uint256 amount);
    event SpotlightWinner(uint256 memeId);

    constructor(uint256 subId, address coordinator, bytes32 keyHash) 
        VRFConsumerBaseV2Plus(coordinator) 
    {
        s_subscriptionId = subId;
        s_keyHash = keyHash;
    }

    function uploadMovie(string memory title, uint256 price) external {
        movieCount++;
        movies[movieCount] = Movie(movieCount, msg.sender, title, price, true);
        emit MovieUploaded(movieCount, msg.sender, price);
    }

    // ─── NEW FEATURE: CREATOR CAN UPDATE PRICE ───
    function updateMoviePrice(uint256 movieId, uint256 newPrice) external {
        require(movies[movieId].owner == msg.sender, "Only owner");
        movies[movieId].pricePerDay = newPrice;
    }

    function rentMovie(uint256 movieId, uint256 daysCount) external payable {
        Movie storage m = movies[movieId];
        require(m.listed, "Not listed");
        
        uint256 totalCost = m.pricePerDay * daysCount;
        require(msg.value == totalCost, "Incorrect payment");

        rentalCount++;
        rentals[rentalCount] = Rental(rentalCount, movieId, msg.sender, block.timestamp, daysCount, true);

        // Send 90% to creator, keep 10% in contract as platform fee
        uint256 creatorShare = (msg.value * 90) / 100;
        payable(m.owner).transfer(creatorShare);
    }

    // ─── NEW FEATURE: 1-HOUR CANCELLATION REFUND ───
    function cancelRental(uint256 rentalId) external {
        Rental storage r = rentals[rentalId];
        require(r.renter == msg.sender, "Not your rental");
        require(r.active, "Already cancelled");
        require(block.timestamp <= r.rentedAt + 1 hours, "Grace period over");

        // CEI Pattern: Update state before external call to prevent reentrancy
        r.active = false;

        // Calculate refund
        uint256 refundAmount = movies[r.movieId].pricePerDay * r.daysCount;
        
        (bool ok, ) = payable(msg.sender).call{value: refundAmount}("");
        require(ok, "Refund failed");
        emit RefundIssued(msg.sender, refundAmount);
    }

    function mintMeme() external {
        memeCount++;
        memes[memeCount] = MemeNFT(memeCount, msg.sender, false);
    }

    // ─── VRF: USERS PAY TO TRIGGER THE SPOTLIGHT ───
    function requestSpotlightWinner() external payable returns (uint256) {
        require(msg.value == 0.01 ether, "Fee required");
        require(memeCount > 0, "No memes");

        // Snapshot the current meme count
        activeSpotlightSnapshot = memeCount;

        return s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: s_keyHash,
                subId: s_subscriptionId,
                requestConfirmations: 3,
                callbackGasLimit: 100000,
                numWords: 1,
                extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
            })
        );
    }

    function fulfillRandomWords(uint256 /* requestId */, uint256[] calldata randomWords) internal override {
        // Use the snapshot to bind the random number
        uint256 winnerId = (randomWords[0] % activeSpotlightSnapshot) + 1;
        
        if (spotlightMemeId > 0) {
            memes[spotlightMemeId].spotlight = false;
        }

        memes[winnerId].spotlight = true;
        spotlightMemeId = winnerId;
        
        emit SpotlightWinner(winnerId);
    }
}