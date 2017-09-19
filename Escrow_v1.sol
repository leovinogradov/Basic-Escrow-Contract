pragma solidity ^0.4.11;

contract Escrow {

  address public buyer;
  address public seller;
  bytes32 public contractHash;
  uint public deadline;

  function Escrow(address _seller, bytes32 _contractHash) {
    buyer = msg.sender;
    seller = _seller;
    contractHash = _contractHash;
    deadline = block.number + 60480; //this is roughly two weeks
  }

  function payoutToSeller(uint key) {
    if(sha3(key) == contractHash) {
      seller.transfer(this.balance);
    }
  }

  function refundToBuyer() {
    if(msg.sender == seller) {
      buyer.transfer(this.balance);
    }
  }

  function notDelivered() {
		if (block.number >= deadline && msg.sender == buyer){
			buyer.transfer(this.balance);
		}
	}

  function getBalance() constant returns (uint) {
    return this.balance;
  }

}
