// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract RockPaperScissors {

    //Use to store the user information
    struct UserInfo{
        address userAddress;
        uint userOption;
    }

    //Use to store the game information
    struct GameInfo{
        UserInfo user1;
        UserInfo user2;
        string finalResult;
    }


    //enum State{Rock, Paper, Scissors}
    uint public lastChoice = 800;

    uint[] public Options;
    uint[] public randomNumSet;
    uint salt = 1;
    uint public userWin;
    uint public systemWin;
    uint public tied;

    //for testing 
    function cleanAll () external {
        delete Options;
    }

    //get user input and push to array
    function enterOption(uint256 userInput) external returns (uint[] memory result){
        require(userInput <= 3, "Error: Can't input more than 3");
        Options.push(userInput);
        // 1 = Rock 2 = Paper 3 = Scissors
        return (Options);
    }

    //use to check the random set generate by system
    function getRandomSet () external view returns (uint[] memory result){
        return (randomNumSet);
    }

    //game logic checking
    //How many round is depand on user input
    function playMutiTimes()  
        public 
        returns (string memory result) {
            //init the parameters
            delete randomNumSet;
            tied = 0;
            systemWin = 0;
            userWin = 0;

            //generate the random number set
            for(uint i = 0; i < Options.length; i++){
                randomNumSet.push(getRandomNumber());
                //randomNumSet.push(1);
            }
            
            //compare the results
            for(uint i = 0; i < Options.length; i++){
                if (Options[i] == randomNumSet[i]) {
                    tied++;
                    continue; 
                }
                if (
                    // 1 = Rock 2 = Paper 3 = Scissors
                    (Options[i] == 1 && randomNumSet[i] == 2) ||
                    (Options[i] == 3 && randomNumSet[i] == 1) ||
                    (Options[i] == 2 && randomNumSet[i] == 3)
                ) {
                   systemWin++;
                } else {
                    userWin++;
                }
                
                //Check the current wins for both sides, and if one side has won more than 50% of the total rounds, that side wins the game.
                // if(userWin == systemWin)
                //     continue;
                if(userWin > systemWin){
                    //cacluate the percentage and check it.
                    uint winTimeRate = (userWin*100)/Options.length;
                    if(winTimeRate > 50)
                        return ("You Win");
                } else {
                    uint winTimeRate = (systemWin*100)/Options.length;
                    if(winTimeRate > 50)
                        return ("You Lose");
                }

            }

            //Judge who wins
            if(userWin == systemWin)
                return ("Tied");
            // if(userWin > systemWin){
            //     return("You Win");
            // } else {
            //     return ("You Lose");
            // }
        //return ("something worng");    
    }
    
    // User guess the final result
    //1 = Tied 2 = User Win 3 = User Lose
    function guessResult(uint guessAnswer) external returns  (string memory result){
        require(guessAnswer <= 3, "Error: Can't input more than 3");
        string memory getResult = playMutiTimes(); 
        uint intResult;
        string[3] memory possibleResult = ["Tied", "You Win", "You Lose"];

        for(uint i = 0; i < possibleResult.length; i++){
            if(compareStrings(possibleResult[i], getResult)){
                intResult = i+1;
                break;
            }
                
        }

        //convert string to int
        //improve use array later
        // if(compareStrings("Tied", getResult))
        //     intResult = 1;
        // if(compareStrings("You Win", getResult))
        //     intResult = 2;
        // if(compareStrings("You Lose", getResult))
        //     intResult = 3;

        if(intResult == guessAnswer){
            return ("You guess is correct");
        } else {
            return ("You guess is wrong");
        }
    }

    //using hash function to compare the string.
    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        //Use bytes32 to store the result from keccak256 hash function
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

    //declear user 1 and 2
    // uint256 public user1Choose;
    // uint256 public user2Choose;

    //One round
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
