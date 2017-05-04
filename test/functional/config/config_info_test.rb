require_relative '../test_helper'

def expect_config_search(config)
  api_expects_search(:configs, :name => config['name']).returns(index_response([config]))
  api_expects(:configs, :show).with_params('id' => config['id']).returns(config)
end

def test_output_field(cmd, config_modification, output_label, output_value)
  expect_config_search(config(config_modification))

  output = FieldMatcher.new(output_label, output_value)

  result = run_cmd(cmd)
  assert_cmd(success_result(output), result)
end

def test_status_field(cmd, api_value, output_value)
  test_output_field(cmd, { "status" => api_value }, 'Status', output_value)
end

def test_interval_field(cmd, api_value, output_value)
  test_output_field(cmd, { "interval" => api_value }, 'Interval', output_value)
end

def test_filter_field(cmd, api_value, output_value)
  test_output_field(cmd, { "filtering_mode" => api_value }, 'Filtering', output_value)
end

describe "virt-who-config" do
  describe "info" do
    before do
      @cmd = ["virt-who-config", "info", '--name=test']
    end

    describe "interval formatting" do
      it "formats 1 hour" do
        test_interval_field(@cmd, 60, 'every hour')
      end

      it "formats 2 hours" do
        test_interval_field(@cmd, 120, 'every 2 hours')
      end
    end

    describe "status formatting" do
      it "formats status unknown" do
        test_status_field(@cmd, 'unknown', 'No Report Yet')
      end

      it "formats status ok" do
        test_status_field(@cmd, 'ok', 'OK')
      end

      it "formats status out_of_date" do
        test_status_field(@cmd, 'out_of_date', 'OK')
      end

      it "formats status error" do
        test_status_field(@cmd, 'error', 'Error')
      end

      it "formats unknown status" do
        test_status_field(@cmd, nil, 'Unknown configuration status')
      end
    end

    describe "when filter is none" do
      it "formats filter" do
        test_filter_field(@cmd, 0, 'Unlimited')
      end
      it "hides whitelist field" do
        expect_config_search(config("filtering_mode" => 0))
        refute_match('Filtered hosts:', run_cmd(@cmd).out)
      end

      it "hides blacklist field" do
        expect_config_search(config("filtering_mode" => 0))
        refute_match('Excluded hosts:', run_cmd(@cmd).out)
      end
    end

    describe "when filter is whitelist" do
      it "formats filter" do
        test_filter_field(@cmd, 1, 'Whitelist')
      end

      it "shows whitelist field" do
        expect_config_search(config("filtering_mode" => 1, 'whitelist' => 'host1,hostb'))

        output = FieldMatcher.new('Filtered hosts', 'host1,hostb')

        result = run_cmd(@cmd)
        assert_cmd(success_result(output), result)
      end

      it "shows empty whitelist field" do
        expect_config_search(config("filtering_mode" => 1, 'whitelist' => nil))
        assert_match('Filtered hosts:', run_cmd(@cmd).out)
      end

      it "hides blacklist field" do
        expect_config_search(config("filtering_mode" => 1))
        refute_match('Excluded hosts:', run_cmd(@cmd).out)
      end
    end

    describe "when filter is blacklist" do
      it "formats filter" do
        test_filter_field(@cmd, 2, 'Blacklist')
      end

      it "shows blacklist field" do
        expect_config_search(config("filtering_mode" => 2, 'blacklist' => 'host1,hostb'))

        output = FieldMatcher.new('Excluded hosts', 'host1,hostb')

        result = run_cmd(@cmd)
        assert_cmd(success_result(output), result)
      end

      it "shows empty blacklist field" do
        expect_config_search(config("filtering_mode" => 2, 'whitelist' => nil))
        assert_match('Excluded hosts:', run_cmd(@cmd).out)
      end

      it "hides whitelist field" do
        expect_config_search(config("filtering_mode" => 2))
        refute_match('Filtered hosts:', run_cmd(@cmd).out)
      end
    end

    describe "when filter is unknown value" do
      it "formats filter" do
        test_filter_field(@cmd, nil, 'Unknown listing mode')
      end
      it "hides whitelist field" do
        expect_config_search(config("filtering_mode" => 0))
        refute_match('Filtered hosts:', run_cmd(@cmd).out)
      end

      it "hides blacklist field" do
        expect_config_search(config("filtering_mode" => 0))
        refute_match('Excluded hosts:', run_cmd(@cmd).out)
      end
    end
  end
end
