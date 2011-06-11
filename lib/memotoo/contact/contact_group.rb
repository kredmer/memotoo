
module Memotoo
  
    class Connect
    
	#  required: name 
	# {:name=>groupname}
	#   #e.g. @connect.addContactGroup({:name=>"Testgroup"})
#    def addContactGroup(details)
#		output(detailsApicall({:contactGroup => details}), :id) if fields?(details, :name)
#	end

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
#    def searchContactGroup(params={})
#		output(searchApiCall(params), :return, :contact_group) if fields?(params, :search)
#    end

		# id = integer
		# e.g. @connect.getContactGroup(12345)
		#
		# returns the contactgroup or nil
		#
#	def getContactGroup(id)
#		output(idApicall(id), :return, :contact_group)
#	end

    	# get modified contactgroups since date
    	# datetime = "2010-02-23 10:00:00" or just "2010-02-23"
    	# e.g. @connect.getContactGroupSync("2010-02-23 10:00:00")
#	def getContactGroupSync(datetime)
#		output(getSyncApiCall(datetime), :return, :contact_group)
#	end

    	# required: name and id
    	# note: you can only change the name
    	# return true if the changed happened
#    def modifyContactGroup(details={})
#		output(detailsApicall({:contactGroup => details}), :ok) if fields?(details, :name, :id)
#    end

		# id = integer
		# e.g. @connect.deleteContactGroup(12345)
		# return true when contactgroup is deleted
#    def deleteContactGroup(id)
#		output(idApicall(id), :ok)
#    end
    
  end # class

end # module
