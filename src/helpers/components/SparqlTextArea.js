"use strict";
import { fetchQueryData } from "../api/fetchQueryData";
import CONSTANTS from "../constants";

function createTextBox() {
    const rootDiv = document.getElementById(CONSTANTS.ID.ROOT_DIV);

    const form = document.createElement("form");
    form.id = CONSTANTS.ID.SPARQL_FORM;
    form.addEventListener("submit", e => {
        e.preventDefault();
        const formData = {
            sparqlInput: textArea.value
        };
        fetchQueryData(formData.sparqlInput)
    });

    const textArea = document.createElement("textarea");
    textArea.rows = 8;
    textArea.cols = 40;
    textArea.id = CONSTANTS.ID.SPARQL_INPUT;
    textArea.required = "true";
    form.appendChild(textArea);

    const submitButton = document.createElement("button");
    submitButton.id = CONSTANTS.ID.SPARQL_SUBMIT;
    submitButton.type = "submit";
    submitButton.innerHTML = "Run Query";
    form.appendChild(submitButton);

    rootDiv.appendChild(form);
}

export { createTextBox }