// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// contract FestivalTicketNFT is ERC721Enumerable, Ownable {
//     using SafeMath for uint256;
    
//     uint256 public maxTickets = 1000;
//     uint256 public ticketPrice = 1 ether;
//     uint256 public currentTicketId = 1;
//     address public currencyToken;
//     uint256 public organizerCutPercentage = 5; // Organizer's cut percentage (5% in this example)
//     uint256 public constant priceIncreasePercentage = 110; // Maximum 110% price increase
//     address public organizer;

    

//     constructor(address _currencyToken) ERC721("FestivalTicket", "FT") {
//         currencyToken = _currencyToken;
//         organizer = msg.sender; // Initialize the organizer variable with the contract deployer's address
//     }

//     function setOrganizerCutPercentage(uint256 _cutPercentage) external onlyOwner {
//         organizerCutPercentage = _cutPercentage;
//     }

//     function buyTicket() external payable {
//         require(msg.value >= ticketPrice, "Insufficient funds");
//         require(currentTicketId <= maxTickets, "No more tickets available");
//         _mint(msg.sender, currentTicketId);
//         currentTicketId++;
//     }

//     function sellTicket(address to, uint256 tokenId, uint256 price) external {
//         require(ownerOf(tokenId) == msg.sender, "You don't own this ticket");
//         require(price <= ticketPrice.mul(110).div(100), "Price cannot exceed 110% of the previous sale price");

//         uint256 priceIncrease = price.mul(priceIncreasePercentage).div(100);
//         uint256 organizerCut = priceIncrease;
//         uint256 sellerProceeds = price.sub(organizerCut);

//         // Check if the contract is approved to spend tokens on behalf of the seller
//         require(IERC20(currencyToken).allowance(msg.sender, address(this)) >= price, "Allowance not set");

//         IERC20(currencyToken).transferFrom(msg.sender, address(this), price);
//         IERC20(currencyToken).transfer(organizer, organizerCut);
//         IERC20(currencyToken).transfer(to, sellerProceeds);

//         safeTransferFrom(msg.sender, to, tokenId);
//     }

// }


/////////////////////////////////////////////////////////


import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract FestivalTicketNFT is ERC721Enumerable, Ownable {
    using SafeMath for uint256;

    struct Ticket {
        uint256 price;
        address owner;
    }

    uint256 public maxTickets = 1000;
    address public currencyToken;
    uint256 public organizerCutPercentage = 5; // Organizer's cut percentage (5% in this example)
    uint256 public constant priceIncreasePercentage = 110; // Maximum 110% price increase
    address public organizer;
    uint256 public currentTicketId = 1;

    // Mapping to store ticket information
    mapping(uint256 => Ticket) public tickets;

    constructor(address _currencyToken) ERC721("FestivalTicket", "FT") {
        currencyToken = _currencyToken;
        organizer = msg.sender; // Initialize the organizer variable with the contract deployer's address
    }

    modifier onlyTicketOwner(uint256 tokenId) {
        require(ownerOf(tokenId) == msg.sender, "You don't own this ticket");
        _;
    }

    modifier ticketsAvailable() {
        require(currentTicketId <= maxTickets, "No more tickets available");
        _;
    }

    function setOrganizerCutPercentage(uint256 _cutPercentage) external onlyOwner {
        organizerCutPercentage = _cutPercentage;
    }
     
    ////1. You can buy tickets from the organizer at a fixed price in the currency token. 
    function ticketPrice() public pure returns (uint256) {
        // Fixed price of 1 ether
        return 1 ether;
    }

    function buyTicket() external payable ticketsAvailable {
        // Ensure the sent Ether matches or exceeds the current ticket price.
        //allows users to purchase tickets by sending Ether, 
        //and it checks if the sent Ether matches or exceeds the fixed price:
        uint256 currentTicketPrice = ticketPrice();
        require(msg.value == currentTicketPrice, "Insufficient funds");

        // Mint the ticket and record its information
        _mint(msg.sender, currentTicketId);
        tickets[currentTicketId] = Ticket(currentTicketPrice, msg.sender);
        currentTicketId++;
    }

    function sellTicket(address to, uint256 tokenId, uint256 price) external onlyTicketOwner(tokenId) {
        // Ensure the selling price doesn't exceed 110% of the previous sale price.
        //the selling price doesn't exceed 110% of the previous sale price.
        //It calculates the maximum price allowed as follows:
        uint256 maxPrice = tickets[tokenId].price.mul(priceIncreasePercentage).div(100);
        require(price <= maxPrice, "Price cannot exceed 110% of the previous sale price");

        //calculates the amount that goes to the organizer, 
        //which is defined as 5% (organizerCutPercentage) of the sale price. 
        //The organizer receives this cut when someone sells a ticket in the secondary market.
        uint256 organizerCut = price.mul(organizerCutPercentage).div(100);
        uint256 sellerProceeds = price.sub(organizerCut);

        // Transfer tokens accordingly.
        IERC20(currencyToken).transferFrom(msg.sender, address(this), price);
        IERC20(currencyToken).transfer(organizer, organizerCut);
        IERC20(currencyToken).transfer(to, sellerProceeds);

        // Transfer ownership of the token.
        safeTransferFrom(msg.sender, to, tokenId);

        // Update the ticket's owner and price.
        tickets[tokenId].owner = to;
        tickets[tokenId].price = price;
    }
}
