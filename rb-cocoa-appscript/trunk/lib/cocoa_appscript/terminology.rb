# Copyright (C) 2008 HAS. 
# Released under MIT License.

######################################################################
# TERMINOLOGY
######################################################################

module RCASTerminology

	require 'osx/cocoa'
	include OSX
	OSX.require_framework 'Appscript'
	
	require "cocoa_appscript/defaultterminology" # default type, enum, property, element, command definitions
	require "cocoa_appscript/reservedkeywords" # names of all existing methods on ASReference::Application
	
	class KeywordConverter
		LegalFirst = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'
		LegalRest = LegalFirst + '0123456789'
		@@_reserved_keywords = {} # ersatz set
		RCAReservedKeywords.each { |name| @@_reserved_keywords[name] = nil }
				
		def convert(s)
			legal = LegalFirst
			res = ''
			s.split(//).each do |c|
				if legal[c]
					res += c
				else
					case c
						when ' ', '-', '/'
							res += '_'
						when '&'
							res += 'and'
					else
						res = '_' if res == ''
						res += "0x#{c.unpack('HXh')}"
					end
				end
				legal = LegalRest
			end
			res += '_' if res[0, 3] == 'AS_' or @@_reserved_keywords.has_key?(res) or res[0, 1] == '_'
			return res
		end
		
		def escape(s)
			return s + '_'
		end
	end
	
	def RCASTerminology.build_default_terms
		classes = []
		enumerators = []
		properties = []
		elements = []
		commands = []
		
		[[RCASDefaultTerminology::Types, classes],
			[RCASDefaultTerminology::Enumerators, enumerators],
			[RCASDefaultTerminology::Properties, properties],
			[RCASDefaultTerminology::Elements, elements],
		].each do |data, res|
			data.each do |code, name|
				res << ASParserDef.alloc.initWithName_code_(name.to_s, code.unpack('N')[0])
			end
		end
		
		RCASDefaultTerminology::Commands.each do |name, data|
			event_class = data[0][0, 4]
			event_id = data[0][4, 4]
			commands << (res = ASParserCommandDef.alloc.initWithName_eventClass_eventID_(
					name.to_s, event_class.unpack('N')[0], event_id.unpack('N')[0]))
			data[1].each do |pname, pcode|
				res.addParameter_(ASParserDef.alloc.initWithName_code_(pname.to_s, pcode.unpack('N')[0]))
			end
		end
		
		terms = ASTerminology.alloc.init
		terms.addClasses_enumerators_properties_elements_commands_(
				classes, enumerators, properties, elements, commands)
		return terms
	end

end

