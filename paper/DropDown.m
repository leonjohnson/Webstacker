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
	
	
	// draw outer shadows first
	for (NSDictionary *dict in arrayShadows) {
		BOOL direction = [[dict valueForKey:@"Direction"] boolValue];
		//CGFloat angle = [[dict valueForKey:@"Angle"] floatValue];
		//CGFloat distance = [[dict valueForKey:@"Distance"] floatValue];
		CGFloat x = [[dict valueForKey:@"OffsetX"] floatValue];
		CGFloat y = [[dict valueForKey:@"OffsetY"] floatValue];
		CGFloat RColor = [[dict valueForKey:@"RColor"] floatValue];
		CGFloat GColor = [[dict valueForKey:@"GColor"] floatValue];
		CGFloat BColor = [[dict valueForKey:@"BColor"] floatValue];
		CGFloat shadowOpacity = [[dict valueForKey:@"Opacity"] floatValue];
		CGFloat blur = [[dict valueForKey:@"Blur"] floatValue];
		
		CGColorRef shadowColor = CGColorCreateGenericRGB(RColor, GColor, BColor, 1.0);
		
		if (direction == YES) {
			[self drawShadows:roundedRectanglePath direction:direction offX:x offY:y color:shadowColor opacity:shadowOpacity blur:blur];
		}
		
		CGColorRelease(shadowColor);
	}
	
	
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


/*
 @function:		drawShadows
 @params:		path:		shape's path to draw
 direction:	shadow direction. If it is YES, outer shadow. otherwise, inner shadow.
 x:			X offset of shadow
 y:			Y offset of shadow
 shadowColor:shadow color
 shadowOpacity:	shadow opacity
 blur:		shadow blur
 @return:		void
 @purpose:		Draw the shadow with path and params.
 */
- (void)drawShadows:(NSBezierPath *)path direction:(BOOL)direction offX:(CGFloat)x offY:(CGFloat)y color:(CGColorRef)shadowColor opacity:(CGFloat)shadowOpacity blur:(CGFloat)blur
{
	// create shadow and init with params
	NSShadow *shadow = [[NSShadow alloc] init];
	
	const CGFloat *components = CGColorGetComponents( shadowColor );
	[shadow setShadowColor:[NSColor colorWithCalibratedRed:components[0] green:components[1] blue:components[2] alpha:shadowOpacity]];
	[shadow setShadowOffset:NSMakeSize(x, y)];
	[shadow setShadowBlurRadius:blur];
	
	// draw shadow
	if (direction == NO) { // drawing inner shadow
		[NSGraphicsContext saveGraphicsState];
		
		[[NSColor whiteColor] setFill];
		[path fill];
		
		// Inner Shadow
		NSRect rectangleBorderRect = NSInsetRect([path bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
		rectangleBorderRect = NSOffsetRect(rectangleBorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
		rectangleBorderRect = NSInsetRect(NSUnionRect(rectangleBorderRect, [path bounds]), -1, -1);
		
		NSBezierPath* rectangleNegativePath = [NSBezierPath bezierPathWithRect: rectangleBorderRect];
		[rectangleNegativePath appendBezierPath:path];
		[rectangleNegativePath setWindingRule: NSEvenOddWindingRule];
		
		[NSGraphicsContext saveGraphicsState];
		{
			NSShadow* shadowWithOffset = [shadow copy];
			
			CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(rectangleBorderRect.size.width);
			CGFloat yOffset = shadowWithOffset.shadowOffset.height;
			
			shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
			[shadowWithOffset set];
			
			[[NSColor grayColor] setFill];
			[path addClip];
			
			NSAffineTransform* transform = [NSAffineTransform transform];
			[transform translateXBy: -round(rectangleBorderRect.size.width) yBy: 0];
			[[transform transformBezierPath: rectangleNegativePath] fill];
			
			[shadowWithOffset release];
		}
		[NSGraphicsContext restoreGraphicsState];
		
		[NSGraphicsContext restoreGraphicsState];
		
	} else { // drawing outer shadow
		
		[NSGraphicsContext saveGraphicsState];
		[shadow set];
		[[NSColor whiteColor] setFill];
		[path fill];
		[NSGraphicsContext restoreGraphicsState];
	}
	
	[shadow release];
}


- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSGraphicsContext *gc = [NSGraphicsContext currentContext];
	CGContextRef context = (CGContextRef) [gc graphicsPort];
    
    [self drawElement:context];
}

@end
