require 'simplecov'
SimpleCov.start

require 'rails_helper'
require 'capybara/rspec'
require 'capybara/dsl'
require 'ecomm/factories'
require 'carrierwave/test/matchers'
require 'rack_session_access/capybara'

%w(support helpers **/shared_examples).each do |folder|
  # Dir["#{File.dirname(__FILE__)}/../spec/#{folder}/**/*.rb"].each do |file|
    # require file
  # end
  Dir[Rails.root.join("spec/#{folder}/**/*.rb")].each { |file| require file }
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.around :each, type: :feature do |example|
    if example.metadata[:use_selenium]
      saved_driver = Capybara.current_driver
      Capybara.current_driver = :selenium
    end

    example.run

    Capybara.current_driver = saved_driver if example.metadata[:use_selenium]
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = :random
  config.include CarrierWave::Test::Matchers
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Rails.application.routes.url_helpers
end
