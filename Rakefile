require 'rake/testtask'
require 'rubocop/rake_task'

task default: %i[rubocop test]

Rake::TestTask.new do |t|
  t.pattern = './test/**/*_test.rb'
end

RuboCop::RakeTask.new
