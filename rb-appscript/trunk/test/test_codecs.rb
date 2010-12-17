#!/usr/bin/ruby -w

begin; require 'rubygems'; rescue LoadError; end

require 'test/unit'
require 'aem'
require 'kae'
require 'ae'

def num(s)
	if [1].pack('s') == "\001\000" # host system is i386
		s.reverse
	else
		s
	end
end

def ut16(s)
	if [1].pack('s') == "\001\000" # host system is i386
		i = 0
		s2 = ''
		(s.length / 2).times do
			s2 += s[i, 2].reverse
			i+=2
		end
		s2
	else
		s
	end
end




class TC_Codecs < Test::Unit::TestCase
	
	def setup
		@c = AEM::Codecs.new
	end
	
	def test_nil
		d = @c.pack(nil)
		assert_equal(KAE::TypeNull, d.type)
		assert_equal('', d.data)
		assert_nil(@c.unpack(d))
	end
	
	def test_bool
		[
			[true, KAE::TypeTrue],
			[false, KAE::TypeFalse]
		].each do |val, type|
			d = @c.pack(val)
			assert_equal(type, d.type)
			assert_equal('', d.data)
			assert_equal(val, @c.unpack(d))
		end
		assert_equal(true, @c.unpack(AE::AEDesc.new(KAE::TypeBoolean, "\xfe")))
		assert_equal(true, @c.unpack(AE::AEDesc.new(KAE::TypeTrue, '')))
		assert_equal(false, @c.unpack(AE::AEDesc.new(KAE::TypeFalse, '')))
	end
	
	def test_num
		[ # (mostly testing at threshold points where Codecs switches types when packing integers)
			[0, "\x00\x00\x00\x00", KAE::TypeInteger],
			[2, "\x00\x00\x00\x02", KAE::TypeInteger],
			[-9, "\xff\xff\xff\xf7", KAE::TypeInteger],
			[2**31-1, "\x7f\xff\xff\xff", KAE::TypeInteger],
			[-2**31, "\x80\x00\x00\x00", KAE::TypeInteger],
			[2**31, "\x00\x00\x00\x00\x80\x00\x00\x00", KAE::TypeSInt64],
			[2**32-1, "\x00\x00\x00\x00\xff\xff\xff\xff", KAE::TypeSInt64],
			[2**32, "\x00\x00\x00\x01\x00\x00\x00\x00", KAE::TypeSInt64], 
			[-2**32, "\xff\xff\xff\xff\x00\x00\x00\x00", KAE::TypeSInt64],
			[2**63-1, "\x7f\xff\xff\xff\xff\xff\xff\xff", KAE::TypeSInt64], 
			[-2**63, "\x80\x00\x00\x00\x00\x00\x00\x00", KAE::TypeSInt64],
			[-2**63+1, "\x80\x00\x00\x00\x00\x00\x00\x01", KAE::TypeSInt64],
			[2**63, "C\xe0\x00\x00\x00\x00\x00\x00", KAE::TypeFloat],
			[-2**63-1, "\xc3\xe0\x00\x00\x00\x00\x00\x00", KAE::TypeFloat],
			[0.1, "?\xb9\x99\x99\x99\x99\x99\x9a", KAE::TypeFloat],
			[-0.9e-9, "\xbe\x0e\xec{\xd5\x12\xb5r", KAE::TypeFloat],
			[2**300, "R\xb0\x00\x00\x00\x00\x00\x00", KAE::TypeFloat],
		].each do |val, data, type|
			data = num(data)
			d = @c.pack(val)
			assert_equal(type, d.type)
			assert_equal(data, d.data)
			assert_equal(val, @c.unpack(d))
		end
	end
	
	def test_str
		s = "\xc6\x92\xe2\x88\x82\xc2\xae\xd4\xb7\xd5\x96\xd4\xb9\xe0\xa8\x89\xe3\x82\xa2\xe3\x84\xbb"
		# test Ruby 1.9+ String Encoding support
		version, sub_version = RUBY_VERSION.split('.').collect {|n| n.to_i} [0, 2]
		if version >= 1 and sub_version >= 9
			s.force_encoding('utf-8')
		end

		[
			# note: aem has to pack UTF8 data as typeUnicodeText (UTF16) as stupid apps expect that type and will error on typeUTF8Text instead of just asking AEM to coerce it to the desired type in advance.
			# note: UTF16 BOM must be omitted when packing UTF16 data into typeUnicodeText AEDescs, as a BOM will upset stupid apps like iTunes 7 that don't recognise it as a BOM and treat it as character data instead
			['', ''],
			['hello', "\000h\000e\000l\000l\000o"],
			[s, "\x01\x92\"\x02\x00\xae\x057\x05V\x059\n\t0\xa21;"],
		].each do |val, data|
			data = ut16(data)
			d = @c.pack(val)
			assert_equal(KAE::TypeUnicodeText, d.type)
			assert_equal(data, d.data)
			assert_equal(val, @c.unpack(d))
		end
		assert_raises(TypeError) { @c.pack("\x88") } # non-valid UTF8 strings should raise error when coercing from typeUTF8Text to typeUnicodeText
	end
	
	def test_date
		# note: not testing on ST-DST boundaries; this is known to have out-by-an-hour problems due to LongDateTime type being crap
		[
			[Time.local(2005, 12, 11, 15, 40, 43), "\x00\x00\x00\x00\xbf\xc1\xf8\xfb"],
			[Time.local(2005, 5, 1, 6, 51, 7), "\x00\x00\x00\x00\xbe\x9a\x2c\xdb"],
		].each do |t, data|
			data = num(data)
			d = @c.pack(t)
			assert_equal(KAE::TypeLongDateTime, d.type)
			assert_equal(data, d.data)
			assert_equal(t, @c.unpack(AE::AEDesc.new(KAE::TypeLongDateTime, data)))
		end
	end
	
	def test_file
		path = '/Applications/TextEdit.app'
		d = @c.pack(MacTypes::Alias.path(path))
		assert_equal(path, @c.unpack(d).to_s)
		
		path = '/Applications/TextEdit.app'
		d = @c.pack(MacTypes::FileURL.path(path))
		assert_equal(path, @c.unpack(d).to_s)
	end
	
	def test_typewrappers
		[
			AEM::AEType.new("docu"),
			AEM::AEEnum.new('yes '),
			AEM::AEProp.new('pnam'),
			AEM::AEKey.new('ABCD'),
		].each do |val|
			d = @c.pack(val)
			val2 = @c.unpack(d)
			assert_equal(val, val2)
			assert_block { val.eql?(val2) }
			val2 = @c.unpack(d)
			assert_equal(val2, val)
			assert_block { val2.eql?(val) }
		end
		assert_raises(ArgumentError) { AEM::AEType.new(3) }
		assert_raises(ArgumentError) { AEM::AEType.new("docum") }
	end
	
	def test_list
	end
	
	def test_hash
		val = {'foo' => 1, AEM::AEType.new('foob') => 2, AEM::AEProp.new('barr') => 3}
		expected_val = {'foo' => 1, AEM::AEType.new('foob') => 2, AEM::AEType.new('barr') => 3} # note that four-char-code keys are always unpacked as AEType
		d = @c.pack(val)
		assert_equal(expected_val, @c.unpack(d))
	end
	
	def test_units
		val = MacTypes::Units.new(3.3, :inches)
		assert_equal(:inches, val.type)
		assert_equal(3.3, val.value)
		d = @c.pack(val)
		assert_equal('inch', d.type)
		assert_equal(3.3, @c.unpack(d.coerce(KAE::TypeFloat)))
		val2 = @c.unpack(d)
		assert_equal(val, val2)
		assert_equal(:inches, val2.type)
		assert_equal(3.3, val2.value)
	end
	
	def test_app
		val = AEM::Application.by_path(FindApp.by_name('TextEdit'))
		d = @c.pack(val)
		assert_equal(KAE::TypeProcessSerialNumber, d.type)
	end
end
