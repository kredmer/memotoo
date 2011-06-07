require 'parsedate'

module Memotoo
  
    class Connect

#contact-group
#     
#:search_contact_group,
#:add_contact_group,    
#:delete_contact_group,
#:get_contact_group,
#:get_contact_group_sync
#:modify_contact_group

    def searchContactGroup(searchparameter={})
    	check=has_fields(searchparameter, :search)
    	if check[0]
			search = { 	:limit_start => '0',
						:limit_nb => '100'
			 		}.merge!(searchparameter)
			search_response = apicall(:searchContactGroup, search)
		# returns an array of contactgroups from search result
		if search_response.nil? || search_response==""
			 nil
		else
			search_response.to_hash.seek :search_contact_group_response, :return, :contact_group
		end
		
		else
			# returns false and a message
			go_home(check[1])
		end
    end





    def addContactGroup(groupname={})
    	check=has_fields(details, :lastname)
		if check[0]
			contact = apicall(:addContactGroup, { :contactGroup => groupname })
			# return the id from the new contact -> get it in my own db? maybe
			contact.to_hash.seek :add_contact_group_response, :id
		else
		# returns false, if lastname is not given
			go_home(check[1])		
		end
	end










    
  end # class

end # module
