ENV['RACK_ENV'] ||= 'test'
require_relative '../config/env'
require 'rack/test'
require 'minitest/autorun'

DatabaseCleaner.strategy = :truncation

module MinitestExtension
  include FactoryGirl::Syntax::Methods

  def before_setup
    DatabaseCleaner.start
  end

  def after_teardown
    DatabaseCleaner.clean
  end
end

class Minitest::Test
  include MinitestExtension
end

class ControllerTest < Minitest::Test
  include Rack::Test::Methods

  def app; Web end
end
