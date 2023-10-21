// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address USER = makeAddr("user");
    uint256 public constant STARTING_BALANCE = 10 ether;
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() external {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    // Modifiers
    modifier pugMinted() {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);
        _;
    }

    // Test functions
    function testNameIsCorrect() public view {
        string memory expectedName = "Doggie";
        string memory testName = basicNft.name();

        // assertEq(basicNft.name(), expectedName);
        // Compare strings using their Bytes32 hashed values
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(testName))
        );
    }

    function testCanMintAndHaveBalance() public {
        vm.prank(USER);
        // vm.startBroadcast();
        basicNft.mintNft(PUG_URI);
        // vm.stopBroadcast();

        // Without pranking, we can user Broadcast and msg.sender to assert the minting & balance
        // assert(basicNft.balanceOf(msg.sender) == 1);
        assert(basicNft.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encodePacked(PUG_URI)) ==
                keccak256(abi.encodePacked(basicNft.tokenURI(0)))
        );
    }

    function testTokenCounterIncremented() public pugMinted {
        assert(basicNft.getTokenCounter() == 1);
    }
}
