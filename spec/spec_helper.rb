require File.join(File.dirname(__FILE__), '..', 'app')
require 'rspec'
require 'rspec/mocks'
require 'rack/test'
require 'pry'

set :environment, :test

RSpec.configure do |conf|
  conf.color = true
  conf.tty = true
  conf.include Rack::Test::Methods
end

def app
  App
end

class NullLogger
  def info(*args)
    puts args
  end
end

