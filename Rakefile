require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :default => ['spec:invasive', 'spec:noninvasive']

namespace :spec do
  rspec_opts = '-f d'
  
  desc "Run all examples with invasive Hash extensions"
  RSpec::Core::RakeTask.new('invasive') do |t|
    t.pattern = './spec/invasive/**/*.rb'
    t.rspec_opts = rspec_opts
  end

  desc "Run all examples with non-invasive Hash extensions"
  RSpec::Core::RakeTask.new('noninvasive') do |t|
    t.pattern = './spec/noninvasive/**/*.rb'
    t.rspec_opts = rspec_opts
  end
end
