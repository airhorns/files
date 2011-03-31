source 'http://rubygems.org'

gem 'rails'
gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'mysql2'
gem "devise"
gem "jammit" # Javascript packager and helper
gem "thwart", "0.0.4"

group :development, :test do
  # Language manipulation stack
  gem "haml-rails"
  gem "jquery-rails" # Template generator for jQuery
  gem "compass"
  gem "fancy-buttons"

  # Javascript testing
  gem 'evergreen', '0.4.0', :require => 'evergreen/rails', :path => "~/Code/evergreen"
   
  # Mongrel as test server
  gem "mongrel", "1.2.0.pre2"
  
  # RSpec for unit tests
  gem "rspec-rails", ">= 2.0.1"
  
  # Steak + Capybara for integration tests
  gem "steak", ">= 1.0.0.rc.1"
  gem "capybara"

  # Guard for watchin' stuff and reacting
  gem "guard"
  gem "guard-rspec"
  gem "guard-coffeescript"
  gem "guard-compass"

  # ruby-debug 1.9 for ruby 1.9
  gem "ruby-debug19", :require => "ruby-debug"
end
