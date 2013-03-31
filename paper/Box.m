#import "Box.h"

@implementation Box

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setBorderWidth:[NSNumber numberWithInt:0]];
        [self setColorAttributes:[NSColor cyanColor]];
    }
    
    return self;
}


- (void)setBoundRect:(NSRect)rt
{
	rtFrame = CGRectStandardize(rt);
    [self setFrame:CGRectMake(rtFrame.origin.x - 2, rtFrame.origin.y - 2, rtFrame.size.width + 8, rtFrame.size.height + 8)];
	[self setNeedsDisplay:YES];
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
    /*
     CGContextSaveGState(context);
     
     CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 1.0);
     CGContextFillRect(context, rtFrame);
     
     CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
     
     
     //CGContextSetRGBFillColor(context, 0.482, 0.62, 0.871, 1.0);
     //CGContextSetLineWidth(context, 13.0);
     //CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
     //CGContextDrawPath(context, kCGPathFillStroke);
     
     
     SPECIAL
     CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
     CGContextSetLineWidth(context, [[[border objectForKey:@"all"] objectForKey:@"width"] floatValue]);
     CGContextStrokeRect(context, rtFrame);
     
     
     CGContextRestoreGState(context);
     
     if (isSelected == YES) 
     {
     NSLog(@"I'm selecetd");
     [self DrawBorderFrame:context];
     }
     [self setNeedsDisplay:YES];
     
     
     */
    
    //  Other option is to bind each checkbox to an individal ivar and call one method whenever a button is clicked.
    /*
     NSLog(@"top left : %i", topLeftBorderRadius);
     NSLog(@"top right : %i", topRightBorderRadius);
     NSLog(@"bottom left : %i", bottomLeftBorderRadius);
     NSLog(@"bottom right : %i", bottomRightBorderRadius);
     */    
    CGFloat rectangleCornerRadius = [borderRadius floatValue];        
    NSRect rectangleFrame = NSMakeRect(2, 2, rtFrame.size.width, rtFrame.size.height);
    
    // rounded edges
    NSRect rectangleInnerRect = NSInsetRect(rectangleFrame, rectangleCornerRadius, rectangleCornerRadius);
    NSBezierPath *rectanglePath = [NSBezierPath bezierPath];
    if (topLeftBorderRadius == NO & topRightBorderRadius == NO & bottomLeftBorderRadius == NO & bottomRightBorderRadius == NO) 
    {
        rectanglePath = [NSBezierPath bezierPathWithRect:rectangleFrame];
    }
    else
    {
        //top-left
        if (topLeftBorderRadius) 
        {
            [rectanglePath appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rectangleInnerRect), NSMinY(rectangleInnerRect)) radius: rectangleCornerRadius startAngle:180 endAngle:270];
        }
        else
        {
            [rectanglePath moveToPoint:NSMakePoint(NSMinX(rectangleFrame), NSMinY(rectangleFrame))];
        }
        
        
        //top-right
        if (topRightBorderRadius) 
        {
            [rectanglePath appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rectangleInnerRect), NSMinY(rectangleInnerRect)) radius: rectangleCornerRadius startAngle:270 endAngle:360];
        }
        else
        {
            [rectanglePath lineToPoint:NSMakePoint(NSMaxX(rectangleFrame), NSMinY(rectangleFrame))];
        }
        
        
        //bottom right
        if (bottomRightBorderRadius) 
        {
            [rectanglePath appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rectangleInnerRect), NSMaxY(rectangleInnerRect)) radius:rectangleCornerRadius startAngle:0 endAngle:90];
        }
        else
        {
            [rectanglePath lineToPoint:NSMakePoint(NSMaxX(rectangleFrame), NSMaxY(rectangleFrame))];
        }
        
        
        //bottom left
        if (bottomLeftBorderRadius) 
        {
            [rectanglePath appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rectangleInnerRect), NSMaxY(rectangleInnerRect)) radius:rectangleCornerRadius startAngle:90 endAngle:180];
        }
        else
        {
            [rectanglePath lineToPoint:NSMakePoint(NSMinX(rectangleFrame), NSMaxY(rectangleFrame))];
        }
        
        [rectanglePath closePath];
    }
    
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
			[self drawShadows:rectanglePath direction:direction offX:x offY:y color:shadowColor opacity:shadowOpacity blur:blur];
		}
		
		CGColorRelease(shadowColor);
	}
    
    
	CGContextSetRGBStrokeColor( context, 0.0, 0.0, 0.0, 1.0 );
    
    CGContextSetRGBFillColor(
                             context, //Change to cd when BINGDING.
                             [colorAttributes redComponent],   //Red 
                             [colorAttributes greenComponent], //Green
                             [colorAttributes blueComponent],  //Blue
                             [colorAttributes alphaComponent]  //Alpha value
                             
                             );// color parameter
    //CGContextFillRect(context, CGRectMake(2, 2, rtFrame.size.width, rtFrame.size.height));
    [rectanglePath fill];
    [rectanglePath setLineWidth:[borderWidth floatValue]];
	
	if (self.isPtInElement == YES) { // highlight shape when the mouse is over the shape.
		[[NSColor colorWithCalibratedRed:0.34 green:0.4 blue:0.9 alpha:1.0] set];
		
		if ([borderWidth floatValue] == 0) {
			[rectanglePath setLineWidth:1.0f];
			[rectanglePath stroke];
		}
	}
	
    if ( [borderWidth intValue] == 0)
    {
        //
    }
    else
    {
        [rectanglePath stroke];
    }
    
	if (isSelected == YES) {
		[self DrawBorderFrame:context];
	}
}

- (NSInteger)IsPointInElement:(NSPoint)pt
{
	NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect: self.bounds];
	
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
	CGContextRef ctx = (CGContextRef) [tvarNSGraphicsContext graphicsPort];
    [self DrawShape:ctx];
}


@end
