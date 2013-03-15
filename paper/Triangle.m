#import "Triangle.h"

@implementation Triangle


/*
 @function:		setBoundRect
 @params:		rt:   triangle's bound rect
 @return:       void
 @purpose:		Set the triangle's bound rect "rtFrame" to rt.
 */
- (void)setBoundRect:(NSRect)rt
{
	rtFrame = rt;
    [self setFrame:CGRectMake(rtFrame.origin.x - 2, rtFrame.origin.y - 2, rtFrame.size.width + 8, rtFrame.size.height + 8)];
	[self setNeedsDisplay:YES];
}


/*
 @function:		DrawShape
 @params:		context:   Graphics context reference
 @return:       void
 @purpose:		Draw the triangle in rtFrame rectangle area.
 */
- (void)DrawShape:(CGContextRef)context
{
	CGContextSetRGBStrokeColor( context, 0.0, 0.0, 0.0, 1.0 );
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint( path, NULL, rtFrame.size.width / 2, 2 );
	CGPathAddLineToPoint( path, NULL, 2, rtFrame.size.height );
	CGPathAddLineToPoint( path, NULL, rtFrame.size.width, rtFrame.size.height );
	CGPathAddLineToPoint( path, NULL, rtFrame.size.width / 2, 2 );
	CGPathCloseSubpath( path );
	
	CGContextAddPath( context, (CGPathRef)path );
	CGContextStrokePath( context );
	
	CGPathRelease( path );
	
	if (isSelected == YES) {
		[self DrawBorderFrame:context];
	}
}


/*
 When the view is redraw, draw the triangle shape view
 */
- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *tvarNSGraphicsContext = [NSGraphicsContext currentContext];
	CGContextRef ctx = (CGContextRef) [tvarNSGraphicsContext graphicsPort];
    
    [self DrawShape:ctx];
}

- (NSInteger)IsPointInElement:(NSPoint)pt
{
	return SHT_NONE;
}



@end
