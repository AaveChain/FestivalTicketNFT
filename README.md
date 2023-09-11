# FestivalTicketNFT
A non-fungible token that represents tickets for a festival and a fungible currency token

```bash
│
├── contracts/
│   ├── FestivalTicketNFT.sol
│   └── CurrencyToken.sol
│
├── migrations/
│   ├── 1_initial_migration.js
│   ├── 2_deploy_contracts.js
│   └── ...
│
├── test/
│   ├── FestivalTicketNFTTest.js
│
├──package-lock.json    
├──package.json 
├── truffle-config.js (or truffle-config.js for Windows)
```
**Contract Overview:**


Our FestivalTicketNFT contract allows users to buy tickets from the organizer at a fixed price in the currency token (Ether) and sell these tickets to others in the secondary market. The contract also enforces that the secondary market price cannot exceed 110% of the previous sale price. Additionally, a portion of the sale price (5%) goes to the organizer as a monetization option.

**Smart Contract Explanation (FestivalTicketNFT.sol):**
The smart contract FestivalTicketNFT is designed to create and manage non-fungible tokens (NFTs) that represent tickets for a festival. It also uses a fungible currency token for transactions.

**Constructor:**

The constructor initializes the contract with the address of the currency token (fungible token) that will be used for transactions.
It sets the contract deployer's address as the organizer.

State Variables:

**maxTickets:** Maximum number of tickets allowed (1000 in this example).
**currencyToken:** Address of the fungible currency token.
**organizerCutPercentage:** Percentage (5% in this example) of the sale price that goes to the organizer in secondary market sales.
**priceIncreasePercentage:** Maximum allowed price increase for a ticket (110% in this example).
**organizer:** Address of the festival organizer.
**currentTicketId:** Current ticket ID being used for minting tickets.
**tickets:** A mapping to store ticket information, including price and owner.

**Modifiers:**

**onlyTicketOwner(uint256 tokenId):** A modifier to check if the caller is the owner of a specific ticket.

**ticketsAvailable():** A modifier to check if there are available tickets for sale.

**Functions:**

**setOrganizerCutPercentage(uint256 _cutPercentage):** Allows the contract owner to set the organizer's cut percentage for secondary market sales.

**ticketPrice():** Returns the fixed price of a ticket (1 Ether in this example).

**buyTicket():** Allows users to purchase tickets from the organizer by sending Ether. Checks if the sent Ether matches the fixed price and mints a ticket.

**sellTicket(address to, uint256 tokenId, uint256 price):** Allows ticket owners to sell tickets to others. Checks if the selling price doesn't exceed 110% of the previous sale price. It also ensures that the contract is approved to spend tokens on behalf of the seller. The selling price is divided into the organizer's cut and the seller's proceeds, and tokens are transferred accordingly.


**Running and Deploying the Contract:**

To run and deploy the smart contract, follow these steps:

**Set up an Ethereum Development Environment:**

Install Node.js and npm (Node Package Manager) if you haven't already.


**Install Truffle with Dependencies:**

```bash


npm init

npm install -g truffle

truffle init
```

In your project directory, run the following commands to install required dependencies:

```bash
npm install @openzeppelin/contracts
```


**Deployment the Contract using Truffle:**

**Compile the Contract:**

Open your terminal and navigate to the project directory containing your Truffle project.

Run the following command to compile the contract:

```bash
truffle compile
```

**Configure the Sepolia Testnet:**

In the **truffle-config.js (or truffle.js)** file, configure the Sepolia Testnet as a custom network. You'll need to specify the network's URL, chain ID, and provide the account mnemonic phrase or private key for deploying.

**Migrate the Contract:**

Run the migration to deploy the contract on the Sepolia Testnet. Use the --network flag to specify the target network. For example:


```bash
truffle migrate --network sepolia
```

**Test Cases:**

**Step 1: Test the Smart Contract with FestivalTicketNFTTest.js**


