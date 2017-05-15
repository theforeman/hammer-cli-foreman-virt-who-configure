require_relative '../test_helper'

describe "virt-who-config" do
  describe "fetch" do
    before do
      @cmd = ["virt-who-config", "fetch"]
      @script = 'echo BASH SCRIPT'
    end

    it "prints script to stdout by default" do
      params = ['--name=test']

      api_expects_search(:configs, :name => 'test').returns(index_response([config]))
      api_expects(:configs, :deploy_script, 'Get config script').returns({'virt_who_config_script' => @script})

      expected_result = CommandExpectation.new(@script + "\n")

      result = run_cmd(@cmd + params)
      assert_cmd(expected_result, result)
    end

    it "stores script into a file" do
      file = Tempfile.new
      begin
        params = ['--name=test', '--output', file.path]

        api_expects_search(:configs, :name => 'test').returns(index_response([config]))
        api_expects(:configs, :deploy_script, 'Get config script').returns({'virt_who_config_script' => @script})

        result = run_cmd(@cmd + params)

        assert_cmd(CommandExpectation.new, result)
        assert_equal(@script, file.read)
      ensure
         file.unlink
      end
    end
  end
end
