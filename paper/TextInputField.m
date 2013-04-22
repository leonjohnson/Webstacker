#import "TextInputField.h"

@implementation TextInputField
//I USE THIS CLASS

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setBorderWidth:[NSNumber numberWithInt:1]];
        [self setColorAttributes: [NSColor colorWithCalibratedRed:1. green:1. blue:1. alpha:1.]];
        
    }
    
    return self;
}

- (void)setBoundRect:(NSRect)rt
{
	
    rtFrame = CGRectStandardize(NSMakeRect(rt.origin.x, rt.origin.y, rt.size.width, rt.size.height ));
    //  4+4 for padding, 4+4 for inset
    //  NOTE  //
    //        //
    //   if you change any of the numbers above then the generation method needs to be modified accordingly.
    //        //
    
    [self setFrame:CGRectMake(rtFrame.origin.x - 6, rtFrame.origin.y -6, rtFrame.size.width + 18, rtFrame.size.height +6 )];
	[self setNeedsDisplay:YES];
     
    
    //[super setBoundRect:rt];
}

- (void)DrawShape:(CGContextRef)context
{
    
    //NSRect rectangleFrame = NSMakeRect(2, 2, rtFrame.size.width, rtFrame.size.height);
    
    // rounded edges
    //NSRect rectangleInnerRect = NSInsetRect(rectangleFrame, rectangleCornerRadius, rectangleCornerRadius);
    
    //CGFloat rectangleCornerRadius = [borderRadius floatValue];
    //NSRect bRect = CGRectInset ([self bounds], 0, 0);
    NSRect bRect = NSMakeRect(6, 6, rtFrame.size.width-6, rtFrame.size.height-6);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:bRect xRadius:3 yRadius:3];
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





- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *tvarNSGraphicsContext = [NSGraphicsContext currentContext];
	CGContextRef context = (CGContextRef) [tvarNSGraphicsContext graphicsPort];
    
    [self DrawShape:context];
}


@end
