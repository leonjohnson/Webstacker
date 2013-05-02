#import "Box.h"

@implementation Box

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setBorderWidth:[NSNumber numberWithInt:0]];
        [self setColorAttributes:[NSColor colorWithCalibratedRed: 0.975 green: 0.975 blue: 0.975 alpha: 1]];
        [self setBorderRadius:[NSNumber numberWithInt:4]];
        self.bottomRightBorderRadius = self.bottomLeftBorderRadius = self.topLeftBorderRadius = self.topRightBorderRadius = YES;
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





- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *tvarNSGraphicsContext = [NSGraphicsContext currentContext];
	CGContextRef ctx = (CGContextRef) [tvarNSGraphicsContext graphicsPort];
    [self DrawShape:ctx];
    
    NSLog(@"is selected : %i", isSelected);
}


@end
