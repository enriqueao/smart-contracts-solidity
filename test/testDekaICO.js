const DekaICO = artifacts.require("DekaICO");
const DekaToken = artifacts.require("DekaToken");

contract("DekaICO", function(accounts){
  const addressTokenHolder1 = accounts[0];
  const addressEther = accounts[3];

  let dekaToken;
  let dekaICO;

  it("Deploys all contracts", async function() {
    dekaToken = await DekaToken.new();
    dekaICO = await DekaICO.new();

    await dekaToken.changeController(dekaICO.address);

    await dekaICO.initialize(
        dekaToken.address,
        addressEther
    );
  });

  it("Does the first buy", async function() {
    // const etherTH1before = await web3.eth.getBalance(addressTokenHolder1);
    // console.log(web3.fromWei(etherTH1before).toNumber());

    await dekaToken.sendTransaction({
      value: web3.toWei(1),
      gas: 300000,
      gasPrice: "20000000000",
      from: addressTokenHolder1
    });

    // const etherTH1after = await web3.eth.getBalance(addressTokenHolder1);
    // console.log(web3.fromWei(etherTH1after).toNumber());

    const balance = await dekaToken.balanceOf(addressTokenHolder1);
    const totalEth = await web3.eth.getBalance(addressEther);

    assert.equal(web3.fromWei(balance).toNumber(), 10);
    assert.equal(web3.fromWei(totalEth).toNumber(), 1);
  });


});
