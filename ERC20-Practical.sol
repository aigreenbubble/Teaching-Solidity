// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ERC20Practical{
    function transferFrom(address payable _to, uint amount) public {
        IERC20 token = IERC20(0xdD870fA1b7C4700F2BD7f44238821C26f7392148);
        token.transferFrom(msg.sender, _to, amount);
    }

    function transfer() public {
        IERC20 token = IERC20(0xdD870fA1b7C4700F2BD7f44238821C26f7392148);
        token.approve(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 100);
        token.transfer(msg.sender, 100);
    }

    function calltransfer (address payable  _to, uint amount) external {
        IERC20 token = IERC20(0xdD870fA1b7C4700F2BD7f44238821C26f7392148);
        token.approve(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, amount);

        transferFrom(_to, amount);
    }
}