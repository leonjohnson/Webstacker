#import "Circle.h"
#import "Singleton.h"

@implementation Circle

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        /*Singleton *sg = [[Singleton alloc]init];
         //NSDictionary *newd = [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithFloat:1.0], @"red",
         [NSNumber numberWithFloat:0.0], @"green",
         [NSNumber numberWithFloat:0.0], @"blue",
         [NSNumber numberWithFloat:1.0], @"alpha",
         nil];
         //[[sg currentElement] setColorAttributes:newd];
         //color = newd;
         */
    }
    
    return self;
}


- (void)setBoundRect:(NSRect)rt
{
	rtFrame = CGRectStandardize(rt);
    [self setFrame:CGRectMake(rtFrame.origin.x - 2, rtFrame.origin.y - 2, rtFrame.size.width + 8, rtFrame.size.height + 8)];
	[self setNeedsDisplay:YES];
}



-(void)setColorAttributes:(id)sender
{
    [super setColorAttributes:sender];
    [super postNotificationToRedraw];
    
}



-(void)setBorderAttributes:(NSDictionary *)borderAttributes
{
    /*
     int thickness = [[borderAttributes objectForKey:@"thickness"] intValue];
     NSArray *color = [borderAttributes objectForKey:@"color"];
     NSString *type = [borderAttributes objectForKey:@"type"];
     */
}



/*
 @function:		DrawShape
 @params:		context:   Graphics context reference
 @return:       void
 @purpose:		Draw the circle in rtFrame rectangle area.
 */
- (void)DrawShape:(CGContextRef)context
{
    CGContextSetRGBFillColor(
                             context, //Change to cd when BINGDING.
                             [colorAttributes redComponent],   //Red 
                             [colorAttributes greenComponent], //Green
                             [colorAttributes blueComponent],  //Blue
                             [colorAttributes alphaComponent]  //Alpha value
                             
                             );// color parameter
    CGContextFillEllipseInRect(context, CGRectMake(2, 2, rtFrame.size.width, rtFrame.size.height));
    CGContextSetRGBStrokeColor( context, 0.0, 0.0, 0.0, 1.0 );
    CGContextSetLineWidth(context, [borderWidth floatValue]);
	CGContextStrokeEllipseInRect( context, CGRectMake(2, 2, rtFrame.size.width, rtFrame.size.height) );
	
	if (isSelected == YES) {
		[self DrawBorderFrame:context];
	}
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
