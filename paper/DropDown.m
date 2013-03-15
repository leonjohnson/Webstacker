#import "DropDown.h"

@implementation DropDown
@synthesize dataSource;

// Hard coded options in the DropDown go into

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.dataSource = [NSArray array];
    }
    
    return self;
}

- (void)setBoundRect:(NSRect)rt
{
    rtFrame = CGRectStandardize(rt);
    [self setFrame:CGRectMake(rtFrame.origin.x - 2, rtFrame.origin.y - 2, rtFrame.size.width + 8, rtFrame.size.height + 8)];
	[self setNeedsDisplay:YES];
}

- (void)drawElement:(CGContextRef)context
{
    //// General Declarations
    context = [[NSGraphicsContext currentContext] graphicsPort];
    
    //// Color Declarations
    NSColor* gradientColor = [NSColor colorWithCalibratedRed: 0.92 green: 0.92 blue: 0.92 alpha: 1];
    NSColor* gradientColor2 = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 1];
    NSColor* aColor = [NSColor colorWithCalibratedRed: 0.76 green: 0.76 blue: 0.76 alpha: 1];
    NSColor* arrowColor = [NSColor colorWithCalibratedRed: 0.27 green: 0.27 blue: 0.27 alpha: 1];
    NSColor* dropShadowColor = [NSColor colorWithCalibratedRed: 0.88 green: 0.88 blue: 0.88 alpha: 1];
    
    //// Gradient Declarations
    NSGradient* gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            gradientColor, 0.16,
                            [NSColor colorWithCalibratedRed: 0.96 green: 0.96 blue: 0.96 alpha: 1], 0.39,
                            gradientColor2, 0.58, nil];
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: dropShadowColor];
    [shadow setShadowOffset: NSMakeSize(0, -1)];
    [shadow setShadowBlurRadius: 3];
    
    //// Abstracted Graphic Attributes
    NSString* textContent = @"";
    
    
    //// Rounded Rectangle Drawing
    NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(1, 1, 216, 21) xRadius: 6 yRadius: 6];
    [NSGraphicsContext saveGraphicsState];
    [shadow set];
    CGContextBeginTransparencyLayer(context, NULL);
    [gradient drawInBezierPath: roundedRectanglePath angle: -90];
    CGContextEndTransparencyLayer(context);
    [NSGraphicsContext restoreGraphicsState];
    
    [aColor setStroke];
	
	if (self.isPtInElement == YES) { // highlight shape when the mouse is over the shape.
		[[NSColor colorWithCalibratedRed:0.34 green:0.4 blue:0.9 alpha:1.0] set];
	}
	
    [roundedRectanglePath setLineWidth: 1];
    [roundedRectanglePath stroke];
    
    
    //// Text Drawing
    NSRect textRect = NSMakeRect(11, 3, 62.5, 16);
    NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    [textStyle setAlignment: NSLeftTextAlignment];
    
    NSDictionary* textFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSFont fontWithName: @"LucidaGrande" size: 12], NSFontAttributeName,
                                        [NSColor blackColor], NSForegroundColorAttributeName,
                                        textStyle, NSParagraphStyleAttributeName, nil];
    
    [textContent drawInRect: textRect withAttributes: textFontAttributes];
    
    
    //// Bezier 2 Drawing
    NSBezierPath* bezier2Path = [NSBezierPath bezierPath];
    [bezier2Path moveToPoint: NSMakePoint(201.41, 4)];
    [bezier2Path curveToPoint: NSMakePoint(205, 9) controlPoint1: NSMakePoint(205.19, 9) controlPoint2: NSMakePoint(205, 9)];
    [bezier2Path lineToPoint: NSMakePoint(198, 9)];
    [bezier2Path lineToPoint: NSMakePoint(201.41, 4)];
    [arrowColor setFill];
    [bezier2Path fill];
    
    
    
    //// Bezier Drawing
    NSBezierPath* bezierPath = [NSBezierPath bezierPath];
    [bezierPath moveToPoint: NSMakePoint(201.71, 17)];
    [bezierPath curveToPoint: NSMakePoint(198, 12) controlPoint1: NSMakePoint(198, 12) controlPoint2: NSMakePoint(198, 12)];
    [bezierPath lineToPoint: NSMakePoint(205, 12)];
    [bezierPath lineToPoint: NSMakePoint(201.71, 17)];
    [arrowColor setFill];
    [bezierPath fill];
    
    

    
    

    
    if (isSelected == YES) {
		[self DrawBorderFrame:context];
	}
    

}

- (NSInteger)IsPointInElement:(NSPoint)pt
{
	NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(2, 2, rtFrame.size.width, rtFrame.size.height)];
	
	if ([path containsPoint:pt] == YES) {
		return SHT_PTINELEMENT;
	}
	
	return SHT_NONE;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSGraphicsContext *gc = [NSGraphicsContext currentContext];
	CGContextRef context = (CGContextRef) [gc graphicsPort];
    
    [self drawElement:context];
}

@end
