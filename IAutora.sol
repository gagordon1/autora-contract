// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@a16z/contracts/licenses/ICantBeEvil.sol";

/**
 * A compliant Autora token, has creator info, parents, and can load ancestor
 * information
 */
interface IAutora is ICantBeEvil{
    /**
     * Gets the wallet address of the creator
     * @return address
     */
    function getCreator() external view returns (address);

    /**
     * Gets the addresses of this contract's parent as an array
     * @return address
     */
    function getParents() external view returns (address);

    /**
     * Gets the REV of the contract (integer between 0 and MAX_OWNERSHIP_VALUE)
     * @return address
     */
    function getREV() external view returns (uint16);
}
