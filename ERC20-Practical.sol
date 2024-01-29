// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ERC20Practical{
    IERC20 _token;

    // token = MyToken's contract address
    constructor() {
        _token = IERC20(0xdD870fA1b7C4700F2BD7f44238821C26f7392148);
    }


    function transferFrom(uint amount) public {
        _token.approve(msg.sender, amount);
        _token.transferFrom(msg.sender, address(this), amount);
    }

    function transfer() public {
        _token.approve(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 100);
        _token.transfer(msg.sender, 100);
    }

    function calltransfer (address payable _to, uint amount) external {
        _token.approve(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, amount);

        //transferFrom(_to, amount);
    }
}

contract TransferToken {
    function transferForm (address recipient, uint amount) external payable {
        IERC20 token = IERC20(0xdD870fA1b7C4700F2BD7f44238821C26f7392148);
        token.transferFrom(msg.sender, recipient, amount);
    }
}

contract Owner {
    function transfer(address recipient, uint amount)external payable {
        IERC20 token = IERC20(0xdD870fA1b7C4700F2BD7f44238821C26f7392148);
        token.approve(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, amount);

        TransferToken transfertoken =TransferToken(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        transfertoken.transferForm(recipient, amount);

    }
}