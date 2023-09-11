const FestivalTicketNFT = artifacts.require("FestivalTicketNFT");
const CurrencyToken = artifacts.require("CurrencyToken");

contract("FestivalTicketNFT", (accounts) => {
  let ticketContract;
  let currencyContract;
  const organizer = accounts[0];
  const buyer1 = accounts[1];
  const buyer2 = accounts[2];

  beforeEach(async () => {
    currencyContract = await CurrencyToken.new({ from: organizer });
    ticketContract = await FestivalTicketNFT.new(currencyContract.address, { from: organizer });
  });

  it("should allow buying tickets from the organizer at a fixed price", async () => {
    const ticketPrice = await ticketContract.ticketPrice();

    await ticketContract.buyTicket({ from: buyer1, value: ticketPrice });

    const buyer1TicketBalance = await ticketContract.balanceOf(buyer1);

    assert.equal(buyer1TicketBalance.toNumber(), 1, "Buyer1 should own 1 ticket");
  });

  it("should allow buying and selling tickets to others within price limit", async () => {
    const ticketPrice = await ticketContract.ticketPrice();
    const increasedPrice = ticketPrice.muln(110).divn(100); // Calculate increased price

    await ticketContract.buyTicket({ from: buyer1, value: ticketPrice });

    await ticketContract.sellTicket(buyer2, 1, increasedPrice, { from: buyer1 });

    const buyer1Balance = await currencyContract.balanceOf(buyer1);
    const buyer2Balance = await currencyContract.balanceOf(buyer2);
    const buyer2TicketBalance = await ticketContract.balanceOf(buyer2);

    assert.equal(buyer1Balance.toString(), ticketPrice.toString(), "Buyer1 should receive payment for the ticket");
    assert.equal(buyer2Balance.toString(), increasedPrice.toString(), "Buyer2 should pay the correct price");
    assert.equal(buyer2TicketBalance.toNumber(), 1, "Buyer2 should own 1 ticket");
  });

  it("should not allow selling tickets above the price limit", async () => {
    const ticketPrice = await ticketContract.ticketPrice();
    const exceededPrice = ticketPrice.muln(110).divn(100).addn(1); // Exceeds the price limit

    await ticketContract.buyTicket({ from: buyer1, value: ticketPrice });

    try {
      await ticketContract.sellTicket(buyer2, 1, exceededPrice, { from: buyer1 });
      assert.fail("Transaction should revert");
    } catch (error) {
      assert(error.toString().includes("Price cannot exceed 110% of the previous sale price"), "Error message should match");
    }
  });

  it("should allow the organizer to set a resale fee", async () => {
    const newCutPercentage = 10; // Set a new resale fee of 10%

    await ticketContract.setOrganizerCutPercentage(newCutPercentage, { from: organizer });

    const cutPercentage = await ticketContract.organizerCutPercentage();

    assert.equal(cutPercentage.toNumber(), newCutPercentage, "Resale fee should be updated");
  });
});
