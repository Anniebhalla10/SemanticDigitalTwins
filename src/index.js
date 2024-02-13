// import { createRootDiv } from "./helpers/components/RootDiv";
// import { createTextBox } from "./helpers/components/SparqlTextArea";
import { fetchQueryData } from "./helpers/api/fetchQueryData";
import { createModelView } from "./helpers/features/3DModelView";


// // Create Root div
// createRootDiv()

// // Creating text Area for the sparQL Query
// createTextBox()

createModelView()

document.getElementById('constructQuery').addEventListener('click', function () {
    const sparqlQuery = document.getElementById('sparqlQuery').value;
    console.log(sparqlQuery)
    fetchQueryData(sparqlQuery)
});