module HammerCLIForemanVirtWhoConfigure
  MODE_UNLIMITED = 0
  MODE_WHITELIST = 1
  MODE_BLACKLIST = 2

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

    def self.format_listing_mode(mode)
      case mode
        when MODE_UNLIMITED
          _('Unlimited')
        when MODE_WHITELIST
          _('Whitelist')
        when MODE_BLACKLIST
          _('Blacklist')
        else
          _('Unknown listing mode')
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

    class InfoCommand < HammerCLIForeman::InfoCommand
      output do
        label _('General information') do
          field :id, _('Id')
          field :name, _('Name')
          field :hypervisor_type, _('Hypervisor type')
          field :hypervisor_server, _('Hypervisor server')
          field :hypervisor_username, _('Hypervisor username')
          field :hypervisor_password, _('Hypervisor password')
          field :_status, _('Status')
        end
        label _('Schedule') do
          field :_interval, _('Interval')
          field :last_report_at, _('Last Report At'), Fields::Date
        end
        label _('Connection') do
          field :satellite_url, _('Satellite server')
          field :hypervisor_id, _('Hypervisor ID')
          field :_listing_mode, _('Filtering')
          field :blacklist, _('Filtered hosts'), Fields::Field, :hide_blank => true
          field :whitelist, _('Excluded hosts'), Fields::Field, :hide_blank => true
          field :debug, _('Debug mode'), Fields::Boolean
          field :proxy, _('HTTP proxy')
          field :no_proxy, _('Ignore proxy')
        end
        HammerCLIForeman::References.taxonomies(self)
      end

      def extend_data(conf)
        conf['_interval'] = VirtWhoConfig.format_interval(conf['interval'])
        conf['_status'] = VirtWhoConfig.format_status(conf['status'])
        conf['_listing_mode'] = VirtWhoConfig.format_listing_mode(conf['listing_mode'])
        # Show host lists only in relevant filtering modes
        conf['whitelist'] = nil if conf['listing_mode'] != MODE_WHITELIST
        conf['blacklist'] = nil if conf['listing_mode'] != MODE_BLACKLIST
        conf
      end

      build_options
    end

    autoload_subcommands
  end
end
