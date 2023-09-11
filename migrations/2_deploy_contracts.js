const FestivalTicketNFT = artifacts.require("./FestivalTicketNFT.sol");
const CurrencyToken = artifacts.require("./CurrencyToken.sol");

module.exports = async function (deployer, network, accounts) {
  // Deploy the CurrencyToken contract
  await deployer.deploy(CurrencyToken);
  const currencyTokenInstance = await CurrencyToken.deployed();

  // Deploy the FestivalTicketNFT contract, passing the address of the CurrencyToken contract as a parameter
  await deployer.deploy(FestivalTicketNFT, currencyTokenInstance.address);
};
