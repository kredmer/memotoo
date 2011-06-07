require 'parsedate'

module Memotoo
  
    class Connect


    #--
    # == Examples
    #
    #   # Setting up the client
    # @connect=Memotoo::Connect.new("myusername","mypassword")
    
    #   # retrieving search results
    # @response = @connect.searchContact({:search=>"ka"})
    
    #   # get a contact from id
    # @response = @connect.getContact(12345)
    
    #    # Add a contact
    # @response = @connect.addContact({:title => "Mr",:lastname => "Wonder",:firstname => "Test"})
    
    #   # modify a contact
    # @response = @connect.modifyContact({:id=>"12345",:lastname=>"New",:jobtitle => "cat-doctor",:otherphone => "12345"})
    
    #
    #   # extracting lastnames of search results
    #   # use this in console only for a few results - the output is to big !
    #++ @response.each {|contact|puts contact[:id]+"-"+contact[:firstname]+" "+contact[:lastname]}


		#[searchparameter:]
		#   {:search=>"something", :limit_start=>0, :limit_nb=>100}
    	#*   required:
    	#        search
    	#*   optional:
    	#       limit_start
    	#       limit_nb
    	#e.g. @connect.searchContact({:search=>"ka", :limit_nb=>50})

    def searchContact(searchparameter={})
        soapname=this_method
    	check=has_fields(searchparameter, :search)
    	if check[0]
			search = { 	:limit_start => '0',
						:limit_nb => '100'
			 		}.merge!(searchparameter)
			search_response = apicall(soapname.to_sym, search)
		# returns an array of contacts from search result
		if search_response.nil? || search_response==""
			 nil
		else
		
		response_name=(soapname+"_response").to_sym
		#response_vars=
			#search_response.to_hash.seek(response_name, :return, :contact)
			#[this_method, this_method.class]
			[response_name,search_response]
		end
		
		else
			# returns false and a message
			go_home(check[1])
		end
    end
    
		# id = integer
		# e.g. @connect.getContact(12345)
    def getContact(id)
    	contact = apicall(:getContact, { :id => id })
		# returns the contact
		contact.to_hash.seek :get_contact_response, :return, :contact
    end
    
    
    	# get modified contacts since date
    	# datetime = "2010-02-23 10:00:00" or just "2010-02-23"
    	# e.g. @connect.getContactSync("2010-02-23 10:00:00")
    def getContactSync(datetime)
    	date2time=Time.mktime(*ParseDate.parsedate(datetime))
    	formated_date=date2time.strftime("%Y-%m-%d %H:%M:%S")
    	contacts = apicall(:getContactSync, { :date => formated_date })
    	contacts.to_hash.seek :get_contact_sync_response, :return, :contact
    end


		# id = integer
		# e.g. @connect.deleteContact(12345)
    def deleteContact(id)
        contact = apicall(:deleteContact, { :id => id })
		# deletes the contact - returns true when contact is deleted
		contact.to_hash.seek :delete_contact_response, :ok
    end

    	# required: lastname and id
    	#
    	# optional: all other \contact_details - see contact fields at bottom
    def modifyContact(details={})
    	check=has_fields(details, :lastname, :id) 
    	if check[0]
			contact = apicall(:modifyContact, { :contact => details })
			# return true if the changed happened
			contact.to_hash.seek :modify_contact_response, :ok
		else
		# returns false, if lastname and/or id is not given
			go_home(check[1])		
		end
    end

    	# required: lastname 
    	#
    	# optional: all other contact_details
    def addContact(details={})
    	check=has_fields(details, :lastname)
		if check[0]
			contact = apicall(:addContact, { :contact => details })
			# return the id from the new contact -> get it in my own db? maybe
			contact.to_hash.seek :add_contact_response, :id
		else
		# returns false, if lastname is not given
			go_home(check[1])		
		end
	end
	
	# ----------------------------------------
#:section: contact_details
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
# ----------------------------------------
	
	
	private
	
	def go_home(message)
		puts "missing fields: " + message.to_s
		false
	end
	
	def has_fields(thehash, *args)
		valid=true
		retarr=[]
		args.each do |arg_item|
			unless thehash.has_key?(arg_item)
				valid = false
				retarr << arg_item
			end
		end
		[valid, retarr]
	end
	
    
  end # class

end # module




