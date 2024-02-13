import { Color } from 'three';
import { IfcViewerAPI } from 'web-ifc-viewer';

export function createModelView() {
    const container = document.createElement("div");
    container.id = "modelContainer";
    document.body.appendChild(container);
    const viewerColor = new Color('#f4f4f4');
    const viewer = new IfcViewerAPI({ container, backgroundColor: viewerColor });
    viewer.grid.setGrid();
    viewer.axes.setAxes();

    const inputButton = document.querySelector("#fileInput");
    inputButton.addEventListener("change", async () => {
        console.log("file input chnaged")
        const ifcFile = inputButton.files[0];
        const ifcURL = URL.createObjectURL(ifcFile);
        await viewer.IFC.loadIfcUrl(ifcURL);
    })


}