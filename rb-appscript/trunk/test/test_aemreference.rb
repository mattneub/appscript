#!/usr/bin/ruby -w

begin; require 'rubygems'; rescue LoadError; end

require 'test/unit'
require "_aem/aemreference"
require "_aem/typewrappers"
require "_aem/codecs"


class TC_AEMReferences < Test::Unit::TestCase

	def test_reference_forms
		[
			[AEMReference::App.property('ctxt'), 'AEM.app.property("ctxt")', nil],
			
			[AEMReference::App.elements('docu'), 'AEM.app.elements("docu")', nil],
			
			[AEMReference::App.elements('docu').by_index(1), 
					'AEM.app.elements("docu").by_index(1)', nil],
			[AEMReference::App.elements('docu').by_name('foo'), 
					'AEM.app.elements("docu").by_name("foo")', nil],
			[AEMReference::App.elements('docu').by_id(300), 
					'AEM.app.elements("docu").by_id(300)', nil],
			
			[AEMReference::App.elements('docu').next('docu'), 
					'AEM.app.elements("docu").next("docu")', nil],
			[AEMReference::App.elements('docu').previous('docu'), 
					'AEM.app.elements("docu").previous("docu")', nil],
			
			[AEMReference::App.elements('docu').first, 'AEM.app.elements("docu").first', nil],
			[AEMReference::App.elements('docu').middle, 'AEM.app.elements("docu").middle', nil],
			[AEMReference::App.elements('docu').last, 'AEM.app.elements("docu").last', nil],
			[AEMReference::App.elements('docu').any, 'AEM.app.elements("docu").any', nil],
			
			[AEMReference::Con.elements("docu").by_index(3), 'AEM.con.elements("docu").by_index(3)', nil],
			
			[AEMReference::App.elements('docu').by_range(
					AEMReference::Con.elements('docu').by_index(3),
					AEMReference::Con.elements('docu').by_name('foo')), 
					'AEM.app.elements("docu").by_range(' +
					'AEM.con.elements("docu").by_index(3), ' +
					'AEM.con.elements("docu").by_name("foo"))', nil],
			
			[AEMReference::App.elements('docu').by_range(1, 'foo'),
					'AEM.app.elements("docu").by_range(1, "foo")',
					AEMReference::App.elements("docu").by_range(
							AEMReference::Con.elements("docu").by_index(1), 
							AEMReference::Con.elements("docu").by_name("foo"))],
			
			[AEMReference::Its.property('name').eq('foo').and(AEMReference::Its.elements('cwor').eq([])), 
					'AEM.its.property("name").eq("foo").and(AEM.its.elements("cwor").eq([]))', nil],
			
			[AEMReference::Its.elements('cwor').ne([]), 
					'AEM.its.elements("cwor").ne([])', 
					AEMReference::Its.elements("cwor").eq([]).not], # i.e. there isn't a KAENotEqual operator, so not-equal tests are actually packed as an equal test followed by not test
					
			[AEMReference::Its.elements('cwor').eq(nil), 'AEM.its.elements("cwor").eq(nil)', nil],
			[AEMReference::Its.elements('cwor').property('leng').gt(0), 
					'AEM.its.elements("cwor").property("leng").gt(0)', nil],
			[AEMReference::Its.elements('cwor').le(''), 'AEM.its.elements("cwor").le("")', nil],
			[AEMReference::Its.elements('cwor').begins_with('foo').not, 
					'AEM.its.elements("cwor").begins_with("foo").not', nil],
			
			
			[AEMReference::Its.elements('cwor').contains('foo'), 'AEM.its.elements("cwor").contains("foo")', nil],
			[AEMReference::Its.elements('cwor').is_in('foo'), 'AEM.its.elements("cwor").is_in("foo")', nil],
			
			[AEMReference::App.elements('docu').by_filter(AEMReference::Its.property('size').ge(42)), 
					'AEM.app.elements("docu").by_filter(AEM.its.property("size").ge(42))', nil],
					
			[AEMReference::App.elements('docu').by_index(1).property('ctxt') \
					.elements('cpar').elements('cha ').by_range(
							AEMReference::Con.elements('cha ').by_index(3), 
							AEMReference::Con.elements('cha ').by_index(55)
					).next('cha ').after,
					'AEM.app.elements("docu").by_index(1).property("ctxt").elements("cpar").elements("cha ")' +
					'.by_range(AEM.con.elements("cha ").by_index(3), AEM.con.elements("cha ").by_index(55))' +
					'.next("cha ").after', nil],
			
			[AEMReference::Its.property('pnam').ne('foo').and(AEMReference::Its.elements('cfol').eq([])).not,
					'AEM.its.property("pnam").ne("foo").and(AEM.its.elements("cfol").eq([])).not',
					AEMReference::Its.property('pnam').eq('foo').not.and(AEMReference::Its.elements('cfol').eq([])).not],
			
			[AEMReference::App.elements('docu').beginning, 'AEM.app.elements("docu").beginning', nil],
			[AEMReference::App.elements('docu').end, 'AEM.app.elements("docu").end', nil],
			[AEMReference::App.elements('docu').by_index(3).before, 'AEM.app.elements("docu").by_index(3).before', nil],
			[AEMReference::App.elements('docu').by_name('foo').after, 'AEM.app.elements("docu").by_name("foo").after', nil],
			
		].each do |val, res, unpacked_version|
			begin
				assert_equal(res, val.to_s)
				d = DefaultCodecs.pack(val)
				val = unpacked_version ? unpacked_version : val
				val2 = DefaultCodecs.unpack(d)
				assert_equal(val, val2)
				val2 = DefaultCodecs.unpack(d)
				assert_block { val.eql?(val2) }
				val2 = DefaultCodecs.unpack(d)
				assert_equal(val2, val)
				val2 = DefaultCodecs.unpack(d)
				assert_block { val2.eql?(val) }
			rescue
				puts 'EXPECTED: ' + res
				raise
			end
		end
		assert_not_equal(AEMReference::App.property('ctxt').property('ctxt'), AEMReference::Con.property('ctxt').property('ctxt'))
		assert_not_equal(AEMReference::App.property('foob').property('ctxt'), AEMReference::App.property('ctxt').property('ctxt'))
		assert_not_equal(AEMReference::App.elements('ctxt').property('ctxt'), AEMReference::App.property('ctxt').property('ctxt'))
		assert_not_equal(AEMReference::App.elements('ctxt').property('ctxt'), 333)
		assert_not_equal(333, AEMReference::App.property('ctxt').property('ctxt'))
#		# by-filter references do basic type checking to ensure an its-based reference is given
		assert_raises(TypeError) { AEMReference::App.elements('docu').by_filter(1) }
		
	end
end

