#!/usr/bin/ruby -w

begin; require 'rubygems'; rescue LoadError; end

require 'test/unit'
require "_aem/findapp"


class TC_FindApp < Test::Unit::TestCase

	def test_find
		[
			['/Applications/iCal.app', '/Applications/iCal.app'],
			['ical.app', '/Applications/iCal.app'],
			['ICAL', '/Applications/iCal.app'],
		].each do |val, res|
			assert_equal(res, FindApp.by_name(val))
		end
		assert_equal('/Applications/TextEdit.app', FindApp.by_creator('ttxt'))
		assert_equal('/System/Library/CoreServices/Finder.app', FindApp.by_id('com.apple.finder'))
		assert_raises(FindApp::ApplicationNotFoundError) { FindApp.by_name('NON-EXISTENT-APP') }

		# assert_equal("/Users/has/\306\222\303\270u\314\210.app", FindApp.by_name("\306\222\303\270u\314\210.app")) # utf8 paths work ok
	end
end
		