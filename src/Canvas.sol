pragma solidity ^0.8.15;

import "./interfaces/ICanvas.sol";

function abs(int256 x) pure returns (int256) {
    return x >= 0 ? x : -x;
}

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

    /* Rasterizer */
    function drawLine(uint256 ux0, uint256 uy0, uint256 ux1, uint256 uy1, uint256 color) public {
        int256 x0 = int256(ux0);
        int256 x1 = int256(ux1);
        int256 y0 = int256(uy0);
        int256 y1 = int256(uy1);
        int256 dx = abs(x1 - x0);
        int256 sx = x0 < x1 ? int256(1) : int256(-1);
        int256 dy = -abs(y1 - y0);
        int256 sy = y0 < y1 ? int256(1) : int256(-1);
        int256 err = dx + dy;
        int256 e2; /* error value e_xy */

        for (;;) {
            setPixel(uint256(x0), uint256(y0), color);
            e2 = 2 * err;
            if (e2 >= dy) {
                /* e_xy+e_x > 0 */
                if (x0 == x1) {
                    break;
                }
                err += dy;
                x0 += sx;
            }
            if (e2 <= dx) {
                /* e_xy+e_y < 0 */
                if (y0 == y1) {
                    break;
                }
                err += dx;
                y0 += sy;
            }
        }
    }

    function drawCircle(
        uint256 uxm,
        uint256 uym,
        uint256 ur,
        uint256 color
    ) public {
        int xm = int(uxm);
        int ym = int(uym);
        int r = int(ur);
        int256 x = -r;
        int256 y = 0;
        int256 err = 2 - 2 * r; /* II. Quadrant */
        do {
            setPixel(uint(xm - x), uint(ym + y), color); /*   I. Quadrant */
            setPixel(uint(xm - y), uint(ym - x), color); /*  II. Quadrant */
            setPixel(uint(xm + x), uint(ym - y), color); /* III. Quadrant */
            setPixel(uint(xm + y), uint(ym + x), color); /*  IV. Quadrant */
            r = err;
            if (r <= y) err += ++y * 2 + 1; /* e_xy+e_y < 0 */
            if (r > x || err > y) err += ++x * 2 + 1; /* e_xy+e_x > 0 or no 2nd y-step */
        } while (x < 0);
    }
}
