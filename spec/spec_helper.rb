$:.push File.expand_path("../lib", __FILE__)

require 'trooper'
require 'rspec'

require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

RSpec.configure do |config|
  # config
end

def mock_net_ssh!
  @connection = double("connection")
  @connection.stub(:close).and_return(true)
  Net::SSH.stub(:start).and_return(@connection)
  @channel = double("channel")
  @channel.stub(:wait).and_return(true)
end

def connection
  @connection
end

def channel
  @channel
end
