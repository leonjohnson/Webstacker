//
//  Container.m
//  designer
//
//  Created by Bai Jin on 2/24/13.
//
//

#import "Container.h"

@implementation Container

- (void)drawRect:(NSRect)dirtyRect
{
	NSGraphicsContext *tvarNSGraphicsContext = [NSGraphicsContext currentContext];
	CGContextRef ctx = (CGContextRef) [tvarNSGraphicsContext graphicsPort];
    
    [self DrawElement:ctx];
}

/*
 @function:		getShapeData
 @params:		nothing
 @return:       returns the dictionary data of the group shape.
 @purpose:		This function create the dictionary data from group shape and return it.
 */
- (NSMutableDictionary *)getShapeData
{
	// format shape type and frame rect
	NSNumber *type = [NSNumber numberWithInteger:uType];
	NSNumber *xPos = [NSNumber numberWithFloat:rtFrame.origin.x];
	NSNumber *yPos = [NSNumber numberWithFloat:rtFrame.origin.y];
	NSNumber *width = [NSNumber numberWithFloat:rtFrame.size.width];
	NSNumber *height = [NSNumber numberWithFloat:rtFrame.size.height];
	
	// set type and frame rect value to dictionary
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:type forKey:@"ShapeType"];
	[dict setValue:xPos forKey:@"xPos"];
	[dict setValue:yPos forKey:@"yPos"];
	[dict setValue:width forKey:@"Width"];
	[dict setValue:height forKey:@"Height"];
	
	// format shape shadow data
	/*NSNumber *shwAngle = [NSNumber numberWithFloat:shadowAngle];
	NSNumber *shwDistance = [NSNumber numberWithFloat:shadowDistance];
	NSNumber *shwOpacity = [NSNumber numberWithFloat:shadowOpacity];
	NSNumber *shwBlur = [NSNumber numberWithFloat:shadowBlur];
	const CGFloat *components = CGColorGetComponents( shadowCGColor );
	NSNumber *shwColorR =  [NSNumber numberWithFloat:components[0]];
	NSNumber *shwColorG =  [NSNumber numberWithFloat:components[1]];
	NSNumber *shwColorB =  [NSNumber numberWithFloat:components[2]];
	NSNumber *shwDirection = [NSNumber numberWithBool:shadowDirection];
	
	// set shadow information to dictionary
	[dict setValue:shwAngle forKey:@"shadowAngle"];
	[dict setValue:shwDistance forKey:@"shadowDistance"];
	[dict setValue:shwBlur forKey:@"shadowBlur"];
	[dict setValue:shwOpacity forKey:@"shadowOpacity"];
	[dict setValue:shwColorR forKey:@"shadowColorR"];
	[dict setValue:shwColorG forKey:@"shadowColorG"];
	[dict setValue:shwColorB forKey:@"shadowColorB"];
	[dict setValue:shwDirection forKey:@"shadowDirection"];*/
	
	// free all value
	type = nil;
	xPos = nil;
	yPos = nil;
	width = nil;
	height = nil;
	
	return dict;
}

/*
 @function:		setBoundRect
 @params:		rt:   group shape's bound rect
 @return:       void
 @purpose:		Set the group shape's bound rect "rtFrame" to rt.
 */
- (void)setBoundRect:(NSRect)rt
{
	rtFrame = CGRectStandardize(rt);
    [self setFrame:CGRectMake(rtFrame.origin.x - 2, rtFrame.origin.y - 2, rtFrame.size.width + 8, rtFrame.size.height + 8)];
	[self setNeedsDisplay:YES];
}

/*
 @function:		IsPointInElement
 @params:		nothing
 @return:       hitTest : hitTest is base on SHT_HANDLESTYLE
 @purpose:		Check the pt is in shape.
 */
- (NSInteger)IsPointInElement:(NSPoint)pt
{
	return SHT_NONE;
}

/*
 @function:		DrawShape
 @params:		context:   Graphics context reference
 @return:       void
 @purpose:		Draw the group shape in rtFrame rectangle area.
 */
