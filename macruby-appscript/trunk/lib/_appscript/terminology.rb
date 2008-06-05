# Copyright (C) 2008 HAS. 
# Released under MIT License.

######################################################################
# TERMINOLOGY
######################################################################

module ASTerminology

	framework 'Appscript'
	
	require "_appscript/defaultterminology" # default type, enum, property, element, command definitions
	require "_appscript/reservedkeywords" # names of all existing methods on ASReference::Application
	
	class KeywordConverter
		LegalFirst = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'
		LegalRest = LegalFirst + '0123456789'
		@@_reserved_keywords = {} # ersatz set
		AReservedKeywords.each { |name| @@_reserved_keywords[name] = nil }
				
		def convert(s)
			legal = LegalFirst
			res = ''
			s.to_s.split(//).each do |c|
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
			return s.to_s + '_'
		end
	end
	
	def ASTerminology.build_default_terms
		classes = []
		enumerators = []
		properties = []
		elements = []
		commands = []
		
		[[ASDefaultTerminology::Types, classes],
			[ASDefaultTerminology::Enumerators, enumerators],
			[ASDefaultTerminology::Properties, properties],
			[ASDefaultTerminology::Elements, elements],
		].each do |data, res|
			data.each do |code, name|
				res << ASParserDef.alloc.initWithName_code_(name.to_s, code.unpack('N')[0])
			end
		end
		
		ASDefaultTerminology::Commands.each do |name, data|
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

