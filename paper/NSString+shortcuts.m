//
//  NSString+shortcuts.m
//  designer
//
//  Created by Leon Johnson on 09/02/2013.
//
//

#import "NSString+shortcuts.h"

@implementation NSString (shortcuts)

- (BOOL) containsString: (NSString*) substring
{
    NSLog(@"string received is : %@", substring);
    NSRange range = [self rangeOfString:substring options:NSCaseInsensitiveSearch];
    BOOL found = ( range.location != NSNotFound );
    return found;
}



- (NSSize) sizeOfString: (NSDictionary*)withAttributes
{
    NSSize sizeOfTextBox = [self sizeWithAttributes:withAttributes];
    return sizeOfTextBox;
}



- (NSSize) sizeOfStandardString
{
    NSSize sizeOfTextBox = [self sizeWithAttributes:[self standardFontAttributes]];
    return sizeOfTextBox;
}



- (NSDictionary*) standardFontAttributes
{
    NSDictionary* text2FontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSFont fontWithName: @"Helvetica Neue" size: 12], NSFontAttributeName,
                                         [NSColor blackColor], NSForegroundColorAttributeName, nil];
    return text2FontAttributes;
}


- (NSFont*) standardFont
{
    NSFont *font = [NSFont fontWithName: @"Helvetica Neue" size: 12];
    return font;
}


-(NSString*)camelCase
{
    [self lowercaseStringWithLocale:[NSLocale currentLocale]];
    return self;
    
}
@end