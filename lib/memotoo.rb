require 'rubygems'
require 'active_support/inflector'
require "savon"
require "memotoo/main"
require "memotoo/core-ext/hash"
require "memotoo/core-ext/kernel"

class Memotoo

   # will hold username and password in a hash style (used for all requests)
    attr_accessor :opts #:nodoc:
    
    SEARCHDEFAULTS = { :limit_start => '0', :limit_nb => '100' }
    
    # requirement for the objects - for validation
	NEEDS = { 	 :contact => [:lastname],
				 :contact_group => [:name],
				 :bookmark => [:url],
				 :bookmark_folder => [:name],
				 :note => [:description],
				 :calendar_category => [:name],
				 :event => [:title, :dateBegin, :dateEnd],
				 :holiday => [:description, :dateBegin, :dateEnd],
				 :task => [:title]}
     
     #[https] default:true for the SOAP service. Use false to use http-connection
     # example:(use https) 
     #     @connect=Memotoo::Connect.new("myusername","mypassword")
     # example:(use http) 
     #     @connect=Memotoo::Connect.new("myusername","mypassword", false)
    def initialize(username, password, https=true)

		# we will need it for every request - will be merged in
		self.opts= { :param => { :login => username, :password => password}}
		
		# build dynamically all methods - some magic :-)
		make_methods
		
		# creates client with memotoo settings 
		client(https)
	end
end

# stop savon logging 

module Savon # :nodoc: all
  module Global
    def log?
      false
    end
      def raise_errors?
      @raise_errors = true
    end
   
  end
end

#Finished in 12.361502 seconds.

#14 tests, 14 assertions, 0 failures, 0 errors
#+----------------------------------------------------+-------+-------+--------+
#|                  File                              | Lines |  LOC  |  COV   |
#+----------------------------------------------------+-------+-------+--------+
#|lib/memotoo.rb                                      |    59 |    34 | 100.0% |
#|lib/memotoo/core-ext/hash.rb                        |    41 |    25 | 100.0% |
#|lib/memotoo/core-ext/kernel.rb                      |    10 |     6 | 100.0% |
#|lib/memotoo/main.rb                                 |   280 |    77 | 100.0% |
#+----------------------------------------------------+-------+-------+--------+
#|Total                                               |   390 |   142 | 100.0% |
#+----------------------------------------------------+-------+-------+--------+
#100.0%   4 file(s)   390 Lines   142 LOC

#Generated on Sun Jun 12 07:03:59 +0200 2011 with rcov 0.9.8


