#import "TextInputField.h"

@implementation TextInputField
//I USE THIS CLASS

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setBorderWidth:[NSNumber numberWithInt:1]];
        self.colorAttributes = [NSColor colorWithCalibratedRed:1. green:1. blue:1. alpha:1.];
    }
    
    return self;
}

- (void)setBoundRect:(NSRect)rt
{
	rtFrame = CGRectStandardize(NSMakeRect(rt.origin.x, rt.origin.y, 210 , 20 ));
    //  4+4 for padding, 4+4 for inset
    //  NOTE  //
    //        //
    //   if you change any of the numbers above then the generation method needs to be modified accordingly.
    //        //
    
    [self setFrame:CGRectMake(rtFrame.origin.x - 2, rtFrame.origin.y - 2, rtFrame.size.width + 8, rtFrame.size.height + 8 )];
	[self setNeedsDisplay:YES];
}

- (void)DrawShape:(CGContextRef)context
{
    //CGFloat rectangleCornerRadius = [borderRadius floatValue];
    NSRect bRect = CGRectInset ([self bounds], 1, 1);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:bRect xRadius:3 yRadius:3];
	
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
			[self drawShadows:path direction:direction offX:x offY:y color:shadowColor opacity:shadowOpacity blur:blur];
		}
		
		CGColorRelease(shadowColor);
	}

	
    [[NSColor whiteColor] set];
    
    CGContextSetRGBStrokeColor( context, 0.0, 0.0, 0.0, 1.0 );
    
    CGContextSetRGBFillColor(
                             context, //Change to cd when BINGDING.
                             [colorAttributes redComponent],   //Red
                             [colorAttributes greenComponent], //Green
                             [colorAttributes blueComponent],  //Blue
                             [colorAttributes alphaComponent]  //Alpha value
                             
                             );// color parameter
    //CGContextFillRect(context, CGRectMake(2, 2, rtFrame.size.width, rtFrame.size.height));
    [path fill];
    [path setLineWidth:[borderWidth floatValue]];
    [[NSColor grayColor] set];
	
	if (self.isPtInElement == YES) { // highlight shape when the mouse is over the shape.
		[[NSColor colorWithCalibratedRed:0.34 green:0.4 blue:0.9 alpha:1.0] set];
		if ([borderWidth floatValue] == 0) {
			[path setLineWidth:1.0];
			[path stroke];
		}
	}
	
    if ( [borderWidth intValue] == 0)
    {
        //
    }
    else
    {
        [path stroke];
    }
    
    
	if (isSelected == YES)
    {
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
    NSGraphicsContext *tvarNSGraphicsContext = [NSGraphicsContext currentContext];
	CGContextRef context = (CGContextRef) [tvarNSGraphicsContext graphicsPort];
    
    [self DrawShape:context];
}


@end
