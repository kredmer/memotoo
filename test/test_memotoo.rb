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
				assert_not_nil response
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

# uncomment this if you want to see everything in log what happens...it's a lot
#module Savon
#  module Global

#    def log?
#      true
#    end
#    
#  end
#end

################## rcov-result ######################

#Generated on Tue Jun 07 09:45:05 +0200 2011 with rcov 0.9.8

#Finished in 21.668891 seconds.

#14 tests, 14 assertions, 0 failures, 0 errors
#+----------------------------------------------------+-------+-------+--------+
#|                  File                              | Lines |  LOC  |  COV   |
#+----------------------------------------------------+-------+-------+--------+
#|lib/memotoo.rb                                      |     5 |     3 | 100.0% |
#|lib/memotoo/connect.rb                              |    97 |    48 | 100.0% |
#|lib/memotoo/contact/contact.rb                      |   210 |    69 | 100.0% |
#|lib/memotoo/core-ext/hash.rb                        |    40 |    25 | 100.0% |
#+----------------------------------------------------+-------+-------+--------+
#|Total                                               |   352 |   145 | 100.0% |
#+----------------------------------------------------+-------+-------+--------+
#100.0%   4 file(s)   352 Lines   145 LOC


