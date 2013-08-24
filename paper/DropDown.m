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
    //rtFrame = CGRectStandardize(rt);
    //[self setFrame:CGRectMake(rtFrame.origin.x - 2, rtFrame.origin.y - 2, rtFrame.size.width + 8, rtFrame.size.height + 8)];
	//[self setNeedsDisplay:YES];
    
    [super setBoundRect:rt];
}

- (void)drawElement:(CGContextRef)context
{
    //// General Declarations
    context = [[NSGraphicsContext currentContext] graphicsPort];
    
    //// Color Declarations
    NSColor* fillColor = [NSColor colorWithCalibratedRed: 0.96 green: 0.961 blue: 0.96 alpha: 1];
    NSColor* strokeColor = [NSColor colorWithCalibratedRed: 0.8 green: 0.8 blue: 0.8 alpha: 1];
    NSColor* shadowColor2 = [NSColor colorWithCalibratedRed: 0.859 green: 0.859 blue: 0.859 alpha: 1];
    NSColor* gradientColor = [NSColor colorWithCalibratedRed: 0.755 green: 0.756 blue: 0.755 alpha: 1];
    NSColor* fillColor3 = [NSColor colorWithCalibratedRed: 0.264 green: 0.264 blue: 0.264 alpha: 1];
    
    //// Gradient Declarations
    NSGradient* topGradient = [[NSGradient alloc] initWithColorsAndLocations:
                               fillColor, 0.41,
                               [NSColor colorWithCalibratedRed: 0.91 green: 0.91 blue: 0.91 alpha: 1], 0.78,
                               shadowColor2, 1.0, nil];
    
    //// Shadow Declarations
    NSShadow* innerShadow = [[NSShadow alloc] init];
    [innerShadow setShadowColor: strokeColor];
    [innerShadow setShadowOffset: NSMakeSize(2.1, 0.1)];
    [innerShadow setShadowBlurRadius: 2];
    
    //// Rounded Rectangle Drawing
    NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(6, 6, 220, 28) xRadius: 3 yRadius: 3];
    [topGradient drawInBezierPath: roundedRectanglePath angle: 90];
    
    ////// Rounded Rectangle Inner Shadow
    NSRect roundedRectangleBorderRect = NSInsetRect([roundedRectanglePath bounds], -innerShadow.shadowBlurRadius, -innerShadow.shadowBlurRadius);
    roundedRectangleBorderRect = NSOffsetRect(roundedRectangleBorderRect, -innerShadow.shadowOffset.width, innerShadow.shadowOffset.height);
    roundedRectangleBorderRect = NSInsetRect(NSUnionRect(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
    
    NSBezierPath* roundedRectangleNegativePath = [NSBezierPath bezierPathWithRect: roundedRectangleBorderRect];
    [roundedRectangleNegativePath appendBezierPath: roundedRectanglePath];
    [roundedRectangleNegativePath setWindingRule: NSEvenOddWindingRule];
	
	if (self.isPtInElement == YES) { // highlight shape when the mouse is over the shape.
		[self.elementHighlightColor set];
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
    
    //[textContent drawInRect: textRect withAttributes: textFontAttributes];
    
    
    
    [NSGraphicsContext saveGraphicsState];
    {
        NSShadow* innerShadowWithOffset = [innerShadow copy];
        CGFloat xOffset = innerShadowWithOffset.shadowOffset.width + round(roundedRectangleBorderRect.size.width);
        CGFloat yOffset = innerShadowWithOffset.shadowOffset.height;
        innerShadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
        [innerShadowWithOffset set];
        [[NSColor grayColor] setFill];
        [roundedRectanglePath addClip];
        NSAffineTransform* transform = [NSAffineTransform transform];
        [transform translateXBy: -round(roundedRectangleBorderRect.size.width) yBy: 0];
        [[transform transformBezierPath: roundedRectangleNegativePath] fill];
    }
    [NSGraphicsContext restoreGraphicsState];
    
    
    [strokeColor setStroke];
    [roundedRectanglePath setLineWidth: 1.5];
    [roundedRectanglePath stroke];
    
    //// Bezier Drawing
    NSBezierPath* bezierPath = [NSBezierPath bezierPath];
    [bezierPath moveToPoint: NSMakePoint(206, 5.5)];
    [bezierPath lineToPoint: NSMakePoint(206, 33.5)];
    [strokeColor setStroke];
    [bezierPath setLineWidth: 1];
    [bezierPath stroke];
    
    
    //// Bezier 2 Drawing
    NSBezierPath* bezier2Path = [NSBezierPath bezierPath];
    [gradientColor setStroke];
    [bezier2Path setLineWidth: 1];
    [bezier2Path stroke];
    
    
    //// Bezier 3 Drawing
    NSBezierPath* bezier3Path = [NSBezierPath bezierPath];
    [bezier3Path moveToPoint: NSMakePoint(212.5, 18.5)];
    [bezier3Path lineToPoint: NSMakePoint(215.5, 12.5)];
    [bezier3Path lineToPoint: NSMakePoint(218.5, 18.5)];
    [bezier3Path lineToPoint: NSMakePoint(212.5, 18.5)];
    [bezier3Path closePath];
    [fillColor3 setFill];
    [bezier3Path fill];
    
    
    //// Bezier 4 Drawing
    NSBezierPath* bezier4Path = [NSBezierPath bezierPath];
    [bezier4Path moveToPoint: NSMakePoint(212.5, 20.5)];
    [bezier4Path lineToPoint: NSMakePoint(218.5, 20.5)];
    [bezier4Path lineToPoint: NSMakePoint(215.7, 26.5)];
    [bezier4Path lineToPoint: NSMakePoint(212.5, 20.5)];
    [bezier4Path closePath];
    [fillColor3 setFill];
    [bezier4Path fill];
    
    

    
    

    
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
