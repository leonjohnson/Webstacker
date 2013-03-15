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
