#!/usr/local/bin/ruby

require 'test/unit'
require "appscript"


class TC_AppscriptReferences < Test::Unit::TestCase

	def setup
		@te = AS.app('TextEdit')
		@s = @te.to_s
	end

	def test_reference_forms
		[
			[@te.text, @s+'.text', nil],
			
			[@te.documents, @s+'.documents', nil],
			
			[@te.documents[1], 
					@s+'.documents[1]', nil],
			[@te.documents['foo'], 
					@s+'.documents["foo"]', nil],
			[@te.documents.ID(300), 
					@s+'.documents.ID(300)', nil],
			
			[@te.documents.next(:document), 
					@s+'.documents.next(:document)', nil],
			[@te.documents.previous(:document), 
					@s+'.documents.previous(:document)', nil],
			
			[@te.documents.first, @s+'.documents.first', nil],
			[@te.documents.middle, @s+'.documents.middle', nil],
			[@te.documents.last, @s+'.documents.last', nil],
			[@te.documents.any, @s+'.documents.any', nil],
			
			[AS.con.documents[3], 'AS.con.documents[3]', nil],
			
			[@te.documents[
					AS.con.documents[3],
					AS.con.documents['foo']], 
					@s+'.documents[' +
					'AS.con.documents[3], ' +
					'AS.con.documents["foo"]]', nil],
			
			
			[AS.its.name.eq('foo').and(AS.its.words.eq([])), 
					'AS.its.name.eq("foo").and(AS.its.words.eq([]))', nil],
			
			[AS.its.words.ne([]), 
					'AS.its.words.ne([])', 
					AS.its.words.eq([]).not], # i.e. there isn't a KAENotEqual operator, so not-equal tests are actually packed as an equal test followed by not test
					
			[AS.its.words.eq(nil), 'AS.its.words.eq(nil)', nil],
			[AS.its.words.size.gt(0), 
					'AS.its.words.size.gt(0)', nil],
			[AS.its.words.le(''), 'AS.its.words.le("")', nil],
			[AS.its.words.starts_with('foo').not, 
					'AS.its.words.starts_with("foo").not', nil],
			
			
			[AS.its.words.contains('foo'), 'AS.its.words.contains("foo")', nil],
			[AS.its.words.is_in('foo'), 'AS.its.words.is_in("foo")', nil],
			
			[@te.documents[AS.its.size.ge(42)], 
					@s+'.documents[AS.its.size.ge(42)]', nil],
			
			[@te.documents[1, 'foo'], 
					@s+'.documents[AS.con.documents[1], AS.con.documents["foo"]]', 
					@te.documents[AS.con.documents[1], AS.con.documents['foo']]],
			
			[@te.documents[1].text \
					.paragraphs.characters[
							AS.con.characters[3], 
							AS.con.characters[55]
					].next(:character).after,
					@s+'.documents[1].text.paragraphs.characters' +
					'[AS.con.characters[3], AS.con.characters[55]]' +
					'.next(:character).after', nil],
			
			[AS.its.name.ne('foo').and(AS.its.words.eq([])).not,
					'AS.its.name.ne("foo").and(AS.its.words.eq([])).not',
					AS.its.name.eq('foo').not.and(AS.its.words.eq([])).not],
			
			[@te.documents.start, @s+'.documents.start', nil],
			[@te.documents.end, @s+'.documents.end', nil],
			[@te.documents[3].before, @s+'.documents[3].before', nil],
			[@te.documents['foo'].after, @s+'.documents["foo"].after', nil],
			
		].each do |val, res, unpacked_version|
			assert_equal(res, val.to_s)
			d = @te.AS_app_data.pack(val)
			val = unpacked_version ? unpacked_version : val
			val2 = @te.AS_app_data.unpack(d)
			if val.class == @te.AS_app_data.unpack(d).class # note: AS::Reference and AS::GenericReference currently aren't comparable with each other, so the next test would always fail for those
				assert_equal(val, val2)
				assert_block { val.eql?(val2) }
			end
		end
	end
end