```bash
truffle test
```


**NOTE:** We Can check contract on ethereum platform also for clarification


**Step 2: Buying Tickets from the Organizer**

In this step, you'll buy tickets from the organizer at a fixed price. Here's the flow:

In the deployed contract instance (under the "Deployed Contracts" section), find the "buyTicket" function.
Click on the "buyTicket" function.
Now, let's explain what values to enter:

In the "from" field: Enter your Ethereum address. This is the address that will be used to buy the ticket. For example, you can use 0xYourAddress.
Example:

In "from": 0xYourAddress (Replace YourAddress with your actual Ethereum address)
Click the "transact" button to execute the transaction.


**Step 3: Selling Tickets to Others**

**Approve the Smart Contract to Spend Ether:**

Use a wallet like MetaMask or any Ethereum wallet that supports ERC-20 tokens.
Go to your wallet's "Assets" or "Tokens" section.
Find the currency token (Ether) you want to use to buy the ticket.
Look for the "Approve" or "Allowance" option for this token.
Approve the smart contract's address (the address of the FestivalTicketNFT contract) to spend the amount you specified as the ticket price (in this case, "1100000000000000000" Wei or 1.1 Ether).


**Execute the sellTicket Transaction Again:**

After approving the allowance, go back to Remix or your preferred method of interacting with the smart contract.
In the "sellTicket" function, use the same values you provided earlier:
"to" should be the buyer's address.
"tokenId" should be the ID of the ticket you want to sell.
"price" should still be "1100000000000000000" (1.1 Ether).
Click the "transact" button to execute the transaction.

Now, with the allowance approved, the smart contract will be able to transfer the specified amount of Ether from your address to the contract when you execute the "sellTicket" function. This should allow you to complete the ticket sale successfully.

In this step, you'll sell tickets to other buyers at a price you specify. Here's the flow:

In the deployed contract instance, find the "sellTicket" function.
Click on the "sellTicket" function.
Now, let's explain what values to enter:

In the "to" field: Enter the Ethereum address of the buyer to whom you want to sell the ticket. This is the address of the person buying the ticket from you. For example, you can use 0xBuyerAddress.


**Example:**
In "to": 0xBuyerAddress (Replace BuyerAddress with the actual Ethereum address of the buyer)

In the "tokenId" field: Enter the ID of the ticket you want to sell. Make sure you own this ticket. For example, if you have a ticket with ID 1, enter 1.

**Example:**

In "tokenId": 1 (If you own a ticket with ID 1)

In the "price" field: Enter the price at which you want to sell the ticket in Ether. For example, you can specify 1 ether as the price.

**Example:**

In "price": 1 ether (This means you are selling the ticket for 1 Ether)
Click the "transact" button to execute the transaction.
That's it! You've successfully explained how to buy tickets from the organizer and sell tickets to others within the specified price limit. Make sure to replace the example addresses (0xYourAddress and 0xBuyerAddress) with actual Ethereum addresses when you interact with the contract.


**Cases:**

**You can buy tickets from the organizer at a fixed price in the currency token.**

In your code, the buyTicket function allows users to purchase tickets from the organizer at a fixed price specified by the ticketPrice function. The fixed price is set to 1 ether, and users can buy tickets by sending Ether equal to or exceeding this fixed price. So, this condition is met.

**You can buy and sell tickets to others, but the price can never be higher than 110% of the previous sale.**

In your code, the sellTicket function checks that the selling price (price) does not exceed 110% of the previous sale price (maxPrice). If the price is within this limit, the ticket can be sold. So, this condition is met.

**Add a monetization option for the organizer in the secondary market sales.**

In your code, when a ticket is sold in the secondary market (i.e., when someone other than the organizer sells a ticket), the organizer receives a cut defined by the organizerCutPercentage, which is 5% in your example. This percentage is deducted from the selling price, and the remaining proceeds go to the seller. So, this condition is also met.


