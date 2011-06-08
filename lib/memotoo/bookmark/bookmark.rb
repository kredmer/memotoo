
module Memotoo
  
    class Connect
    
	#  required: url
	#
	#  optional:
	#  		description
	#       tags
	#       rank
	#       id_bookmarkfolder 
	# {:name=>groupname}
	#   #e.g. @connect.addBookmark({:name=>"Testgroup"})
    def addBookmark(details)
		if has_needed_fields(details, :url)
			#addparams = { 	:id => '',
			#			:updated => ''
			#		 }.merge!(details)
					format_result(addApiCall({:bookmark => addparams}), :id)
		end
	end

    #[searchparameter:]
		#   {:search=>"something", :limit_start=>0, :limit_nb=>100}
    	#*   required:
    	#        search
    	#*   optional:
    	#       limit_start
    	#       limit_nb
    	#e.g. @connect.searchBookmark({:search=>"ka", :limit_nb=>50})
    	#
    	# returns nil or a hash of one contactgroup or an array of contactgroups
    	#
    def searchBookmark(searchparameter={})
		if has_needed_search_parameter(searchparameter)
			format_result(searchApiCall(searchparameter), :return, :bookmark)
		end
    end

		# id = integer
		# e.g. @connect.getBookmark(12345)
		#
		# returns the contactgroup or nil
		#
	def getBookmark(id)
		format_result(getApiCall(id), :return, :bookmark)
	end

    	# get modified contactgroups since date
    	# datetime = "2010-02-23 10:00:00" or just "2010-02-23"
    	# e.g. @connect.getBookmarkSync("2010-02-23 10:00:00")
	def getBookmarkSync(datetime)
		format_result(getSyncApiCall(datetime), :return, :bookmark)
	end

    	# required: name and id
    	# note: you can only change the name
    	# return true if the changed happened
    def modifyBookmark(details={})
		if has_needed_fields(details, :name, :id)
			format_result(modifyApiCall({:bookmark => details}), :ok)
		end
    end

		# id = integer
		# e.g. @connect.deleteBookmark(12345)
		# return true when contactgroup is deleted
    def deleteBookmark(id)
		format_result(deleteApiCall(id), :ok)
    end
    
  end # class

end # module
