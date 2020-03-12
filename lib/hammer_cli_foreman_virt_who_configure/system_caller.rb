module HammerCLIForemanVirtWhoConfigure
  class SystemCaller
    WHITELISTED_VARS = %w[HOME USER LANG].freeze

    def initialize(tempfile = nil)
      @tempfile = tempfile || Tempfile.new('virt_who')
    end

    def clean_env_vars
      # Cleaning ENV vars and keeping required vars only because,
      # When using SCL it adds GEM_HOME and GEM_PATH ENV vars.
      # These vars break foreman-maintain tool.
      # This way we use system ruby to execute the bash script.
      cleaned_env = ENV.select { |var| WHITELISTED_VARS.include?(var) || var.start_with?('LC_') }
      cleaned_env['PATH'] = '/sbin:/bin:/usr/sbin:/usr/bin'
      cleaned_env
    end

    def system(command)
      result = nil
      begin
        @tempfile.write(command)
        @tempfile.flush # to make sure the command is complete
        result = Kernel.system(clean_env_vars, "/usr/bin/bash #{@tempfile.path}", unsetenv_others: true)
      ensure
        @tempfile.close
        @tempfile.unlink
      end
      result
    end
  end
end
