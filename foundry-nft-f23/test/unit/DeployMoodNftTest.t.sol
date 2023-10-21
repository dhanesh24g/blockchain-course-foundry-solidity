// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft deployer;

    function setUp() external {
        deployer = new DeployMoodNft();
    }

    function testSvgToImageUri() public view {
        string
            memory expectedSvgString = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICAgIDxjaXJjbGUgY3g9IjgwIiBjeT0iODAiIHI9IjYwIiBzdHJva2U9ImdyZWVuIiBzdHJva2Utd2lkdGg9IjMiIGZpbGw9InNreWJsdWUiIC8+CiAgICA8ZyBjbGFzcz0iZXllcyI+CiAgICAgICAgPGNpcmNsZSBjeD0iNTAiIGN5PSI2MCIgcj0iNCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIiBmaWxsPSJibGFjayIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMTAiIGN5PSI2MCIgcj0iNCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIiBmaWxsPSJibGFjayIgLz4KICAgIDwvZz4KICAgIDxnIGNsYXNzPSJub3NlIj4KICAgICAgICA8ZWxsaXBzZSBjeD0iODAiIGN5PSI4MiIgcng9IjIiIHJ5PSI2IiBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjEiIGZpbGw9InllbGxvdyIgLz4KICAgIDwvZz4KICAgIDxnIGNsYXNzPSJtb3V0aCI+CiAgICAgICAgPHBhdGggZD0ibTExNC44MSA5Ni41M2MuNjkgMzEuMTItNTguMTEgNDItNzEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IG1hcm9vbjsgc3Ryb2tlLXdpZHRoOiAzOyIgLz4KICAgIDwvZz4KPC9zdmc+";
        string memory svg = vm.readFile("./image/dynamicNft/blueFace.svg");

        assert(
            keccak256(abi.encodePacked(expectedSvgString)) ==
                keccak256(abi.encodePacked(deployer.svgToImageUri(svg)))
        );
    }
}
