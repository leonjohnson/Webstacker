//
//  CustomButton.m
//  designer
//
//  Created by Bai Jin on 3/9/13.
//
//

#import "CustomButton.h"

@implementation CustomButton

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
	// draw background
    NSGradient *    gradient;
    NSColor *       pathColor;
	
	gradient = [[NSGradient alloc] initWithColorsAndLocations:
				 [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:1.0], 0.1,
				 [NSColor colorWithDeviceRed:0.15 green:0.15 blue:0.15 alpha:1.0], 0.7, nil]; //160 80
	
	pathColor = [NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.5 alpha:1.0];
	
	NSRect aRowRect = NSInsetRect(self.bounds, 7.5, 4);
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:aRowRect xRadius:0.0 yRadius:0.0];
	[path setLineWidth:2];
	[pathColor set];
	[path stroke];
	
	[gradient drawInBezierPath:path angle:90];
	
	[gradient release];
	
	// draw text
	NSString *string = self.title;
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSFont systemFontOfSize:10], NSFontAttributeName,
						  [NSColor whiteColor], NSForegroundColorAttributeName,
						  nil];
	NSSize sz = [string sizeWithAttributes:dict];
	
	[string drawAtPoint:NSMakePoint(self.bounds.size.width / 2 - sz.width / 2, self.bounds.size.height / 2 - sz.height / 2) withAttributes:dict];
}

@end
