#!/usr/bin/ruby -w

begin; require 'rubygems'; rescue LoadError; end

require 'test/unit'
require 'appscript'

# rb-appscript 0.5.0+ should no longer require the following kludge:
#class AS_SafeObject
#	def self.hide(name)
#	end
#end

class TC_AppscriptNewApp < Test::Unit::TestCase

	def test_by_name
		[
				'/Applications/TextEdit.app',
				'Finder.app',
				'System Events'
		].each do |name|
			a = Appscript.app(name)
			assert_not_nil(a)
			assert_instance_of(Appscript::Application, a)
			assert_instance_of(Appscript::Reference, a.name)
		end
		assert_equal('app("/Applications/TextEdit.app")', Appscript.app('TextEdit').to_s)
		assert_equal('app("/Applications/TextEdit.app")', Appscript.app.by_name('TextEdit').to_s)
		
		assert_raises(Appscript::ApplicationNotFoundError) { Appscript.app('/non-existent/app') }
		assert_raises(Appscript::ApplicationNotFoundError) { Appscript.app('non-existent.app') }
	end
	
	def test_by_id
		[
				'com.apple.textedit',
				'com.apple.finder',
		].each do |name|
			a = Appscript.app.by_id(name)
			assert_not_nil(a)
			assert_instance_of(Appscript::Application, a)
			assert_instance_of(Appscript::Reference, a.name)
		end
		assert_equal('app("/Applications/TextEdit.app")', Appscript.app.by_id('com.apple.textedit').to_s)
		
		assert_raises(Appscript::ApplicationNotFoundError) { Appscript.app.by_id('non.existent.app') }
	end

	def test_by_creator
		a = Appscript.app.by_creator('ttxt')
		assert_instance_of(Appscript::Reference, a.name)
		assert_equal('app("/Applications/TextEdit.app")', a.to_s)
		assert_raises(Appscript::ApplicationNotFoundError) { Appscript.app.by_id('!@$o') }
	end
	
	def test_by_pid
		pid = `top -l1 | grep Finder | awk '{ print $1 }'`.to_i # note: this line will return a bad result if more than one user is logged in
		a = Appscript.app.by_pid(pid)
		assert_instance_of(Appscript::Reference, a.name)
		assert_equal("app.by_pid(#{pid})", a.to_s)
		assert_equal('Finder', a.name.get)
	end
	
	def test_by_aem_app
		a = Appscript.app.by_aem_app(AEM::Application.by_path('/Applications/TextEdit.app'))
		assert_instance_of(Appscript::Reference, a.name)
		assert_equal('app.by_aem_app(AEM::Application.by_path("/Applications/TextEdit.app"))', a.to_s)
	end
end


class TC_AppscriptCommands < Test::Unit::TestCase

	def setup
		@te = Appscript.app('TextEdit')
		@f = Appscript.app('Finder')
	end
	
	def test_commands_1
		assert_equal('TextEdit', @te.name.get)
		d = @te.make(:new=>:document, :with_properties=>{:text=>'test test_commands'})
		assert_instance_of(Appscript::Reference, d)
		d.text.end.make(:new=>:word, :with_data=>' test2')
		assert_equal('test test_commands test2', d.text.get)
		assert_instance_of(String, 
				d.text.get(:ignore=>[:diacriticals, :punctuation, :whitespace, :expansion], :timeout=>10))
		assert_nil(d.get(:wait_reply=>false))
		
		
		# test Ruby 1.9+ String Encoding support
		version, sub_version = RUBY_VERSION.split('.').collect {|n| n.to_i} [0, 2]
		if version >= 1 and sub_version >= 9
			
			print "(check Encoding support)"
			s = "\302\251 M. Lef\303\250vre"
			s.force_encoding('utf-8')
			d.text.set(s)
			assert_equal(s, d.text.get)
		
			@te.AS_app_data.use_ascii_8bit
		end
		
		d.text.set("\302\251 M. Lef\303\250vre")
		assert_equal("\302\251 M. Lef\303\250vre", d.text.get)
		
		d.close(:saving=>:no)
	end
	
	def test_commands_2
		d = @te.make(:new=>:document, :at=>@te.documents.end)
		
		@te.set(d.text, :to=> 'test1')
		assert_equal('test1', d.text.get)
		
		@te.set(d.text, :to=> 'test2')
		@te.make(:new=>:word, :at=>Appscript.app.documents[1].paragraphs.end, :with_data=>' test3')
		assert_equal('test2 test3', d.text.get)
		
		d.close(:saving=>:no)
		
		assert_raises(Appscript::CommandError) { @te.documents[10000].get }
		
		assert_instance_of(Fixnum, @te.documents.count)
		assert_equal(@te.documents.count, @te.count(:each=>:document))
	end
	
	def test_commands_3
		assert_equal('Finder', @f.name.get)
		val = @f.home.folders['Desktop'].get(:result_type=>:alias)
		assert_instance_of(MacTypes::Alias, val)
		assert_equal(val, @f.desktop.get(:result_type=>:alias))
		assert_instance_of(Array, @f.disks.get)
		
		r = @f.home.get
		f = r.get(:result_type=>:file_ref)
		assert_equal(r, @f.items[f].get)
		
		assert_equal(@f.home.items.get, @f.home.items.get)
		assert_not_equal(@f.disks['non-existent'], @f.disks[1].get)
	end
	
	def test_command_error
		begin
			@f.items[10000].get
		rescue Appscript::CommandError => e
			assert_equal(-1728, e.to_i)
			assert_equal("CommandError\n\t\tOSERROR: -1728\n\t\tMESSAGE: Can't get reference.\n\t\tOFFENDING OBJECT: app(\"/System/Library/CoreServices/Finder.app\").items[10000]\n\t\tCOMMAND: app(\"/System/Library/CoreServices/Finder.app\").items[10000].get()\n", e.to_s)
			assert_instance_of(AEM::EventError, e.real_error)
		end
	end
end

