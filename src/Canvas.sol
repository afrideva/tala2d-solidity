pragma solidity ^0.8.15;

import "./interfaces/ICanvas.sol";

contract Canvas is ICanvas {
    CanvasState public state;

    constructor(uint256 width, uint256 height, uint256 color) {
        state.width = width;
        state.height = height;
        fill(color);
    }

    function getState() public view returns (CanvasState memory s) {
        return state;
    }

    function setPixel(uint256 x, uint256 y, uint256 color) public {
        state.pixels[y][x] = color;
    }

    function getPixel(uint256 x, uint256 y) public view returns (uint256) {
        return state.pixels[y][x];
    }

    function fill(uint256 color) public {
        uint256 width = state.width;
        uint256 height = state.height;
        uint256[] memory row = new uint256[](width);
        delete state.pixels;
        for (uint256 index = 0; index < width; index++) {
            row[index] = color;
        }
        for (uint256 index = 0; index < height; index++) {
            state.pixels.push(row);
        }
    }
}
