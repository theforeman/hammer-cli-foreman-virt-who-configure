# frozen_string_literal: true

require 'hammer_cli_foreman_virt_who_configure/system_caller'
require_relative '../test_helper'

describe 'SystemCaller' do
  class CaptureContentTempfile < Tempfile
    attr_accessor :contents

    def write(data)
      @contents ||= []
      @contents << data
      super
    end
  end

  let(:script) { 'echo "Test"' }

  it 'uses tempfile for executing the script' do
    tmp_file = CaptureContentTempfile.new
    vars = HammerCLIForemanVirtWhoConfigure::SystemCaller.new.clean_env_vars
    Kernel.expects(:system).with(vars, "/usr/bin/bash #{tmp_file.path}", unsetenv_others: true)

    sys_caller = HammerCLIForemanVirtWhoConfigure::SystemCaller.new(tmp_file)
    sys_caller.system(script)

    assert_equal([script], tmp_file.contents)
  end
end
