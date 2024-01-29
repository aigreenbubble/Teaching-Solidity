// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract TickTackToe{
    struct GameInfo{
        bool _activate;
        string _currentPlayer;
        string[] _options;
        address _player1address;
        address _player2address;
        uint _playerCount;
        //game id?
    }

    //validate the user
    address public player1address; //store user 1 address
    address public player2address; //store uesr 2 address
    uint public playerCount = 0; //count current user

    //User 1 set to X    User 2 set to O     
    // basic game logic
    string[] public options = ["", "", "", "", "", "", "", "", ""]; //options to store player option
    uint[] public finalWinOption;
    bool public activate = false; // initial game status is false
    string public currentPlayer = "X"; // frist player is X
    uint[][] private winConditionSet=  
    [[0, 1, 2], 
    [3, 4, 5],      //set all win condition
    [6, 7, 8],      // tick tack toe grid
    [0, 3, 6],      // 0 1 2
    [1, 4, 7],      // 3 4 5
    [2, 5, 8],      // 6 7 8
    [0, 4, 8],
    [2, 4, 6]]; 

    event showResult (string result); // send the game result to UI
    event startGame(string message, address player1, address player2); // send the player in this metch
    event nextUser(address nextUser); // send next user address
    event updateUI(string[] options); // send message to update UI
    event nextUesrStr(string next);   // send next uesr (X or O)
    event resetUI(string initPLayer); // use to trigger UI reset function   
    event showFirstPlayer(address player1Address);

    // for UI to get option array
    function getoption () external view returns (string[] memory){
        return options;
    }

    // for UI to get finalWinOption array
    function getFinalWinOption () external view returns (uint[] memory){
        return finalWinOption;
    }

    // user queue
    function joinGame () external {
        //allow player to join if player not more than 2 
        if(playerCount == 0){
            restartGame();
            player1address = msg.sender;
            playerCount++;
            emit showFirstPlayer(player1address);
        }else if(playerCount == 1){
            require((msg.sender != player1address), "Error: You cannot play with yourself");
            player2address = msg.sender;
            playerCount++;
            activate = true;
            //send message to inform the player start game
            emit startGame("Start game!", player1address, player2address);
        }else{
            //if player more than 2, send the message to UI
            require(playerCount < 2,"Now queue is full, try later");
        }
    } 

    // basic game logic
    // check player input and ensure the input is from correct player 
    function userInput(uint input) external {
        require(activate,"The game still not start yet");               //check game status
        require(compareStrings(options[input],""),"Invalid input");     //check the input
        //check player
        if(compareStrings(currentPlayer, "X")){
            require(msg.sender == player1address,"You are not player 1");
        }else{
            require(msg.sender == player2address,"You are not player 2");
        }
        
        options[input] = currentPlayer; //if both no problem, just put into options
        emit updateUI(options);         //sned data for UI display
        checkWinner();                  //check the win condition
    }
    // use to check the win, draw  
    function checkWinner () private {
        bool userWon = false;  //condition to check game status
        //get the win condition on array and do the condition check
        for(uint i = 0 ; i < winConditionSet.length; i++){
            uint[] memory winCondition = winConditionSet[i];
            //get the win condition and check the element
            string memory resultA= options[winCondition[0]];
            string memory resultB= options[winCondition[1]];
            string memory resultC= options[winCondition[2]];
            // tick tack toe grid
            // 0 1 2
            // 3 4 5
            // 6 7 8
            //compare the option on the array
            //if all are same, then that player win
            if(compareStrings(resultA, "")||compareStrings(resultB, "")||compareStrings(resultC, "")){
                continue;
            }
            if(compareStrings(resultA, resultB) && compareStrings(resultB, resultC)){
                finalWinOption = winCondition;
                userWon = true;
                break;
            }
        }
        //if someone win or draw, send message to UI
        //else change player and go to next round
        if(userWon){
            //sent winer to info UI
            emit showResult(currentPlayer);
            //reset attribute
            activate = false;
            playerCount = 0;
        } else if(checkOptions()){
            // send Draw message to UI
            emit showResult("Draw");
            //reset attribute
            activate = false;
            playerCount = 0;
        } else {
            //change to next player
            changePlayer();
        }
    }
    //change player per round
    function changePlayer() private {
        //send the change message to UI
        if(compareStrings(currentPlayer, "X")){
            emit nextUser(player2address);
        }else{
            emit nextUser(player1address);
        }
        //change the player
        currentPlayer = (compareStrings(currentPlayer, "X")) ? "O" : "X";
        //sent the player info to UI
        emit nextUesrStr(currentPlayer);
    }

    // Use to check if there are any empty options.
    function checkOptions() private view returns (bool) {
        //check each element in options array
        //if include any "" return false, else return true
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

    //use to reset game information
    function restartGame() public {
        currentPlayer = "X";
        options = ["", "", "", "", "", "", "", "", ""];
        emit resetUI(currentPlayer);
        playerCount = 0;
        activate = false;
        player1address = address(0);
        player2address = address(0);
        delete finalWinOption;
    }

}