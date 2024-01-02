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
    UserInfo[] private waitingPoll; 

    //setting the event to track the progress
    event showUserAddress(address indexed logUserAddress);
    event showResult(string logResult); 
    event showError(string);

    function getUserOption(uint option) external {
        emit showUserAddress(msg.sender);
        //check user input
        require(option != 0, "Error: Can't input 0");
        require(option <= 3, "Error: Can't input more than 3");  

        UserInfo memory userinfo;
        waitingPoll.push(userinfo);
        waitingPoll[waitingPoll.length - 1].userAddress = msg.sender;
        waitingPoll[waitingPoll.length - 1].userOption = option;

        if(waitingPoll.length == 4){
            //go to game logic
        }
    }

    function newgame () private {
        do {
            UserInfo memory user1 = ChooseRandomUser();
            UserInfo memory user2 = ChooseRandomUser();
        } 
        while (waitingPoll.length == 0);
        //choose 2 player to play the game

        //store result and go to next one
    }

    function ChooseRandomUser () private  returns (UserInfo memory){
        require(waitingPoll.length > 0, "Array is empty");

        // Generate a pseudo-random index based on block information
        uint256 randomIndex = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, salt))) % waitingPoll.length;
        salt++;
        // Get the randomly selected element
        UserInfo memory randomUser = waitingPoll[randomIndex];

        // Remove the selected element by swapping it with the last element and then reducing the array size
        waitingPoll[randomIndex] = waitingPoll[waitingPoll.length - 1];
        waitingPoll.pop();

        return randomUser;
    }

    // function getRandomNumber() public returns (uint256) {
    //     // Increment the seed based on certain parameters
    //     uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, blockhash(block.number - 1))));

    //     // Use the seed to generate three random numbers
    //     uint256 random1 = uint256(keccak256(abi.encodePacked(seed, salt)));
    //     salt += 1;
    //     // Get a random number between 1 and 3
    //     return random1 % waitingPoll.length;
    // }

    // 1/2/2024

    function getUser1 (uint index) external view returns(UserInfo memory){
        //do condition check then return the data
        require(index <= gameHistory.length, "Error: Invalid length");
        return (gameHistory[index].user1);
    }
    
    //use to testing, check the array data
    function getGameHistory () external view returns(GameInfo[] memory){
        //do condition check then return the data
        return (gameHistory);
    }

    function getSpecificGameHistory (uint index) external view returns(GameInfo memory){
        //do condition check then return the data
        require(index <= gameHistory.length, "Error: Invalid length");

        //Avoid the second user to check the user1 option and choose the option that is favourable to user2
        require(gameHistory[index].user2.userAddress != address(0), "Error: The game not finish yet");

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
    //If there are two users waiting, it triggers the game to start.
    function play (uint option) external noReentrancy{
        emit showUserAddress(msg.sender);
        //check user input
        require(option != 0, "Error: Can't input 0");
        require(option <= 3, "Error: Can't input more than 3");  
        
        if(userCount == 0){
            //when no user in the queue, create a new gameInfo and push to array
            GameInfo memory gameInfo;
            gameHistory.push(gameInfo); 
            //Store the user1 information to gameInfo which just created.
            gameHistory[gameHistory.length - 1].user1.userAddress = msg.sender;
            gameHistory[gameHistory.length - 1].user1.userOption = option;

            //count user 
            userCount++;
        }
        else{
            //Check whether the users are the same person
            require(msg.sender != gameHistory[gameHistory.length - 1].user1.userAddress,"Error: You cannot play with yourself");

            //Store the user2 information to array.
            gameHistory[gameHistory.length - 1].user2.userAddress = msg.sender;
            gameHistory[gameHistory.length - 1].user2.userOption = option;
            
            //Trigger game condition
            game();
            userCount = 0;

        }
        // Q: How can i solve the third person coming when game is excuting and userCount still not equal to 0
        // A: No need to worry this, the user is assign by blockchain one by one. 
        // Even they come in the same time. Which transaction done first, that will be the correct one.
        // But still need to avoid the Race condition. 
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