import { D3Visualization } from '../features/D3Visualization';
import { parseRdfData } from './ParseRdfData';

const axios = require('axios');


export async function fetchQueryData(query) {
    if (query) {
        try {
            fetch('/fetch_sparql_result', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `query=${encodeURIComponent(query)}`
            })
                .then(response => response.json())
                .then(data => {
                    const graphData = parseRdfData(data.results)
                    console.log(graphData)
                    D3Visualization(graphData)
                })
                .catch(error => {
                    console.error('Error:', error);
                });

        } catch (err) {
            console.error(err)
        }
    }
}

window.fetchQueryData = fetchQueryData