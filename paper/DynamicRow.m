#import "DynamicRow.h"

@implementation DynamicRow


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setBorderWidth:[NSNumber numberWithInt:2]];
        [self setColorAttributes:[NSColor cyanColor]];
    }
    
    return self;
}


- (void)setBoundRect:(NSRect)rt
{
	[super setBoundRect:rt];
}


-(void)setBorderRadius:(NSNumber *)radius
{
    [super setBorderRadius:radius];
    [super postNotificationToRedraw];
    
}

-(void)setBorderWidth:(NSNumber *)width
{
    [super setBorderWidth:width];
    [super postNotificationToRedraw];
    
}

-(void)setTopLeftBorderRadius:(BOOL)radius
{
    [super setTopLeftBorderRadius:radius];
    [super postNotificationToRedraw];
}

-(void)setTopRightBorderRadius:(BOOL)radius
{
    [super setTopRightBorderRadius:radius];
    [super postNotificationToRedraw];
}

-(void)setBottomLeftBorderRadius:(BOOL)toggle
{
    [super setBottomLeftBorderRadius:toggle];
    [super postNotificationToRedraw];
}

-(void)setBottomRightBorderRadius:(BOOL)radius
{
    [super setBottomRightBorderRadius:radius];
    [super postNotificationToRedraw];
}


- (void)DrawShape:(CGContextRef)context
{
    [super DrawShape:context];
    
}

- (NSInteger)IsPointInElement:(NSPoint)pt
{
	return SHT_NONE;
}


- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *tvarNSGraphicsContext = [NSGraphicsContext currentContext];
	CGContextRef ctx = (CGContextRef) [tvarNSGraphicsContext graphicsPort];
    [self DrawShape:ctx];
}




@end
