// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract RockPaperScissors {
    //enum State{Rock, Paper, Scissors}
    uint public lastChoice;

    uint public playerOption;
    uint[] public Options;
    uint[] public randomNumSet;
    uint public salt = 1;

    function enterOption(uint256 userInput) external {
        require(userInput <= 3, "Error: Can't input more than 3");
        playerOption = userInput;
        Options.push(playerOption);
    }

    function playMutiTimes() 
        external 
        returns (uint[] memory result) {
            
            //uint totalNunber = 
            for(uint i = 0; i < 3; i++){
                randomNumSet.push(getRandomNumber());
            }



    
        return (Options);
    }

    //declear user 1 and 2
    // uint256 public user1Choose;
    // uint256 public user2Choose;

    //what they want to choose
    function play(uint256 option) 
        external 
        returns (string memory result) {
        uint256 randomChoice = getRandomNumber();
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

    function getRandomNumber() public returns (uint256) {
        // Increment the seed based on certain parameters
        // uint256 seed = uint256(
        //     keccak256(abi.encodePacked(block.timestamp, block.number))
        // );

        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, blockhash(block.number - 1))));
         
        // Use the seed to generate three random numbers
        uint256 random1 = uint256(keccak256(abi.encodePacked(seed, salt)));
        salt += 1;
        // Get a random number between 1 and 3
        return (random1 % 3) + 1;
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
