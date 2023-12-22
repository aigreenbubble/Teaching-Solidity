// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// let user to guess the random number 1 - 5. 
contract MyGuessNumberGame {
    uint256 public targetNumber;
    uint public maxNumber;
    uint public minNumber;

    uint public number;

    bool win; // Default value is false
    address payable public treasury =
        payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
        
    function setMaxNumber (uint _maxNumber) external {
        maxNumber = _maxNumber;
    }

    function setMinNumber (uint _minNumber) external {
        minNumber = _minNumber;
    }

    function getRandomNumber() public view returns (uint256) {
        // Increment the seed based on certain parameters
        uint256 seed = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.number))
        );

        // Get a random number between miniman and maximin
        return (seed % (maxNumber-minNumber+1)) + minNumber;
    }

    //testing purpose 
    function getnumber () external {
        number = getRandomNumber();
    }


    // function processUserInput(uint _inputValue) public pure returns (uint) {
    //     // Process the user input, you can do any logic here
    //     return _inputValue;
    // }

    function logicCheck(uint guessNumber) external payable returns (string memory) {
        targetNumber = getRandomNumber();
        if (guessNumber == targetNumber) {
            win = true;
        }

        // for (uint256 i = 1; i <= 5; i++)
        // {
        //     // Get the user real time input. Cannot do that.
        //     //uint newGuessNumber = processUserInput(uint _inputValue);
        //     //setGuessNumber();
        //     if(guessNumber == targetNumber){
        //         win = true;
        //     }
        // }

        if (win) 
            return ("You win!!");
        else {
            require(msg.value >= 0, "Error: Send 100 wei!");
            bool success = treasury.send(msg.value);
            require(success, "Failed to send");
            return ("You loss");
        }
    }
}

