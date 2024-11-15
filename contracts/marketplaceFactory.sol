// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.27;

import "./MarketPlaace.sol"; 

contract MarketPlaceFactory {
    address public owner;
    MarketPlace[] public marketplaces;

    event MarketPlaceCreated(address indexed marketplaceAddress, address indexed creator);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createMarketPlace() external returns (address) {
        MarketPlace newMarketPlace = new MarketPlace();
        marketplaces.push(newMarketPlace);

        emit MarketPlaceCreated(address(newMarketPlace), msg.sender);
        return address(newMarketPlace);
    }

    function getMarketPlaces() external view returns (MarketPlace[] memory) {
        return marketplaces;
    }
}