#import <AppKit/AppKit.h>

@interface NSColor (colorToHex)

+ (NSColor *) colorWithHex:(NSString *)hexColor;    //pass in a hex and I give you an NSColor
- (NSString *) hexColor;                            //Turn an NSColor to a hex
-(NSColor *)colorWithHexString:(NSString *)hexString;
@end

