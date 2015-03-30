APP_FILE  = 'app.rb'
APP_CLASS = 'App'

require 'sinatra/assetpack/rake'

task :environment do
  require './app'
end

desc "Run those specs"
task :spec do
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = %w{--colour --format documentation}
  end
end

