require File.dirname(__FILE__) + '/../app'
require 'rspec'
require 'rack/test'

set :environment, :test

RSpec.configure do |conf|
  conf.color = true
  conf.tty = true
  conf.include Rack::Test::Methods
end

def app
  App
end