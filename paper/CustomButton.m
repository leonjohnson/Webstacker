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
	NSSize sizz = NSMakeSize(self.frame.size.width, 32);
    [self setFrameSize: sizz];
    //// Color Declarations
    NSColor* lightBlack1 = [NSColor colorWithCalibratedRed: 0.189 green: 0.189 blue: 0.189 alpha: 1];
    NSColor* darkBlack1 = [NSColor colorWithCalibratedRed: 0.098 green: 0.098 blue: 0.098 alpha: 1];
    
    //// Gradient Declarations
    NSGradient* panelBarGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                    darkBlack1, 0.0,
                                    [NSColor colorWithCalibratedRed: 0.143 green: 0.143 blue: 0.143 alpha: 1], 0.64,
                                    lightBlack1, 1.0, nil];
    
    //// Shadow Declarations
    NSShadow* panelBarTopShadow = [[NSShadow alloc] init];
    [panelBarTopShadow setShadowColor: [NSColor lightGrayColor]];
    [panelBarTopShadow setShadowOffset: NSMakeSize(0.1, -1.1)];
    [panelBarTopShadow setShadowBlurRadius: 1.5];
    
    //// Abstracted Attributes
    NSRect roundedRectangle2Rect = NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height);
    
    
    //// Rounded Rectangle 2 Drawing
    NSBezierPath* roundedRectangle2Path = [NSBezierPath bezierPathWithRect: roundedRectangle2Rect];
    [panelBarGradient drawInBezierPath: roundedRectangle2Path angle: -90];
    
    ////// Rounded Rectangle 2 Inner Shadow
    NSRect roundedRectangle2BorderRect = NSInsetRect([roundedRectangle2Path bounds], -panelBarTopShadow.shadowBlurRadius, -panelBarTopShadow.shadowBlurRadius);
    roundedRectangle2BorderRect = NSOffsetRect(roundedRectangle2BorderRect, -panelBarTopShadow.shadowOffset.width, -panelBarTopShadow.shadowOffset.height);
    roundedRectangle2BorderRect = NSInsetRect(NSUnionRect(roundedRectangle2BorderRect, [roundedRectangle2Path bounds]), -1, -1);
    
    NSBezierPath* roundedRectangle2NegativePath = [NSBezierPath bezierPathWithRect: roundedRectangle2BorderRect];
    [roundedRectangle2NegativePath appendBezierPath: roundedRectangle2Path];
    [roundedRectangle2NegativePath setWindingRule: NSEvenOddWindingRule];
    
    [NSGraphicsContext saveGraphicsState];
    {
        NSShadow* panelBarTopShadowWithOffset = [panelBarTopShadow copy];
        CGFloat xOffset = panelBarTopShadowWithOffset.shadowOffset.width + round(roundedRectangle2BorderRect.size.width);
        CGFloat yOffset = panelBarTopShadowWithOffset.shadowOffset.height;
        panelBarTopShadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
        [panelBarTopShadowWithOffset set];
        [[NSColor grayColor] setFill];
        [roundedRectangle2Path addClip];
        NSAffineTransform* transform = [NSAffineTransform transform];
        [transform translateXBy: -round(roundedRectangle2BorderRect.size.width) yBy: 0];
        [[transform transformBezierPath: roundedRectangle2NegativePath] fill];
    }
    [NSGraphicsContext restoreGraphicsState];
    
    [darkBlack1 setStroke];
    [roundedRectangle2Path setLineWidth: 2];
    [roundedRectangle2Path stroke];
    
    
    
    

	
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
