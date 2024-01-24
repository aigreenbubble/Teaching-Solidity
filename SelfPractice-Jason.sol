// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract payAndPlay{
    uint private salt = 0; 
    uint public numberCount = 1;
    address payable public contractAddress = payable(address(this));
    address playerAddress;
    address public owner;
    bool locked;

    event showBalance(uint);
    event showResult(uint);
    event showError(string);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier noReentrancy() {
        require(!locked, "Error: Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    constructor() {
        owner = msg.sender;
    }

    function getPlayerBalance() external view returns(uint) {
        return msg.sender.balance;
    }

    function getBalance() external view returns(uint) {
        return contractAddress.balance;
    }

    function depositeMoney () public payable {
        contractAddress.transfer(msg.value);
        //bool success = contractAddress.send(msg.value);
        // if(!success){
        //     emit showError("something wrong");
        // }
        emit showBalance(contractAddress.balance);

    }

    function withdrawMoney () public payable {
        require(msg.sender == playerAddress,"You are not winer");
        payable(msg.sender).transfer(contractAddress.balance);
        emit showBalance(contractAddress.balance);

    }

    function getAllMoney() external payable onlyOwner{
        payable(msg.sender).transfer(contractAddress.balance);
    }

    receive() external payable{
        contractAddress.send(msg.value);
     }

    //game logic
    function playGame(uint guessNumber)external payable noReentrancy{
        require(msg.value >= 1 ether,"send 1 ether!");
        numberCount++;
        if(getRandomNumber() == guessNumber){
            playerAddress = msg.sender;
            withdrawMoney();
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

