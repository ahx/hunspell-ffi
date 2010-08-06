require 'rake/testtask'
task :default => [:test]
Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/test_*.rb']
  t.ruby_opts = ['-rubygems -I.'] if defined? Gem
end
