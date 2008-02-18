#!/usr/bin/ruby -w

begin; require 'rubygems'; rescue LoadError; end

require 'test/unit'
require "appscript"

class TC_AppscriptReferences < Test::Unit::TestCase

	def setup
		@te = Appscript.app('TextEdit')
		@s = @te.to_s
	end

	def test_reference_forms
		[
			
			[@te.documents[
					Appscript.con.documents[3],
					Appscript.con.documents['foo']], 
					@s+'.documents[' +
					'con.documents[3], ' +
					'con.documents["foo"]]', nil],
					
					
					
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
			
			[Appscript.con.documents[3], 'con.documents[3]', nil],
			
			
			[Appscript.its.name.eq('foo').and(Appscript.its.words.eq([])), 
					'its.name.eq("foo").and(its.words.eq([]))', nil],
			
			[Appscript.its.words.ne([]), 
					'its.words.ne([])', 
					Appscript.its.words.eq([]).not], # i.e. there isn't a KAENotEqual operator, so not-equal tests are actually packed as an equal test followed by not test
					
			[Appscript.its.words.eq(nil), 'its.words.eq(nil)', nil],
			[Appscript.its.words.size.gt(0), 
					'its.words.size.gt(0)', nil],
			[Appscript.its.words.le(''), 'its.words.le("")', nil],
			[Appscript.its.words.begins_with('foo').not, 
					'its.words.begins_with("foo").not', nil],
			
			
			[Appscript.its.words.contains('foo'), 'its.words.contains("foo")', nil],
			[Appscript.its.words.is_in('foo'), 'its.words.is_in("foo")', nil],
			
			[@te.documents[Appscript.its.size.ge(42)], 
					@s+'.documents[its.size.ge(42)]', nil],
			
			[@te.documents[1, 'foo'], 
					@s+'.documents[1, "foo"]',
					@te.documents[Appscript.con.documents[1], Appscript.con.documents["foo"]]],
			
			[@te.documents[1].text \
					.paragraphs.characters[
							Appscript.con.characters[3], 
							Appscript.con.characters[55]
					].next(:character).after,
					@s+'.documents[1].text.paragraphs.characters' +
					'[con.characters[3], con.characters[55]]' +
					'.next(:character).after', nil],
			
			[Appscript.its.name.ne('foo').and(Appscript.its.words.eq([])).not,
					'its.name.ne("foo").and(its.words.eq([])).not',
					Appscript.its.name.eq('foo').not.and(Appscript.its.words.eq([])).not],
			
			[@te.documents.beginning, @s+'.documents.beginning', nil],
			[@te.documents.end, @s+'.documents.end', nil],
			[@te.documents[3].before, @s+'.documents[3].before', nil],
			[@te.documents['foo'].after, @s+'.documents["foo"].after', nil],
			
		].each do |val, res, unpacked_version|
			assert_equal(res, val.to_s)
			d = @te.AS_app_data.pack(val)
			val = unpacked_version ? unpacked_version : val
			val2 = @te.AS_app_data.unpack(d)
			if val.class == @te.AS_app_data.unpack(d).class # note: Appscript::Reference and Appscript::GenericReference currently aren't comparable with each other, so the next test would always fail for those
				assert_equal(val, val2)
				assert_block { val.eql?(val2) }
			end
		end
	end
end

