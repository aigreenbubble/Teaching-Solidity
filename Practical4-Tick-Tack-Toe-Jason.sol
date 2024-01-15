// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract TickTackToe{
    //validate the user
    address public player1address; //store user 1 address
    address public player2address; //store uesr 2 address
    uint playerCount = 0;

    //User 1 set to X    User 2 set to O     
    // basic game logic
    string[] public options = ["", "", "", "", "", "", "", "", ""];
    bool activate = true;
    string currentPlayer = "X";
    uint[][] private winConditionSet= 
    [[0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]];
    
    event showResult (string result);
    event queueFull(string message);
    event metchSuccessful(string message);
    event startGame(string message, address player1, address player2);
    event nextUser(address nestUser);

    function getoption () external view returns (string[] memory){
        return options;
    }

    // user queue
    function joinGame () external {
        if(playerCount == 0){
            player1address = msg.sender;
            playerCount++;
        }else if(playerCount == 1){
            require((msg.sender != player1address), "Error: You cannot play with yourself");
            player2address == msg.sender;
            playerCount++;
            //send message to inform the player
            emit startGame("Start game!", player1address, player2address);
        }else{
            emit queueFull("Now queue is full, try later");
        }
    } 

    // basic game logic
    function userInput(uint input) external {
        require(activate,"The game still not start yet");
        require(compareStrings(options[input],""),"Invalid input");
        options[input] = currentPlayer;

        checkWinner();
    }

    function checkWinner () private {
        bool userWon = false;
        for(uint i = 0 ; i < winConditionSet.length; i++){
            uint[] memory winCondition = winConditionSet[i];
            string memory resultA= options[winCondition[0]];
            string memory resultB= options[winCondition[1]];
            string memory resultC= options[winCondition[2]];

            if(compareStrings(resultA, "")||compareStrings(resultB, "")||compareStrings(resultC, "")){
                continue;
            }
            if(compareStrings(resultA, resultB) && compareStrings(resultB, resultC)){
                userWon = true;
                break;
            }
        }

        if(userWon){
            //sent message
            emit showResult(currentPlayer);
            activate = false;
        } else if(checkOptions()){
            emit showResult("Draw");
        } else {
            if(compareStrings(currentPlayer, "X")){
                emit nextUser(player2address);
            }else{
                emit nextUser(player1address);
            }
            changePlayer();
        }
    }

    function changePlayer() private {
        //change the player per round
        currentPlayer = (compareStrings(currentPlayer, "X")) ? "O" : "X";
    }

    function checkOptions() private view returns (bool) {
        for(uint i = 0 ; i < options.length; i++){
            if(compareStrings(options[i], "")){
                return false;
            }
        }
        return true;
    }


    //using hash function to compare the string.
    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        //Use bytes32 to store the result from keccak256 hash function
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }


    function restartGame() external {
        currentPlayer = "X";
        options = ["", "", "", "", "", "", "", "", ""];
        activate = true;
    }

}