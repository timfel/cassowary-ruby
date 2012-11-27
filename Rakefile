require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests with coverage checks (at least 90)"
task "coverage" do
  ENV["coverage"] = "1"
  Rake::Task["test"].invoke
end

desc "Run tests"
task :default => :coverage
