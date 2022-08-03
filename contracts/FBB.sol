// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

address constant totalWallet = 0x09395E698CC8B90D6b7D882919E15085049cFbaE;

contract FBB is ERC721URIStorage, ERC721Enumerable {
    event MintBirdBox(address indexed to, uint8 boxType, uint256 tokenId);

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address fbtTokenAddress;
    IERC20 token;
    string private baseURI = "http://172.20.10.4:8001/v1/api/birdbox/nft";

    constructor(address fbtToken) ERC721("FBIRD BOX", "FBB") {
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

    function mintBirdBox(uint8 boxType) public returns (string memory) {
        uint256 erc20balance = token.balanceOf(msg.sender);
        uint256 amount = 100000;
        string memory boxQuality;
        string memory uri;

        if (boxType == 1) {
            boxQuality = "COMMOM";
            amount = 1000 * 10**18;
        } else if (boxType == 2) {
            boxQuality = "COSMETIC";
            amount = 2000 * 10**18;
        } else if (boxType == 3) {
            boxQuality = "LEGENDARY";
            amount = 5000 * 10**18;
        }
        require(amount <= erc20balance, "balance is low");

        token.transferFrom(msg.sender, totalWallet, amount);

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        nftItem[newItemId] = NFTItem(newItemId, payable(msg.sender));
        _mint(msg.sender, newItemId);
        uri = string(abi.encodePacked(baseURI, "/", Strings.toString(newItemId)));
        _setTokenURI(newItemId, uri);
        emit MintBirdBox(msg.sender, boxType, newItemId);
        return uri;
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
