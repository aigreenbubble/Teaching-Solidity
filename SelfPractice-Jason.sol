// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

//import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
//import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
//import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract payAndPlay{
    uint private salt = 0; //salt for random number generate
    uint public numberCount = 1; // count now many user
    address payable public contractAddress = payable(address(this)); // declare contract address
    address playerAddress; // recoed player address
    address public owner; // contract owner
    bool locked;    // lock for re entry
    //uint time = block.timestamp + 4 weeks;

    event showBalance(uint);
    event showResult(uint);
    event showError(string);

    //check the message sender is owner or not
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
    //avoid re entry 
    modifier noReentrancy() {
        require(!locked, "Error: Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    constructor() {
        owner = msg.sender;
    }
    //get current player balance
    function getPlayerBalance() external view returns(uint) {
        return msg.sender.balance;
    }
    //get the contract balance
    function getBalance() external view  returns(uint) {
        return contractAddress.balance;
    }

    function depositeMoney () public payable {
        //contractAddress.transfer(msg.value);
        //bool success = payable(contractAddress).send(msg.value);
        //require(success, "something wrong");
        // if(!success){
        //     emit showError("something wrong");
        // }
        emit showBalance(contractAddress.balance);

    }
    //let winer to get their reward
    function withdrawMoney () public {
        require(msg.sender == playerAddress,"You are not winer"); //check player who what to withdraw money is winer or not
        payable(msg.sender).transfer(contractAddress.balance); // transfer reward to winer address
        emit showBalance(contractAddress.balance); // show current balance

    }
    // fall back all token to owner wallet address
    // only own can execute this function
    function getAllMoney() external onlyOwner{
        payable(msg.sender).transfer(contractAddress.balance);
    }


    //game logic
    function playGame(uint guessNumber)external payable noReentrancy{
        require(msg.value >= 1 ether,"send 1 ether!"); // require player atleast put 1 token to play
        //increase the number count when it not more than 10
        if(numberCount <= 10){
            numberCount++;
        }
        //win condition check user win or not
        if(getRandomNumber() == guessNumber){
            //get the user address and send reward
            playerAddress = msg.sender;
            withdrawMoney();
            //initail the game information 
            playerAddress = address(0);
            numberCount = 2;
        } else{
            depositeMoney();
        }
        
    }

    
    function getRandomNumber() public returns (uint256) {
        
        // Increment the seed based on certain parameters
        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, blockhash(block.number - 1))));

        // Use the seed to generate three random numbers
        uint256 random1 = uint256(keccak256(abi.encodePacked(seed, salt)));
        salt += 1;
        // Get a random number between 1 and 3
        emit showResult((random1 % numberCount) + 1);
        return (random1 % numberCount) + 1;
    }
}
