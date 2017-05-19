require 'minitest/autorun'
require 'minitest/spec'
require "mocha/setup"

require 'hammer_cli'
require 'hammer_cli_foreman/testing/api_expectations'

FOREMAN_VERSION = Gem::Version.new(ENV['TEST_API_VERSION'] || '1.15')

include HammerCLIForeman::Testing::APIExpectations
HammerCLI.context[:api_connection].create('foreman') do
  api_connection({}, FOREMAN_VERSION)
end

require 'hammer_cli_foreman_virt_who_configure'
