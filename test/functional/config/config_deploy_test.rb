require_relative '../test_helper'

describe "virt-who-config" do
  describe "deploy" do
    class FakeSystemCaller
      def initialize(output, result=true)
        @output = output
        @result = result
      end

      def system(script)
        puts @output
        @result
      end
    end

    before do
      @cmd = ["virt-who-config", "deploy"]
      @params = ['--name=test']
      @script = 'echo BASH SCRIPT'
    end

    it "sends the script to #system" do
      api_expects_search(:configs, :name => 'test').returns(index_response([config]))
      api_expects(:configs, :deploy_script, 'Get config script').returns({'virt_who_config_script' => @script})

      system_caller = mock
      system_caller.expects(:system).with(@script).returns(true)

      result = run_cmd(@cmd + @params, { :system_caller => system_caller })
      assert_cmd(CommandExpectation.new, result)
    end

    it "prints output of the script to stdout" do
      api_expects_search(:configs, :name => 'test').returns(index_response([config]))
      api_expects(:configs, :deploy_script, 'Get config script').returns({'virt_who_config_script' => @script})

      system_caller = FakeSystemCaller.new('Script output...')
      expected_result = CommandExpectation.new('Script output...' + "\n")

      result = run_cmd(@cmd + @params, { :system_caller => system_caller })
      assert_cmd(expected_result, result)
    end

    it "returns HammerCLI::EX_SOFTWARE on config failure" do
      api_expects_search(:configs, :name => 'test').returns(index_response([config]))
      api_expects(:configs, :deploy_script, 'Get config script').returns({'virt_who_config_script' => @script})

      system_caller = FakeSystemCaller.new('Script output...', false)
      expected_result = CommandExpectation.new('Script output...' + "\n", '', HammerCLI::EX_SOFTWARE)

      result = run_cmd(@cmd + @params, { :system_caller => system_caller })
      assert_cmd(expected_result, result)
    end
  end
end
