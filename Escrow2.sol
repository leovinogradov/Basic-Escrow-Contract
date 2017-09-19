pragma solidity ^0.4.11;

contract Escrow {
  struct instance {
    address buyer;
    address seller;
    bytes32 contractHash;
    uint deadline;
    uint instanceBalance;
	}
	mapping(uint => instance) EscrowInstances;
	uint numInstances;

  function Escrow(address _seller, bytes32 _contractHash) payable returns (uint instanceID) {
    instanceID = numInstances++;
		EscrowInstances[instanceID].buyer = msg.sender;
    EscrowInstances[instanceID].seller = _seller;
    EscrowInstances[instanceID].contractHash = _contractHash;
    EscrowInstances[instanceID].deadline = block.number + 60480; //this is roughly two weeks
    EscrowInstances[instanceID].instanceBalance = msg.value;
  }

  function payoutToSeller(uint id, uint key) {
    instance i = EscrowInstances[id];
    if(sha3(key) == i.contractHash) {
      if(!i.seller.send(i.instanceBalance)) {
        require(false);
      }
    }
  }

  function refundToBuyer(uint id) {
    instance i = EscrowInstances[id];
    if(msg.sender == i.seller) {
      // seller gives refund
      if (!i.buyer.send(i.instanceBalance)) {
        require(false);
      }
    } else if (block.number >= i.deadline && msg.sender == i.buyer) {
      // buyer demands refund after deadline has passed
      if (!buyer.send(i.instanceBalance)){
        require(false);
      }
	}
  }

  function getBalance(uint id) constant returns (uint) {
    instance i = EscrowInstances[id];
    return i.instanceBalance;
  }

  function getContractBalance() constant returns (uint) {
    // get the balance of the whole contract
    return this.balance;
  }

}
