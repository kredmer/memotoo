require 'parsedate'

module Memotoo
  
    class Connect

#contact-group
#     
#                :search_contact_group,
#                :add_contact_group,    
#                :delete_contact_group,
#                :get_contact_group,
#                :get_contact_group_sync
#                :modify_contact_group

    def searchContactGroup(searchparameter={})
		if has_needed_search_parameter(searchparameter)
			format_result(searchApiCall(searchparameter), :return, :contact_group)
		end
    end

    def addContactGroup(groupname)
    addparams = { 	:id => '',
				:updated => ''
			 }.merge!(:name=>groupname)
			
			format_result(addApiCall({:contactGroup => addparams}), :id)
	end


    def deleteContactGroup(id)
		format_result(deleteApiCall(id), :ok)
    end

	def getContactGroup(id)
		format_result(getApiCall(id), :return, :contact_group)
	end


	def getContactGroupSync(datetime)
		format_result(getSyncApiCall(datetime), :return, :contact_group)
	end

    def modifyContactGroup(details={})
		if has_needed_fields(details, :name, :id)
			format_result(modifyApiCall({:contactGroup => details}), :ok)
		end
    end




    
  end # class

end # module
