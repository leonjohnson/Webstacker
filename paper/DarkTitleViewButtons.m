#import "DarkTitleViewButtons.h"

@implementation DarkTitleViewButtons

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    //// Color Declarations
    NSColor* black = [NSColor colorWithCalibratedRed: 0 green: 0 blue: 0 alpha: 1];
    NSColor* lightBlack = [NSColor colorWithCalibratedRed: 0.25 green: 0.25 blue: 0.26 alpha: 1];
    NSColor* endBlack = [NSColor colorWithCalibratedRed: 0.09 green: 0.09 blue: 0.09 alpha: 1];
    
    //// Gradient Declarations
    NSGradient* buttonGradient = [[NSGradient alloc] initWithColorsAndLocations:
                                  endBlack, 0.0,
                                  [NSColor colorWithCalibratedRed: 0.17 green: 0.17 blue: 0.17 alpha: 1], 0.60,
                                  lightBlack, 1.0, nil];
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: [NSColor lightGrayColor]];
    [shadow setShadowOffset: NSMakeSize(0, 0)];
    [shadow setShadowBlurRadius: 1];
    
    
    //// Rectangle Drawing
    CGFloat rectangleCornerRadius = 2;
    NSRect rectangleFrame = NSMakeRect(5, 12.5, 50, 25);
    NSRect rectangleInnerRect = NSInsetRect(rectangleFrame, rectangleCornerRadius, rectangleCornerRadius);
    NSBezierPath* rectanglePath = [NSBezierPath bezierPath];
    [rectanglePath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(rectangleInnerRect), NSMinY(rectangleInnerRect)) radius: rectangleCornerRadius startAngle: 180 endAngle: 270];
    [rectanglePath lineToPoint: NSMakePoint(NSMaxX(rectangleFrame), NSMinY(rectangleFrame))];
    [rectanglePath lineToPoint: NSMakePoint(NSMaxX(rectangleFrame), NSMaxY(rectangleFrame))];
    [rectanglePath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(rectangleInnerRect), NSMaxY(rectangleInnerRect)) radius: rectangleCornerRadius startAngle: 90 endAngle: 180];
    [rectanglePath closePath];
    
    [buttonGradient drawInBezierPath: rectanglePath angle: -90];
    
    ////// Rectangle Inner Shadow
    NSRect rectangleBorderRect = NSInsetRect([rectanglePath bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
    rectangleBorderRect = NSOffsetRect(rectangleBorderRect, -shadow.shadowOffset.width, shadow.shadowOffset.height);
    rectangleBorderRect = NSInsetRect(NSUnionRect(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
    
    NSBezierPath* rectangleNegativePath = [NSBezierPath bezierPathWithRect: rectangleBorderRect];
    [rectangleNegativePath appendBezierPath: rectanglePath];
    [rectangleNegativePath setWindingRule: NSEvenOddWindingRule];
    
    [NSGraphicsContext saveGraphicsState];
    {
        NSShadow* shadowWithOffset = [shadow copy];
        CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(rectangleBorderRect.size.width);
        CGFloat yOffset = shadowWithOffset.shadowOffset.height;
        shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
        [shadowWithOffset set];
        [[NSColor grayColor] setFill];
        [rectanglePath addClip];
        NSAffineTransform* transform = [NSAffineTransform transform];
        [transform translateXBy: -round(rectangleBorderRect.size.width) yBy: 0];
        [[transform transformBezierPath: rectangleNegativePath] fill];
    }
    [NSGraphicsContext restoreGraphicsState];
    
    
    [black setStroke];
    [rectanglePath setLineWidth: 0.5];
    [rectanglePath stroke];
    
    
    //// Rectangle 2 Drawing
    CGFloat rectangle2CornerRadius = 2;
    NSRect rectangle2Frame = NSMakeRect(105, 12.5, 50, 25);
    NSRect rectangle2InnerRect = NSInsetRect(rectangle2Frame, rectangle2CornerRadius, rectangle2CornerRadius);
    NSBezierPath* rectangle2Path = [NSBezierPath bezierPath];
    [rectangle2Path moveToPoint: NSMakePoint(NSMinX(rectangle2Frame), NSMinY(rectangle2Frame))];
    [rectangle2Path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(rectangle2InnerRect), NSMinY(rectangle2InnerRect)) radius: rectangle2CornerRadius startAngle: 270 endAngle: 360];
    [rectangle2Path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(rectangle2InnerRect), NSMaxY(rectangle2InnerRect)) radius: rectangle2CornerRadius startAngle: 0 endAngle: 90];
    [rectangle2Path lineToPoint: NSMakePoint(NSMinX(rectangle2Frame), NSMaxY(rectangle2Frame))];
    [rectangle2Path closePath];
    
    [buttonGradient drawInBezierPath: rectangle2Path angle: -90];
    
    ////// Rectangle 2 Inner Shadow
    NSRect rectangle2BorderRect = NSInsetRect([rectangle2Path bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
    rectangle2BorderRect = NSOffsetRect(rectangle2BorderRect, -shadow.shadowOffset.width, shadow.shadowOffset.height);
    rectangle2BorderRect = NSInsetRect(NSUnionRect(rectangle2BorderRect, [rectangle2Path bounds]), -1, -1);
    
    NSBezierPath* rectangle2NegativePath = [NSBezierPath bezierPathWithRect: rectangle2BorderRect];
    [rectangle2NegativePath appendBezierPath: rectangle2Path];
    [rectangle2NegativePath setWindingRule: NSEvenOddWindingRule];
    
    [NSGraphicsContext saveGraphicsState];
    {
        NSShadow* shadowWithOffset = [shadow copy];
        CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(rectangle2BorderRect.size.width);
        CGFloat yOffset = shadowWithOffset.shadowOffset.height;
        shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
        [shadowWithOffset set];
        [[NSColor grayColor] setFill];
        [rectangle2Path addClip];
        NSAffineTransform* transform = [NSAffineTransform transform];
        [transform translateXBy: -round(rectangle2BorderRect.size.width) yBy: 0];
        [[transform transformBezierPath: rectangle2NegativePath] fill];
    }
    [NSGraphicsContext restoreGraphicsState];
    
    
    [black setStroke];
    [rectangle2Path setLineWidth: 0.5];
    [rectangle2Path stroke];
    
    
    //// Rectangle 3 Drawing
    NSBezierPath* rectangle3Path = [NSBezierPath bezierPathWithRect: NSMakeRect(55, 12.5, 50, 25)];
    [buttonGradient drawInBezierPath: rectangle3Path angle: -90];
    
    ////// Rectangle 3 Inner Shadow
    NSRect rectangle3BorderRect = NSInsetRect([rectangle3Path bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
    rectangle3BorderRect = NSOffsetRect(rectangle3BorderRect, -shadow.shadowOffset.width, shadow.shadowOffset.height);
    rectangle3BorderRect = NSInsetRect(NSUnionRect(rectangle3BorderRect, [rectangle3Path bounds]), -1, -1);
    
    NSBezierPath* rectangle3NegativePath = [NSBezierPath bezierPathWithRect: rectangle3BorderRect];
    [rectangle3NegativePath appendBezierPath: rectangle3Path];
    [rectangle3NegativePath setWindingRule: NSEvenOddWindingRule];
    
    [NSGraphicsContext saveGraphicsState];
    {
        NSShadow* shadowWithOffset = [shadow copy];
        CGFloat xOffset = shadowWithOffset.shadowOffset.width + round(rectangle3BorderRect.size.width);
        CGFloat yOffset = shadowWithOffset.shadowOffset.height;
        shadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
        [shadowWithOffset set];
        [[NSColor grayColor] setFill];
        [rectangle3Path addClip];
        NSAffineTransform* transform = [NSAffineTransform transform];
        [transform translateXBy: -round(rectangle3BorderRect.size.width) yBy: 0];
        [[transform transformBezierPath: rectangle3NegativePath] fill];
    }
    [NSGraphicsContext restoreGraphicsState];
    
    
    [black setStroke];
    [rectangle3Path setLineWidth: 0.5];
    [rectangle3Path stroke];
    

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
