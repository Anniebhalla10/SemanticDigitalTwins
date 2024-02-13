import os
import sys
import argparse
sys.path.append('/python-env/lib/python3.9/site-packages')

import ifcopenshell
from rdflib import Graph, Literal, Namespace, RDF, URIRef

# input_path="./ifcFiles/"
# file_name="Duplex_A_20110907"
# output_path="./outputFiles/"

def convert_ifc_to_rdf(ifc_path, output_rdf_path):
    # Set RDF namespaces and graph
    g = Graph()
    EX = Namespace("http://example.org/ifc/")
    g.bind("ex", EX)

    # Load IFC file
    ifc_file = ifcopenshell.open(ifc_path)

    # Traverse all entities in the IFC file
    for entity in ifc_file:
        entity_uri = URIRef(EX + entity.is_a() + "#" + str(entity.id()))
        # Entity type
        g.add((entity_uri, RDF.type, Literal(entity.is_a())))
        # Entity attributes
        for attr_name, attr_value in entity.get_info().items():
            if attr_value:
                g.add((entity_uri, RDF.type, URIRef(EX[entity.is_a()])))
                #g.add((entity_uri, URIRef(EX + attr_name), Literal(str(attr_value))))

    # serialize RDF graph and save to file
    g.serialize(destination=output_rdf_path, format='turtle')

if __name__ == "__main__":

    # Read command line parameters.
    # For example "python3 ifc_to_rdf.py myfile.ifc myfile.ttl"
    # Then the input file's name is myfile.ifc;
    # The output file's name is myfile.ttl
    parser = argparse.ArgumentParser()
    parser.add_argument('inputName')
    parser.add_argument('outputName')
    args = parser.parse_args()

    # Get the input file's absolute path
    input_file_path = os.path.abspath(args.inputName)

    # Get the input file's father path
    input_file_father_path = os.path.abspath(os.path.dirname(input_file_path) + os.path.sep + ".")

    # Generate the output file's absolute path
    output_file_path = os.path.join(input_file_father_path, args.outputName)

    # print(args.inputName)
    # print(args.outputName)
    # print(input_file_path)
    # print(input_file_father_path)
    # print(output_file_path)

    convert_ifc_to_rdf( input_file_path, output_file_path)
    print("Generation successful?")
