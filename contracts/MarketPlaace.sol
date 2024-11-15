// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.27;
// uint public prices;
// address public owner;
// address public deployer;

// constructor(address _owner, uint _prices ){
//     prices = _prices;
//     owner = _owner;
//     deployer = msg.sender;
// }


contract MarketPlace  {
    mapping(address => User) users;
    struct User {
  bool isApproved;
}

modifier onlyApproved {
  require(users[msg.sender].isApproved, "You are not registered.");
  _;
}

    address public owner;
    address public buyer;

    enum OrderStatus {
        None,
        Created,
        Pending,
        Sold
    }

    struct Item {
        string name;
        uint16 price;
        OrderStatus status;
    }

    Item[] public assets;
    mapping(uint256 => bool) public isSold;

    event ItemListed(string indexed name, uint16 price);
    event ItemSold(string indexed name, uint16 price, address buyer);

    constructor() {
        owner = msg.sender;
    }

    function listItem(string memory _name, uint16 _price) external {
        require(msg.sender != address(0), "Zero address is not allowed");

        Item memory newItem;
        newItem.name = _name;
        newItem.price = _price;
        newItem.status = OrderStatus.Created;

        assets.push(newItem);

        emit ItemListed(_name, _price);
    }

    function buyItem(uint8 _index) external {
        require(msg.sender != address(0), "Zero address is not allowed");
        require(_index < assets.length, "Out of bound!");
        require(!isSold[_index], "Asset already sold");

        
        assets[_index].status = OrderStatus.Sold;
        isSold[_index] = true;
        buyer = msg.sender;

        emit ItemSold(assets[_index].name, assets[_index].price, msg.sender);
    }
}

   
