#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sinatra'
require 'sinatra/param'
require 'fileutils'

# Include upload_to_db.rb
require_relative 'upload_to_db'

LIMIT = 100

class App < Sinatra::Base
  set :bind, "0.0.0.0"
  set :public_folder, "#{__dir__}/static"
  set :ifc_files_dir, "#{__dir__}/ifc_files"
  set :owl_files_dir, "#{__dir__}/owl_files"

  # Route to render the index page
  get '/' do
    erb :index, format: :html5
  end

  # Route to handle file upload
  post '/upload' do
    if params[:fileInput].nil? || params[:fileInput][:tempfile].nil? || params[:fileType].nil?
      return "No file selected for upload or file type not specified."
    end

    uploaded_file = params[:fileInput][:tempfile]
    filename = params[:fileInput][:filename]
    file_type = params[:fileType]

    case file_type
    when 'ifc'
      handle_ifc_upload(uploaded_file, filename)
    when 'rdf', 'ifcowl', 'ttl'
      handle_rdf_upload(uploaded_file, filename)
    else
      return "Unsupported file type selected."
    end
  end

  # Route to handle SPARQL query execution
  post '/run_sparql' do
    content_type :json
    sparql_query = params[:sparqlQuery]
    puts sparql_query

    # Implement logic to execute the SPARQL query here
    # You can use a SPARQL query engine or your preferred method
    sparql_endpoint = 'https://kg.informatik.uni-stuttgart.de/repositories/DigitalTwinsLab2023'
    username = 'SemanticDigitalTwins2023'
    password = 'eem1uNiique2phowoht9'

    # Create an instance of the ExtendedSPARQL::AuthenticatedClient
    client = ExtendedSPARQL::AuthenticatedClient.new(sparql_endpoint, username: username, password: password)

    begin
      result = client.query(sparql_query)

      # Extrahiere die Werte aus dem RDF::Query::Solution-Objekt
      results_formatted = result.map { |solution| solution.bindings.values.join(", ") }.join("\n")

      { results: results_formatted }.to_json
    rescue SPARQL::Client::ClientError => e
      { error: "SPARQL Query Error: #{e.message}" }.to_json
    rescue StandardError => e
      { error: "Unexpected Error: #{e.message}" }.to_json
    end
  end

  post '/fetch_sparql_result' do
    content_type :json
    query = params[:query]
    puts query
    
    # Implement logic to execute the SPARQL query here
    # You can use a SPARQL query engine or your preferred method
    sparql_endpoint = 'https://kg.informatik.uni-stuttgart.de/repositories/DigitalTwinsLab2023'
    username = 'SemanticDigitalTwins2023'
    password = 'eem1uNiique2phowoht9'

    # Create an instance of the ExtendedSPARQL::AuthenticatedClient
    client = ExtendedSPARQL::AuthenticatedClient.new(sparql_endpoint, username: username, password: password)

    begin
      result = client.query(query)

      # Extrahiere die Werte aus dem RDF::Query::Solution-Objekt
      results_formatted = result.map { |solution| solution.bindings }

      { results: results_formatted }.to_json
    rescue SPARQL::Client::ClientError => e
      { error: "SPARQL Query Error: #{e.message}" }.to_json
    rescue StandardError => e
      { error: "Unexpected Error: #{e.message}" }.to_json
    end
  end

  private

  # Method to handle IFC file upload
  def handle_ifc_upload(uploaded_file, filename)
    FileUtils.mkdir_p(settings.ifc_files_dir) unless File.exist?(settings.ifc_files_dir)
    FileUtils.mkdir_p(settings.owl_files_dir) unless File.exist?(settings.owl_files_dir)

    File.open(File.join(settings.ifc_files_dir, filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end

    puts "IFC File '#{filename}' has been uploaded to the 'ifc_files' folder."
    owl_filepath = File.join(settings.owl_files_dir, "#{File.basename(filename, File.extname(filename))}.ifcowl")
    IFC.to_ifc_owl(File.join(settings.ifc_files_dir, filename), owl_filepath)
    upload_graph(owl_filepath, filename)
  end

  # Method to handle RDF file upload
  def handle_rdf_upload(uploaded_file, filename)
    FileUtils.mkdir_p(settings.owl_files_dir) unless File.exist?(settings.owl_files_dir)

    File.open(File.join(settings.owl_files_dir, filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end

    puts "RDF/IFCOWL File '#{filename}' has been uploaded to the 'owl_files' folder."
    upload_graph(File.join(settings.owl_files_dir, filename), filename)
  end
end

class IFC
  def self.to_ifc_owl(arg1, arg2)
    jar_path = File.expand_path("ifc_to_ifcOWL.jar", __dir__)
    puts "Input IFC file: #{arg1}"
    puts "Output ifcOWL file: #{arg2}"
    puts "The java package used for convention: #{jar_path}"
    command = "java -jar #{jar_path} #{arg1} #{arg2}"
    puts "Command for system console is: #{command}"
    system(command)
    puts "Finished"
  end
end
