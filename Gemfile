# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'gettext', '>= 3.1.3', '< 4.0.0'

group :test do
  gem 'ci_reporter', '>= 1.6.3', '< 2.0.0', :require => false
  gem 'minitest', '5.18'
  gem 'minitest-spec-context'
  gem 'mocha'
  gem 'rake'
  gem 'simplecov'
  gem 'thor'
end

# load local gemfile
['Gemfile.local.rb', 'Gemfile.local'].map do |file_name|
  local_gemfile = File.join(File.dirname(__FILE__), file_name)
  self.instance_eval(Bundler.read_file(local_gemfile)) if File.exist?(local_gemfile)
end
