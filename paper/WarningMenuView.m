//
//  WarningMenuView.m
//  designer
//
//  Created by Bai Jin on 3/5/13.
//
//

#import "WarningMenuView.h"

@implementation WarningMenuView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    //// General Declarations
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	
	//// Color Declarations
	NSColor* gradientColor = [NSColor colorWithCalibratedRed: 0.989 green: 0.983 blue: 0.974 alpha: 1];
	NSColor* gradientColor2 = [NSColor colorWithCalibratedRed: 0.75 green: 0.75 blue: 0.75 alpha: 1];
	NSColor* color = [NSColor colorWithCalibratedRed: 0.541 green: 0.541 blue: 0.541 alpha: 1];
	
	//// Gradient Declarations
	NSGradient* gradientBar = [[NSGradient alloc] initWithColorsAndLocations:
							   gradientColor2, 0.1,
							   gradientColor, 0.7, nil];
	
	
	//// Shadow Declarations
	NSShadow* shadow = [[NSShadow alloc] init];
	[shadow setShadowColor: color];
	[shadow setShadowOffset:NSMakeSize(1 * sin(180 * 3.141592 / 180), 1 * cos(180 * 3.141592 / 180))];
	[shadow setShadowBlurRadius: 2.5];
	
	
	//// Rectangle Drawing
	NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRect: NSMakeRect(dirtyRect.origin.x, 3, dirtyRect.size.width, dirtyRect.size.height - 3)];
	
	[NSGraphicsContext saveGraphicsState];

	[shadow set];
	
	CGContextBeginTransparencyLayer(context, NULL);
	
	[gradientBar drawInBezierPath: rectanglePath angle: 90];
	
	CGContextEndTransparencyLayer(context);
	
	[NSGraphicsContext restoreGraphicsState];
	
	/*//// Draw bottom border
	NSRect rtBottomBorder = NSMakeRect(dirtyRect.origin.x, 0, dirtyRect.size.width, 2);
	
	[NSGraphicsContext saveGraphicsState];
	
	[[NSColor colorWithCalibratedRed:0.8 green:0.8 blue:0.8 alpha:1.0] setFill];
	NSRectFill(rtBottomBorder);
	[NSGraphicsContext restoreGraphicsState];*/
}

@end
