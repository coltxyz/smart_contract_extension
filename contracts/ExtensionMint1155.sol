// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @author: swms.de

import "./access/AdminControl.sol";
import "./core/IERC1155CreatorCore.sol";
import "./extensions/ICreatorExtensionTokenURI.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

/**
 * As I recall, I know you love to show off
 * But I never thought that you would take it this far
 * What do I know?
 */
contract ExtensionMint1155 is AdminControl, ICreatorExtensionTokenURI {
    using Strings for uint256;

    address private _creator;
    uint256 private _tokenId;
    string public _script;
    string private _name;
    string private _description;
    string private _attributes;
    string[2] private _previews;
    
    uint256[] private _tokenIdsForMint;
    uint256[] private _amountsForMint;
    string[] private _urisForMint;

    constructor(address creator) {
        _creator = creator;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AdminControl, IERC165)
        returns (bool)
    {
        return
            interfaceId == type(ICreatorExtensionTokenURI).interfaceId ||
            AdminControl.supportsInterface(interfaceId) ||
            super.supportsInterface(interfaceId);
    }

    function mint() public {
        // require(_tokenId == 0, "Token already minted");
        address[] memory arg1 = new address[](1);
        arg1[0] = msg.sender;
        _amountsForMint.push(1);
        _tokenIdsForMint.push(1);
        // IERC1155CreatorCore(_creator).mintExtensionNew(arg1, _amountsForMint, _urisForMint);
        IERC1155CreatorCore(_creator).mintExtensionExisting(arg1, _tokenIdsForMint, _amountsForMint);
    }

    function setName(string memory name) private adminRequired {
        _name = name;
    }

    function setDescription(string memory description) private adminRequired {
        _description = description;
    }

    function setAttributes(string memory attributes) private adminRequired {
        _attributes = attributes;
    }

    function setPreviews(string memory imagePreview, string memory videoPreview)
        private
    {
        // require(
        //     IERC1155(_creator).ownerOf(_tokenId) == msg.sender ||
        //         isAdmin(msg.sender),
        //     "Only owner or admin can change."
        // );
        _previews[0] = imagePreview;
        _previews[1] = videoPreview;
    }

    function tokenURI(address creator, uint256 tokenId)
        external
        view
        override
        returns (string memory)
    {
        require(creator == _creator && tokenId == _tokenId, "Invalid token");
        return
            string(
                abi.encodePacked(
                    "data:application/json;utf8,",
                    '{"name":"',
                    _name,
                    '","created_by":"SWMS","description":"',
                    _description,
                    '","image":"',
                    _previews[0],
                    '","image_url":"',
                    _previews[0],
                    '","attributes":[',
                    _attributes,
                    "]}"
                )
            );
    }
}
