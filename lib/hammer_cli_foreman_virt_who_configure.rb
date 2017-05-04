require 'hammer_cli'

module HammerCLIForemanVirtWhoConfigure

  HammerCLI::MainCommand.lazy_subcommand('virt-who-config', _("Manage Virt Who configurations"),
    'HammerCLIForemanVirtWhoConfigure::VirtWhoConfig', 'hammer_cli_foreman_virt_who_configure/config'
  )

end
