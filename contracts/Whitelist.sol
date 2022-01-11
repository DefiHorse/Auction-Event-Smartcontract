//SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

contract Whitelist is Ownable {

    mapping(address => bool) whitelist;

    event AddedToWhitelist(address indexed account);
    event RemovedFromWhitelist(address indexed account);

    /**
     * @dev Adds a new address to the whitelist.
     * @param _address The address to be whitelisted. 
     */
    function add(address _address) public onlyOwner {
        whitelist[_address] = true;
        emit AddedToWhitelist(_address);
    }

    /**
     * @dev Adds a new address to the whitelist.
     * @param _addresses Array of addresses to be whitelisted. 
     */
    function addBatch(address[] memory _addresses) public onlyOwner {
        for(uint i=0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = true;
            emit AddedToWhitelist(_addresses[i]);
        }
    }

    /**
     * @dev Removes a address from the whitelist.
     * @param _address The address to remove. 
     */
    function remove(address _address) public onlyOwner {
        whitelist[_address] = false;
        emit RemovedFromWhitelist(_address);
    }

    /**
     * @dev Removes a address from the whitelist.
     * @param _addresses Array of addresses to be whitelisted. 
     */
    function removeBatch(address[] memory _addresses) public onlyOwner {
        for(uint i=0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = false;
            emit RemovedFromWhitelist(_addresses[i]);
        }
    }

     /**
     * @dev Getter to check if address is whitelisted.
     * @param _address The address to check. 
     */
    function isWhitelisted(address _address) public view returns(bool) {
        return whitelist[_address];
    }

    /**
     * @dev Modifier to restrict acces to function for only whitelisted addresses.
     */
    modifier onlyWhitelisted() {
            require(isWhitelisted(msg.sender));
        _;
        
    }

}