#!/usr/local/bin/ruby

require 'test/unit'
require "macfile"


class TC_MacFile < Test::Unit::TestCase
	
	def setup
		@path1 = `mktemp -t codecs-test`.chomp
		dir, fname = File.split(@path1)
		@path2 = File.join(dir, 'moved-' + fname)
		# puts "path: #{@path1}" # e.g. /tmp/codecs-test.HWr1EnE3
	end
	
	def test_alias
		# make alias
		@f = MacFile::Alias.at(@path1)
		
		# get path
		# note that initial /tmp/codecs-test... path will automatically change to /private/tmp/codecs-test...
		p1 = '/private'+@path1
		p2 = '/private'+@path2
		
		assert_equal("MacFile::Alias.at(#{p1.inspect})", @f.inspect)
		
		#puts "alias path 1: #{f.path}" # e.g. /private/tmp/codecs-test.HWr1EnE3
		assert_equal(p1, @f.path)
		
		# get desc
		#puts f.desc.type, f.desc.data # alis, [binary data]
		assert_equal('alis', @f.desc.type)

		
		# check alias keeps track of moved file
		`mv #{@path1} #{@path2}`
		# puts "alias path 2: #{f.path}" # /private/tmp/moved-codecs-test.HWr1EnE3
		assert_equal(p2, @f.path)

		assert_equal("MacFile::Alias.at(#{p2.inspect})", @f.inspect)
		
		# check a FileNotFoundError is raised if getting path/FileURL for a filesystem object that no longer exists
		`rm #{@path2}`
		assert_raises(MacFile::FileNotFoundError) { @f.path } # File not found.
		assert_raises(MacFile::FileNotFoundError) { @f.to_FileURL } # File not found.
	end


	def test_fileURL

		g = MacFile::FileURL.at('/non/existent path')

		assert_equal('/non/existent path', g.path)
		
		assert_equal('furl', g.desc.type)
		assert_equal('file://localhost/non/existent%20path', g.desc.data)

		assert_equal('MacFile::FileURL.at("/non/existent path")', g.to_FileURL.inspect)

		# check a not-found error is raised if getting Alias for a filesystem object that doesn't exist
		assert_raises(MacFile::FileNotFoundError) { g.to_Alias } # File "/non/existent path" not found.

	end
end