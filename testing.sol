    // SPDX-License-Identifier: MIT
    pragma solidity 0.8.20;

    contract testingVersion {
        uint256 public testint;
        function modifyInt(uint256 num) public returns (uint256){
            testint = num;
            return testint;
        }
    }