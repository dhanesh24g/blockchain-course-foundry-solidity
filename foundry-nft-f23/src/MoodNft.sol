// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    // Enum
    enum Mood {
        HAPPY,
        SAD,
        BLUE
    }

    uint256 private s_tokenCounter;
    mapping(Mood => string imageUri) private s_moodToImageUriMapping;
    mapping(uint256 tokenId => Mood) private s_tokenIdToMood;

    // Custom Errors
    error MoodNft__InvalidTokenId();

    constructor(
        string memory _happyFaceUri,
        string memory _sadFaceUri,
        string memory _blueFaceUri
    ) ERC721("Mood NFT", "MDNFT") {
        // Mapping moods to their images
        s_moodToImageUriMapping[Mood.HAPPY] = _happyFaceUri;
        s_moodToImageUriMapping[Mood.SAD] = _sadFaceUri;
        s_moodToImageUriMapping[Mood.BLUE] = _blueFaceUri;

        s_tokenCounter = 0;
    }

    function mintNft(uint8 _moodValue) public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood(_moodValue);
        s_tokenCounter++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        // Verifying for the valid s_tokenCounter values
        if (_tokenId >= s_tokenCounter) {
            revert MoodNft__InvalidTokenId();
        }
        // Assigning the imageUri on the basis of the mood
        string memory imageUri = s_moodToImageUriMapping[
            s_tokenIdToMood[_tokenId]
        ];

        // Generating the encoded token metadata to form the final tokenUri
        string memory tokenEncoded = Base64.encode(
            bytes(
                abi.encodePacked(
                    '{\n"name": "',
                    name(),
                    '",\n"description": "An adorable PUG!", \n"image": "',
                    imageUri,
                    '",\n"attributes": [ \n{\n"trait_type": "cuteness",\n"value": 100}]\n}'
                )
            )
        );

        return string(abi.encodePacked(_baseURI(), tokenEncoded));
    }

    ///////////////////////
    // Getter Functions //
    //////////////////////

    function getImageUri(Mood _mood) public view returns (string memory) {
        return (s_moodToImageUriMapping[_mood]);
    }

    function getMoodFromTokenId(uint256 _tokenId) public view returns (Mood) {
        return (s_tokenIdToMood[_tokenId]);
    }
}
