require 'rubygems'
require 'bundler'
Bundler.require

Mongoid.load!('config/mongoid.yml')
FactoryGirl.definition_file_paths = %w{./factories ./test/factories ./spec/factories}
FactoryGirl.find_definitions
require './app/uploaders/avatar_uploader'
require './app/jobs/fetch_items_job'
require './app.rb'
require './app/models/channel'
require './app/models/item'
