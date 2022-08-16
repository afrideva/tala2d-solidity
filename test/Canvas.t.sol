// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import {Test} from "forge-std/Test.sol";
import "../src/Canvas.sol";

contract CanvasTest is Test {
    ICanvas private canvas;
    uint256 width = 16;
    uint256 height = 16;
    uint256 initColor = 0;

    function setUp() public {
        canvas = new Canvas(width, height, initColor);
    }

    function testGetState() public {
        CanvasState memory s = canvas.getState();
        assertEq(s.pixels[0].length, width);
        assertEq(s.pixels[0][0], initColor);
        assertEq(s.pixels.length, height);
    }

    function testFill() public {
        uint256 color = 7;
        canvas.fill(color);
        CanvasState memory s = canvas.getState();
        assertEq(s.pixels[0][0], color);
    }

    function testGetPixel() public {
        canvas.fill(0);
        assertEq(canvas.getPixel(0, 0), 0);
    }

    function testSetPixel() public {
        uint256 color = 777;
        assertEq(canvas.getPixel(0, 0), 0);
        canvas.setPixel(0, 0, color);
        assertEq(canvas.getPixel(0, 0), color);
    }
}
