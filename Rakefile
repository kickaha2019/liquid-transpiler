# frozen_string_literal: true

require 'rake'
require 'rake/testtask'

task(default: [:test])

desc('run test suite with default parser')
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = FileList['test/**/test*.rb']
  t.warning = false
end

