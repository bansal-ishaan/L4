# 🎬 CineVault — Decentralized Movie & Meme Platform

CineVault is a decentralized platform that combines movie rentals, dynamic pricing, meme NFTs, and a randomness-powered spotlight system.

It demonstrates real-world smart contract design challenges, including financial logic, asynchronous execution, and secure randomness integration.

---

## 🚀 Overview

CineVault allows users to:

* Upload and rent movies
* Dynamically update pricing
* Cancel rentals within a grace period
* Mint meme NFTs
* Participate in a spotlight system powered by verifiable randomness

---

## 🧠 Core Concept

Smart contracts are:

* Public
* Asynchronous
* Immutable

This project highlights how these properties introduce **non-obvious vulnerabilities** when state changes over time.

---

## 🔗 Chainlink Integration

CineVault uses **Chainlink VRF (Verifiable Random Function)** for secure randomness.

### Key Components

* `keyHash` — identifies oracle job
* `subscriptionId` — funds randomness requests
* `vrfCoordinator` — handles request lifecycle

---

## 🎥 Movie System

* Upload movies
* Update rental price dynamically
* Rent movies for a fixed duration
* Cancel rental within **1-hour grace period**
* Automatic revenue split:

  * 90% → creator
  * 10% → platform

---

## 🖼️ Meme NFT System

* Users can mint meme NFTs
* All memes participate in a shared pool
* Stored with metadata on IPFS

---

## 🌟 Spotlight System

* Users pay a small fee to trigger spotlight selection
* Uses Chainlink VRF for randomness
* One meme is selected as the winner

### Flow

1. User requests randomness
2. Contract stores necessary state
3. Chainlink responds asynchronously
4. `fulfillRandomWords` selects winner using modulo

---

## ⚠️ Core Challenges

This project contains **intentional vulnerabilities**:

### 1. Financial Exploit

* Refund logic can be manipulated
* Attackers can drain platform funds

### 2. VRF Manipulation

* Improper state handling during async execution
* Attackers can influence spotlight outcome

---

## 🔍 What You Need to Do

* Audit the contract logic
* Identify both vulnerabilities
* Explain attack vectors step-by-step
* Implement secure fixes
* Deploy and test on testnet

---

## 🔁 Expected Workflow

### Financial Audit

* Analyze `updateMoviePrice`, `rentMovie`, `cancelRental`
* Check refund calculations

### VRF Audit

* Analyze `requestSpotlightWinner`, `fulfillRandomWords`
* Track state changes during delay

### Exploit Design

* Write step-by-step attack scenarios

### Patch

* Fix vulnerabilities without removing features

---

## 🏆 Steps to Qualify as a Winner

To successfully complete this challenge:

1. Complete and deploy the smart contract
2. Properly integrate Chainlink VRF (subscription, coordinator, keyHash)
3. Test all core functions:

   * Movie upload
   * Price update
   * Rent and cancel flow
   * Meme minting
4. Upload at least 3–4 memes to populate the system
5. Trigger the VRF request for spotlight selection
6. Wait for the Chainlink response (approx. 3–7 minutes)
7. Call the winner selection flow after randomness is fulfilled
8. Verify that:

   * A fair winner is selected
   * No manipulation is possible
   * All edge cases are handled

---

## ⏳ Important Note

VRF responses are **not instant**.

They may take **3–15 minutes**, during which contract state can change.

> Tip: Always wait for the VRF callback to complete before calling the winner logic.

---

## ⚙️ Constraints

* Do NOT replace VRF with pseudo-random methods
* Do NOT remove core features
* Fix logic, not architecture

---

## 🧩 Why This Is Challenging

* No syntax errors
* Multi-feature contract
* Asynchronous execution
* State-dependent vulnerabilities

---

## 🧪 Evaluation Criteria

* Correct identification of financial exploit
* Correct identification of VRF exploit
* Clear attack explanation
* Secure and functional patch

---

## 🚨 Final Note

This is not a syntax problem — it is a **state and logic problem**.

Understanding how variables evolve over time is key to solving it.

---

## 👤 Author

Built for advanced smart contract security learning and auditing practice.
