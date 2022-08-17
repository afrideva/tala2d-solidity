// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

struct CanvasState {
    uint256[][] pixels;
    uint256 size;
    uint256 height;
    uint256 width;
}

interface ICanvas {
    function fill(uint256 color) external;

    function getState() external view returns (CanvasState memory);

    function getPixel(uint256 x, uint256 y) external view returns (uint256);

    function setPixel(uint256 x, uint256 y, uint256 color) external;

    function drawLine(uint256 x0, uint256 y0, uint256 x1, uint256 y1, uint256 color) external;
}
