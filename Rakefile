require 'rake/testtask'
require 'bundler/gem_tasks'
require 'ci/reporter/rake/minitest'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = Dir.glob('test/**/*_test.rb')
  t.verbose = true
  t.warning = ENV.key?('RUBY_WARNINGS')
end

namespace :pkg do
  desc 'Generate package source gem'
  task :generate_source => :build
end

require "hammer_cli_foreman_virt_who_configure/version"
require "hammer_cli_foreman_virt_who_configure/i18n"
require "hammer_cli/i18n/find_task"
HammerCLI::I18n::FindTask.define(HammerCLIForemanVirtWhoConfigure::I18n::LocaleDomain.new, HammerCLIForemanVirtWhoConfigure.version.to_s)
