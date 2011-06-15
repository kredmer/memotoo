require File.expand_path('./test/helper')

class TestMemotoo < Test::Unit::TestCase

# api-problem in: BookmarkFolder, Holiday -> reportet to Thomas Pequet on 12.July 2011

# uncomment this to test all soapobjects
soapobjects = %w{Contact}
#soapobjects = %w{Contact ContactGroup Bookmark Note CalendarCategory Event Task}




fixure = {  :contact => {	:new => {:lastname => "Testcontact123456"},
							:mod => {:lastname => "Testcontact123456xyz"}},
			:contact_group => {	:new=>{:name => "TestcontactGroup123456"},
								:mod => {:name => "TestcontactGroup123456xyz"}},
			:bookmark => {	:new=>{:url => "Testbookmark.com"},
							:mod => {:url => "Testbookmark123.com"}},
			:bookmark_folder => {:new=>{:name => "Testbookmarkfolder123456"},
						:mod => {:name => "Testbookmarkfolder123456xyz"}},
			:note => {	:new => {:description => "TestNote12345"},
						:mod => {:description => "TestNote12345xyz"}},
			:calendar_category => {:new=>{:name => "TestCalendarCategory123456"},
						:mod => {:name => "TestCalendarCategory123456xyz"}},
			:event => {	:new => {:title=> "Testevent1234", :dateBegin=>"2011-06-12T10:00:00", :dateEnd=>"2011-06-12T15:00:00"},
						:mod => {:title=> "Testevent1234xyz", :dateBegin=>"2011-06-12T10:00:00", :dateEnd=>"2011-06-12T15:00:00"}},
			:holiday => {:new => {:description=> "Testholiday1234", :dateBegin=>"2011-07-12", :dateEnd=>"2011-07-20"},
						:mod => {:description=> "Testholiday1234xyz", :dateBegin=>"2011-07-12", :dateEnd=>"2011-07-20"}},
			:task => {	:new => {:title=> "Testtask1234"},
						:mod => {:title=> "Testtask1234xyz"}} }

needs = Memotoo::NEEDS

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
			@connect=Memotoo.new(MEMOTOO_USERNAME,MEMOTOO_PASSWORD, false)
		end

		context "Adding and finding #{soapobject}" do

			should "add a new #{soapobject}" do
				response= @connect.send(addmethod,fixure[symbol][:new])
				assert_not_nil response
			end
			
			should "add a new #{soapobject} (and look for needed params)" do
				assert_raises ArgumentError do
					response = @connect.send(addmethod,{})
				end
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
				assert_raises ArgumentError do
					response = @connect.send(searchmethod,{})
				end
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
				params = {:id=>response[:id]}.merge(fixure[symbol][:mod])
	 		    contact = @connect.send(modifymethod,params)
				assert contact
			end

			should "modify the test#{soapobject} (and look for needed params)" do
				response = @connect.send(searchmethod,{:search => fixure[symbol][:mod][needs[symbol][0]]})
				assert_raises ArgumentError do
					contact = @connect.send(modifymethod, {})
				end
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
