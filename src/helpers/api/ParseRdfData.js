export function parseRdfData(rdfData) {
    try {
        const nodes = new Set();
        const links = [];

        rdfData.forEach(triple => {
            // var s = triple.s.split("/").pop()
            // var o = triple.o.split("/").pop()
            // var p = triple.p.split("/").pop().split("#").pop()
            // if (!s)
            //     s = triple.s.split("/").slice(-3).join("")
            // if (!o)
            //     o = triple.o.split("/").slice(-3).join("")

            nodes.add(triple.s);
            nodes.add(triple.o);

            links.push({
                source: triple.s,
                target: triple.o,
                predicate: triple.p
            });
        });

        return { nodes: Array.from(nodes), links: links };
    } catch (err) {
        console.error("Error:", err);
        return null;
    }
}