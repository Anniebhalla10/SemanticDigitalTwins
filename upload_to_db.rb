require_relative 'sparql_client_extended.rb'
require 'rdf'
require 'rdf/ntriples'
# RDF database endpoint, username, and password

def upload_graph(rdf_file_path, graph_name)
  sparql_endpoint = 'https://kg.informatik.uni-stuttgart.de/repositories/DigitalTwinsLab2023'
  username = 'SemanticDigitalTwins2023'
  password = 'eem1uNiique2phowoht9'
  repo_id = 'DigitalTwinsLab2023'

# Create an instance of the ExtendedSPARQL::AuthenticatedClient
  client = ExtendedSPARQL::AuthenticatedClient.new(sparql_endpoint, username: username, password: password)
  client.upload_file(rdf_file_path, graph_name)
end
