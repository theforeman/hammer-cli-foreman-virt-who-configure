# -*- encoding: utf-8 -*-
$:.unshift File.expand_path("../lib", __FILE__)
require "hammer_cli_foreman_virt_who_configure/version"

Gem::Specification.new do |s|

  s.name          = "hammer_cli_foreman_virt_who_configure"
  s.version       = HammerCLIForemanVirtWhoConfigure.version.dup
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Tomáš Strachota"]
  s.email         = "tstracho@redhat.com"
  s.homepage      = "http://github.com/theforeman/hammer-cli-foreman-virt-who-configure"
  s.license       = "GPL v3+"

  s.summary       = %q{Plugin for configuring Virt Who}
  s.description   = <<EOF
  Plugin for configuring Virt Who
EOF

  locales = Dir['locale/*'].select { |f| File.directory?(f) }
  s.files = Dir['{lib,doc,test,config}/**/*', 'LICENSE', 'README*'] +
    locales.map { |loc| "#{loc}/LC_MESSAGES/hammer-cli-foreman-virt-who-configure.mo" }

  s.test_files       = Dir['{test}/**/*']
  s.extra_rdoc_files = Dir['{doc}/**/*', 'README*']
  s.require_paths = ["lib"]

  s.add_dependency 'hammer_cli', '>= 0.5.0'
  s.add_dependency 'hammer_cli_foreman', '>= 0.5.0'
end
