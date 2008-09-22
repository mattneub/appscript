# Copyright (C) 2008 HAS. 
# Released under MIT License.

######################################################################
# TERMINOLOGY
######################################################################

module MRATerminology

	framework 'Appscript'
	
	require "_appscript/defaultterminology" # default type, enum, property, element, command definitions
	require "_appscript/reservedkeywords" # names of all existing methods on MRAReference::Application
	
	class KeywordConverter
		LegalFirst = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_'
		LegalRest = LegalFirst + '0123456789'
		@@_reserved_keywords = {} # ersatz set
		MRAReservedKeywords.each { |name| @@_reserved_keywords[name] = nil }
				
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
	
	def MRATerminology.build_default_terms
		classes = []
		enumerators = []
		properties = []
		elements = []
		commands = []
		
		[[MRADefaultTerminology::Types, classes],
			[MRADefaultTerminology::Enumerators, enumerators],
			[MRADefaultTerminology::Properties, properties],
			[MRADefaultTerminology::Elements, elements],
		].each do |data, res|
			data.each do |code, name|
				res << ASParserDef.alloc.initWithName(name.to_s, code: code.unpack('N')[0])
			end
		end
		
		MRADefaultTerminology::Commands.each do |name, data|
			event_class = data[0][0, 4]
			event_id = data[0][4, 4]
			commands << (res = ASParserCommandDef.alloc.initWithName(name.to_s, 
					eventClass: event_class.unpack('N')[0], eventID: event_id.unpack('N')[0]))
			data[1].each do |pname, pcode|
				res.addParameter(ASParserDef.alloc.initWithName(pname.to_s, code: pcode.unpack('N')[0]))
			end
		end
#		p classes.collect { |o| o.fourCharCode }
		terms = ASTerminology.alloc.init
		terms.addClasses(classes, enumerators: enumerators, 
				properties: properties, elements: elements, 
				commands: commands)
#		p terms.typeByCodeTable.allKeys
		return terms
	end

end

