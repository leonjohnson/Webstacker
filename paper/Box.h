#import "Element.h"


@interface Box : Element
{

}


- (void)setBoundRect:(NSRect)rt;
- (void)DrawShape:(CGContextRef)context;


@end
