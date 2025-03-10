# frozen_string_literal: true

require "bundler/setup"
require "technology_one_scraper"
require "vcr"

ENV['CYCLE_POSITION'] = '0'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Make it stop on the first failure. Makes in this case
  # for quicker debugging
  config.fail_fast = true

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

ScraperUtils::MechanizeUtils::AgentConfig.configure do |config|
  config.default_random_delay = nil
end

ScraperUtils::RandomizeUtils.sequential = true
