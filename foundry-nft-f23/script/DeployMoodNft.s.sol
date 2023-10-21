// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {
        string memory happySvg = vm.readFile(
            "./image/dynamicNft/happyFace.svg"
        );
        string memory sadSvg = vm.readFile("./image/dynamicNft/sadFace.svg");
        string memory blueSvg = vm.readFile("./image/dynamicNft/blueFace.svg");

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(
            svgToImageUri(happySvg),
            svgToImageUri(sadSvg),
            svgToImageUri(blueSvg)
        );
        vm.stopBroadcast();

        return moodNft;
    }

    // Function to generate the custom image URIs
    function svgToImageUri(
        string memory _svg
    ) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes((abi.encodePacked(_svg)))
        );

        return string(abi.encodePacked(baseURL, svgBase64Encoded));
    }
}
