# alias of `bundle exec irb -I:".:app:lib"`
task :console do
  require 'irb'
  require 'irb/completion'


  $LOAD_PATH.unshift(File.dirname(__FILE__))

  # example of file loading:
  # Dir["app/events/*.rb"].each {|file| require file.gsub('lib/', '') }
  ['app', 'lib', 'test'].each { |f| $LOAD_PATH.unshift(File.dirname(__FILE__) + '/' + f) }

  # example ofapp init:
  # require 'tweetes/config'
  # Tweetes::Config.start

  ARGV.clear
  IRB.start
end

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "app"
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/test_*.rb"]
end

task :default => :test