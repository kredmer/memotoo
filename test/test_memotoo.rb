require 'helper'
require 'savon'
require File.dirname(__FILE__) + "/../lib/memotoo"


class TestMemotoo < Test::Unit::TestCase

  # put your own credentials here
  
  MEMOTOO_USERNAME = "memotoo-tester"
  MEMOTOO_PASSWORD = "memotoo-tester"
  
  context "Memotoo-Soap Api for contact" do
  
		setup do
			@connect=Memotoo::Connect.new(MEMOTOO_USERNAME,MEMOTOO_PASSWORD)
		end
		  
		should "have a connect-instance" do
			assert_equal Memotoo::Connect, @connect.class
		end
		  
		should "write a message if username/password is not correct" do
		    @connect=Memotoo::Connect.new(MEMOTOO_USERNAME,"wrongpasswd")
			response = @connect.searchContact({:search=>" ", :limit_start => '0', :limit_nb => '2'})
			assert_raise RuntimeError do
			  raise 'Boom!!!'			
			end
		end

		should "have valid username and password and get search results" do
			response = @connect.searchContact({:search=>" ", :limit_start => '0', :limit_nb => '2'})
			assert_not_nil response
		end
		
		
		should "also use http request instead of https" do
					@connect=Memotoo::Connect.new(MEMOTOO_USERNAME,MEMOTOO_PASSWORD, false)
			response = @connect.searchContact({:search=>" ", :limit_start => '0', :limit_nb => '2'})
			assert_not_nil response
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

# uncomment this if you want to see everything in log what happens...it's a lot
#module Savon
#  module Global
#    def log?
#      true
#    end
#    
#  end
#end

# comment this to see http requests logged
module HTTPI
  class << self
    def log?
      @log = false
    end
  end
end


################## rcov-result ######################

#Generated on Wed Jun 08 09:34:09 +0200 2011 with rcov 0.9.8

#Finished in 22.44544 seconds.

#24 tests, 24 assertions, 0 failures, 0 errors
#+----------------------------------------------------+-------+-------+--------+
#|                  File                              | Lines |  LOC  |  COV   |
#+----------------------------------------------------+-------+-------+--------+
#|lib/memotoo.rb                                      |     8 |     5 | 100.0% |
#|lib/memotoo/connect.rb                              |   241 |    96 | 100.0% |
#|lib/memotoo/contact/contact.rb                      |   163 |    29 | 100.0% |
#|lib/memotoo/contact/contact_group.rb                |    70 |    32 | 100.0% |
#|lib/memotoo/core-ext/hash.rb                        |    41 |    25 | 100.0% |
#|lib/memotoo/core-ext/kernel.rb                      |    10 |     6 | 100.0% |
#+----------------------------------------------------+-------+-------+--------+
#|Total                                               |   533 |   193 | 100.0% |
#+----------------------------------------------------+-------+-------+--------+
#100.0%   6 file(s)   533 Lines   193 LOC



