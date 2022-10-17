// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./Autora.sol";

/**
 * One of one fractional NFT
 */
contract AutoraFractionalNFT is ERC1155, Autora {
    event AutoraFractionalNFTCreated(address newAddress);

    /**
     * Construct the fractional NFT using a base uri, REV, parents & creator address
     */
    constructor(
        address payable _creator,
        address[] memory _parents,
        uint16 _REV,
        string memory _baseURI
    ) Autora(_creator, _parents, _REV) ERC1155(_baseURI) {
        address[] memory ancestors = getAncestors();
        //mint tokens to all ancestors
        autoraFractionalNFTMint(ancestors);
        emit AutoraFractionalNFTCreated(address(this));
    }

    function autoraFractionalNFTMint(address[] memory ancestors) internal {
        //mint to ancestors
        uint16 supply = 0;
        for (uint16 i = 0; i < ancestorCount; i++) {
            Autora ancestor = Autora(ancestors[i]);
            uint16 ancestorREV = ancestor.getREV();
            _mint(ancestor.getCreator(), 0, ancestorREV, "");
            supply += ancestorREV;
        }
        //give this contract's creator the ownership
        _mint(creator, 0, MAX_OWNERSHIP_VALUE - supply, "");
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(CantBeEvil, ERC1155)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
