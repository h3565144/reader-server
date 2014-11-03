Dir['lib/tasks/*.rake'].each { |path| import path }

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
end
