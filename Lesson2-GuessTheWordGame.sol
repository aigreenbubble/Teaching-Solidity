// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract GuessTheWord {
    uint guessWord;

    uint attemptPrice = 100;

    address payable public treasury = payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);

    function setGuessWord(uint newWord) external {
        guessWord = newWord;
    }

    function guessTheWord(uint _guessWord) external payable returns(bool){
        require(msg.value >= attemptPrice, "Error: Send 100 wei!");

        bool success = treasury.send(msg.value);
        require(success, "Failed to send");

        if(_guessWord == guessWord) {
            return true;
        } else {
            revert ("you are wrong");
        }
    }
}