import * as d3 from "d3";

export function D3Visualization(graph) {
    // Load the graph data from the JSON file

    // Transform nodes from strings to objects with an id and label
    const nodes = graph.nodes.map(node => ({
        id: node,
        label: node.split(/[\/#]/).pop() // Keep the last segment of the URI for the label
    }));

    // Update links to refer to the node objects and extract predicate label
    const links = graph.links.map(link => ({
        source: nodes.find(n => n.id === link.source),
        target: nodes.find(n => n.id === link.target),
        label: link.predicate.split(/[\/#]/).pop() // Keep the last segment of the predicate for the label
    }));

    var height = 350;
    var width = 550;

    document.querySelector("#d3-vis").innerHTML = "";



    const svg = d3.select("#d3-vis").append("svg").attr("width", width)
        .attr("height", height)
        .attr("viewBox", `0 0 ${width} ${height}`);

    const simulation = d3.forceSimulation(nodes)
        .force("link", d3.forceLink(links).id(d => d.id).distance(10).strength(0.2))
        // .force("charge", d3.forceManyBody().strength(-200)) // Reduce repulsion
        .force("collide", d3.forceCollide(d => d.label.length * 3).strength(0.005)) // Reduce collision force
        .force("center", d3.forceCenter(width / 2, height / 2));

    // Define the arrowhead marker
    svg.append('defs').append('marker')
        .attr('id', 'arrowhead')
        .attr('viewBox', '-0 -5 10 10')
        .attr('refX', 50) // Adjust this value to move the arrowhead along the link
        .attr('refY', 0)
        .attr('orient', 'auto')
        .attr('markerWidth', 2) // Marker size
        .attr('markerHeight', 2)
        .attr('xoverflow', 'visible')
        .append('svg:path')
        .attr('d', 'M 0,-5 L 10 ,0 L 0,5') // Arrowhead shape
        .attr('fill', '#999'); // Arrowhead color

    // Draw the links
    const link = svg.append("g")
        .attr("class", "links")
        .selectAll("line")
        .data(links)
        .enter().append("line")
        .attr("stroke-width", 2)
        .style("stroke", "grey")
        .attr('marker-end', 'url(#arrowhead)'); // Use the arrowhead marker;

    // Draw the nodes
    const node = svg.append("g")
        .attr("class", "nodes")
        .selectAll("circle")
        .data(nodes)
        .enter().append("circle")
        .attr("r", 5) // Reduced node size

    // Labels for the nodes
    const nodeLabels = svg.append("g")
        .selectAll(".node-label")
        .data(nodes)
        .enter().append("text")
        .attr("class", "node-label")
        .attr("text-anchor", "middle") // Center the text
        .attr("dy", ".35em") // Vertically align text
        .text(d => d.label);

    // Labels for the links
    const linkLabels = svg.append("g")
        .selectAll(".link-label")
        .data(links)
        .enter().append("text")
        .attr("class", "link-label")
        .attr("text-anchor", "middle")
        .attr("dy", ".35em")
        .text(d => d.label);

    // Update the simulation's tick function
    simulation.on("tick", () => {
        link
            .attr("x1", d => d.source.x)
            .attr("y1", d => d.source.y)
            .attr("x2", d => d.target.x)
            .attr("y2", d => d.target.y);

        node
            .attr("cx", d => d.x)
            .attr("cy", d => d.y);

        nodeLabels
            .attr("x", d => d.x)
            .attr("y", d => d.y);

        linkLabels
            .attr("x", d => (d.source.x + d.target.x) / 2)
            .attr("y", d => (d.source.y + d.target.y) / 2);
    });

    // Drag functionalities
    node.call(d3.drag()
        .on("start", dragstarted)
        .on("drag", dragged)
        .on("end", dragended));

    // Drag functions
    function dragstarted(event, d) {
        if (!event.active) simulation.alphaTarget(0.3).restart();
        d.fx = d.x;
        d.fy = d.y;
    }

    function dragged(event, d) {
        d.fx = event.x;
        d.fy = event.y;
    }

    function dragended(event, d) {
        if (!event.active) simulation.alphaTarget(0);
        d.fx = null;
        d.fy = null;
    }

}