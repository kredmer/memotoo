#require 'helper'

#class TestBookmark < Test::Unit::TestCase

# TESTBOOKMARK="www.testbookmark.de"
# TESTBOOKMARKSEARCH = {:search=>TESTBOOKMARK}

#   	context "what we could do with bookmarks" do
#   	
#   		setup do
#			@connect=Memotoo::Connect.new(MEMOTOO_USERNAME,MEMOTOO_PASSWORD)
#			#puts "testing bookmarks...."
#		end

#		context "Adding and finding bookmarks" do

#			should "add a new testbookmark" do
#				response = @connect.addBookmark({:url => TESTBOOKMARK})
#				assert_not_nil response
#			end
#			
#			should "add a new testbookmark (and look for needed params)" do
#				response = @connect.addBookmark({})
#				assert_nil response
#			end
#		
#			should "find the testbookmark" do
#				  response = @connect.searchBookmark(TESTBOOKMARKSEARCH)
#				  assert_not_nil response
#			end
#			
#			should "not find a non existent contact" do
#				  response = @connect.searchBookmark(
#				        {:search=>"Testbookmark1234567890"})
#				  assert_nil response
#			end
#			
#			should "look for a search parameter in search" do
#				  response = @connect.searchBookmark({})
#				  assert !response
#			end
#			
#	  		should "get the testbookmark" do
#	 		      response = @connect.searchBookmark(TESTBOOKMARKSEARCH)
#				  contact = @connect.getBookmark(response[:id])
#				  assert_not_nil contact
#			end
#			
#			should "get the bookmarks changed since 2011-01-01" do
#				response = @connect.getBookmarkSync("2011-01-01 00:00:00")
#				assert_not_nil response
#			end
#		end
#		
#		
#		context "B Modifying bookmarks" do
#		
#			should "modify the testbookmark" do
#	 		      response = @connect.searchBookmark(TESTBOOKMARKSEARCH)
#				  contact = @connect.modifyBookmark(
#				  {:id=>response[:id],
#				   :url=>TESTBOOKMARK,
#				   :description => "nice"})
#				  assert contact
#			end

#			should "modify the testbookmark (and look for needed params)" do
#	 		      response = @connect.searchBookmark(TESTBOOKMARKSEARCH)
#				  contact = @connect.modifyBookmark({})
#				  assert !contact
#			end
#		end
#		
#		
#		context "Deleting bookmarks" do
#		
#			should "delete the testbookmark" do
#	 		      response = @connect.searchBookmark(TESTBOOKMARKSEARCH)
#				  contact = @connect.deleteBookmark(response[:id])
#				  assert contact
#			end
#		end
#		
#	end
#end
