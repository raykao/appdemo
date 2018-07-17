require 'sinatra'

require "sinatra"
require "mongo"

# Server values
HOSTADDRESS = ENV["HOSTADDRESS"] || "0.0.0.0"
HOSTPORT = ENV["HOSTPORT"] || "4567"
HOSTENVIRONMENT = ENV["HOSTENVIRONMENT"] || null

# Set Server Values
set :bind, HOSTADDRESS
set :port, HOSTPORT
set :server, "thin"
set :environment, HOSTENVIRONMENT

## Database values
DBURI = ENV["MONGOURI"]
DBOptions = {}
DBOptions[:user] = ENV["MONGOUSER"] if ENV["MONGOUSER"]
DBOptions[:password] = ENV["MONGOPWD"] if ENV["MONGOPWD"]
DBOptions[:database] = ENV["MONGODB"] if ENV["MONGODB"]
 # Note to self: bash "MONGODBSSL" value is only false if it is completely *NOT* set i.e. bash variable does not exist.  
 # Otherwise even a value of false returns true in ruby when grabbing from ENV ¯\_(ツ)_/¯
DBOptions[:ssl] = true if ENV["MONGODBSSL"]

Mongo::Logger.logger.level = Logger::FATAL if :production?

begin
  DBClient = Mongo::Client.new([DBURI], DBOptions)
  puts('Client Connection: ')
  puts(DBClient.cluster.inspect)
  puts('Collection Names: ')
  puts(DBClient.database.collection_names.inspect)
  puts('Connected!')
rescue StandardError => err
  puts('Error: ')
  puts(err)
end

get '/flights/country/:code' do
  content_type 'application/json'
  key = request.path_info

  flights = DBClient[:flights].find().to_a.to_json

  return flights
end

get '/healthprobe' do
  "Put this in your pipe and smoke it!"
end

get 'readinessprobe' do
  "Ready to go!"
end