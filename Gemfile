source 'http://rubygems.org'

gem 'rails'

# Datamapper
gem 'dm-core',                      '~> 1.1.0'
gem 'dm-serializer',                '~> 1.1.0'
gem 'dm-timestamps',                '~> 1.1.0'
gem 'dm-validations',               '~> 1.1.0'
gem 'dm-accepts_nested_attributes', '~> 1.1.0', :git => "git://github.com/snusnu/dm-accepts_nested_attributes.git"

gem 'dm-redis-adapter',             '~> 0.3.0', :path => "~/Code/dm-redis-adapter"
gem 'dm-devise',                    '~> 1.2.0'
gem 'redis-objects',                :require => "redis/objects" # LIKE A ZILLION ORMS MAN

# Authentication
gem 'devise'

# Media Info APIs
gem 'rockstar'
gem 'movie_searcher', :path => "~/Code/MovieSearcher"
gem 'carrierwave'
gem 'mini_magick' # for Carrierwave to generate thumbnails

# Tooling
gem 'jammit'

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
  gem 'spork', '~> 0.9.0.rc'

  # Steak + Capybara for integration tests
  gem "steak", ">= 1.0.0.rc.1"
  gem "capybara"

  # Guard for watchin' stuff and reacting
  gem "guard"
  gem "guard-rspec"
  gem "guard-coffeescript"
  gem "guard-compass"
  gem "guard-spork"
  gem "growl"

  # ruby-debug 1.9 for ruby 1.9
  gem "ruby-debug19", :require => "ruby-debug"
end

group :test do
  gem "webmock"
  gem "vcr"
end
