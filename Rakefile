# encoding: utf-8
# frozen_string_literal: true

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  if ENV['API']
    t.pattern = 'test/**/*_api_test.rb'
  else
    t.test_files = Dir['test/**/*_test.rb'] - Dir['test/**/*_api_test.rb']
  end
  t.warning = true
  t.verbose = true
end

task default: :test
