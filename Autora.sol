// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LicenseVersion, CantBeEvil} from "@a16z/contracts/licenses/CantBeEvil.sol";
import "hardhat/console.sol";

contract Autora is CantBeEvil {
    uint16 internal MAX_OWNERSHIP_VALUE = 100;
    uint16 internal ancestorCount = 0;
    address payable public creator;
    address[] public parents;
    uint16 public REV; // uint16 less than MAX_OWNERSHIP_VALUE

    constructor(
        address payable _creator,
        address[] memory _parents,
        uint16 _REV
    ) CantBeEvil(LicenseVersion.CBE_CC0) {
        require(_REV <= MAX_OWNERSHIP_VALUE, "Maximum REV = 100.");
        parents = _parents;
        REV = _REV;
        creator = payable(_creator);
    }

    function getCreator() external view returns (address) {
        return creator;
    }

    function getParents() external view returns (address[] memory) {
        return parents;
    }

    function getREV() external view returns (uint16) {
        return REV;
    }

    function getAncestors() internal returns (address[] memory) {
        address[] memory ancestors = new address[](MAX_OWNERSHIP_VALUE); //largest size the array could conceivably be
        loadAncestors(ancestors, parents);
        //check for sufficient equity to mint ownership tokens.
        require(
            getAncestorEquity(ancestors) <= MAX_OWNERSHIP_VALUE,
            "Not enough equity remaining to mint."
        );
        return ancestors;
    }

    /**
     * loads ancestor contracts into an ancestor array not including this contract
     */
    function loadAncestors(
        address[] memory ancestors,
        address[] memory _parents
    ) internal {
        for (uint256 i = 0; i < _parents.length; i++) {
            address parent = _parents[i];
            ancestors[ancestorCount] = parent;
            ancestorCount++;
            loadAncestors(ancestors, Autora(parent).getParents());
        }
    }

    /**
     * Computes the sum of ancestor ownership
     */
    function getAncestorEquity(address[] memory _ancestors)
        internal
        view
        returns (uint16)
    {
        uint16 ancestorEquity = 0;
        for (uint16 i = 0; i < ancestorCount; i++) {
            address ancestor = _ancestors[i];
            ancestorEquity += Autora(ancestor).getREV();
        }
        return ancestorEquity;
    }

    function senderIsAncestor(address sender, address[] memory ancestors) internal view returns(bool) {
        for (uint16 i = 0; i < ancestorCount; i++){
            if(sender == Autora(ancestors[i]).getCreator()){
                return true;
            }
        }
        return false;
    }
     
}
