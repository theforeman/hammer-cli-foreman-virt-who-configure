module HammerCLIForemanVirtWhoConfigure
  class VirtWhoConfig < HammerCLIForeman::Command
    resource :configs

    def self.format_interval(interval)
      _('every %s hours') % (interval / 60)
    end

    def self.format_status(status)
      case status
        when 'unknown'
          _('No Report Yet')
        when 'ok', 'out_of_date'
          _('OK')
        when 'error'
          _('Error')
        else
          _('Unknown configuration status')
      end
    end

    class ListCommand < HammerCLIForeman::ListCommand

      output do
        field :id, _('Id')
        field :name, _('Name')
        field :_interval, _('Interval')
        field :_status, _('Status')
        field :last_report_at, _('Last Report At'), Fields::Date
      end

      def extend_data(conf)
        conf['_interval'] = VirtWhoConfig.format_interval(conf['interval'])
        conf['_status'] = VirtWhoConfig.format_status(conf['status'])
        conf
      end

      build_options
    end

    autoload_subcommands
  end
end
