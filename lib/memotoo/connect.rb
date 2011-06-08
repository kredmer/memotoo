require "savon"
require "memotoo/core-ext/hash"
require "memotoo/core-ext/kernel"
require "memotoo/contact/contact"
require "memotoo/contact/contact_group"
require 'parsedate'

module Memotoo

  # = Memotoo::Connect
  #
  # Memotoo::Connect is the main object for connecting
  # to the {memotoo}[http://www.memotoo.com/index-saleshype.php] SOAP service. 
  
    class Connect

    # will hold username and password in a hash style (used for all requests)
    attr_accessor :opts
    
    SEARCHDEFAULTS = { :limit_start => '0', :limit_nb => '100' }
     
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
    
    
    def searchApiCall(searchparameter)
		search = SEARCHDEFAULTS.merge!(searchparameter)
		apicall(calling_method.to_sym, search)
    end
    
    def getApiCall(id)
    	apicall(calling_method.to_sym, { :id => id })
    end
    
    def getSyncApiCall(datetime)
    	date2time=Time.mktime(*ParseDate.parsedate(datetime))
    	formated_date=date2time.strftime("%Y-%m-%d %H:%M:%S")
    	apicall(calling_method.to_sym, { :date => formated_date })
    end
    
    def deleteApiCall(id)
	    apicall(calling_method.to_sym, { :id => id })
    end
    
    def modifyApiCall(details)
		apicall(calling_method.to_sym, details )    
    end
    
    def addApiCall(details)
		apicall(calling_method.to_sym, details )    
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
    
	def format_result(response, *_keys_)
		output_key = [(calling_method.underscore+"_response").to_sym] | _keys_
		response.nil? ? nil : response.to_hash.seek(output_key) 
    end
    
    	
	
	private
	
	def go_home(message)
	#-- 
	# TODO: raising errors instead of writing to STDOUT
	#++
		puts "missing fields: " + message.to_s
		false
	end
	
	def has_needed_fields(thehash, *args)
		valid=true
		retarr=[]
		args.each do |arg_item|
			unless thehash.has_key?(arg_item)
				valid = false
				retarr << arg_item
			end
		end
		valid ? true : go_home(retarr.join(", "))
	end
	
	def has_needed_search_parameter(searchparameter)
		has_needed_fields(searchparameter, :search)
	end
    
  end # class

end # module

# stop savon logging 

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

#-- available memotoo soap actions !!!!!!!!!!

#event

#:get_event,
#:delete_event,    
#:get_event_sync, 
#:modify_event,    
#:search_event,
#:add_event,

#calendar_category

#:search_calendar_category,
#:add_calendar_category,
#:delete_calendar_category,
#:get_calendar_category,
#:modify_calendar_category,
#:get_calendar_category_sync,

#holiday

#:get_holiday, 
#:delete_holiday,
#:get_holiday_sync,
#:modify_holiday,
#:search_holiday,
#:add_holiday,
# 

#contact - ready implemented
#:add_contact,    
#:modify_contact, 
#:search_contact,    
#:delete_contact,    
#:get_contact_sync,
#:get_contact,

#contact-group - ready implemented
#     
#:search_contact_group,
#:add_contact_group,    
#:delete_contact_group,
#:get_contact_group,
#:get_contact_group_sync
#:modify_contact_group
#     
#bookmark
#     
#:get_bookmark,
#:modify_bookmark,
#:search_bookmark
#:add_bookmark, 
#:delete_bookmark,
#:get_bookmark_sync,  
# 
#bookmarkfolder
# 
#:search_bookmark_folder,
#:add_bookmark_folder,     
#:delete_bookmark_folder,
#:get_bookmark_folder,      
#:get_bookmark_folder_sync,
#:modify_bookmark_folder, 

#task

#:modify_task,     
#:get_task, 
#:get_task_sync,
#:search_task,       
#:add_task,    
#:delete_task, 

#note

#:get_note_sync
#:modify_note,
#:search_note,
#:delete_note,
#:add_note, 
#:get_note,
#++
