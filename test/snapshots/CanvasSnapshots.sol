// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import {Test} from "forge-std/Test.sol";
import "../../src/interfaces/ICanvas.sol";

contract CanvasSnapshots is Test {
    uint256[3][3] testDrawLineSnap = [
        [uint256(1), 0, 0],
        [uint256(0), 1, 2],
        [uint256(0), 0, 1]
    ];
    uint256 public width = 3;
    uint256 public height = 3;

    /**/
    function assertEqPixels(
        CanvasState memory imgState,
        uint256[3][3] memory expected
    ) public {
        uint256[][] memory input = imgState.pixels;
        for (uint256 y = 0; y < uint256(height); y++) {
            for (uint256 x = 0; x < uint256(width); x++) {
                /* uint pixel = ctx.getPixel(x,y) ; */
                uint256 pixel = input[uint256(y)][uint256(x)];
                uint256 expectedPixel = expected[uint256(y)][uint256(x)];
                assertEq(pixel, expectedPixel);
            }
        }
    }

    function assertEqPixels(ICanvas img, uint256[3][3] memory expected) public {
        CanvasState memory state = img.getState();
        assertEqPixels(state, expected);
    }
}
