require 'hammer_cli_foreman_virt_who_configure/system_caller'

module HammerCLIForemanVirtWhoConfigure
  MODE_UNLIMITED = 0
  MODE_WHITELIST = 1
  MODE_BLACKLIST = 2

  class VirtWhoConfig < HammerCLIForeman::Command
    resource :configs

    def self.format_interval(interval)
      hr_interval = (interval / 60)
      if hr_interval <= 1
        _('every hour')
      else
        _('every %s hours') % (interval / 60)
      end
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

    def self.format_filtering_mode(mode)
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
          field :_status, _('Status')
        end
        label _('Schedule') do
          field :_interval, _('Interval')
          field :last_report_at, _('Last Report At'), Fields::Date
        end
        label _('Connection') do
          field :satellite_url, _('Satellite server')
          field :hypervisor_id, _('Hypervisor ID')
          field :_filtering_mode, _('Filtering')
          field :blacklist, _('Excluded hosts'), Fields::Field, :hide_blank => true
          field :whitelist, _('Filtered hosts'), Fields::Field, :hide_blank => true
          field :filter_host_parents, _('Filter host parents'), Fields::Field, :hide_blank => true
          field :exclude_host_parents, _('Exclude host parents'), Fields::Field, :hide_blank => true
          field :debug, _('Debug mode'), Fields::Boolean
          field :proxy, _('HTTP proxy')
          field :no_proxy, _('Ignore proxy')
        end
        HammerCLIForeman::References.taxonomies(self)
      end

      def extend_data(conf)
        conf['_interval'] = VirtWhoConfig.format_interval(conf['interval'])
        conf['_status'] = VirtWhoConfig.format_status(conf['status'])
        conf['_filtering_mode'] = VirtWhoConfig.format_filtering_mode(conf['filtering_mode'])
        # Show host lists only in relevant filtering modes
        if conf['filtering_mode'] != MODE_WHITELIST
          conf['whitelist'] = nil
        else
          conf['whitelist'] ||= " "
        end
        if conf['filtering_mode'] != MODE_BLACKLIST
          conf['blacklist'] = nil
        else
          conf['blacklist'] ||= " "
        end
        conf
      end

      build_options
    end

    class FetchCommand < HammerCLIForeman::Command
      command_name "fetch"
      action :deploy_script

      failure_message _('Could not fetch the Virt Who configuration')

      option ['--output', '-o'], 'FILE', _('File where the script will be written.')

      def execute
        data = send_request
        if option_output
          path = File.expand_path(option_output)
          if File.exists?(path)
            # this could be a security issue, the file should be readable only by the user
            output.print_error(
              _('Could not save the script'),
              _("File at %{path} already exists, please specify a different path.") % { :path => path }
            )
            return HammerCLI::EX_USAGE
          else
            File.write(path, data, { :perm => 0700, :mode => File::RDWR|File::CREAT|File::EXCL })
            return HammerCLI::EX_OK
          end
        else
          puts data
          return HammerCLI::EX_OK
        end
      end

      def transform_format(data)
        data['virt_who_config_script']
      end

      build_options
    end

    class DeployCommand < HammerCLIForeman::Command
      command_name "deploy"
      desc _('Download and execute script for the specified virt-who configuration')
      action :deploy_script

      failure_message _('Could not deploy the Virt Who configuration')

      def execute
        script = send_request
        if system_caller.system(script)
          HammerCLI::EX_OK
        else
          HammerCLI::EX_SOFTWARE
        end
      end

      def transform_format(data)
        data['virt_who_config_script']
      end

      def system_caller
        context[:system_caller] || HammerCLIForemanVirtWhoConfigure::SystemCaller.new
      end

      build_options
    end

    module UpdateCommons
      FILTER_MAPPING = {
        'none' => 0,
        'whitelist' => 1,
        'blacklist' => 2
      }

      def self.included(base)
        base.option '--filtering-mode', 'MODE', _('Hypervisor filtering mode'),
          :format => HammerCLI::Options::Normalizers::Enum.new(FILTER_MAPPING.keys)
      end

      def request_params
        params = super
        mode = params['foreman_virt_who_configure_config']['filtering_mode']
        params['foreman_virt_who_configure_config']['filtering_mode'] = FILTER_MAPPING[mode] if mode
        params
      end
    end

    class CreateCommand < HammerCLIForeman::CreateCommand
      include UpdateCommons

      success_message _('Virt Who configuration [%{name}] created')
      failure_message _('Could not create the Virt Who configuration')

      build_options
    end

    class UpdateCommand < HammerCLIForeman::UpdateCommand
      include UpdateCommons

      success_message _('Virt Who configuration [%{name}] updated')
      failure_message _('Could not create the Virt Who configuration')

      build_options
    end

    class DeleteCommand < HammerCLIForeman::DeleteCommand
      success_message _('Virt Who configuration deleted')
      failure_message _('Could not delete the Virt Who configuration')

      build_options
    end

    autoload_subcommands
  end
end
