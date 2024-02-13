require 'sparql/client'
require 'net/http'
require 'uri'
require 'base64'
require 'nokogiri'

# Set authentication credentials
username = 'SemanticDigitalTwins2023'
password = 'eem1uNiique2phowoht9'

# Encode the credentials for basic authentication
auth = Base64.strict_encode64("#{username}:#{password}")
auth_header = "Basic #{auth}"

# Set the SPARQL endpoint URL
endpoint_url = 'https://kg.informatik.uni-stuttgart.de/repositories/DigitalTwinsLab2023'  

# Create the SPARQL client
sparql = SPARQL::Client.new(endpoint_url)

# Define the SPARQL query
query = <<-SPARQL
  SELECT ?subject ?predicate ?object
  WHERE {
    ?subject ?predicate ?object
  }
  LIMIT 10
SPARQL

query_url = "#{endpoint_url}?query=#{URI.encode_www_form_component(query)}"

# Create the URI for the HTTP request
uri = URI.parse(query_url)

# Set up the HTTP connection
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = (uri.scheme == 'https')

# Create the HTTP request
request = Net::HTTP::Get.new(uri)
request['Authorization'] = auth_header
request['Accept'] = 'application/sparql-results+xml'
# Send the HTTP request
response = http.request(request)

if response.is_a?(Net::HTTPSuccess)
  # Process the response if authentication is successful
  response_body = response.body
  doc = Nokogiri::XML(response_body)

  # Extract and print the query results as tuples
  results = doc.xpath('//sparql:result', 'sparql' => 'http://www.w3.org/2005/sparql-results#')
  
  results.each do |result|
    subject = result.xpath('./sparql:binding[@name="subject"]/sparql:uri', 'sparql' => 'http://www.w3.org/2005/sparql-results#').text
    predicate = result.xpath('./sparql:binding[@name="predicate"]/sparql:uri', 'sparql' => 'http://www.w3.org/2005/sparql-results#').text
    object = result.xpath('./sparql:binding[@name="object"]/sparql:uri', 'sparql' => 'http://www.w3.org/2005/sparql-results#').text
    
    puts "Subject: #{subject}, Predicate: #{predicate}, Object: #{object}"
  end

else
  puts "Authentication failed. Status code: #{response.code}"
end
