#import <Foundation/Foundation.h>
#import "Element.h"

@interface Singleton : NSObject
{
    NSNumber *__strong mynumber;
    Element *__strong currentElement;
    CGContextRef contextref;
    NSFont *__strong lastSelectedFont;
    
}

@property (strong, nonatomic) Element *currentElement;
@property (strong, nonatomic) NSNumber *mynumber;
@property (assign, nonatomic) CGContextRef contextref;
@property (strong, nonatomic) NSFont *lastSelectedFont;
@end
