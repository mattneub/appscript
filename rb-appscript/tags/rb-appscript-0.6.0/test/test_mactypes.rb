#!/usr/bin/ruby -w

begin; require 'rubygems'; rescue LoadError; end

require 'test/unit'
require "_aem/mactypes"


class TC_MacTypes < Test::Unit::TestCase
	
	def setup
		@path1 = `mktemp -t codecs-test`.chomp
		dir, fname = File.split(@path1)
		@path2 = File.join(dir, 'moved-' + fname)
		# puts "path: #{@path1}" # e.g. /tmp/codecs-test.HWr1EnE3
	end
	
	def normalize(path)
		return path.gsub(/\/+/, '/') # quick-n-dirty
	end
	
	def test_alias
		# make alias
		f = MacTypes::Alias.path(@path1)
		
		
		assert_equal(MacTypes::Alias.path(@path1), f)
		
		# get path
		# note that initial /tmp/codecs-test... path will automatically change to /private/tmp/codecs-test...
		p1 = normalize('/private'+@path1)
		p2 = normalize('/private'+@path2)
				
		assert_equal(p1, normalize(f.path))
		
		#puts "alias path 1: #{f}" # e.g. /private/tmp/codecs-test.HWr1EnE3
		assert_equal(p1, f.to_s)
		
		# get desc
		#puts f.desc.type, f.desc.data # alis, [binary data]
		assert_equal('alis', f.desc.type)

		
		# check alias keeps track of moved file
		`mv #{@path1} #{@path2}`
		# puts "alias path 2: #{f}" # /private/tmp/moved-codecs-test.HWr1EnE3
		assert_equal(p2, f.to_s)

		assert_equal(p2, normalize(f.path))
		
		# check a FileNotFoundError is raised if getting path/FileURL for a filesystem object that no longer exists
		`rm #{@path2}`
		assert_raises(MacTypes::FileNotFoundError) { f.to_s } # File not found.
		assert_raises(MacTypes::FileNotFoundError) { f.to_file_url } # File not found.
		
		assert_equal(MacTypes::Alias.path("/Library/Scripts/"), MacTypes::Alias.path("/Library/Scripts/"))
		assert_not_equal(MacTypes::Alias.path("/Library/Scripts/"), MacTypes::Alias.path("/Applications/"))
	end


	def test_file_url

		g = MacTypes::FileURL.path('/non/existent path')

		assert_equal('/non/existent path', g.to_s)
		
		assert_equal('furl', g.desc.type)
		assert_equal('file://localhost/non/existent%20path', g.desc.data)

		assert_equal('MacTypes::FileURL.path("/non/existent path")', g.to_file_url.inspect)

		# check a not-found error is raised if getting Alias for a filesystem object that doesn't exist
		assert_raises(MacTypes::FileNotFoundError) { g.to_alias } # File "/non/existent path" not found.
		
		assert_equal(MacTypes::FileURL.path("/Library/Scripts/"), MacTypes::FileURL.path("/Library/Scripts/"))
		assert_not_equal(MacTypes::FileURL.path("/Library/Scripts/"), MacTypes::FileURL.path("/Applications/"))
		assert_not_equal(MacTypes::FileURL.path("/Library/Scripts/"), MacTypes::Alias.path("/Library/Scripts/"))
	end
end