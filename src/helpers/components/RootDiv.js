"use Strict";
import CONSTANTS from '../constants';

export function createRootDiv() {
    const root = document.createElement("div");
    root.id = CONSTANTS.ID.ROOT_DIV;
    root.style.height = "100vh";
    root.style.width = "100vw";
    root.style.backgroundColor = "#ffe6e6";

    document.body.appendChild(root)
}