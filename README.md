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

**CurrencyToken.sol**

Simple ERC20 Token contract, we can use openzeppelin wizards.

**FestivalTicketNFT.sol**

Our FestivalTicketNFT contract allows users to buy tickets from the organizer at a fixed price in the currency token (Ether) and sell these tickets to others in the secondary market. The contract also enforces that the secondary market price cannot exceed 110% of the previous sale price. Additionally, a portion of the sale price (5%) goes to the organizer as a monetization option.

**Smart Contract Explanation (FestivalTicketNFT.sol):**
The smart contract FestivalTicketNFT is designed to create and manage non-fungible tokens (NFTs) that represent tickets for a festival. It also uses a fungible currency token for transactions.

**Constructor:**

The constructor initializes the contract when it is deployed. It takes the address of the currency token (_currencyToken) as an argument and sets it as the currency token. It also initializes the organizer variable with the address of the contract deployer.

**State Variables:**
State Variables:

**maxTickets:** Maximum number of tickets allowed (1000 in this example).

**currencyToken:** Address of the fungible currency token.

**organizerCutPercentage:** Percentage (5% in this example) of the sale price that goes to the organizer in secondary market sales.

**priceIncreasePercentage:** Maximum allowed price increase for a ticket (110% in this example).

**organizer:** Address of the festival organizer.

**currentTicketId:** Current ticket ID being used for minting tickets.

**tickets:** A mapping to store ticket information, including price and owner.

**Struct:**

**Ticket:** A struct that represents a ticket with two properties: price (the price of the ticket) and owner (the address of the ticket owner).

**Mapping:**

**tickets:** A mapping that associates a ticket ID (represented as a uint256) with a Ticket struct. This mapping is used to store information about each ticket.


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

Install Node.js and npm (Node Package Manager) if we haven't already.


**Install Truffle with Dependencies:**

```bash


npm init

npm install -g truffle

truffle init
```

In our project directory, run the following commands to install required dependencies:

```bash
npm install @openzeppelin/contracts
```


**Deployment the Contract using Truffle:**

**Compile the Contract:**

Open our terminal and navigate to the project directory containing our Truffle project.

Run the following command to compile the contract:

```bash
truffle compile
```

**Configure the Sepolia Testnet:**

In the **truffle-config.js (or truffle.js)** file, configure the Sepolia Testnet as a custom network. We'll need to specify the network's URL, chain ID, and provide the account mnemonic phrase or private key for deploying. Replace the private key and Replace with your Infura API key on truffle-config.js.

**Migrate the Contract:**

**Truffle Migration Script (2_deploy_contracts.js)**

This script deploys both the ERC20 token (currency token) and the FestivalTicketNFT contract. Make sure to replace the addresses of the ERC20 token and the organizer with your actual values. Create or update our migration script (2_deploy_contracts.js) to deploy the CurrencyToken (ERC20) and FestivalTicketNFT contracts, as shown in the provided migration script. Run the migration to deploy the contract on the Sepolia Testnet. Use the --network flag to specify the target network. For example:


```bash
truffle migrate --network sepolia
```
**Compile and Migrate:**

Open a terminal in the project directory.
Compile our contracts using the command: truffle compile.
Deploy our contracts to the Sepolia testnet using: truffle migrate --network sepolia. Ensure that you have configured the sepolia network in your truffle-config.js file with the appropriate RPC endpoint and account details.

**Testing:**

Create a test file (e.g., FestivalTicketNFT.test.js) and write test cases for various contract functionalities as shown in the provided testing script.

**Run Tests:**

Run your tests using Truffle by executing the command: 
```bash
truffle test
```

**Test Cases:**

**Step 1: Test the Smart Contract with FestivalTicketNFTTest.js**


```bash
truffle test
```


**NOTE:** We can also check contract on ethereum platform also for clarification


**Step 2: Buying Tickets from the Organizer**

In this step, we'll buy tickets from the organizer at a fixed price. Here's the flow:

In the deployed contract instance (under the "Deployed Contracts" section), find the "buyTicket" function.
Click on the "buyTicket" function.
Now, let's explain what values to enter:

In the "from" field: Enter our Ethereum address. This is the address that will be used to buy the ticket. For example, we can use 0xourAddress.
Example:

In "from": 0xourAddress (Replace ourAddress with our actual Ethereum address)
Click the "transact" button to execute the transaction.


**Step 3: Selling Tickets to Others**

**Approve the Smart Contract to Spend Ether:**

Use a wallet like MetaMask or any Ethereum wallet that supports ERC-20 tokens.
Go to our wallet's "Assets" or "Tokens" section.
Find the currency token (Ether) we want to use to buy the ticket.
Look for the "Approve" or "Allowance" option for this token.
Approve the smart contract's address (the address of the FestivalTicketNFT contract) to spend the amount, specified as the ticket price (in this case, "1100000000000000000" Wei or 1.1 Ether).


**Execute the sellTicket Transaction Again:**

After approving the allowance, go back to Remix or our preferred method of interacting with the smart contract.
In the "sellTicket" function, use the same values you provided earlier:
"to" should be the buyer's address.
"tokenId" should be the ID of the ticket we want to sell.
"price" should still be "1100000000000000000" (1.1 Ether).
Click the "transact" button to execute the transaction.

Now, with the allowance approved, the smart contract will be able to transfer the specified amount of Ether from our address to the contract when we execute the "sellTicket" function. This should allow to complete the ticket sale successfully.

In this step, you'll sell tickets to other buyers at a price you specify. Here's the flow:

In the deployed contract instance, find the "sellTicket" function.
Click on the "sellTicket" function.
Now, let's explain what values to enter:

In the "to" field: Enter the Ethereum address of the buyer to whom we want to sell the ticket. This is the address of the person buying the ticket. For example, we can use 0xBuyerAddress.


**Example:**
In "to": 0xBuyerAddress (Replace BuyerAddress with the actual Ethereum address of the buyer)

In the "tokenId" field: Enter the ID of the ticket you want to sell. Make sure you own this ticket. For example, if you have a ticket with ID 1, enter 1.

**Example:**

In "tokenId": 1 (If you own a ticket with ID 1)

In the "price" field: Enter the price at which you want to sell the ticket in Ether. For example, you can specify 1 ether as the price.

**Example:**

In "price": 1 ether (This means you are selling the ticket for 1 Ether)
Click the "transact" button to execute the transaction.
That's it! You've successfully explained how to buy tickets from the organizer and sell tickets to others within the specified price limit. Make sure to replace the example addresses (0xourAddress and 0xBuyerAddress) with actual Ethereum addresses when we interact with the contract.


**Cases:**

**You can buy tickets from the organizer at a fixed price in the currency token.**

In our code, the buyTicket function allows users to purchase tickets from the organizer at a fixed price specified by the ticketPrice function. The fixed price is set to 1 ether, and users can buy tickets by sending Ether equal to or exceeding this fixed price. So, this condition is met.

**You can buy and sell tickets to others, but the price can never be higher than 110% of the previous sale.**

In our code, the sellTicket function checks that the selling price (price) does not exceed 110% of the previous sale price (maxPrice). If the price is within this limit, the ticket can be sold. So, this condition is met.

**Add a monetization option for the organizer in the secondary market sales.**

In our code, when a ticket is sold in the secondary market (i.e., when someone other than the organizer sells a ticket), the organizer receives a cut defined by the organizerCutPercentage, which is 5% in our example. This percentage is deducted from the selling price, and the remaining proceeds go to the seller. So, this condition is also met.


