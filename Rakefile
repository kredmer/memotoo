require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "memotoo"
  gem.homepage = "http://github.com/kredmer/memotoo"
  gem.license = "MIT"
  gem.summary = "Unofficial gem for connecting to the memotoo soap-api"
  gem.description = "Unofficial gem for connecting to the memotoo soap-api and handle your contact needs. Memotoo lets your synchronize all your contacts, events and tasks with yahoo, gmail, facebook, xing, outlook, your mobile-phone and more. You can also get your e-mails in one place. Memotoo is good value for money!"
  gem.email = "k.redmer@yahoo.de"
  gem.authors = ["Karsten Redmer"]
  gem.add_dependency 'savon'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "memotoo #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
