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

    //declare user
    UserInfo public _user1;
    UserInfo public _user2;
    uint public userCount = 0; // count the user for condition check
    GameInfo[] private gameHistory; // store all game history
    bool private locked;  // declear the lock of critical section code
    uint public gameCount; // count how many game

    //setting the event to track the progress
    event showUserAddress(address indexed logUserAddress);
    event showResult(string logResult); 
    event showError(string);
    
    //use to testing, check the array data
    function getGameHistory () external view returns(GameInfo[] memory){
        //do some condition check then return the data
        return (gameHistory);
    }

    function getSpecificGameHistory (uint index) external view returns(GameInfo memory){
        //do some condition check then return the data
        require(index <= gameHistory.length, "Error: Invalid length");
        require(gameHistory[index].user2.userAddress == address(0), "Error: The game not finish yet");

        return (gameHistory[index]);
    }

    //lock of critical section code
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
            //when no user in the queue, put the user in to user 1
            // GameInfo memory gameInfo;
            // gameHistory.push(gameInfo); 
            // gameHistory[gameCount].user1.userAddress = msg.sender;
            // gameHistory[gameCount].user1.userOption = option;
            _user1.userAddress = msg.sender;
            _user1.userOption = option;
            userCount++;
        }
        else{
            //Check whether the users are the same person
            require(msg.sender != _user1.userAddress,"Error: You cannot play with yourself");

            // gameHistory[gameCount].user2.userAddress = msg.sender;
            // gameHistory[gameCount].user2.userOption = option;
            

            //when second user come, assign the user to user 2
            _user2.userAddress = msg.sender;
            _user2.userOption = option;
            userCount++;
            //Trigger game condition
            game();
            userCount = 0;
            //Do i need to init the previous parameter such as address
            //Need
            //Initial users address
            _user1.userAddress = address(0);
            _user2.userAddress = address(0);

            // gameCount++;

        }
        // Q: How can i solve the third person coming when game is excuting and userCount still not equal to 0
        // A: No need to worry this, the user is assign by blockchain one by one. 
        // Even they come in the same time. Which transaction done first, that will be the correct one.
        // But still need to avoid the Race condition. 
    }

    //game logic check
    function game () private {
        //store 2 user information to gameinfo
        GameInfo memory newGameinfo;
        newGameinfo.user1.userAddress = _user1.userAddress;
        newGameinfo.user1.userOption = _user1.userOption;
        newGameinfo.user2.userAddress = _user2.userAddress;
        newGameinfo.user2.userOption = _user2.userOption;

        //check who wins the game and store result in array(game history)
        // 1 = Rock 2 = Paper 3 = Scissors
        if (_user1.userOption == _user2.userOption) {
            newGameinfo.finalResult = "Tied";
            emit showResult("Tied");  //
            gameHistory.push(newGameinfo);
            //gameHistory[gameCount].finalResult = "Tied";
        }
        else {
            if (
                (_user1.userOption == 1 && _user2.userOption == 2) ||
                (_user1.userOption == 3 && _user2.userOption == 1) ||
                (_user1.userOption == 2 && _user2.userOption == 3)
            ) {
                newGameinfo.finalResult = "User2 win";
                emit showResult("User2 win");
                gameHistory.push(newGameinfo);
                //gameHistory[gameCount].finalResult = "User2 win";
            } else {
                newGameinfo.finalResult = "User1 win";
                emit showResult("User1 win");
                gameHistory.push(newGameinfo);
                //gameHistory[gameCount].finalResult = "User1 win";
            }
        }
    }
}