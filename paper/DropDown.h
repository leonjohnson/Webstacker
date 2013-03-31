#import "Element.h"

@interface DropDown : Element
{
    NSArray *dataSource;
}

- (void)setBoundRect:(NSRect)rt;
- (void)drawElement:(CGContextRef)context;

@property (nonatomic, assign) NSArray *dataSource;

- (void)drawShadows:(NSBezierPath *)path direction:(BOOL)direction offX:(CGFloat)x offY:(CGFloat)y color:(CGColorRef)shadowColor opacity:(CGFloat)shadowOpacity blur:(CGFloat)blur;

@end
