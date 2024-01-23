// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";

contract payAndPlay{
    uint private salt = 0; 

    address public tokenAddress = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;

    constructor(address _tokenAddress) {
        tokenAddress = _tokenAddress;
    }

    function depositTokens(uint256 amount) private {
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), amount);
    }

    function withdrawTokens(uint256 amount) private  {
        IERC20(tokenAddress).transfer(msg.sender, amount);
    }

    function getTokenBalance() external view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function depositMoney (uint amount) external payable {
        depositTokens(amount);
    }

    function withdrawMoney(uint amount) external payable {
        withdrawTokens(amount);
    }

    event showWiner(uint);
    function getRandomNumber() public returns (uint256) {
        
        // Increment the seed based on certain parameters
        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, blockhash(block.number - 1))));

        // Use the seed to generate three random numbers
        uint256 random1 = uint256(keccak256(abi.encodePacked(seed, salt)));
        salt += 1;
        // Get a random number between 1 and 3
        emit showWiner((random1 % 2) + 1);
        return (random1 % 2) + 1;
    }
}