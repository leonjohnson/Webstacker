#import "DocumentBarButton.h"

@implementation DocumentBarButton

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    
    CGFloat roundedRadius = 3.0f;
    
    // Outer stroke (drawn as gradient)
    
    [ctx saveGraphicsState];
    NSBezierPath *outerClip = [NSBezierPath bezierPathWithRoundedRect:frame 
                                                              xRadius:roundedRadius 
                                                              yRadius:roundedRadius];
    [outerClip setClip];
    
    NSGradient *outerGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                 [NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.0f, 
                                 [NSColor colorWithDeviceWhite:0.21f alpha:1.0f], 1.0f, 
                                 nil];
    
    //[outerGradient drawInRect:[outerClip bounds] angle:90.0f];
    [ctx restoreGraphicsState];
    
    // Background gradient
    
    [ctx saveGraphicsState];
    NSBezierPath *backgroundPath = 
    [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.0f, 2.0f) 
                                    xRadius:roundedRadius 
                                    yRadius:roundedRadius];
    [backgroundPath setClip];
    
    /*
    NSGradient *backgroundGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                      [NSColor colorWithDeviceWhite:0.17f alpha:1.0f], 0.0f, 
                                      [NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.12f, 
                                      [NSColor colorWithDeviceWhite:0.27f alpha:1.0f], 0.5f, 
                                      [NSColor colorWithDeviceWhite:0.30f alpha:1.0f], 0.5f, 
                                      [NSColor colorWithDeviceWhite:0.42f alpha:1.0f], 0.98f, 
                                      [NSColor colorWithDeviceWhite:0.50f alpha:1.0f], 1.0f, 
                                      nil];
     */
    //// Color Declarations
    NSColor* twitterDarkBlue = [NSColor colorWithCalibratedRed: 0.02 green: 0.24 blue: 0.75 alpha: 1];
    NSColor* twitterLightBlue = [NSColor colorWithCalibratedRed: 0.05 green: 0.44 blue: 0.75 alpha: 1];
    //NSColor* twitterBorderColor = [NSColor colorWithCalibratedRed: 0.04 green: 0.32 blue: 0.66 alpha: 1];
    //NSColor* twitterInnerShadow = [NSColor colorWithCalibratedRed: 0.93 green: 0.94 blue: 1 alpha: 1];
    
    //// Gradient Declarations
    NSGradient* backgroundGradient = [[NSGradient alloc] initWithStartingColor: twitterDarkBlue endingColor: twitterLightBlue];
    
    
    [backgroundGradient drawInRect:[backgroundPath bounds] angle:-90.0f];
    [ctx restoreGraphicsState];
    
    // Dark stroke
    
    [ctx saveGraphicsState];
    [[NSColor colorWithDeviceWhite:0.12f alpha:1.0f] setStroke];
    [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 1.5f, 1.5f) 
                                     xRadius:roundedRadius 
                                     yRadius:roundedRadius] stroke];
    [ctx restoreGraphicsState];
    
    // Inner light stroke
    
    [ctx saveGraphicsState];
    [[NSColor colorWithDeviceWhite:1.0f alpha:0.05f] setStroke];
    [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.5f, 2.5f) 
                                     xRadius:roundedRadius 
                                     yRadius:roundedRadius] stroke];
    [ctx restoreGraphicsState];        
    
    // Draw darker overlay if button is pressed
    
    if([self isHighlighted]) {
        [ctx saveGraphicsState];
        [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.0f, 2.0f) 
                                         xRadius:roundedRadius 
                                         yRadius:roundedRadius] setClip];
        [[NSColor colorWithCalibratedWhite:0.0f alpha:0.35] setFill];
        NSRectFillUsingOperation(frame, NSCompositeSourceOver);
        [ctx restoreGraphicsState];
    }
}


- (void)drawImage:(NSImage*)image withFrame:(NSRect)frame inView:(NSView*)controlView
{
    NSGraphicsContext *ctx = [NSGraphicsContext currentContext];
    CGContextRef contextRef = [ctx graphicsPort];
    
    NSData *data = [image TIFFRepresentation]; // open for suggestions
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)CFBridgingRetain(data), NULL);
    if(source) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
        CFRelease(source);
        
        // Draw shadow 1px below image
        
        CGContextSaveGState(contextRef);
        {
            NSRect rect = NSOffsetRect(frame, 0.0f, 1.0f);
            CGFloat white = [self isHighlighted] ? 0.2f : 0.35f;
            CGContextClipToMask(contextRef, NSRectToCGRect(rect), imageRef);
            [[NSColor colorWithDeviceWhite:white alpha:1.0f] setFill];
            NSRectFill(rect);
        } 
        CGContextRestoreGState(contextRef);
        
        // Draw image
        
        CGContextSaveGState(contextRef);
        {
            NSRect rect = frame;
            CGContextClipToMask(contextRef, NSRectToCGRect(rect), imageRef);
            [[NSColor colorWithDeviceWhite:0.1f alpha:1.0f] setFill];
            NSRectFill(rect);
        } 
        CGContextRestoreGState(contextRef);        
        
        CFRelease(imageRef);
    }
}
@end
