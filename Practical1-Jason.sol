// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract MyGuessNumberGame {
    uint public targetNumber;
    uint public guessNumber;
    bool win = false;
    address payable public treasury = payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);

    function setTargetNumber(uint newTargetNubmer) external {
        targetNumber = newTargetNubmer;
    }

    function setGuessNumber (uint newGuessNumber) public {
        guessNumber = newGuessNumber;
    }

    // function processUserInput(uint _inputValue) public pure returns (uint) {
    //     // Process the user input, you can do any logic here
    //     return _inputValue;
    // }


    function logicCheck() external payable returns (string memory){
        if(guessNumber == targetNumber){
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

        if(win)
            return ("You win!!");
        else 
        {
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
    uint public user1Choose;
    uint public user2Choose;
    //what they want to choose
    function user1Dicision (uint decisionofRockPaperScissors ) external {
        if((decisionofRockPaperScissors) == (1)||(decisionofRockPaperScissors) == (2)||(decisionofRockPaperScissors) == (3))
        {
            user1Choose = decisionofRockPaperScissors;
        }
        else
        {
            revert ("Please entey 1, 2 or 3");
        }
    }
    function user2Dicision (uint decisionofRockPaperScissors ) external {
        if((decisionofRockPaperScissors) == (1)||(decisionofRockPaperScissors) == (2)||(decisionofRockPaperScissors) == (3))
        {
            user2Choose = decisionofRockPaperScissors;
        }
        else
        {
            revert ("Please entey 1, 2 or 3");
        }
    }
    //logic checking
    // 1 = Rock 2 = Paper 3 = Scissoes
    function logicCheck () view external returns (string memory){
        if(user1Choose == 1){
            if(user2Choose == 1)
                return ("Tie");
            if(user2Choose == 2)
                return ("User2 Win!");
            else
                return ("User1 Win!");
        }
        if(user1Choose == 2){
            if(user2Choose == 2)
                return ("Tie");
            if(user2Choose == 3)
                return ("User2 Win!");
            else
                return ("User1 Win!");
        }
        if(user1Choose == 3){
            if(user2Choose == 3)
                return ("Tie");
            if(user2Choose == 1)
                return ("User2 Win!");
            else
                return ("User1 Win!");
        } 

        return ("something wrong");
    }

}