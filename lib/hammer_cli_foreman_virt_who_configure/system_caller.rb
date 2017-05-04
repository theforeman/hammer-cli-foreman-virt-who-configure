module HammerCLIForemanVirtWhoConfigure
  class SystemCaller
    def initialize(tempfile = nil)
      @tempfile = tempfile || Tempfile.new('virt_who')
    end

    def system(commad)
      result = nil
      begin
        @tempfile.write(commad)
        @tempfile.flush # to make sure the command is complete
        result = Kernel.system("/usr/bin/bash #{@tempfile.path}")
      ensure
        @tempfile.close
        @tempfile.unlink
      end
      result
    end
  end
end
