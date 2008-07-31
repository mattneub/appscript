//
//  formatter.m
//  appscript
//
//   Copyright (C) 2007-2008 HAS
//

#import "objectrenderer.h"


@implementation AEMObjectRenderer

+(NSString *)formatOSType:(OSType)code {
	NSMutableString *str;
	char c;
	int i;
	
	code = CFSwapInt32HostToBig(code);
	str = [NSMutableString stringWithCapacity: 16];
	for (i = 0; i < sizeof(code); i++) {
		c = ((char*)(&code))[i];
		if (c < 32 || c > 126 || c == '\\' || c == '\'')
			[str appendFormat: @"\\x%02x", c];
		else
			[str appendFormat: @"%c", c];
	}
	return str;
}



+(void)formatObject:(id)obj indent:(NSString *)indent result:(NSMutableString *)result {
	NSEnumerator *n;
	id obj2, obj3;
	NSMutableString *tmp;
	NSString *nextIndent = [NSString stringWithFormat: @"\t%@", indent];
	NSNumber *num;
	
	[result appendString: indent];
		
	if ([obj isKindOfClass: [NSArray class]]) {
		n = [(NSArray *)obj objectEnumerator];
		[result appendString: @"[NSArray arrayWithObjects:\n"];
		while (obj2 = [n nextObject]) {
			[self formatObject: obj2 indent: nextIndent result: result];
			[result appendString: @",\n"];
		}
		[result appendFormat: @"%@nil\n%@]", nextIndent, indent];
		
	} else if ([obj isKindOfClass: [NSDictionary class]]) {
		n = [(NSDictionary *)obj keyEnumerator];
		[result appendString: @"[NSDictionary dictionaryWithObjectsAndKeys:\n"];
		while (obj2 = [n nextObject]) {
			obj3 = [(NSDictionary *)obj objectForKey: obj2];
			[self formatObject: obj3 indent: nextIndent result: result];
			[result appendString: @", "];
			[self formatObject: obj2 indent: @"" result: result];
			[result appendString: @",\n"];
		}
		[result appendFormat: @"%@nil\n%@]", nextIndent, indent];
		
	} else if ([obj isKindOfClass: [NSString class]]) {
		tmp = [[NSMutableString alloc] initWithString: (NSString *)obj];
		[tmp replaceOccurrencesOfString: @"\\" withString: @"\\\\" options: 0 range: NSMakeRange(0, [tmp length])];
		[tmp replaceOccurrencesOfString: @"\"" withString: @"\\\"" options: 0 range: NSMakeRange(0, [tmp length])];
		[tmp replaceOccurrencesOfString: @"\r" withString: @"\\r" options: 0 range: NSMakeRange(0, [tmp length])];
		[tmp replaceOccurrencesOfString: @"\n" withString: @"\\n" options: 0 range: NSMakeRange(0, [tmp length])];
		[tmp replaceOccurrencesOfString: @"\t" withString: @"\\t" options: 0 range: NSMakeRange(0, [tmp length])];
		[result appendFormat: @"@\"%@\"", tmp];
		[tmp release];
	
	} else if ([obj isKindOfClass: [NSNumber class]]) {
		num = (NSNumber *)obj;
		switch (*[num objCType]) {
			case 'b':
			case 'c':
			case 'C':
			case 's':
			case 'S':
			case 'i':
			case 'l':
				[result appendFormat: @"[NSNumber numberWithInt: %@]", num];
				break;
			case 'I':
			case 'L':
				[result appendFormat: @"[NSNumber numberWithUnsignedInt: %@]", num];
				break;
			case 'q':
				[result appendFormat: @"[NSNumber numberWithLongLong: %@]", num];
				break;
			case 'Q':
				[result appendFormat: @"[NSNumber numberWithUnsignedLongLong: %@]", num];
				break;
			default: // f, d
				[result appendFormat: @"[NSNumber numberWithDouble: %@]", num];
		}
		
	} else if ([obj isKindOfClass: [NSDate class]]) {
		[result appendString: @"[NSDate dateWithString: "];
		[self formatObject: [obj description] indent: @"" result: result];
		[result appendString: @"]"];
		
	} else if ([obj isKindOfClass: [NSURL class]]) {
		[result appendString: @"[NSURL URLWithString: "];
		[self formatObject: [obj description] indent: @"" result: result];
		[result appendString: @"]"];
	
	} else
		[result appendFormat: @"%@", obj];
}


+(NSString *)formatObject:(id)obj {
	NSString *result;
	NSMutableString *collector = [[NSMutableString alloc] init];
	[self formatObject: obj indent: @"" result: collector];
	result = [NSString stringWithString: collector];
	[collector release];
	return result;
}


@end
