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
	
		soapobjects.each do |soapobject|
		symbol=soapobject.underscore.to_sym
	
		# add method
		methodname="add"+soapobject	
		selfclass.send(:define_method, methodname) { |details| output(detailsApicall({symbol => details}), :id) if fields?(details, NEEDS[symbol]) }
		
		# search
		methodname="search"+soapobject	
		selfclass.send(:define_method, methodname) { |params| output(searchApiCall(params), :return, symbol) if fields?(params, [:search]) }
		
		# get
		methodname="get"+soapobject	
		selfclass.send(:define_method, methodname) { |id| output(idApicall(id), :return, symbol) }

		# get...Sync
		methodname="get"+soapobject+"Sync"	
		selfclass.send(:define_method, methodname) { |datetime| output(getSyncApiCall(datetime), :return, symbol) }

		# modify
		methodname="modify"+soapobject	
		selfclass.send(:define_method, methodname) { |details| output(detailsApicall({symbol => details}), :ok) if fields?(details, [NEEDS[symbol], :id].flatten!) }
		
		# delete
		methodname="delete"+soapobject	
		selfclass.send(:define_method, methodname) { |id| output(idApicall(id), :ok) }

		end
	end
	
    def searchApiCall(searchparameter)
		search = SEARCHDEFAULTS.merge!(searchparameter)
		apicall(calling_method.to_sym, search)
    end
    
    def getSyncApiCall(datetime)
    	date2time=Time.mktime(*ParseDate.parsedate(datetime))
    	formated_date=date2time.strftime("%Y-%m-%d %H:%M:%S")
    	apicall(calling_method.to_sym, { :date => formated_date })
    end
    
    def idApicall(id)
        apicall(calling_method.to_sym, { :id => id })
    end
    
    def detailsApicall(details)
		apicall(calling_method.to_sym, details )
    end
    
    # used internally for a request
    def apicall(action, parameter)
		response=@client.request :wsdl, action do 
			soap.body = { :param => parameter }.deep_merge_me!(self.opts)
		end	
		response
		rescue Savon::Error => error
			raise ArgumentError, "Memotoo::Connect #invalid username/password" if error.message.nil?
	end

	def output(response, *_keys_)
		output_key = [(calling_method.underscore+"_response").to_sym] | _keys_
		response.nil? ? nil : response.to_hash.seek(output_key) 
    end
	
	def go_home(message)
		raise ArgumentError, "Memotoo::Connect #missing fields: " + message.to_s
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




