#import <Foundation/Foundation.h>
#import "Element.h"

@interface Singleton : NSObject
{
    NSNumber *mynumber;
    Element *currentElement;
    CGContextRef contextref;
    NSFont *lastSelectedFont;
    
}

@property (assign, nonatomic) Element *currentElement;
@property (assign, nonatomic) NSNumber *mynumber;
@property (assign, nonatomic) CGContextRef contextref;
@property (assign, nonatomic) NSFont *lastSelectedFont;
@end
