require 'parsedate'

module Memotoo
  
    class Connect
    
	#  required: name 
	# {:name=>groupname}
	#   #e.g. @connect.addContactGroup({:name=>"Testgroup"})
    def addContactGroup(groupname)
		if has_needed_fields(groupname, :name)
			addparams = { 	:id => '',
						:updated => ''
					 }.merge!(groupname)
					format_result(addApiCall({:contactGroup => addparams}), :id)
		end
	end

    #[searchparameter:]
		#   {:search=>"something", :limit_start=>0, :limit_nb=>100}
    	#*   required:
    	#        search
    	#*   optional:
    	#       limit_start
    	#       limit_nb
    	#e.g. @connect.searchContactGroup({:search=>"ka", :limit_nb=>50})
    	#
    	# returns nil or a hash of one contactgroup or an array of contactgroups
    	#
    def searchContactGroup(searchparameter={})
		if has_needed_search_parameter(searchparameter)
			format_result(searchApiCall(searchparameter), :return, :contact_group)
		end
    end

		# id = integer
		# e.g. @connect.getContactGroup(12345)
		#
		# returns the contactgroup or nil
		#
	def getContactGroup(id)
		format_result(getApiCall(id), :return, :contact_group)
	end

    	# get modified contactgroups since date
    	# datetime = "2010-02-23 10:00:00" or just "2010-02-23"
    	# e.g. @connect.getContactGroupSync("2010-02-23 10:00:00")
	def getContactGroupSync(datetime)
		format_result(getSyncApiCall(datetime), :return, :contact_group)
	end

    	# required: name and id
    	# note: you can only change the name
    	# return true if the changed happened
    def modifyContactGroup(details={})
		if has_needed_fields(details, :name, :id)
			format_result(modifyApiCall({:contactGroup => details}), :ok)
		end
    end

		# id = integer
		# e.g. @connect.deleteContactGroup(12345)
		# return true when contactgroup is deleted
    def deleteContactGroup(id)
		format_result(deleteApiCall(id), :ok)
    end
    
  end # class

end # module
