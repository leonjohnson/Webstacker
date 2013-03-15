#import <Foundation/Foundation.h>
#import "Element.h"


@interface Circle : Element
{
	
}


- (void)setBoundRect:(NSRect)rt;
- (void)DrawShape:(CGContextRef)context;

@end
