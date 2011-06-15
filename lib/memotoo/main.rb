class Memotoo

	private	
	
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
    
	def selfclass
	(class << self; self; end)
	end

	# builds for every soap-object six methods (add, search, get, get..Sync,modify, delete )
	# on-the-fly :-)
	def make_methods
	
	# the accessible soap objects
	soapobjects = %w{Contact ContactGroup Bookmark BookmarkFolder Note CalendarCategory Event Holiday Task}
	methods = %w{add search get modify sync delete }
	
		soapobjects.each do |soapobject|
			symbol=soapobject.underscore.to_sym # Contact -> :contact
			
			action={} # action = generated method names in a hash e.g. {:add=>"addContact", :get=>"getContact"} for this soapobject
			methods.each do |newmethod|
				action[newmethod.to_sym]=newmethod+soapobject
				action[newmethod.to_sym]="get" << soapobject << "Sync" if newmethod=="sync"
			end
		
			selfclass.send(:define_method, action[:add]) do |details| 
				detailsApicall(action[:add],{symbol => details},[:id]) if fields?(details, NEEDS[symbol]) 
			end
		
			selfclass.send(:define_method, action[:modify]) do |details| 
				detailsApicall(action[:modify],{symbol => details},[:ok]) if fields?(details, [NEEDS[symbol], :id].flatten!) 
			end
		
			selfclass.send(:define_method, action[:search]) do |params| 
				searchCall(action[:search],params,[:return, symbol]) if fields?(params, [:search]) 
			end
		
			selfclass.send(:define_method, action[:sync]) do |datetime| 
				getSyncApiCall(action[:sync],datetime,[:return, symbol]) 
			end

			selfclass.send(:define_method, action[:get]) do |id| 
				idApicall(action[:get],id,[:return, symbol]) 
			end

			selfclass.send(:define_method, action[:delete]) do |id|
				idApicall(action[:delete],id,[:ok]) 
			end

		end
	end
	
    def searchCall(method, searchparameter, outputkeys)
        search = SEARCHDEFAULTS.merge!(searchparameter)
        output(method,apicall(method,search), outputkeys)
    end
    
    def getSyncApiCall(method, datetime, outputkeys)
        formated_date=Date.parse(datetime).strftime("%Y-%m-%d %H:%M:%S")
        output(method,apicall(method, {:date => formated_date}), outputkeys) 
    end
    
    def idApicall(method, id, outputkeys)
        output(method,apicall(method,{:id => id}), outputkeys) 
    end
    
    def detailsApicall(method, details, outputkeys)
        output(method,apicall(method,details), outputkeys)
    end

    # used internally for a request
    def apicall(action, parameter)
    
		response=@client.request :wsdl, action do 
			soap.body = { :param => parameter }.deep_merge_me!(self.opts)
		end	
		response
		rescue Savon::Error => error
			raise ArgumentError, "Memotoo - invalid username/password" if error.message.nil?
	end

	def output(method, response, keys=[])
		output_key = [(method.to_s.underscore+"_response").to_sym] | keys # e.g. [:addContact, :return, :contact]
		response.nil? ? nil : response.to_hash.seek(output_key) 
    end
	
	def go_home(message)
		raise ArgumentError, "Memotoo - missing fields: " + message.to_s
	end
	
	def fields?(thehash, args=[])
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
	
# ---------------------
# :section: memotoo soap actions
# === bookmark - ready implemented
# * searchBookmark(searchparams={})
# * addBookmark(params={})
# * getBookmark(id)
# * getBookmarkSync(datetime)  
# * modifyBookmark(params={})
# * deleteBookmark(id)
# 
# === bookmarkfolder - ready implemented - API problem with search
# * searchBookmarkFolder(searchparams={})
# * addBookmarkFolder(params={})
# * getBookmarkFolder(id)      
# * getBookmarkFolderSync(datetime)
# * modifyBookmarkFolder(params={})
# * deleteBookmarkFolder(id)
#
# === calendar_category  - ready implemented
# * searchCalendarCategory
# * addCalendarCategory
# * getCalendarCategory
# * getCalendarCategorySync
# * modifyCalendarCategory
# * deleteCalendarCategory
# 
# === contact - ready implemented
# * searchContact    
# * add_contact    
# * getContact
# * getContactSync
# * modifyContact 
# * deleteContact    
#
# === contact-group - ready implemented
# * searchContactGroup
# * addContactGroup    
# * getContactGroup
# * getContactGroupSync
# * modifyContactGroup
# * deleteContactGroup
#
# === event - ready implemented
# * searchEvent
# * addEvent
# * getEvent
# * getEventSync 
# * modifyEvent    
# * deleteEvent    
#
# === holiday - ready implemented - API problem with get and getSync
# * searchHoliday
# * addHoliday
# * getHoliday 
# * getHolidaySync
# * modifyHoliday
# * deleteHoliday
# 
# === note  - ready implemented
# * searchNote
# * addNote 
# * getNote
# * getNoteSync
# * modifyNote
# * deleteNote
#
# === task - ready implemented
# * searchTask
# * addTask    
# * getTask 
# * getTaskSync
# * modifyTask     
# * deleteTask 
#
# ---------------------

# ---------------------
# :section: Bookmark fields
#
# id:: "2531368"
# url(*):: "http://www.google.com"
# description:: "google"
# rank:: "0"
# tags:: nil
# id_bookmark_folder:: "363174"
# ---------------------

# ---------------------
# :section: BookmarkFolder fields
# 
# id:: "2531368"
# name(*):: "Download applications"
# id_bookmark_folder_parent:: "363174"
# ---------------------

#--
#
# for the other object make a search and analyze the first result
#
#++

# ---------------------
# :section: Contact fields
# all contacts fields
#			:id
#			:title => 'Mr.',
#			:lastname => 'test',
#			:firstname => 'user',
#			:middlename => '',
#			:nickname => 'bob',
#			:suffix => '',
#			:birthday => '1975-02-14', // Format YYYY-MM-DD
#			:homeaddress => '',
#			:homecity => 'new york',
#			:homepostalcode => '',
#			:homestate => '',
#			:homecountry => 'usa',
#			:homeemail => '',
#			:homephone => '',
#			:homemobile => '',
#			:homefax => '',
#			:homewebpage => '',
#			:businessaddress => '',
#			:businesscity => '',
#			:businesspostalcode => '',
#			:businessstate => '',
#			:businesscountry => '',
#			:businessemail => '',
#			:businessphone => '',
#			:businessmobile => '',
#			:businessfax => '',
#			:businesswebpage => '',
#			:company => '',
#			:department => '',
#			:jobtitle => '',
#			:notes => '',
#			:otheraddress => '',
#			:othercity => '',
#			:otherpostalcode => '',
#			:otherstate => '',
#			:othercountry => '',
#			:otheremail => '',
#			:otherphone => '',
#			:othermobile => '',
#			:otherfax => '',
#			:skypeid => '',
#			:msnid => '',
#			:aimid => '',
#			:pager => '',
#			:carphone => '',
#			:managersname => '',
#			:assistantsname => '',
#			:assistantsphone => '',
#			:parent => '',
#			:spouse => '',
#			:children => '',
#			:custom1 => '',
#			:custom2 => '',
#			:custom3 => '',
#			:custom4 => '',
#			:group => '0',
#			:photo => '', // Photo encoded with Base64
# ---------------------
	
  end




