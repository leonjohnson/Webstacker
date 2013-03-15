#import "DocumentBar.h"

@implementation DocumentBar

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    //[self setTranslatesAutoresizingMaskIntoConstraints:NO];
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    /*
    NSGraphicsContext *gc = [NSGraphicsContext currentContext];
	CGContextRef contextref = (CGContextRef) [gc graphicsPort];
    
	// draw stageView's bound rect with black color
	CGContextSetRGBStrokeColor( contextref, 1.0, 0.0, 0.0, 1.0 );
	CGContextStrokeRect( contextref, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) );
    
    */
    
    
    
    
    //// Color Declarations
    NSColor* shadowGreyD = [NSColor colorWithCalibratedRed: 0.83 green: 0.83 blue: 0.85 alpha: 1];
    NSColor* darkD = [NSColor colorWithCalibratedRed: 0.85 green: 0.85 blue: 0.85 alpha: 1];
    NSColor* lightD = [NSColor colorWithCalibratedRed: 0.99 green: 0.99 blue: 0.99 alpha: 1];
    
    //// Gradient Declarations
    NSGradient* dBar = [[NSGradient alloc] initWithStartingColor: darkD endingColor: lightD];
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: shadowGreyD];
    [shadow setShadowOffset: NSMakeSize(0, -1)];
    [shadow setShadowBlurRadius: 6];
    
    
    //// Rectangle Drawing
    NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRect: NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)];
    [NSGraphicsContext saveGraphicsState];
    [shadow set];
    [shadow.shadowColor setFill];
    [rectanglePath fill];
    [dBar drawInBezierPath: rectanglePath angle: 90];
    [NSGraphicsContext restoreGraphicsState];
    
    [[NSColor grayColor] setStroke];
    [rectanglePath setLineWidth: 0.5];
    [rectanglePath stroke];
    
    //// Cleanup
    [shadow release];
    [dBar release];


}

@end
