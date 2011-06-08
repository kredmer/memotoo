require 'helper'

class TestMemotoo < Test::Unit::TestCase

   	context "what we could do with contactgroups" do
   	
   		setup do
			@connect=Memotoo::Connect.new(MEMOTOO_USERNAME,MEMOTOO_PASSWORD)
		end
		
		context "Adding and finding contactgroups" do
		  
			should "add a new testcontactgroup" do
				response = @connect.addContactGroup({:name=>"TestcontactGroup123456"})
				assert_not_nil response
			end
			
			should "add a new testcontactgroup (and look for needed params)" do
				response = @connect.addContactGroup({})
				assert_nil response
			end
			
			should "find the testcontactgroup" do
				  response = @connect.searchContactGroup({:search=>"TestcontactGroup123456"})
				  assert_not_nil response
			end
			
			should "not find a non existent contactgroup" do
				  response = @connect.searchContactGroup({:search=>"TestcontactGroup1234567890"})
				  assert_nil response
			end
			
			should "look for a search parameter in search" do
				  response = @connect.searchContactGroup({})
				  assert !response
			end
			
	  		should "get the testcontactgroup" do
	 		      response = @connect.searchContactGroup({:search=>"TestcontactGroup123456"})
				  contactgroup = @connect.getContactGroup(response[:id])
				  assert_not_nil contactgroup
			end
			
			should "get the contactgroups changed since 2011-01-01" do
				response = @connect.getContactGroupSync("2011-01-01 00:00:00")
				assert_not_nil response
			end
		end
		
		
		context "B Modifying contactgroups" do
		
			should "modify the testcontactgroup" do
	 		      response = @connect.searchContactGroup({:search=>"TestcontactGroup123456"})
	 		      #puts "response:::"+response.to_s
				  contactgroup = @connect.modifyContactGroup({:id=>response[:id], :name=>"TestcontactGroup1234567"})
				  assert contactgroup
			end

			should "modify the testcontactgroup (and look for needed params)" do
	 		      response = @connect.searchContactGroup({:search=>"TestcontactGroup123456"})
				  contact = @connect.modifyContactGroup({})
				  assert !contact
			end
		end


		context "Deleting contactgroups" do
		
			should "delete the testcontactgroup" do
	 		      response = @connect.searchContactGroup({:search=>"TestcontactGroup1234567"})
				  contactgroup = @connect.deleteContactGroup(response[:id])
				  assert contactgroup
			end
		end
		
	end
end
