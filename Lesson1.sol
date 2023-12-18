// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
// pragma solidity >=0.4.0 <0.6.0;
// pragma solidity ^0.8.0;

/* Default values in soildity
    All visibility is set to private
*/

/*
    Two types of functions - Setter and getter
    getter functions costs 0 gas
    Setter functions costs gas depending upon what data is being set

    Setter functions are of two types - Payable & non-Payable
*/

contract DataTypes {
    string public myName = "Arun Kumar";
    uint public myNumber = 44; // uint8, uint16, uint32, uint64, uint128, uint256
    address public myWallet = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    bool public isTrue = true;

    function updateMyName(string memory newName) external returns(string memory _myName){
        myName = newName;

        return newName;
    }
}

contract ArithmeticOperators is DataTypes {
    function multiplyMyNumber(uint numberToMultiply) external view returns(uint){
       return (myNumber * numberToMultiply);
    }

    function addToMyNumber(uint numberToAdd) external view returns(uint){
        return (myNumber + numberToAdd);
    }

    function subtractFromMyNumber(uint numberToSubtract) external view returns(uint){
        return (myNumber - numberToSubtract);
    }

    function divideMyNumber(uint divisor) external view returns(uint){
        return (myNumber / divisor); // Solidity does not support floats (decimal) values, this operation will revert only the whole value
    }

    function findTheRemainder(uint divisor) external view returns(uint){
        return (myNumber % divisor);
    }

    function incrementNumber() external returns(uint){
        myNumber++;
        return (myNumber);
    }

    function decrementNumber() external returns(uint){
        myNumber--;
        return (myNumber);
    }
}