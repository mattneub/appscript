#!/usr/bin/ruby -w

begin; require 'rubygems'; rescue LoadError; end

require 'test/unit'
require 'osax'

class TC_OSAX < Test::Unit::TestCase
	
	def test_1
		sa = OSAX.osax('Standardadditions')
		
		assert_equal(65, sa.ASCII_number('A'))
		
		assert_equal(MacTypes::Alias.path("/Applications/"), sa.path_to(:applications_folder))
		
		assert_equal(MacTypes::Alias.path("/Library/Scripts/"), 
				sa.path_to(:scripts_folder, :from=>:local_domain))
		
		assert_raises(RuntimeError) { sa.non_existent_command }
	end
	
	def test_2
		sa = OSAX.osax('Standardadditions').by_name('Finder')
		assert_equal(65, sa.ASCII_number('A'))
		assert_equal(MacTypes::Alias.path("/System/Library/CoreServices/Finder.app/"), sa.path_to(nil))
	end
	
	def test_3
		sa = OSAX.osax('Standardadditions').by_creator('MACS')
		assert_equal(65, sa.ASCII_number('A'))
		assert_equal(MacTypes::Alias.path("/System/Library/CoreServices/Finder.app/"), sa.path_to(nil))
	end
	
	def test_4
		sa = OSAX.osax('Standardadditions').by_id('com.apple.finder')
		assert_equal(65, sa.ASCII_number('A'))
		assert_equal(MacTypes::Alias.path("/System/Library/CoreServices/Finder.app/"), sa.path_to(nil))
	end
	
	def test_5
		sa = OSAX.osax('Standardadditions').by_pid(`top -l1 | grep Finder | awk '{ print $1 }'`.to_i)
		assert_equal(MacTypes::Alias.path("/System/Library/CoreServices/Finder.app/"), sa.path_to(nil))
		assert_equal(65, sa.ASCII_number('A'))
	end

	def test_6
		sa = OSAX.osax('Standardadditions').by_aem_app(AEM::Application.by_path("/System/Library/CoreServices/Finder.app/"))
		assert_equal(65, sa.ASCII_number('A'))
		assert_equal(MacTypes::Alias.path("/System/Library/CoreServices/Finder.app/"), sa.path_to(nil))
	end


end