- (void)DrawElement:(CGContextRef)context
{
	// draw shadow
	NSBezierPath* path = [NSBezierPath bezierPathWithRect: NSMakeRect(2, 2, rtFrame.size.width, rtFrame.size.height)];
	
	[NSGraphicsContext saveGraphicsState];
	[[NSColor whiteColor] setFill];
	[path fill];
	[NSGraphicsContext restoreGraphicsState];
	
	// draw shadow
	//[self drawShadows:path direction:shadowDirection angle:shadowAngle distance:shadowDistance color:shadowCGColor opacity:shadowOpacity blur:shadowBlur];
	
	// draw outer shadows first
	/*for (NSDictionary *dict in arrayShadows) {
		BOOL direction = [[dict valueForKey:@"Direction"] boolValue];
		CGFloat angle = [[dict valueForKey:@"Angle"] floatValue];
		CGFloat distance = [[dict valueForKey:@"Distance"] floatValue];
		CGFloat RColor = [[dict valueForKey:@"RColor"] floatValue];
		CGFloat GColor = [[dict valueForKey:@"GColor"] floatValue];
		CGFloat BColor = [[dict valueForKey:@"BColor"] floatValue];
		CGFloat opacity = [[dict valueForKey:@"Opacity"] floatValue];
		CGFloat blur = [[dict valueForKey:@"Blur"] floatValue];
		
		CGColorRef color = CGColorCreateGenericRGB(RColor, GColor, BColor, 1.0);
		
		if (direction == YES) {
			[self drawShadows:path direction:direction angle:angle distance:distance color:color opacity:opacity blur:blur];
		}
		
		CGColorRelease(color);
	}
	
	// next, draw inner shadows
	for (NSDictionary *dict in arrayShadows) {
		BOOL direction = [[dict valueForKey:@"Direction"] boolValue];
		CGFloat angle = [[dict valueForKey:@"Angle"] floatValue];
		CGFloat distance = [[dict valueForKey:@"Distance"] floatValue];
		CGFloat RColor = [[dict valueForKey:@"RColor"] floatValue];
		CGFloat GColor = [[dict valueForKey:@"GColor"] floatValue];
		CGFloat BColor = [[dict valueForKey:@"BColor"] floatValue];
		CGFloat opacity = [[dict valueForKey:@"Opacity"] floatValue];
		CGFloat blur = [[dict valueForKey:@"Blur"] floatValue];
		
		CGColorRef color = CGColorCreateGenericRGB(RColor, GColor, BColor, 1.0);
		
		if (direction == NO) {
			[self drawShadows:path direction:direction angle:angle distance:distance color:color opacity:opacity blur:blur];
		}
		
		CGColorRelease(color);
	}*/
	
	// draw shape again with stroke only
	[NSGraphicsContext saveGraphicsState];
	[[NSColor blackColor] setStroke];
	[path setLineWidth:1];
	[path stroke];
	[NSGraphicsContext restoreGraphicsState];
	
	if (isSelected == YES) {
		[self DrawBorderFrame:context];
	}
}

/*
 @function:		drawShadows
 @params:		path:		shape's path to draw
 direction:	shadow direction. If it is YES, outer shadow. otherwise, inner shadow.
 angle:		shadow angle
 distance:	shadow distance
 color:		shadow color
 opacity:	shadow opacity
 blur:		shadow blur
 @return:		void
 @purpose:		Draw the shadow with path and params.
 */
- (void)drawShadows:(NSBezierPath *)path direction:(BOOL)direction angle:(CGFloat)angle distance:(CGFloat)distance color:(CGColorRef)color opacity:(CGFloat)opacity blur:(CGFloat)blur
{
	// create shadow and init with params
	NSShadow *shadow = [[NSShadow alloc] init];
	
	const CGFloat *components = CGColorGetComponents( color );
	[shadow setShadowColor:[NSColor colorWithCalibratedRed:components[0] green:components[1] blue:components[2] alpha:opacity]];
	[shadow setShadowOffset:NSMakeSize(distance * sin(angle * 3.141592 / 180), distance * cos(angle * 3.141592 / 180))];
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
	
}

@end
