require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'


$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'savon'
require File.dirname(__FILE__) + "/../lib/memotoo"

class Test::Unit::TestCase

  # put your own credentials here
 MEMOTOO_USERNAME = "memotoo-tester"
 MEMOTOO_PASSWORD = "memotoo-tester"
 
 TESTSEARCHDEFAULTS = {:search=>" ", :limit_start => '0', :limit_nb => '1'}

end

