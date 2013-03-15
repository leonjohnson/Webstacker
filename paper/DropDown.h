#import "Element.h"

@interface DropDown : Element
{
    NSArray *dataSource;
}

- (void)setBoundRect:(NSRect)rt;
- (void)drawElement:(CGContextRef)context;

@property (nonatomic, assign) NSArray *dataSource;
@end
