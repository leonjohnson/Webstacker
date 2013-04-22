//
//  NSString+shortcuts.h
//  designer
//
//  Created by Leon Johnson on 09/02/2013.
//
//

#import <Foundation/Foundation.h>

@interface NSString (shortcuts)
- (BOOL) containsString: (NSString*) substring;
- (NSDictionary*) standardFontAttributes;
- (NSFont*) standardFont;
- (NSSize) sizeOfStandardString;
- (NSSize) sizeOfString: (NSDictionary*)withAttributes;
- (NSString*) camelCase;
@end
