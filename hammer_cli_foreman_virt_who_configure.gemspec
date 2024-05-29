# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "hammer_cli_foreman_virt_who_configure/version"

Gem::Specification.new do |s|
  s.name          = "hammer_cli_foreman_virt_who_configure"
  s.version       = HammerCLIForemanVirtWhoConfigure.version.dup
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Tomáš Strachota"]
  s.email         = "tstracho@redhat.com"
  s.homepage      = "https://github.com/theforeman/hammer-cli-foreman-virt-who-configure"
  s.license       = "GPL-3.0+"

  s.summary       = 'Plugin for configuring Virt Who'
  s.description   = <<EOF
  Plugin for configuring Virt Who
EOF

  locales = Dir['locale/*'].select { |f| File.directory?(f) }
  s.files = Dir['{lib,doc,test,config}/**/*', 'LICENSE', 'README*'] +
  locales.map { |loc| "#{loc}/LC_MESSAGES/hammer-cli-foreman-virt-who-configure.mo" }

  s.test_files       = Dir['{test}/**/*']
  s.extra_rdoc_files = Dir['{doc}/**/*', 'README*']
  s.require_paths = ["lib"]
  s.required_ruby_version = '>= 2.7', '< 4'

  s.add_dependency 'hammer_cli', '~> 3.10', '< 4.0'
  s.add_dependency 'hammer_cli_foreman', '~> 3.9', '< 4.0'

  s.add_development_dependency 'ci_reporter', '>= 1.6.3', '< 2.0.0'
  s.add_development_dependency 'gettext', '>= 3.1.3', '< 4.0.0'
  s.add_development_dependency 'minitest', '4.7.4'
  s.add_development_dependency 'minitest-spec-context', '~> 0.0.5'
  s.add_development_dependency 'mocha', '~> 2.0'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'theforeman-rubocop', '~> 0.1.0'
  s.add_development_dependency 'thor', '~> 1.0'
end
