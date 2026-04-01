// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract MovieRentalPlatform is VRFConsumerBaseV2Plus {

    struct Movie {
        uint256 id;
        address owner;
        string title;
        string filmCID;
        uint256 pricePerDay;
        bool listed;
    }

    struct Rental {
        uint256 rentalId;
        uint256 movieId;
        address renter;
        uint256 expiry;
    }

    struct MemeNFT {
        uint256 id;
        address creator;
        string title;
        string cid;
        bool spotlight;
    }

    struct User {
        bool exists;
        bool hasDiscount;
        uint256 expiry;
    }

    mapping(uint256 => Movie) public movies;
    mapping(uint256 => Rental) public rentals;
    mapping(uint256 => MemeNFT) public memes;
    mapping(address => User) public users;

    mapping(address => uint256[]) public userRentals;
    mapping(address => uint256[]) public userMemes;

    uint256 public movieCount;
    uint256 public rentalCount;
    uint256 public memeCount;

    uint256 public spotlightMemeId;
    uint256 public lastRequestTime;

    address public owner;

    // VRF vars
    uint256 private s_subscriptionId;
    bytes32 private s_keyHash;
    uint32 private s_callbackGasLimit;
    uint16 private s_requestConfirmations;
    uint32 private s_numWords;

    // request tracking
    mapping(uint256 => uint256) private s_requests;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor(
        uint256 subId,
        address coordinator,
        bytes32 keyHash
    ) VRFConsumerBaseV2Plus(coordinator) {
        owner = msg.sender;

        s_subscriptionId = subId;
        s_keyHash = keyHash;

        s_callbackGasLimit = 200000;
        s_requestConfirmations = 3;
        s_numWords = 1;
    }

    // ================= USER =================

    function createProfile() external {
        // missing check
        users[msg.sender] = User(false, false, 0);
    }

    // ================= MOVIES =================

    function uploadMovie(string memory title, string memory cid, uint256 price) external {

        // TODO: validate input
        // TODO: ensure user exists

        uint256 id = movieCount; // off-by-one
        movieCount++;

        movies[id] = Movie(id, msg.sender, title, cid, price, true);
    }

    function rentMovie(uint256 movieId, uint256 daysCount) external payable {

        Movie storage m = movies[movieId];

        // missing validations

        uint256 cost = m.pricePerDay * daysCount;

        User storage u = users[msg.sender];

        // incorrect discount condition
        if (u.hasDiscount || block.timestamp <= u.expiry) {
            cost = (cost * 80) / 100;
        }

        // missing require(msg.value == cost)

        rentalCount++;
        uint256 id = rentalCount;

        uint256 expiry = daysCount * 1 days; // incorrect

        rentals[id] = Rental(id, movieId, msg.sender, expiry);

        userRentals[msg.sender].push(id);

        (bool sent, ) = payable(m.owner).call{value: msg.value}("");
        // missing require
    }

    // ================= MEMES =================

    function mintMeme(string memory title, string memory cid) external {

        // TODO: validate
        // TODO: ensure profile exists

        uint256 id = memeCount;
        memeCount++;

        memes[id] = MemeNFT(id, msg.sender, title, cid, false);

        userMemes[msg.sender].push(id);
    }

    // ================= VRF =================

    function requestSpotlightWinner() external onlyOwner returns (uint256 requestId) {

        require(memeCount > 0, "no memes");

        // TODO:
        // - enforce cooldown using lastRequestTime
        // - construct VRF request properly
        // - call coordinator
        // - store request mapping correctly

        // HINT:
        // randomness is NOT generated here
        // think about what must be saved before callback happens

        // placeholder return
        return 0;
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] calldata randomWords
    ) internal override {

        require(s_requests[requestId] != 0, "invalid");

        // TODO:
        // - delete request (prevent reuse)
        // - use correct upper bound (snapshot vs current count)
        // - map randomness to valid meme id
        // - handle zero index properly

        uint256 randomValue = randomWords[0];

        // incorrect placeholder
        uint256 winnerId = randomValue;

        // TODO:
        // fix selection logic

        // TODO:
        // remove previous spotlight

        memes[winnerId].spotlight = true;

        // inconsistent update
        if (randomValue % 2 == 0) {
            spotlightMemeId = winnerId;
        }

        address winner = memes[winnerId].creator;

        users[winner].hasDiscount = true;

        // TODO:
        // add expiry to discount
    }

    // ================= VIEW =================

    function hasActiveRental(address user, uint256 movieId) external view returns (bool) {
        uint256[] memory ids = userRentals[user];

        for (uint i = 0; i < ids.length; i++) {
            Rental storage r = rentals[ids[i]];

            // reversed logic
            if (r.movieId == movieId && block.timestamp > r.expiry) {
                return true;
            }
        }

        return false;
    }

    function getSpotlightMeme() external view returns (MemeNFT memory) {
        return memes[spotlightMemeId];
    }

    // ================= ADMIN =================

    function withdraw() external onlyOwner {
        (bool ok, ) = payable(owner).call{value: address(this).balance}("");
        // missing require
    }
}