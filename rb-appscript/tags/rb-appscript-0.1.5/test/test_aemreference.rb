#!/usr/local/bin/ruby

require 'test/unit'
require "_aem/aemreference"
require "_aem/typewrappers"
require "_aem/codecs"


class TC_AEMReferences < Test::Unit::TestCase

	def test_referenceForms
		[
			[AEMReference::App.property('ctxt'), 'AEM.app.property("ctxt")', nil],
			
			[AEMReference::App.elements('docu'), 'AEM.app.elements("docu")', nil],
			
			[AEMReference::App.elements('docu').byindex(1), 
					'AEM.app.elements("docu").byindex(1)', nil],
			[AEMReference::App.elements('docu').byname('foo'), 
					'AEM.app.elements("docu").byname("foo")', nil],
			[AEMReference::App.elements('docu').byid(300), 
					'AEM.app.elements("docu").byid(300)', nil],
			
			[AEMReference::App.elements('docu').next('docu'), 
					'AEM.app.elements("docu").next("docu")', nil],
			[AEMReference::App.elements('docu').previous('docu'), 
					'AEM.app.elements("docu").previous("docu")', nil],
			
			[AEMReference::App.elements('docu').first, 'AEM.app.elements("docu").first', nil],
			[AEMReference::App.elements('docu').middle, 'AEM.app.elements("docu").middle', nil],
			[AEMReference::App.elements('docu').last, 'AEM.app.elements("docu").last', nil],
			[AEMReference::App.elements('docu').any, 'AEM.app.elements("docu").any', nil],
			
			[AEMReference::Con.elements("docu").byindex(3), 'AEM.con.elements("docu").byindex(3)', nil],
			
			[AEMReference::App.elements('docu').byrange(
					AEMReference::Con.elements('docu').byindex(3),
					AEMReference::Con.elements('docu').byname('foo')), 
					'AEM.app.elements("docu").byrange(' +
					'AEM.con.elements("docu").byindex(3), ' +
					'AEM.con.elements("docu").byname("foo"))', nil],
			
			
			[AEMReference::Its.property('name').eq('foo').and(AEMReference::Its.elements('cwor').eq([])), 
					'AEM.its.property("name").eq("foo").and(AEM.its.elements("cwor").eq([]))', nil],
			
			[AEMReference::Its.elements('cwor').ne([]), 
					'AEM.its.elements("cwor").ne([])', 
					AEMReference::Its.elements("cwor").eq([]).not], # i.e. there isn't a KAENotEqual operator, so not-equal tests are actually packed as an equal test followed by not test
					
			[AEMReference::Its.elements('cwor').eq(nil), 'AEM.its.elements("cwor").eq(nil)', nil],
			[AEMReference::Its.elements('cwor').property('leng').gt(0), 
					'AEM.its.elements("cwor").property("leng").gt(0)', nil],
			[AEMReference::Its.elements('cwor').le(''), 'AEM.its.elements("cwor").le("")', nil],
			[AEMReference::Its.elements('cwor').startswith('foo').not, 
					'AEM.its.elements("cwor").startswith("foo").not', nil],
			
			
			[AEMReference::Its.elements('cwor').contains('foo'), 'AEM.its.elements("cwor").contains("foo")', nil],
			[AEMReference::Its.elements('cwor').isin('foo'), 'AEM.its.elements("cwor").isin("foo")', nil],
			
			[AEMReference::App.elements('docu').byfilter(AEMReference::Its.property('size').ge(42)), 
					'AEM.app.elements("docu").byfilter(AEM.its.property("size").ge(42))', nil],
					
			[AEMReference::App.elements('docu').byindex(1).property('ctxt') \
					.elements('cpar').elements('cha ').byrange(
							AEMReference::Con.elements('cha ').byindex(3), 
							AEMReference::Con.elements('cha ').byindex(55)
					).next('cha ').after,
					'AEM.app.elements("docu").byindex(1).property("ctxt").elements("cpar").elements("cha ")' +
					'.byrange(AEM.con.elements("cha ").byindex(3), AEM.con.elements("cha ").byindex(55))' +
					'.next("cha ").after', nil],
			
			[AEMReference::Its.property('pnam').ne('foo').and(AEMReference::Its.elements('cfol').eq([])).not,
					'AEM.its.property("pnam").ne("foo").and(AEM.its.elements("cfol").eq([])).not',
					AEMReference::Its.property('pnam').eq('foo').not.and(AEMReference::Its.elements('cfol').eq([])).not],
			
			[AEMReference::App.elements('docu').start, 'AEM.app.elements("docu").start', nil],
			[AEMReference::App.elements('docu').end, 'AEM.app.elements("docu").end', nil],
			[AEMReference::App.elements('docu').byindex(3).before, 'AEM.app.elements("docu").byindex(3).before', nil],
			[AEMReference::App.elements('docu').byname('foo').after, 'AEM.app.elements("docu").byname("foo").after', nil],
			
		].each do |val, res, unpackedVersion|
			assert_equal(res, val.to_s)
			d = DefaultCodecs.pack(val)
			val = unpackedVersion ? unpackedVersion : val
			val2 = DefaultCodecs.unpack(d)
			assert_equal(val, val2)
			assert_block { val.eql?(val2) }
		end
		# by-range and by-filter references do basic type checking to ensure a reference is given
		assert_raises(TypeError) { AEMReference::App.elements('docu').byrange(1, 2) }
		assert_raises(TypeError) { AEMReference::App.elements('docu').byfilter(1) }
		
	end
end

