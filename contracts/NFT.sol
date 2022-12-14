// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

import "hardhat/console.sol";

contract NFT is ERC721URIStorage, ERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address fbtTokenAddress;
    IERC20 token;

    constructor(address fbtToken) ERC721("FBird NFT", "FBNFT") {
        fbtTokenAddress = fbtToken;
        token = IERC20(fbtToken);
    }

    struct NFTItem {
        uint256 tokenId;
        address payable owner;
    }

    mapping(uint256 => NFTItem) private nftItem;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    // Base URI
    string private _baseURIextended;

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI)
        internal
        virtual
        override
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI set of nonexistent token"
        );
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory _tokenURI = _tokenURIs[tokenId];

        return _tokenURI;
    }

    function createToken(string memory tokenNFTURI) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        nftItem[newItemId] = NFTItem(newItemId, payable(msg.sender));
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenNFTURI);
        return newItemId;
    }

    function getOwnerNFT() public view returns (NFTItem[] memory) {
        uint256 currentTokenID = _tokenIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for (uint256 i = 0; i < currentTokenID; i++) {
            if (nftItem[i + 1].owner == msg.sender) {
                itemCount += 1;
            }
        }
        NFTItem[] memory items = new NFTItem[](itemCount);

        for (uint256 i = 0; i < currentTokenID; i++) {
            if (nftItem[i + 1].owner == msg.sender) {
                items[currentIndex] = nftItem[i + 1];
                currentIndex += 1;
            }
        }

        return items;
    }
}
