//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import { Base64 } from "./libraries/Base64.sol";

//inheriting imported contract
contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    //base SVG code
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    //random words
    string[] firstWords = ["Flaming", "Silver", "Neurotic", "Young", "Tragically", "Charming"];
    string[] secondWords = ["Old", "Fine", "Round", "Rude", "Polite", "Cowardly"];
    string[] thirdWords = ["Pumpkins", "Lips", "Stones", "Cannibals", "Debutantes", "Natives"];

    constructor () ERC721 ("BandNameNFT", "BAND") {
        console.log("This is my NFT contract.");
    }

    //randomly pick words from arrays

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        //seed RNG
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    //function user calls to get their NFT
    function makeAnEpicNFT() public {
          
        //get current tokenId, starting at 0
        uint256 newItemId = _tokenIds.current();

        //check to make max mints has not been met
        require(newItemId <= 49, "Maximum number of NFTs already minted!");
        
        //get random words
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));
        //generate final code for SVG via concatination
        string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));
        //get all JSON metadata in place and base64 encode it
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "The most epic band names ever.", "image": "data:image/svg+xml;base64,',
                    // add data:image/svg+xml;base64 and then append our base64 encoded svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                    )
                )
            )
        );
        //generate final URI using encoded JSON
        string memory finalTokenUri = string(abi.encodePacked("data:application/json;base64,", json));
        
        
        console.log("\n---------------------------");
        console.log(finalTokenUri);
        console.log("---------------------------\n");

        //mint NFT
        _safeMint(msg.sender, newItemId);
        //set NFT data
        _setTokenURI(newItemId, "placeholder");
        //console log minting
        console.log("A new NFT with ID %s has been minted by %s!", newItemId, msg.sender);
        //increment tokenId
        _tokenIds.increment();
        emit NewEpicNFTMinted(msg.sender, newItemId);
        
    }

    function getTotalMinted() public view returns (uint256) {
        uint256 total = _tokenIds.current();
        return total;
    } 
}