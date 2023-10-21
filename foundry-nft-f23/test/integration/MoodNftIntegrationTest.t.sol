// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {MoodNft} from "../../src/MoodNft.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";
import {Test, console} from "forge-std/Test.sol";

contract MoodNftIntegrationTest is Test {
    MoodNft public mood;
    DeployMoodNft public deployer;
    address USER = makeAddr("user");

    // Setting the ImageURIs for different moods
    string public constant HAPPY_FACE =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIxMDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIgLz4KICAgIDxnIGNsYXNzPSJleWVzIj4KICAgICAgICA8Y2lyY2xlIGN4PSI2MSIgY3k9IjgyIiByPSIxMiIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiIC8+CiAgICA8L2c+CiAgICA8cGF0aCBkPSJtMTM2LjgxIDExNi41M2MuNjkgMjYuMTctNjQuMTEgNDItODEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7IiAvPgo8L3N2Zz4=";
    string public constant SAD_FACE =
        "data:image/svg+xml;base64,PHN2ZyB2aWV3Qm94PSIwIDAgMjAwIDIwMCIgd2lkdGg9IjQwMCIgaGVpZ2h0PSI0MDAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgICA8Y2lyY2xlIGN4PSIxMDAiIGN5PSIxMDAiIGZpbGw9InllbGxvdyIgcj0iNzgiIHN0cm9rZT0iYmxhY2siIHN0cm9rZS13aWR0aD0iMyIgLz4KICAgIDxnIGNsYXNzPSJleWVzIj4KICAgICAgICA8Y2lyY2xlIGN4PSI2MSIgY3k9IjgyIiByPSIxMiIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMjciIGN5PSI4MiIgcj0iMTIiIC8+CiAgICA8L2c+CiAgICA8cGF0aCBkPSJtMTM5LjgxIDE0Ni41MyBjLjExIC0zMS4xMSAtNzQuMTEgLTMyLjkgLTgxLjIyIC0xIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IGJsYWNrOyBzdHJva2Utd2lkdGg6IDM7IiAvPgogICAgPCEtLSA8cGF0aCBkPSJtMTM2LjgxIDQxLjUzYy42OSAyNi4xNy02NC4xMSA0Mi04MS41Mi0uNzMiIHN0eWxlPSJmaWxsOm5vbmU7IHN0cm9rZTogYmxhY2s7IHN0cm9rZS13aWR0aDogMzsiIC8+IC0tPgo8L3N2Zz4=";
    string public constant BLUE_FACE =
        "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICAgIDxjaXJjbGUgY3g9IjgwIiBjeT0iODAiIHI9IjYwIiBzdHJva2U9ImdyZWVuIiBzdHJva2Utd2lkdGg9IjMiIGZpbGw9InNreWJsdWUiIC8+CiAgICA8ZyBjbGFzcz0iZXllcyI+CiAgICAgICAgPGNpcmNsZSBjeD0iNTAiIGN5PSI2MCIgcj0iNCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIiBmaWxsPSJibGFjayIgLz4KICAgICAgICA8Y2lyY2xlIGN4PSIxMTAiIGN5PSI2MCIgcj0iNCIgc3Ryb2tlPSJibGFjayIgc3Ryb2tlLXdpZHRoPSIzIiBmaWxsPSJibGFjayIgLz4KICAgIDwvZz4KICAgIDxnIGNsYXNzPSJub3NlIj4KICAgICAgICA8ZWxsaXBzZSBjeD0iODAiIGN5PSI4MiIgcng9IjIiIHJ5PSI2IiBzdHJva2U9ImJsYWNrIiBzdHJva2Utd2lkdGg9IjEiIGZpbGw9InllbGxvdyIgLz4KICAgIDwvZz4KICAgIDxnIGNsYXNzPSJtb3V0aCI+CiAgICAgICAgPHBhdGggZD0ibTExNC44MSA5Ni41M2MuNjkgMzEuMTItNTguMTEgNDItNzEuNTItLjczIiBzdHlsZT0iZmlsbDpub25lOyBzdHJva2U6IG1hcm9vbjsgc3Ryb2tlLXdpZHRoOiAzOyIgLz4KICAgIDwvZz4KPC9zdmc+";
    string public constant BLUE_FACE_TOKEN_URI =
        "data:application/json;base64,ewoibmFtZSI6ICJNb29kIE5GVCIsCiJkZXNjcmlwdGlvbiI6ICJBbiBhZG9yYWJsZSBQVUchIiwgCiJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUIzYVdSMGFEMGlNakF3SWlCb1pXbG5hSFE5SWpJd01DSWdlRzFzYm5NOUltaDBkSEE2THk5M2QzY3Vkek11YjNKbkx6SXdNREF2YzNabklqNEtJQ0FnSUR4amFYSmpiR1VnWTNnOUlqZ3dJaUJqZVQwaU9EQWlJSEk5SWpZd0lpQnpkSEp2YTJVOUltZHlaV1Z1SWlCemRISnZhMlV0ZDJsa2RHZzlJak1pSUdacGJHdzlJbk5yZVdKc2RXVWlJQzgrQ2lBZ0lDQThaeUJqYkdGemN6MGlaWGxsY3lJK0NpQWdJQ0FnSUNBZ1BHTnBjbU5zWlNCamVEMGlOVEFpSUdONVBTSTJNQ0lnY2owaU5DSWdjM1J5YjJ0bFBTSmliR0ZqYXlJZ2MzUnliMnRsTFhkcFpIUm9QU0l6SWlCbWFXeHNQU0ppYkdGamF5SWdMejRLSUNBZ0lDQWdJQ0E4WTJseVkyeGxJR040UFNJeE1UQWlJR041UFNJMk1DSWdjajBpTkNJZ2MzUnliMnRsUFNKaWJHRmpheUlnYzNSeWIydGxMWGRwWkhSb1BTSXpJaUJtYVd4c1BTSmliR0ZqYXlJZ0x6NEtJQ0FnSUR3dlp6NEtJQ0FnSUR4bklHTnNZWE56UFNKdWIzTmxJajRLSUNBZ0lDQWdJQ0E4Wld4c2FYQnpaU0JqZUQwaU9EQWlJR041UFNJNE1pSWdjbmc5SWpJaUlISjVQU0kySWlCemRISnZhMlU5SW1Kc1lXTnJJaUJ6ZEhKdmEyVXRkMmxrZEdnOUlqRWlJR1pwYkd3OUlubGxiR3h2ZHlJZ0x6NEtJQ0FnSUR3dlp6NEtJQ0FnSUR4bklHTnNZWE56UFNKdGIzVjBhQ0krQ2lBZ0lDQWdJQ0FnUEhCaGRHZ2daRDBpYlRFeE5DNDRNU0E1Tmk0MU0yTXVOamtnTXpFdU1USXROVGd1TVRFZ05ESXROekV1TlRJdExqY3pJaUJ6ZEhsc1pUMGlabWxzYkRwdWIyNWxPeUJ6ZEhKdmEyVTZJRzFoY205dmJqc2djM1J5YjJ0bExYZHBaSFJvT2lBek95SWdMejRLSUNBZ0lEd3ZaejRLUEM5emRtYysiLAoiYXR0cmlidXRlcyI6IFsgCnsKInRyYWl0X3R5cGUiOiAiY3V0ZW5lc3MiLAoidmFsdWUiOiAxMDB9XQp9";

    // Modifiers
    modifier mintForAllMoods() {
        vm.prank(USER);
        mood.mintNft(1);
        console.log(mood.tokenURI(0));

        vm.prank(USER);
        mood.mintNft(2);
        console.log(mood.tokenURI(1));

        vm.prank(USER);
        mood.mintNft(0);
        console.log(mood.tokenURI(2));

        _;
    }

    function setUp() external {
        deployer = new DeployMoodNft();
        mood = deployer.run();
    }

    function testIntegrationViewDefaultTokenUri() public mintForAllMoods {
        // Since we are checking for tokenId = 4, the below RevertCheck will be successful
        vm.expectRevert(MoodNft.MoodNft__InvalidTokenId.selector);
        console.log(mood.tokenURI(4));
    }

    function testMoodToTokenUriMapping() public {
        vm.prank(USER);
        mood.mintNft(2);

        console.log(mood.tokenURI(0));
        console.log(BLUE_FACE_TOKEN_URI);

        assert(
            keccak256(abi.encodePacked(mood.tokenURI(0))) ==
                keccak256(abi.encodePacked(BLUE_FACE_TOKEN_URI))
        );
    }

    function testGetMoodFromTokenId() public mintForAllMoods {
        // Verify Mood from TokenId
        console.log(
            "Mood for TokenId 2 - ",
            uint256(mood.getMoodFromTokenId(2))
        );
        assert(MoodNft.Mood.HAPPY == mood.getMoodFromTokenId(2));
        assert(MoodNft.Mood.BLUE == mood.getMoodFromTokenId(1));
        assert(MoodNft.Mood.SAD == mood.getMoodFromTokenId(0));
    }
}
