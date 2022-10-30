// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract EventOrganizer {
    struct Event {
        address organizer;
        string name;
        uint256 date;
        uint256 price;
        uint256 ticketCount;
        uint256 ticketRemain;
    }

    mapping(uint256 => Event) public events;
    mapping(address => mapping(uint256 => uint256)) public tickets;
    uint256 public nextID;

    function createEvent(
        string memory name,
        uint256 date,
        uint256 price,
        uint256 ticketCount,
        uint256 ticketRemain
    ) external {
        require(date > block.timestamp, "invalid date");
        require(
            ticketCount > 0,
            "You can organize if u have created more than 0 tickets"
        );
        events[nextID] = Event(
            msg.sender,
            name,
            date,
            price,
            ticketCount,
            ticketRemain
        );
        nextID++;
    }

    function buyTicket(uint256 id, uint256 quantity) external payable {
        require(events[id].date != 0, "Event does not Exists");
        require(block.timestamp < events[id].date, "Event Closed");

        Event storage _event = events[id];
        require(msg.value == (_event.price * quantity), "Insufficient Ether");
        require((_event.ticketRemain >= quantity), "Tickets are not left");
        _event.ticketRemain -= quantity;
        tickets[msg.sender][id] += quantity;

        //msg.value amount of ether in remix ide value
        //msg.sender is the person who is buying tickets
        //id is the show of which the person is buying tickets
        //quantity is the number of tickets for the show
    }

    function transferTickets(
        uint256 id,
        uint256 quantity,
        address to
    ) external {
        require(events[id].date != 0, "Event doesnot Exists");
        require(block.timestamp < events[id].date, "Event Closed");
        require(
            tickets[msg.sender][id] >= quantity,
            "you dont have enough tickets to transfer"
        );
        tickets[msg.sender][id] -= quantity;
        tickets[to][id] += quantity;
    }

    function checkBalanceMsg() external payable returns (uint256) {
        return msg.value;
    }
}
