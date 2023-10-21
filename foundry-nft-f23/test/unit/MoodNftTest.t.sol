// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {MoodNft} from "../../src/MoodNft.sol";
import {Test, console} from "forge-std/Test.sol";

contract MoodNftTest is Test {
    MoodNft public mood;
    address USER = makeAddr("user");

    // Setting the ImageURIs for different moods
    string public constant HAPPY_FACE =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIxMDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIgLz4KICAgIDxnIGNsYXNzPSJleWVzIj4KICAgICAgICA8Y2lyY2xlIGN4PSI2MSIgY3k9IjgyIiByPSIxMiIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiIC8+CiAgICA8L2c+CiAgICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7IiAvPgo8L3N2Zz4=";
    string public constant SAD_FACE =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIxMDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIgLz4KICAgIDxnIGNsYXNzPSJleWVzIj4KICAgICAgICA8Y2lyY2xlIGN4PSI2MSIgY3k9IjgyIiByPSIxMiIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiIC8+CiAgICA8L2c+CiAgICA8cGF0aCBkPSJtMTM5LjgxIDE0Ni41MyBjLjExIC0zMS4xMSAtNzQuMTEgLTMyLjkgLTgxLjIyIC0xIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7IiAvPgogICAgPCEtLSA8cGF0aCBkPSJtMTM2LjgxIDQxLjUzYy42OSAyNi4xNy02NC4xMSA0Mi04MS41Mi0uNzMiIHN0eWxlPSJmaWxsOm5vbmU7IHN0cm9rZTogYmxhY2s7IHN0cm9rZS13aWR0aDogMzsiIC8+IC0tPgo8L3N2Zz4=";
    string public constant BLUE_FACE =
        "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICAgIDxjaXJjbGUgY3g9IjgwIiBjeT0iODAiIHI9IjYwIiBzdHJva2U9ImdyZWVuIiBzdHJva2Utd2lkdGg9IjMiIGZpbGw9InNreWJsdWUiIC8+CiAgICA8ZyBjbGFzcz0iZXllcyI+CiAgICAgICAgPGNpcmNsZSBjeD0iNTAiIGN5PSI2MCIgcj0iNCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIiBmaWxsPSJibGFjayIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMTAiIGN5PSI2MCIgcj0iNCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIiBmaWxsPSJibGFjayIgLz4KICAgIDwvZz4KICAgIDxnIGNsYXNzPSJub3NlIj4KICAgICAgICA8ZWxsaXBzZSBjeD0iODAiIGN5PSI4MiIgcng9IjIiIHJ5PSI2IiBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjEiIGZpbGw9InllbGxvdyIgLz4KICAgIDwvZz4KICAgIDxnIGNsYXNzPSJtb3V0aCI+CiAgICAgICAgPHBhdGggZD0ibTExNC44MSA5Ni41M2MuNjkgMzEuMTItNTguMTEgNDItNzEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IG1hcm9vbjsgc3Ryb2tlLXdpZHRoOiAzOyIgLz4KICAgIDwvZz4KPC9zdmc+";

    function setUp() external {
        mood = new MoodNft(HAPPY_FACE, SAD_FACE, BLUE_FACE);
    }

    function testViewDefaultTokenUri() public {
        vm.prank(USER);
        mood.mintNft(1);
        console.log(mood.tokenURI(0));

        vm.prank(USER);
        mood.mintNft(2);
        console.log(mood.tokenURI(1));

        vm.prank(USER);
        mood.mintNft(0);
        console.log(mood.tokenURI(2));

        // Since we are checking for tokenId = 4, the below RevertCheck will be successful
        vm.expectRevert(MoodNft.MoodNft__InvalidTokenId.selector);
        console.log(mood.tokenURI(4));
    }

    function testGetImageUriFromMood() public view {
        console.log(mood.getImageUri(MoodNft.Mood.BLUE));
    }

    function testTokenUriFromMood() public {
        vm.prank(USER);
        mood.mintNft(2);
        console.log(mood.tokenURI(0));
    }
}
