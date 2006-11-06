#!/usr/local/bin/ruby
# Copyright (C) 2006 HAS. 
# Released under MIT License.

require "_aem/codecs"

module MacUnit
	
	class UnitBase
		private_class_method :new
		attr_reader :desc, :units
	
		def initialize(val, type, units, unitName)
			@desc = DefaultCodecs.pack(val).coerce(type)
			@units = units
			@unitName = unitName
		end
	
		def to_i
			return DefaultCodecs.unpack(@desc.coerce(KAE::TypeInteger))
		end
		
		def to_f
			return DefaultCodecs.unpack(@desc.coerce(KAE::TypeFloat))
		end
		
		def to_s
			return "#{to_f} #{@unitName}"
		end
		
		def inspect
			return "#{self.class.name}.#{@units}(#{to_f})"
		end
	end
	
	#######
	
	class Length < UnitBase
	
		def Length.centimeters(val)
			return new(val, KAE::TypeCentimeters, :centimeters, 'centimeters')
		end
	
		def Length.meters(val)
			return new(val, KAE::TypeMeters, :meters, 'meters')
		end
	
		def Length.kilometers(val)
			return new(val, KAE::TypeKilometers, :kilometers, 'kilometers')
		end
	
		def Length.inches(val)
			return new(val, KAE::TypeInches, :inches, 'inches')
		end
	
		def Length.feet(val)
			return new(val, KAE::TypeFeet, :feet, 'feet')
		end
	
		def Length.yards(val)
			return new(val, KAE::TypeYards, :yards, 'yards')
		end
	
		def Length.miles(val)
			return new(val, KAE::TypeMiles, :miles, 'miles')
		end
	
		def centimeters
			return Length.centimeters(@desc)
		end
	
		def meters
			return Length.meters(@desc)
		end
	
		def kilometers
			return Length.kilometers(@desc)
		end
	
		def inches
			return Length.inches(@desc)
		end
	
		def feet
			return Length.feet(@desc)
		end
	
		def yards
			return Length.yards(@desc)
		end
	
		def miles
			return Length.miles(@desc)
		end
	
	end
	
	##
	
	class Area < UnitBase
	
		def Area.meters(val)
			return new(val, KAE::TypeSquareMeters, :meters, 'square meters')
		end
	
		def Area.kilometers(val)
			return new(val, KAE::TypeSquareKilometers, :kilometers, 'square kilometers')
		end
	
		def Area.feet(val)
			return new(val, KAE::TypeSquareFeet, :feet, 'square foot', 'square feet')
		end
	
		def Area.yards(val)
			return new(val, KAE::TypeSquareYards, :yards, 'square yards')
		end
	
		def Area.miles(val)
			return new(val, KAE::TypeSquareMiles, :miles, 'square miles')
		end
	
		def meters
			return Area.meters(@desc)
		end
	
		def kilometers
			return Area.kilometers(@desc)
		end
	
		def feet
			return Area.feet(@desc)
		end
	
		def yards
			return Area.yards(@desc)
		end
	
		def miles
			return Area.miles(@desc)
		end
		
	end
	
	##
	
	class CubicVolume < UnitBase
	
		def CubicVolume.centimeters(val)
			return new(val, KAE::TypeCubicCentimeter, :centimeters, 'cubic centimeters')
		end
	
		def CubicVolume.meters(val)
			return new(val, KAE::TypeCubicMeters, :meters, 'cubic meters')
		end
	
		def CubicVolume.inches(val)
			return new(val, KAE::TypeCubicInches, :inches, 'cubic inches')
		end
	
		def CubicVolume.feet(val)
			return new(val, KAE::TypeCubicFeet, :feet, 'cubic feet')
		end
	
		def CubicVolume.yards(val)
			return new(val, KAE::TypeCubicYards, :yards, 'cubic yards')
		end
	
		def centimeters
			return CubicVolume.centimeters(@desc)
		end
	
		def meters
			return CubicVolume.meters(@desc)
		end
	
		def inches
			return CubicVolume.inches(@desc)
		end
	
		def feet
			return CubicVolume.feet(@desc)
		end
	
		def yards
			return CubicVolume.yards(@desc)
		end
	
	end
	
	##
	
	class LiquidVolume < UnitBase
	
		def LiquidVolume.liters(val)
			return new(val, KAE::TypeLiters, :liters, 'liters')
		end
	
		def LiquidVolume.quarts(val)
			return new(val, KAE::TypeQuarts, :quarts, 'quarts')
		end
	
		def LiquidVolume.gallons(val)
			return new(val, KAE::TypeGallons, :gallons, 'gallons')
		end
	
		def liters
			return LiquidVolume.liters(@desc)
		end
	
		def quarts
			return LiquidVolume.quarts(@desc)
		end
	
		def gallons
			return LiquidVolume.gallons(@desc)
		end
		
	end
	
	##
	
	class Weight < UnitBase
	
		def Weight.grams(val)
			return new(val, KAE::TypeGrams, :grams, 'grams')
		end
	
		def Weight.kilograms(val)
			return new(val, KAE::TypeKilograms, :kilograms, 'kilograms')
		end
	
		def Weight.ounces(val)
			return new(val, KAE::TypeOunces, :ounces, 'ounces')
		end
	
		def Weight.pounds(val)
			return new(val, KAE::TypePounds, :pounds, 'pounds')
		end
	
		def grams
			return Weight.grams(@desc)
		end
	
		def kilograms
			return Weight.kilograms(@desc)
		end
	
		def ounces
			return Weight.ounces(@desc)
		end
	
		def pounds
			return Weight.pounds(@desc)
		end
	end
	
	##
	
	class Temperature < UnitBase
	
		def Temperature.celsius(val)
			return new(val, KAE::TypeDegreesC, :celsius, 'Celsius')
		end
	
		def Temperature.fahrenheit(val)
			return new(val, KAE::TypeDegreesF, :fahrenheit, 'Fahrenheit')
		end
		
		def Temperature.kelvin(val)
			return new(val, KAE::TypeDegreesK, :kelvin, 'Kelvin')
		end
		
		def celsius
			return Temperature.celsius(@desc)
		end
		
		def fahrenheit
			return Temperature.fahrenheit(@desc)
		end
		
		def kelvin
			return Temperature.kelvin(@desc)
		end
	end
	
end

