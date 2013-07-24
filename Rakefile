#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

require './lib/diff/display/version'

desc "run tests"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*test.rb']
  t.verbose = true
end

task :default => :test
