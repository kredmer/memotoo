require 'rubygems'
require 'active_support/inflector'
require "savon"
require "memotoo/main"
require "memotoo/core-ext/hash"

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
     #[log] default:false - set to true to see savons logging
     #[requeslog] default:false - set to 
     # example:(use https) 
     #     @connect=Memotoo::Connect.new("myusername","mypassword")
     # example:(use http) 
     #     @connect=Memotoo::Connect.new("myusername","mypassword", false)
     # example:(set loggin on and http-request-logging off)
     #     @connect=Memotoo::Connect.new("myusername","mypassword", true, true, false)
    def initialize(username, password, https=true, log=false, requestlog=true)

		# need it for every request - will be merged in
		self.opts= { :param => { :login => username, :password => password}}
		
		# set savon logging and erros
		Savon.configure do |config|
			config.raise_errors = true # raise SOAP faults and HTTP errors
			config.log = log # enable/disable logging
			config.log_level = :debug # changing the log level
		end
		
		HTTPI.log=requestlog
		
		# build dynamically all methods - some magic :-)
		make_methods
		
		# creates client with memotoo settings 
		client(https)
	end
	
	   # Creates the <tt>Savon::Client</tt>.
    def client(https=true)
		#--
		# in any case problems switch back to receiving the wsdl file from memotoo
		# https: wsdl.document = "https://www.memotoo.com/SOAP-server.php?wsdl"
		# http:  wsdl.document = "http://www.memotoo.com/SOAP-server.php?wsdl"
		#++
		@client ||= Savon::Client.new do
          wsdl.namespace="urn:memotooSoap"
		  if https
				wsdl.endpoint="https://www.memotoo.com/SOAP-server.php"
				http.auth.ssl.verify_mode = :none 
		  else
				wsdl.endpoint="http://www.memotoo.com/SOAP-server.php"
		  end
		  http.auth.basic self.opts[:param][:login], self.opts[:param][:password]
		end
    end
	
end

#Finished in 41.165241 seconds.

#74 tests, 74 assertions, 0 failures, 0 errors
#+----------------------------------------------------+-------+-------+--------+
#|                  File                              | Lines |  LOC  |  COV   |
#+----------------------------------------------------+-------+-------+--------+
#|lib/memotoo.rb                                      |    74 |    33 | 100.0% |
#|lib/memotoo/core-ext/hash.rb                        |    39 |    25 | 100.0% |
#|lib/memotoo/main.rb                                 |   291 |    88 | 100.0% |
#+----------------------------------------------------+-------+-------+--------+
#|Total                                               |   404 |   146 | 100.0% |
#+----------------------------------------------------+-------+-------+--------+
#100.0%   3 file(s)   404 Lines   146 LOC

#Generated on Thu Jun 16 02:15:11 +0200 2011 with rcov 0.9.8


