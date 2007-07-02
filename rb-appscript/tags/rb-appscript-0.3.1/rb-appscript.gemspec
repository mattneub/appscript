require "rubygems"

spec = Gem::Specification.new do |s|
	s.name = "rb-appscript"
	s.version = "0.3.1"
	s.author = "HAS"
	s.homepage = "http://rb-appscript.rubyforge.org/"
	s.rubyforge_project="rb-appscript"
	s.summary="Ruby appscript (rb-appscript) is a high-level, user-friendly Apple event bridge that allows you to control scriptable Mac OS X applications using ordinary Ruby scripts."
	s.files = Dir["**/*"].delete_if { |name| ["MakeFile", "ae.bundle", "mkmf.log", "rbae.o", "src/osx_ruby.h", "src/osx_intern.h"].include?(name) }
	s.extensions = "extconf.rb"
	s.test_files = Dir["test/test_*.rb"]
	s.required_ruby_version = ">= 1.8"
end


if $0==__FILE__
	Gem::manage_gems
	Gem::Builder.new(spec).build
end
