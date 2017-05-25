require_relative '../test_helper'

require 'hammer_cli/testing/command_assertions'
require 'hammer_cli/testing/output_matchers'

include HammerCLI::Testing::CommandAssertions
include HammerCLI::Testing::OutputMatchers

def missing_arguments_result(argument_name)
  HammerCLI::Testing::CommandAssertions::CommandExpectation.new('', /Missing arguments for.*\[#{argument_name}\]/, HammerCLI::EX_USAGE)
end

def assert_requires_argument(cmd, params, required_argument_name)
  expected_result = missing_arguments_result(required_argument_name)

  api_expects_no_call
  result = run_cmd(cmd + params)
  assert_cmd(expected_result, result)
end

def assert_usage_error(cmd, params, error_msg)
  expected_result = usage_error_result(cmd,
    error_msg,
    "Could not create the Virt Who configuration")

  api_expects_no_call
  result = run_cmd(cmd + params)
  assert_cmd(expected_result, result)
end

def hash_to_opts(hash, options={})
  hash.reject do |k|
    k == options[:reject]
  end.map do |key, value|
    "--#{key.to_s.gsub('_', '-')}=#{value}"
  end
end

def config(attrs = {})
  {
    "name" => "test",
    "interval" => 60,
    "organization_id" => 1,
    "whitelist" => "",
    "blacklist" => "",
    "hypervisor_id" => "hostname",
    "hypervisor_type" => "libvirt",
    "hypervisor_server" => "libvirt.test.org",
    "hypervisor_username" => "user",
    "debug" => false,
    "satellite_url" => "10.34.131.166",
    "proxy" => "",
    "no_proxy" => "",
    "status" => "unknown",
    "last_report_at" => nil,
    "out_of_date_at" => nil,
    "filtering_mode" => 0,
    "id" => 11
  }.merge(attrs)
end
