// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract MyGuessNumberGame {
    uint256 public targetNumber;
    uint256 public guessNumber;
    bool win; // Default value is false
    address payable public treasury =
        payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);

    function setTargetNumber(uint256 newTargetNubmer) external {
        targetNumber = newTargetNubmer;
    }

    function setGuessNumber(uint256 newGuessNumber) public {
        guessNumber = newGuessNumber;
    }

    // function processUserInput(uint _inputValue) public pure returns (uint) {
    //     // Process the user input, you can do any logic here
    //     return _inputValue;
    // }

    function logicCheck() external payable returns (string memory) {
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

        if (win) return ("You win!!");
        else {
            require(msg.value >= 100, "Error: Send 100 wei!");
            bool success = treasury.send(msg.value);
            require(success, "Failed to send");
            return ("You loss");
        }
    }
}

contract RockPaperScissors {
    //enum State{Rock, Paper, Scissors}

    //declear user 1 and 2
    // uint256 public user1Choose;
    // uint256 public user2Choose;
    uint public lastChoice;

    //what they want to choose
    function play(uint256 option)
        external
        returns (string memory result)
    {
        uint randomChoice = getRandomNumber();
        lastChoice = randomChoice;

        require(option <= 3, "Error: Can't input more than 3");
        // 1 = Rock 2 = Paper 3 = Scissors
        if (option == randomChoice) {
            return ("Tied");
        }
        if (
            (option == 1 && randomChoice == 2) ||
            (option == 3 && randomChoice == 1) ||
            (option == 2 && randomChoice == 3)
        ) {
            return ("You lose");
        } else {
            return ("You won");
        }
    }

    function getRandomNumber() public view returns (uint256) {
        // Increment the seed based on certain parameters
        uint256 seed = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.number))
        );

        // Get a random number between 1 and 3
        return (seed % 3) + 1;
    }

    // function user2Dicision(uint256 decisionofRockPaperScissors) external {
    //     require(
    //         decisionofRockPaperScissors <= 3,
    //         "Error: Can't input more than 3"
    //     );
    //     user2Choose = decisionofRockPaperScissors;
    // }

    //logic checking
    // 1 = Rock 2 = Paper 3 = Scissoes
    // function logicCheck() external view returns (string memory) {
    //     // if (user1Choose == 1) {
    //     //     if (user2Choose == 1) return ("Tie");
    //     //     if (user2Choose == 2) return ("User2 Win!");
    //     //     else return ("User1 Win!");
    //     // }
    //     // if (user1Choose == 2) {
    //     //     if (user2Choose == 2) return ("Tie");
    //     //     if (user2Choose == 3) return ("User2 Win!");
    //     //     else return ("User1 Win!");
    //     // }
    //     // if (user1Choose == 3) {
    //     //     if (user2Choose == 3) return ("Tie");
    //     //     if (user2Choose == 1) return ("User2 Win!");
    //     //     else return ("User1 Win!");
    //     // }
    //     if (user1Choose == user2Choose) {
    //         return ("Tied");
    //     }

    //     return ("something wrong");
    // }
}
