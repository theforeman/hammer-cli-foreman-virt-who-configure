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
      file_path = file.path
      file.unlink
      begin
        params = ['--name=test', '--output', file_path]

        api_expects_search(:configs, :name => 'test').returns(index_response([config]))
        api_expects(:configs, :deploy_script, 'Get config script').returns({'virt_who_config_script' => @script})

        result = run_cmd(@cmd + params)

        assert_cmd(CommandExpectation.new, result)
        assert_equal(@script, File.read(file_path))
      ensure
        File.unlink(file_path)
      end
    end

    it "refuses to store the script into existing file" do
      file = Tempfile.new
      begin
        params = ['--name=test', '--output', file.path]

        api_expects_search(:configs, :name => 'test').returns(index_response([config]))
        api_expects(:configs, :deploy_script, 'Get config script').returns({'virt_who_config_script' => @script})

        result = run_cmd(@cmd + params)

        expected_result = CommandExpectation.new('', /File at .* already exists, please specify a different path/, HammerCLI::EX_USAGE)

        assert_cmd(expected_result, result)
        assert_equal('', file.read)
      ensure
         file.unlink
      end
    end
  end
end
