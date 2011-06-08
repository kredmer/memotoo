require 'helper'

class TestMemotoo < Test::Unit::TestCase

   	context "what we could do with contacts" do
   	
   		setup do
			@connect=Memotoo::Connect.new(MEMOTOO_USERNAME,MEMOTOO_PASSWORD)
			#puts "testing contacts...."
		end

		context "Adding and finding contacts" do

			should "add a new testcontact" do
				response = @connect.addContact({:lastname => "Testcontact123456"})
				assert_not_nil response
			end
			
			should "add a new testcontact (and look for needed params)" do
				response = @connect.addContact({})
				assert_nil response
			end
		
			should "find the testcontact" do
				  response = @connect.searchContact({:search=>"Testcontact123456"})
				  assert_not_nil response
			end
			
			should "not find a non existent contact" do
				  response = @connect.searchContact({:search=>"Testcontact1234567890"})
				  assert_nil response
			end
			
			should "look for a search parameter in search" do
				  response = @connect.searchContact({})
				  assert !response
			end
			
	  		should "get the testcontact" do
	 		      response = @connect.searchContact({:search=>"Testcontact123456"})
				  contact = @connect.getContact(response[:id])
				  assert_not_nil contact
			end
			
			should "get the contacts changed since 2011-01-01" do
				response = @connect.getContactSync("2011-01-01 00:00:00")
				assert_not_nil response
			end
		end
		
		
		context "B Modifying contacts" do
		
			should "modify the testcontact" do
	 		      response = @connect.searchContact({:search=>"Testcontact123456"})
				  contact = @connect.modifyContact({:id=>response[:id], :lastname=>"Testcontact123456", :firstname=>"test"})
				  assert contact
			end

			should "modify the testcontact (and look for needed params)" do
	 		      response = @connect.searchContact({:search=>"Testcontact123456"})
				  contact = @connect.modifyContact({})
				  assert !contact
			end
		end
		
		
		context "Deleting contacts" do
		
			should "delete the testcontact" do
	 		      response = @connect.searchContact({:search=>"Testcontact123456"})
				  contact = @connect.deleteContact(response[:id])
				  assert contact
			end
		end
		
	end
end
