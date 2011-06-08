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


    	# required: lastname 
    	#
    	# optional: all other contact_details - see below
    def addContact(details={})
		if has_needed_fields(details, :lastname)
			format_result(addApiCall({:contact => details}), :id)
		end
	end


		#[searchparameter:]
		#   {:search=>"something", :limit_start=>0, :limit_nb=>100}
    	#*   required:
    	#        search
    	#*   optional:
    	#       limit_start
    	#       limit_nb
    	#e.g. @connect.searchContact({:search=>"ka", :limit_nb=>50})
    	#
    	# returns nil or a hash of one contact or an array of contacts
    	#
    def searchContact(searchparameter={})
    	if has_needed_search_parameter(searchparameter)
			format_result(searchApiCall(searchparameter), :return, :contact)
		end
    end
    
		# id = integer
		# e.g. @connect.getContact(12345)
		#
		# returns the contact or nil
		#
    def getContact(id)
    	format_result(getApiCall(id), :return, :contact)
    end
    
    	# get modified contacts since date
    	# datetime = "2010-02-23 10:00:00" or just "2010-02-23"
    	# e.g. @connect.getContactSync("2010-02-23 10:00:00")
    def getContactSync(datetime)
    	format_result(getSyncApiCall(datetime), :return, :contact)
    end

    	# required: lastname and id
    	#
    	# optional: all other \contact_details - see contact fields at bottom
    	# return true if the changed happened
    def modifyContact(details={})
		if has_needed_fields(details, :lastname, :id)
			format_result(modifyApiCall({:contact => details}), :ok)
		end
    end

		# id = integer
		# e.g. @connect.deleteContact(12345)
		# return true when contact is deleted
    def deleteContact(id)
		format_result(deleteApiCall(id), :ok)
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
	
    
  end # class

end # module




