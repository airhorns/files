# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.extend VCR::RSpec::Macros
end

VCR.config do |c|
  c.cassette_library_dir = File.join(Rails.root, 'spec', 'fixtures', 'cassettes')
  c.stub_with :webmock
  c.default_cassette_options = { :record => :new_episodes }
end

# Massage path function
def mp(p)
  File.join(Files::Config.files_path, p)
end
