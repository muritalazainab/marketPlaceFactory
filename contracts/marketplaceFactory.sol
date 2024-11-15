// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.27;
import "./MarketPlaace.sol";


contract MarketPlaceFactory   {

     MarketPlace[] public deployedMarketPlace;
    mapping(address => uint256) public marketplaceToIndex;
        


     function deployProposalVote() external returns (address ) {
        MarketPlace newMarketPlace = new MarketPlace();
        uint256 index = deployedMarketPlace.length;
        deployedMarketPlace.push(newMarketPlace);
        marketplaceToIndex[address (newMarketPlace)] = index;
          return address(newMarketPlace);

    }
   

    function createlistItem(address MarketPlaceAddress,string memory _name, uint16 _price) external  {
    
        // require(ItemAddress != address(0), "Invalid contract address");
        // require(isMarketplaceContract(ItemAddress), "Contract not found");
        
        // MarketPlace marketPlace = MarketPlace(MarketPlaceAddress);
        // marketPlace.createlistItem(_name, _price);
        
    }

    



    constructor() {
        
    }
}

