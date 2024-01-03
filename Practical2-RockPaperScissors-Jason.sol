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

    // 1/2/2024
    uint private salt = 1;
    UserInfo[] public waitingPool;  // Store the player data in array temporary

    //setting the event to track the progress
    event showUserAddress(address indexed logUserAddress);
    event showResult(string logResult); 
    event showError(string);
    event showArraylenght(uint);

    function showWaitingPoll () external view returns (UserInfo[] memory) {
        return (waitingPool);
    }

        //Testing purpose, check the array data
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

    function getUserOption(uint option) external noReentrancy{
        emit showUserAddress(msg.sender);
        //check user input
        require(option != 0, "Error: Can't input 0");
        require(option <= 3, "Error: Can't input more than 3");  

        //check the user is inside the array
        //Question: Do i need to allow user join in same match and do some logic check to let user play with other?
        bool exist;
        for (uint i = 0; i < waitingPool.length; i++) 
        {
            if(msg.sender == waitingPool[i].userAddress){
                exist = true;
                require(!exist, "Error: You already in the queue, wait for other play join"); 
            }
        }
        
        // store the user info to the poll and wait for other user join
        UserInfo memory userinfo;
        waitingPool.push(userinfo);
        waitingPool[waitingPool.length - 1].userAddress = msg.sender;
        waitingPool[waitingPool.length - 1].userOption = option;

        // trigger the game start condition
        if(waitingPool.length == 6){
            //go to game logic
            choosePlayerPlay();
        }
    }


    function choosePlayerPlay () private {
        
        do {
            //Random choose 2 player to play the game
            //if want to allow same user play in the same match, add check condition here.
            UserInfo memory user1 = ChooseRandomUser();
            UserInfo memory user2 = ChooseRandomUser();

            //play game, store result and go to next one
            game(user1, user2);
        } 
        while (waitingPool.length != 0);
        emit showArraylenght(waitingPool.length);

    }

    function ChooseRandomUser () private returns (UserInfo memory){
        require(waitingPool.length > 0, "Array is empty");

        // Generate a pseudo-random index based on block information
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, salt))) % waitingPool.length;
        salt++;
        // Get the randomly selected element
        UserInfo memory randomUser = waitingPool[randomIndex];

        // Remove the selected element by swapping it with the last element and then reducing the array size
        waitingPool[randomIndex] = waitingPool[waitingPool.length - 1];
        waitingPool.pop();

        return randomUser;
    }

    function game (UserInfo memory userOne, UserInfo memory userTwo) private {

        // init a gameinfo and push to gameHistory array
        GameInfo memory gameinfo;
        gameHistory.push(gameinfo);
        // store user information to gameHistory array
        gameHistory[gameHistory.length - 1].user1 = userOne;
        gameHistory[gameHistory.length - 1].user2 = userTwo;

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

    // 1/2/2024

    

}