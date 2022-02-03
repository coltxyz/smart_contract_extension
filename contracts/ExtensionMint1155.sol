// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @author: swms.de

import "./access/AdminControl.sol";
import "./core/IERC1155CreatorCore.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

contract ExtensionMint1155 is AdminControl {
    using Strings for uint256;

    address private _creator;
    uint256[] private _tokenIdsForMint;
    uint256[] private _amountsForMint;
    string[] private _urisForMint;

    uint256 private _tokenId = 0;
    uint private _numMinted = 0;
    uint256 public constant PRICE = 0.01 ether;
    uint256 public constant MAX_MINTABLE = 5;
    string private constant METADATA_URI = 'https://studio.api.manifoldxyz.dev/asset_uploader/asset/3557341317/metadata/full';

    constructor(address creator) {
        _creator = creator;
        _amountsForMint.push(1);  // mint one token at a time
        _urisForMint.push(METADATA_URI);
    }

    function mintNew() public adminRequired {
        address[] memory _callerAddress = new address[](1);
        _callerAddress[0] = msg.sender;
        uint256[] memory minted = IERC1155CreatorCore(_creator).mintExtensionNew(_callerAddress, _amountsForMint, _urisForMint);
        _tokenId = minted[0];
        _numMinted ++;
    }

    function mintExisting() public payable {
        require(
            msg.value >= PRICE * 1,
            "Not enough ether to purchase NFT."
        );
        require(
            _numMinted <= MAX_MINTABLE,
            "All NFTs have been minted"
        );
        require(
            _tokenId > 0,
            "mintNew must be called first"
        );
        address[] memory _callerAddress = new address[](1);
        _callerAddress[0] = msg.sender;
        _tokenIdsForMint.push(_tokenId);
        IERC1155CreatorCore(_creator).mintExtensionExisting(_callerAddress, _tokenIdsForMint, _amountsForMint);
        _numMinted ++;

    }
}
