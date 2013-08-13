# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'coveralls'
Coveralls.wear!('rails')

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'
require 'hashie'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, :js_errors => false)
end

# To debug failures of javascript-enabled tests, you can add ":debug => true"
# as an additional option on line 16. For example:
# Capybara::Poltergeist::Driver.new(app, :js_errors => true, :debug => true)
# This will result in verbose output in the Terminal when running tests.

# You can also use Poltergeist's experimental remote debugging feature by
# adding ":inspector => true" as an additional option on line 16. Then, in the
# failing test, add "page.driver.debug" at a spot where you want to pause the
# test. When you run the test, it will pause at that spot, and will launch a
# browser window where you can inspect the page contents.
# Remember to remove "page.driver.debug" when you're done debugging!
# https://github.com/jonleighton/poltergeist#remote-debugging-experimental

# Sometimes, debugging is as simple as using Ruby's "puts" to output whatever
# you want to the Terminal. For example, if you want to see the URLs for
# all the visible links on the page at any point during a test, you can add
# this line: all('a').each { |a| puts a[:href] }

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include DetailFormatHelper

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

end

