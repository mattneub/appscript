#!/usr/local/bin/ruby

require 'test/unit'
require 'osax'

class AS_SafeObject
	def self.hide(name)
	end
end

class TC_OSAX < Test::Unit::TestCase
	
	def test_new
		sa = OSAX.osax('Standardadditions')
		
		assert_equal(65, sa.ASCII_number('A'))
		
		assert_equal(MacTypes::Alias.path("/Applications/"), sa.path_to(:applications_folder))
		
		assert_equal(MacTypes::Alias.path("/Library/Scripts/"), sa.path_to(:scripts_folder, :from=>:local_domain))
		
		assert_raises(RuntimeError) { sa.non_existent_command }
	end



end