#import "NSColor+colorToHex.h"

@implementation NSColor (colorToHex)

+ (NSColor *) colorWithHex:(NSString *)hexColor {
    
    // Remove the hash if it exists
    hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    int length = (int)[hexColor length];
    bool triple = (length == 3);
    
    NSMutableArray *rgb = [[NSMutableArray alloc] init];
    
    // Make sure the string is three or six characters long
    if (triple || length == 6) {
        
        CFIndex i = 0;
        UniChar character = 0;
        NSString *segment = @"";
        CFStringInlineBuffer buffer;
        CFStringInitInlineBuffer((CFStringRef)hexColor, &buffer, CFRangeMake(0, length));
        
        
        while ((character = CFStringGetCharacterFromInlineBuffer(&buffer, i)) != 0 ) {
            if (triple) segment = [segment stringByAppendingFormat:@"%c%c", character, character];
            else segment = [segment stringByAppendingFormat:@"%c", character];
            
            if ((int)[segment length] == 2) {
                NSScanner *scanner = [[NSScanner alloc] initWithString:segment];
                
                unsigned number;
                
                while([scanner scanHexInt:&number]){
                    [rgb addObject:[NSNumber numberWithFloat:(float)(number / (float)255)]];
                }
                segment = @"";
            }
            
            i++;
        }
        
        // Pad the array out (for cases where we're given invalid input)
        while ([rgb count] != 3) [rgb addObject:[NSNumber numberWithFloat:0.0]];
        
        return [NSColor colorWithCalibratedRed:[[rgb objectAtIndex:0] floatValue] 
                                         green:[[rgb objectAtIndex:1] floatValue] 
                                          blue:[[rgb objectAtIndex:2] floatValue] 
                                         alpha:1];
    }
    else {
        NSException* invalidHexException = [NSException exceptionWithName:@"InvalidHexException"
                                                                   reason:@"Hex color not three or six characters excluding hash"                                    
                                                                 userInfo:nil];
        @throw invalidHexException;
        
    }
    
}

- (NSString *) hexColor {
    // Rewritten according to http://developer.apple.com/library/mac/#qa/qa1576/_index.html
    CGFloat redFloatValue, greenFloatValue, blueFloatValue;
    int redIntValue, greenIntValue, blueIntValue;
    NSString *redHexValue, *greenHexValue, *blueHexValue;

    // Convert the colour to RGB before accessing it's components
    NSColor *convertedColour = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];

    if (!convertedColour) {
        // Couldn't convert the colour.
        return nil;
    }

    [convertedColour getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:NULL];

    // Convert the components to numbers between 0 and 155
    redIntValue = redFloatValue * 255.99999f;
    greenIntValue = greenFloatValue * 255.99999f;
    blueIntValue = blueFloatValue * 255.99999f;

    // Convert the numbers to their hexadecimal reperesentation
    NSString *hexFormatString = @"%02x";
    redHexValue = [NSString stringWithFormat:hexFormatString , redIntValue];
    greenHexValue = [NSString stringWithFormat:hexFormatString, greenIntValue];
    blueHexValue = [NSString stringWithFormat:hexFormatString, blueIntValue];

    return [NSString stringWithFormat:@"#%@%@%@", redHexValue, greenHexValue, blueHexValue];
}


- (NSColor *)colorWithHexString:(NSString *)hexString {
    
	/* convert the string into a int */
	unsigned int colorValueR,colorValueG,colorValueB,colorValueA;
	NSString *hexStringCleared = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
	if(hexStringCleared.length == 3) {
		/* short color form */
		/* im lazy, maybe you have a better idea to convert from #fff to #ffffff */
		hexStringCleared = [NSString stringWithFormat:@"%@%@%@%@%@%@", [hexStringCleared substringWithRange:NSMakeRange(0, 1)],[hexStringCleared substringWithRange:NSMakeRange(0, 1)],
                            [hexStringCleared substringWithRange:NSMakeRange(1, 1)],[hexStringCleared substringWithRange:NSMakeRange(1, 1)],
                            [hexStringCleared substringWithRange:NSMakeRange(2, 1)],[hexStringCleared substringWithRange:NSMakeRange(2, 1)]];
	}
	if(hexStringCleared.length == 6) {
		hexStringCleared = [hexStringCleared stringByAppendingString:@"ff"];
	}
    
	/* im in hurry ;) */
	NSString *red = [hexStringCleared substringWithRange:NSMakeRange(0, 2)];
	NSString *green = [hexStringCleared substringWithRange:NSMakeRange(2, 2)];
	NSString *blue = [hexStringCleared substringWithRange:NSMakeRange(4, 2)];
	NSString *alpha = [hexStringCleared substringWithRange:NSMakeRange(6, 2)];
    
	[[NSScanner scannerWithString:red] scanHexInt:&colorValueR];
	[[NSScanner scannerWithString:green] scanHexInt:&colorValueG];
	[[NSScanner scannerWithString:blue] scanHexInt:&colorValueB];
	[[NSScanner scannerWithString:alpha] scanHexInt:&colorValueA];
    
    
	return [NSColor colorWithCalibratedRed:((colorValueR)&0xFF)/255.0
                                     green:((colorValueG)&0xFF)/255.0
                                      blue:((colorValueB)&0xFF)/255.0
                                     alpha:((colorValueA)&0xFF)/255.0];
    
    
}
@end
