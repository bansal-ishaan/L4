# 🎬 CineVault — Decentralized Movie & Meme Platform

Welcome to **CineVault**, a decentralized platform where users can:
- Upload and rent movies 🎥  
- Mint meme NFTs 🖼️  
- Participate in a daily **Spotlight Feature** powered by randomness 🎲  

This level focuses on one of the most important (and misunderstood) concepts in blockchain systems:

> ⚠️ **Randomness is NOT native to blockchain**

---

## 🔗 About Chainlink

Modern smart contracts rely on external infrastructure to perform tasks that cannot be done natively on-chain.

One such ecosystem is **Chainlink**, which provides multiple services, including:

- **VRF (Verifiable Random Function)** → Secure randomness  
- **CCIP (Cross-Chain Interoperability Protocol)** → Cross-chain communication  
- **Automation** → Scheduled / trigger-based execution  

In this challenge, you are dealing with:

> 🎯 **VRF — because randomness must be provably fair and tamper-proof**

---

## 🎲 VRF — What You Need to Know

To use VRF, a contract typically requires a few key parameters:

- `keyHash` → Identifies the oracle job / gas lane  
- `subscriptionId` → Funds and authorizes randomness requests  
- `vrfCoordinator` → The contract responsible for handling requests  

These are part of the **setup layer**, not the core business logic.

💡 Hint:
> You are not expected to invent randomness —  
> you are expected to correctly **plug into the randomness pipeline**.

Some parts of this integration are intentionally incomplete.  
You will need to figure out how they fit together.

---

## 🧠 What This Project Does

CineVault combines multiple features into a single smart contract:

### 🎥 Movie System
- Upload movies using IPFS CIDs  
- Rent movies for a fixed duration  
- Automatic revenue split between platform and creator  

### 🖼️ Meme NFT System
- Mint meme NFTs stored via IPFS  
- Each meme participates in a global pool  

### 🌟 Spotlight System (Core Challenge)
- Once every cycle, **one meme is selected randomly**
- The winner:
  - Gets spotlight visibility  
  - Receives a temporary platform benefit  

---

## 🎯 Your Objective

You are given a **partially broken / incomplete implementation** of the system.

Your goal is to:
- Understand how the platform is supposed to behave  
- Fix the broken flow  
- Ensure the **Spotlight system works correctly**  

---

## 🔁 Expected Workflow

To complete this level, follow a structured approach:

1. **Fix the Contract**
   - Identify incomplete and incorrect logic  
   - Make all core features functional  

2. **Integrate VRF Properly**
   - Ensure randomness request and fulfillment flow is correct  
   - Connect the request → response → execution pipeline  

3. **Deploy the Contract**
   - Use sepolia 
   - Provide correct VRF parameters  

4. **Simulate Real Usage**
   - Use **3–4 different accounts**  
   - Create user profiles  
   - Upload movies  
   - Perform rentals  

5. **Test Meme System**
   - Mint at least **3–4 memes from different accounts**  
   - Ensure they are stored and tracked correctly  

6. **Run Spotlight Selection**
   - Trigger randomness request  
   - Wait for fulfillment  
   - Verify that:
     - A valid meme is selected  
     - State updates correctly  
     - Rewards are applied properly  

## 💡 Subtle Disclaimer

> Once you trigger the VRF request and try to check the winner, the result is **not immediate**.  
> The response can take anywhere between **3 to 15 minutes** depending on network conditions.
---

## 🔁 Spotlight Flow (IMPORTANT)

The spotlight system does **NOT** work in a single step.

It follows this pattern:

1. A randomness request is triggered  
2. The system waits for a response  
3. A separate function processes the result  
4. The winning meme is selected and updated  

⚠️ If you try to treat this as a one-step function, it will fail.

---

## 🎲 About Randomness (Read Carefully)

On-chain randomness is tricky because:
- Every value is publicly visible  
- Every node must reach the same result  
- Direct randomness = predictable randomness  

So instead, this project uses an **external randomness provider pattern**.

You will notice:
- Randomness is **requested**
- Randomness is **fulfilled later**

💡 Subtle Hint:
> The contract already knows *how to ask* for randomness.  
> Focus on how the system **handles the response**.

---

## ⚠️ Constraints

- Do NOT replace randomness with:
  - `block.timestamp`
  - `block.number`
  - hashes or pseudo tricks  

- You must follow the **existing architecture**
- The solution lies in completing the **intended flow**, not bypassing it  

---

## 🧩 What Makes This Level Hard

- Multi-feature contract (not isolated logic)  
- Asynchronous execution flow  
- Hidden dependency between functions  
- Easy to misunderstand the randomness lifecycle  

---

## 🛠️ Suggested Approach

- First, understand how:
  - memes are stored  
  - spotlight is tracked  
- Then trace:
  - where randomness is requested  
  - where it should be consumed  
- Finally:
  - connect the missing pieces logically  

---

## 🧪 Evaluation Criteria

You will be evaluated on:

- ✅ Correct spotlight selection  
- ✅ Proper handling of randomness  
- ✅ Maintaining system integrity  
- ✅ No insecure shortcuts  

---

## 🚨 Final Note

This is not a syntax problem.  
This is a **thinking problem**.

If you:
- blindly modify code → it will break  
- try to shortcut randomness → it will be insecure  

But if you:
- understand the flow → it becomes solvable  

---

Good luck 🚀