//SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import './Whitelist.sol';


contract HorseAuction2 is  Ownable, Whitelist {

    
    event Bid(address indexed account, uint256 amount);
    event Deposit(address indexed account, uint256 amount);
    event Withdraw(address indexed account, uint256 amount);

    
    uint256 public constant DECIMALS = 10 ** 18; 
    uint256 public constant START = 1641820700; 
    uint256 public constant END = START + 6 minutes; 
    uint256 public constant BASE = 5 ether;
    uint256 internal highestBidAmount = BASE;
    address internal highestBidder;

    mapping(address => uint256) public provided;
    mapping(address => uint256) private accumulated;
    
 

    /**
     * @dev Deposits ETH into contract.
     *
     * Requirements:
     * - The auction must be ongoing.
     */
    


    function bid() external payable {
        require(START <= block.timestamp, "The auction has not started yet");
        require(block.timestamp <= END, "The auction has already ended");
        
        require(isWhitelisted(msg.sender),"The address is not whitelisted");
        provided[msg.sender] += msg.value;
    
        accumulated[msg.sender] = Math.max(accumulated[msg.sender], provided[msg.sender]);
        require(accumulated[msg.sender] > BASE, "Your bid is lower than the starting price");
        require(accumulated[msg.sender] > highestBidAmount, "Your bid is lower than the highest bid");
        highestBidAmount = accumulated[msg.sender];
        highestBidder = msg.sender;
        emit Bid(msg.sender, provided[msg.sender]);
    }

    /**
     * @dev Returns total BNB deposited in the contract of an address.
     */
    function getUserBidAmount(address _user) external view returns (uint256) {
        return provided[_user];
    }

    function _getAuctionWinner() internal view returns (address) {
        require(START <= block.timestamp, "The auction has not started yet");
        require(block.timestamp >= END, "The auction has not ended");
        return highestBidder;
    }

    function getAuctionWinner() external view returns (address) {
        return _getAuctionWinner();
    }

    function getHighestBidder() external view returns (address) {
        return highestBidder;
    }

    function getHighestBidAmount() external view returns (uint256) {
        return highestBidAmount;
    }

    /**
     * @dev Calculate the amount of BNB that can be withdrawn by user
     */
    function _getWithdrawableAmount(address _user) internal view returns (uint256) {
        uint256 userAccumulated = accumulated[_user];
        return userAccumulated;
    }

    function getWithdrawableAmount(address _user) external view returns (uint256) {
        return _getWithdrawableAmount(_user);
    }

    

    

    /**
     * @dev Get user's accumulated amount after deposit
     */
    

    /**
     * @dev Withdraws BNB
     *
     * Requirements:
     * - The auction must be ongoing.
     * - Amount to withdraw must be less than withdrawable amount
     */
    function withdraw(uint256 amount) external {
        require(block.timestamp > END, "Only withdrawable after the auction period");

        require(amount <= provided[msg.sender], "Insufficient balance");

        require(amount <= _getWithdrawableAmount(msg.sender), "Invalid amount");

        require(START <= block.timestamp, "The auction has not started yet");

        require(block.timestamp >= END, "The auction has not ended");

        require(msg.sender!=_getAuctionWinner(), "The winner can not withdraw funds");

        require(isWhitelisted(msg.sender),"The address is not whitelisted");

        provided[msg.sender] -= amount;

    

        payable(msg.sender).transfer(amount);

        emit Withdraw(msg.sender, amount);
    }

    

    /**
     * @dev Withdraw total BNB to owner's wallet
     *
     * Requirements:
     * - Only the owner can withdraw
     * - The auction must have been already ended.
     * - The contract must have BNB left.
     */
    function withdrawSaleFunds() external onlyOwner {
        require(END < block.timestamp, "The auction has not ended");
        require(address(this).balance > 0, "Contract's balance is empty");

        payable(owner()).transfer(address(this).balance);
    }

    

    
}