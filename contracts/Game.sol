// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Game {
    address fbtTokenAddress;
    IERC20 token;
    address private  owner;
    mapping (address => uint256) balances;

    constructor(address fbtToken) {
        token = IERC20(fbtToken);
        fbtTokenAddress = fbtToken;
        owner = msg.sender;
    }

    event ClaimToken(
        address _from,
        uint256 amount
    );

    event UpdateBalances(
        address _to,
        uint256 amount
    );

    modifier onlyOwner() {
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }


    function claimToken(uint256 amount) payable public {
        require(balances[msg.sender] >= amount, "your balance not enough to claim");
        uint256 erc20balance = token.balanceOf(address(this));
        require(amount <= erc20balance, "balance not enough");
        balances[msg.sender] -= amount;
        token.transfer(msg.sender, amount);
        emit ClaimToken(msg.sender, amount);
    }

    function updateBalance(address _to ,uint256 amount) public onlyOwner {
        balances[_to] += amount;
        emit UpdateBalances(_to, amount);
    }


}
