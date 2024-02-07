    // SPDX-License-Identifier: MIT
    pragma solidity 0.8.19;

    import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

    contract BuyToken {
        IERC20 public TTTToken = IERC20(0xc6bDdCd0DA1c50281f02a57B8D2ada2ebF76AEC7);
        bool private locked;
        address public owner;
        uint256 public exchangeRate;
        constructor(){
            exchangeRate = 1000;
        }

        event topUpSuccessful (uint256 amount, address buyer);

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

        function changeEXCTRate(uint256 newRate) external onlyOwner{
            exchangeRate = newRate;
        }

        function buyTTTToken() external payable noReentrancy{
            require(msg.value >= 1 ether, "Please at least send 1 ether!");
            require(payable(0x9163f6f9A843827aB2fC1B0fBd95B7eF77763129).send(msg.value),"transfer fail");
            uint256 buyAmount = (msg.value/1 ether)*exchangeRate;
            //how to approve this transfer
            //TTTToken.transferFrom(owner, msg.sender, buyAmount);

            emit topUpSuccessful(buyAmount, msg.sender);

        }

        //TTTToken.Approval(owner, spender, value);
    }