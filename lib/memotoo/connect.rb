require "savon"
require "memotoo/core-ext/hash"
require "memotoo/contact/contact"

module Memotoo

  # = Memotoo::Connect
  #
  # Memotoo::Connect is the main object for connecting
  # to the {memotoo}[http://www.memotoo.com/index-saleshype.php] SOAP service. 
  
    class Connect

    # will hold username and password in a hash style (used for all requests)
    attr_accessor :opts
     
     #[https] default:true for the SOAP service.
     # example: @connect=Memotoo::Connect.new("myusername","mypassword")
    def initialize(username, password, https=true)
    
		# we will need it for every request - will be merged in
		self.opts= {
			:param => { 
				:login => username,
				:password => password,
					}
			}
		
		# creates client with memotoo settings 
		client(https)
	end
	
   # Creates the <tt>Savon::Client</tt>.
    def client(https=true)
		#--
		# TODO: dont fetch wdsl-file - make setting by myself - it's faster
		#   # Directly accessing a SOAP endpoint
		#   client = Savon::Client.new do
		#     wsdl.endpoint = "http://example.com/UserService"
		#     wsdl.namespace = "http://users.example.com"
		#   end
		#++
    
      @client ||= Savon::Client.new do
		  if https
				wsdl.document = "https://www.memotoo.com/SOAP-server.php?wsdl"
				http.auth.ssl.verify_mode = :none 
		  else
		        wsdl.document = "http://www.memotoo.com/SOAP-server.php?wsdl"
		  end
		  http.auth.basic self.opts[:param][:login], self.opts[:param][:password]
		end
		
    end
    
    # used internally for a request
    def apicall(action, parameter)
		
		response=@client.request :wsdl, action do 
				soap.body = { :param => parameter }.deep_merge_me!(self.opts)
			end	
		response
		
		#--
		# TODO: error-handling - I was tooo lazy.....
		#++
		
		rescue Savon::Error => error
			if error.message.nil?
				puts "invalid username/password"
				
		# I don't know which error is still possible
		#			else
		#				puts error.to_s
		end
    end
    
    
  end # class

end # module

# stop savon logging and raising errors

module Savon
  module Global

    def log?
      false
    end
    
      def raise_errors?
      @raise_errors = true
    end
   
  end
end
