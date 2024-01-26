// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract RockPaperScissors {

    //Use to store the user information
    struct UserInfo{
        address userAddress;  //store particular user address
        uint userOption; // store user's option
    }

    //Use to store the game information
    struct GameInfo{
        UserInfo user1;  //store user1 information
        UserInfo user2;  //store user2 information
        string finalResult;  //store game result
    }

    uint private userCount = 0; // count the user for condition check
    GameInfo[] private gameHistory; // store all game history
    bool private locked;  // declear the lock of critical section code
    address public user1address;
    address public user2address;

    //setting the event to track the progress
    event showUserAddress(address indexed logUserAddress);
    event showResult(string logResult); 
    event showError(string);
    event inputOption(address user1, address user2);

    function getUser1 (uint index) external view returns(UserInfo memory){
        //do condition check then return the data
        require(index <= gameHistory.length, "Error: Invalid length");
        return (gameHistory[index].user1);
    }

    //for front end to check the length
    function getGameHistoryLength() external view returns(uint){
        return (gameHistory.length);
    }
    
    //use to testing, check the array data
    function getGameHistory () external view returns(GameInfo[] memory){
        //do condition check then return the data
        return (gameHistory);
    }

    function getSpecificGameHistory (uint index) external view returns(GameInfo memory){
        //do condition check then return the data
        require(index <= gameHistory.length, "Error: Invalid length");

        return (gameHistory[index]);
    }

    //lock of critical section code
    //but now problem is it may reject transaction
    modifier noReentrancy() {
        require(!locked, "Error: Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    //check the user information
    //If there are two users waiting, tell both 2 user can choose the option and start the game.
    function play () external noReentrancy{

        if(userCount == 0){
            //when no user in the queue, create a new gameInfo and push to array
            GameInfo memory gameInfo;
            gameHistory.push(gameInfo); 
            //Store the user1 information to gameInfo to gameHistory
            gameHistory[gameHistory.length - 1].user1.userAddress = msg.sender;
            user1address = msg.sender;

            //count user 
            userCount++;
        }
        else{
            //Check whether the users are the same person
            require(msg.sender != gameHistory[gameHistory.length - 1].user1.userAddress,"Error: You cannot play with yourself");
            require(userCount<2, "You need to wait for the pervious user");

            //Store the user2 information to array.
            gameHistory[gameHistory.length - 1].user2.userAddress = msg.sender;
            user2address = msg.sender;
            //gameHistory[gameHistory.length - 1].user2.userOption = option;
            
            //let user input the option
            emit inputOption(gameHistory[gameHistory.length - 1].user1.userAddress , gameHistory[gameHistory.length - 1].user2.userAddress);
            //userCount = 0;
            userCount++;
        }
    }

    //Wait for user input their option
    function userEnterOption (uint option) external {
        if(msg.sender == gameHistory[gameHistory.length - 1].user1.userAddress){
            require(gameHistory[gameHistory.length - 1].user1.userOption == 0, "You already select option and it cannot change");
            gameHistory[gameHistory.length - 1].user1.userOption = option;
        }
        else{
            if(msg.sender == gameHistory[gameHistory.length - 1].user2.userAddress){
                require(gameHistory[gameHistory.length - 1].user2.userOption == 0, "You already select option and it cannot change");
                gameHistory[gameHistory.length - 1].user2.userOption = option;
            }      
        }

        //check both user already give the option
        if((gameHistory[gameHistory.length - 1].user1.userOption) != 0 && (gameHistory[gameHistory.length - 1].user2.userOption) != 0){
            emit showError("go in to condition check");
            game();
            userCount = 0;
            user1address = address(0);
            user2address = address(0);
        }
    }


    //game logic check
    function game () private {

        //check who wins the game and store final result in array(game history)
        // 1 = Rock 2 = Paper 3 = Scissors
        if (gameHistory[gameHistory.length - 1].user1.userOption == gameHistory[gameHistory.length - 1].user2.userOption) {
            gameHistory[gameHistory.length - 1].finalResult = "Tied";
            emit showResult("Tied");
        }
        else {
            if (
                (gameHistory[gameHistory.length - 1].user1.userOption == 1 && gameHistory[gameHistory.length - 1].user2.userOption == 2) ||
                (gameHistory[gameHistory.length - 1].user1.userOption == 3 && gameHistory[gameHistory.length - 1].user2.userOption == 1) ||
                (gameHistory[gameHistory.length - 1].user1.userOption == 2 && gameHistory[gameHistory.length - 1].user2.userOption == 3)
            ) {
                gameHistory[gameHistory.length - 1].finalResult = "User2 win";
                emit showResult("User2 win");
            } else {
                gameHistory[gameHistory.length - 1].finalResult = "User1 win";
                emit showResult("User1 win");
            }
        }
    }
}