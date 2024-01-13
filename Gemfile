source "http://rubygems.org"

ruby "~> 3.3.0"
gem 'rake'
gem 'excon'
gem 'hamlit'
gem 'addressable'
gem 'observer'
gem 'rmagick'
gem 'sprite-factory', git: 'https://github.com/RandieM/sprite-factory', require: 'sprite_factory'
gem 'dotenv'

group :guard do
  gem 'guard'
  gem 'guard-yield'
  gem 'guard-livereload'
end

group :test do
  gem 'rspec'
  gem 'vcr'
end

group :production do
  gem 'rollbar'
end