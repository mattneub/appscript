require "rubygems"

spec = Gem::Specification.new do |s|
	s.name = "rb-appscript"
	s.version = "0.6.1"
	s.homepage = "http://appscript.sourceforge.net/"
	s.summary="Ruby appscript (rb-appscript) is a high-level, user-friendly Apple event bridge that allows you to control scriptable Mac OS X applications using ordinary Ruby scripts."
	s.files = Dir["**/*"].delete_if { |name| ["MakeFile", "ae.bundle", "mkmf.log", "rbae.o", "SendThreadSafe.o", "src/osx_ruby.h", "src/osx_intern.h"].include?(name) }
	s.extensions = "extconf.rb"
	s.test_files = Dir["test/test_*.rb"]
#	s.platform = Gem::Platform::CURRENT
	s.required_ruby_version = ">= 1.8"
end


if $0==__FILE__
	Gem::manage_gems
	Gem::Builder.new(spec).build
end
