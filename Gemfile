source "https://rubygems.org"

ruby "2.1.5"
gem "rails", "~> 4.2.0" # rails! :-)
gem "dotenv-rails", :groups => [:development, :test]  # Autoload dotenv in Rails.
gem "pg"  # postgres interface
gem "dce_lti", '~> 0.5.2'  # handles the canvas security handshake
gem "httparty" # handles http requests

gem "bourbon", "~> 3.2.1"  #library of pure Sass mixins that are designed to be simple and easy to use. 
gem "neat", "~> 1.5.1"  # fluid grid framework to work with Bourbon
gem 'refills'  # Prepackaged patterns and components built with Bourbon, Neat and Bitters.

gem "coffee-rails"  # CoffeeScript adapter for the Rails asset pipeline.
gem "delayed_job_active_record"  # ActiveRecord backend for Delayed::Job
gem "email_validator"  # what it sez
gem "flutie"  # provides some utility view helpers for use with Rails applications; There are helpers for setting a page title and for generating body classes.
gem "high_voltage" # Rails engine for static pages.

gem "normalize-rails", "~> 3.0.0" # Integrates normalize.css with the rails asset pipeline.
gem "rack-timeout"  # times out long-running requests (default: 15s)

gem 'responders', '~> 2.0'  # inserts/handles some http response stuff
gem 'redcarpet'  # Markdown to (x)html renderer
gem "recipient_interceptor"  # prevents senind emails to real people from staging environment
gem "sass-rails", "~> 4.0.3"  # sass adaptor
gem "simple_form"  # form generation
gem "title"  # "Translations for <title>s!" (?)
gem "i18n-tasks"  # find and manage missing and unused translations.
gem "jquery-rails" # jQuery stuff
gem "uglifier" # ruby wrapper for UglifyJS JS compressor
gem "unicorn" # http server for Rack applications and fast clients
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'activerecord-session_store', '~> 0.1.1'  # "An Action Dispatch session store backed by an Active Record class."
gem 'browser', '~> 0.8.0'  # browser detection

gem 'waiable' # add accessibility to forms
gem 'therubyracer'  # needed for less
gem 'less-rails-bootstrap'
gem 'font-awesome-less', '~> 4.2.0'  # fonts that TLT uses

group :development do
  gem 'binding_of_caller' # for better_errors
  gem 'quiet_assets'  # turns off Rails asset pipeline log
  gem 'better_errors'
end

group :development, :test do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'bundler-audit', require: false  # provides patch-level verification for Bundled apps
  gem 'brakeman', require: false  # detects security vulnerabilities in Ruby on Rails applications via static analysis.
  gem "awesome_print" # pretty print Ruby objects
  gem "byebug" # Ruby 2 debugger.
#  gem "dotenv-rails"  # Autoload dotenv in Rails.
  gem "factory_girl_rails" # rails version of factory_girl for test suite creation
  gem "pry-rails" # opens pry from the rails console
  gem "rspec-rails", "~> 3.1.0" # run tests on rails
end

group :test do
  gem "schema_to_scaffold" # from CRT; "Enables "rails generate scaffold" to create Rails code that matches an existing database "
  gem "database_cleaner"   # cleans databases for testing
  gem "launchy"  # " helper class for launching cross-platform applications in a fire and forget manner"
  gem "shoulda-matchers", require: false   # "Shoulda Matchers provides RSpec- and Minitest-compatible one-liners that test common Rails functionality."
  gem "timecop" # help test time-dependent code
  gem "webmock"  # "stubbing HTTP requests and setting expectations on HTTP requests"
  gem "simplecov", require: false  # code coverage
  gem 'rack_session_access'  # "middleware that provides access to rack.session environment"
end




group :staging, :production do
  gem 'rails_12factor'  # something to do with 12factor log stuff
  gem 'newrelic_rpm' # performance management system
end
