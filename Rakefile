require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:unit) do |spec|
  spec.rspec_opts = '-b'
end

task :default => :unit
