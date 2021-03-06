require File.expand_path('./test/helper')

class TestMemotoo < Test::Unit::TestCase
  
  context "Memotoo-Soap Api basic tests" do
  
		setup do
			@connect=Memotoo.new(MEMOTOO_USERNAME,MEMOTOO_PASSWORD, true, false, false)
		end
		
		should "have a connect-instance" do
			assert_equal Memotoo, @connect.class
		end
		
		should "write a message if username/password is not correct" do
			@connect=Memotoo.new(MEMOTOO_USERNAME,"wrongpasswd", true, false, false)
			assert_raises ArgumentError do
					response = @connect.searchContact(TESTSEARCHDEFAULTS)
			end
		end

		should "have valid username and password and get search results" do
			response = @connect.searchContact(TESTSEARCHDEFAULTS)
			assert_not_nil response
		end
		
		
		should "also use http request instead of https" do
			@connect=Memotoo.new(MEMOTOO_USERNAME,MEMOTOO_PASSWORD, false, false, false)
			response = @connect.searchContact(TESTSEARCHDEFAULTS)
			assert_not_nil response
		end
		
  end
		
end

################## rcov-result ######################

#Generated on Wed Jun 08 22:39:46 +0200 2011 with rcov 0.9.8

#Finished in 33.501191 seconds.

#34 tests, 34 assertions, 0 failures, 0 errors
#+----------------------------------------------------+-------+-------+--------+
#|                  File                              | Lines |  LOC  |  COV   |
#+----------------------------------------------------+-------+-------+--------+
#|lib/memotoo.rb                                      |     8 |     5 | 100.0% |
#|lib/memotoo/bookmark/bookmark.rb                    |    72 |    28 | 100.0% |
#|lib/memotoo/connect.rb                              |   244 |    98 | 100.0% |
#|lib/memotoo/contact/contact.rb                      |   162 |    28 | 100.0% |
#|lib/memotoo/contact/contact_group.rb                |    69 |    31 | 100.0% |
#|lib/memotoo/core-ext/hash.rb                        |    41 |    25 | 100.0% |
#|lib/memotoo/core-ext/kernel.rb                      |    10 |     6 | 100.0% |
#+----------------------------------------------------+-------+-------+--------+
#|Total                                               |   606 |   221 | 100.0% |
#+----------------------------------------------------+-------+-------+--------+
#100.0%   7 file(s)   606 Lines   221 LOC




