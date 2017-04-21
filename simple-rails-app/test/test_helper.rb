ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails/capybara'

# when using javascript-drivers and sqlite
# you need https://github.com/iangreenleaf/transactional_capybara
TransactionalCapybara.share_connection

Capybara.javascript_driver = :webkit

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
