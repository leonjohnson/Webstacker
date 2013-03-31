#import "Element.h"


@interface Box : Element
{

}


- (void)setBoundRect:(NSRect)rt;
- (void)DrawShape:(CGContextRef)context;

- (void)drawShadows:(NSBezierPath *)path direction:(BOOL)direction offX:(CGFloat)x offY:(CGFloat)y color:(CGColorRef)shadowColor opacity:(CGFloat)shadowOpacity blur:(CGFloat)blur;

@end
