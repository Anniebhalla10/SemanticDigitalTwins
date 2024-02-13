require 'rdf'
require 'sparql/client'
require 'net/http/persistent'
require 'net/http'
require 'json'

module ExtendedSPARQL
  class AuthenticatedClient < SPARQL::Client
    attr_accessor :username, :password, :base_url

    def initialize(base_url, username:, password:, **options, &block)
      @base_url = base_url
      @username = username
      @password = password
      super("#{base_url}", **options, &block)
    end

    def upload_file(file_path, graph_name)
      import_url = "#{base_url}/rdf-graphs/service?graph=http://ex.org/#{graph_name}"
      puts import_url
    
      uri = URI.parse(import_url)
    
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
    
      # Read file content as binary data
      file_content = File.binread(file_path)
    
      # Split file content into chunks of up to 100 lines until a space followed by a dot and a newline
      chunk_size = 1000
      chunks = file_content.split(/(?<=\.\n)\s+/, -1).each_slice(chunk_size).to_a
    
      # Process each chunk separately
      chunks.each_with_index do |chunk, index|
        request = Net::HTTP::Post.new(uri.request_uri)
        request.basic_auth(username, password)
        request['Content-Type'] = 'application/x-turtle'
    
        # Set the body of the request with the current chunk
        request.body = chunk.join
        #puts "chunk #{chunk}"
        #puts "Chunk #{index + 1} request body: #{request.body}"
        response = http.request(request)
        puts "Chunk #{index + 1} response: #{response}"
      end
    end
    
    
    

    private
    def make_post_request(query, headers)
      request = super(query, headers)
      request.basic_auth(username, password) if username && !username.empty?
      request
    end

    def make_get_request(query, headers)
      request = super(query, headers)
      request.basic_auth(username, password) if username && !username.empty?
      request
    end
  end
end
