pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;

    function Lottery() public {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value >= 1.01 ether);

        address player = msg.sender;
        players.push(player);
    }

    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.difficulty, block.timestamp, players)
                )
            );
    }

    function getBalance() public view returns (uint256) {
        return uint256(address(this).balance);
    }

    function pickWinner() public restricted {
        uint256 index = random() % players.length;
        // new solidity: payable(players[index]).transfer(address(this).balance);
        players[index].transfer(this.balance);
        players = new address[](0);
    }

    modifier restricted() {
        require(msg.sender == manager);
        _; // code will be run here
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}
