require 'helper'

class TestMemotoo < Test::Unit::TestCase

# api-problem in: BookmarkFolder

#soapobjects = %w{Contact ContactGroup Bookmark Note}
soapobjects = %w{Contact}



fixure = {  :contact => {:new => {:lastname => "Testcontact123456"},
						:mod => {:lastname => "Testcontact123456xyz"}},
			:contact_group => {:name => "TestcontactGroup123456"},
			:bookmark => {:url => "Testbookmark.com"},
			:bookmark_folder => {:name => "Testbookmarkfolder123456"},
			:note => {:description => "TestNote12345"},
			:calendar_category => {:name => "TestCalendarCategory123456"}}

needs = Memotoo::Connect::NEEDS

soapobjects.each do |soapobject|
		symbol=soapobject.underscore.to_sym
		objectfixure = fixure[symbol][:new][needs[symbol][0]]
		addmethod=("add"+soapobject).to_sym
		searchmethod=("search"+soapobject).to_sym
		getmethod=("get"+soapobject).to_sym
		getsyncmethod=("get"+soapobject+"Sync").to_sym
		modifymethod=("modify"+soapobject).to_sym
		deletemethod=("delete"+soapobject).to_sym


   	context "what we could do with #{soapobject}'s" do
   	
   		setup do
			@connect=Memotoo::Connect.new(MEMOTOO_USERNAME,MEMOTOO_PASSWORD, false)
		end

		context "Adding and finding #{soapobject}" do

			should "add a new #{soapobject}" do
				response= @connect.send(addmethod,fixure[symbol][:new])
				assert_not_nil response
			end
			
			should "add a new #{soapobject} (and look for needed params)" do
				response = @connect.send(addmethod,{})
				assert_nil response
			end
		
			should "find the #{soapobject}" do
				response = @connect.send(searchmethod,{:search => objectfixure})
				assert_not_nil response
			end
			
			should "not find a non existent #{soapobject}" do
				response = @connect.send(searchmethod,{:search => objectfixure+"xyz"})
				assert_nil response
			end
			
			should "look for a search parameter in search for #{soapobject}" do
				response = @connect.send(searchmethod,{})
				assert !response
			end
			
	  		should "get the test#{soapobject}" do
	  			response = @connect.send(searchmethod,{:search => objectfixure})
	  			contact = @connect.send(getmethod,response[:id])
				assert_not_nil contact
			end
			
			should "get the #{soapobject} changed since 2011-01-01" do
				response = @connect.send(getsyncmethod,"2011-01-01 00:00:00")
				assert_not_nil response
			end
		end
		
		
		context "B Modifying #{soapobject}'s" do
		
			should "modify the test#{soapobject}" do
				response = @connect.send(searchmethod,{:search => objectfixure})
	 		    contact = @connect.send(modifymethod, {:id=>response[:id]}.merge(fixure[symbol][:mod]))
				assert contact
			end

			should "modify the test#{soapobject} (and look for needed params)" do
				response = @connect.send(searchmethod,{:search => objectfixure})
	 		      contact = @connect.send(modifymethod, {})
				  assert !contact
			end
		end
		
		
		context "Deleting #{soapobject}" do
		
			should "delete the test#{soapobject}" do
				response = @connect.send(searchmethod,{:search => fixure[symbol][:mod][needs[symbol][0]]})
				contact = @connect.send(deletemethod,response[:id])
				assert contact
			end
		end
		
	end #context
	end # each
end #class
