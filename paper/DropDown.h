#import "Element.h"

@interface DropDown : Element
{
    NSArray *__strong dataSource;
}

- (void)setBoundRect:(NSRect)rt;
- (void)drawElement:(CGContextRef)context;

@property (nonatomic, strong) NSArray *dataSource;
@end
