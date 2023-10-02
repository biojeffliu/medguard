// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract UndeletableMessage {
  string public message;
  address public messenger;

  constructor(string memory _message, address _messenger) {
    message = _message;
    messenger = _messenger;
  }

  modifier onlyMessenger() {
    require(msg.sender == messenger, "Only the messenger can call this function");
    _;
  }

  function setMessage(string memory newMessage) external onlyMessenger {
    message = newMessage;
  }
}