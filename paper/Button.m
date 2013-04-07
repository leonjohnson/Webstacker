#import "Button.h"
#import "Singleton.h"


@implementation Button
@synthesize buttonColor, buttonSize, buttonTextContainer;


-(id)init
{
    if ((self = [super init]))
    {
        self.buttonText = [NSMutableString stringWithString:@""];
        [self setBorderRadius:[NSNumber numberWithFloat:4.0]];
        [self setBorderWidth:[NSNumber numberWithFloat:1.0]];
        
        [self setTopLeftBorderRadius:YES];
        [self setTopRightBorderRadius:YES];
        [self setBottomLeftBorderRadius:YES];
        [self setBottomRightBorderRadius:YES];
    }
    return self;
}

-(void)setBoundRect:(NSRect)rt
{
    [super setBoundRect:rt];
}

-(NSString *)buttonString
{
    return [super buttonString];
    
    
}

- (void)setButtonString:(NSString *)txt
{
	[super setButtonString:txt];
    [super postNotificationToRedraw];
    
}




-(void)setBorderRadius:(NSNumber *)radius
{
    [super setBorderRadius:radius];
    [super postNotificationToRedraw];
    
}

-(void)setBorderWidth:(NSNumber *)width
{
    [super setBorderWidth:width];
    [super postNotificationToRedraw];
    
}

-(void)setTopLeftBorderRadius:(BOOL)radius
{
    [super setTopLeftBorderRadius:radius];
    [super postNotificationToRedraw];
}

-(void)setTopRightBorderRadius:(BOOL)radius
{
    [super setTopRightBorderRadius:radius];
    [super postNotificationToRedraw];
}

-(void)setBottomLeftBorderRadius:(BOOL)toggle
{
    [super setBottomLeftBorderRadius:toggle];
    [super postNotificationToRedraw];
}

-(void)setBottomRightBorderRadius:(BOOL)radius
{
    [super setBottomRightBorderRadius:radius];
    [super postNotificationToRedraw];
}




-(void)DrawShape:(CGContextRef)context
{
    //I NOW NEED TO ADD A TEXTBOX TO THE BUTTON THAT CAN BE POSITIONED WITHIN THE BUTTON. THE TEXTBOX RTFRAME THEN BECOMES THE NSRECT USED TO DRAW THE TEXT IN THE BUTTON.
    
    CGFloat rectangleCornerRadius = [borderRadius floatValue];
    NSRect rectangleFrame = NSMakeRect(2, 2, rtFrame.size.width, rtFrame.size.height);
    
    // rounded edges
    NSRect rectangleInnerRect = NSInsetRect(rectangleFrame, rectangleCornerRadius, rectangleCornerRadius);
    NSBezierPath *roundedRectangle2Path = [NSBezierPath bezierPath];
    if (topLeftBorderRadius == NO & topRightBorderRadius == NO & bottomLeftBorderRadius == NO & bottomRightBorderRadius == NO)
    {
        roundedRectangle2Path = [NSBezierPath bezierPathWithRect:rectangleFrame];
    }
    else
    {
        //bottom-left
        if (bottomLeftBorderRadius)
        {
            [roundedRectangle2Path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rectangleInnerRect), NSMinY(rectangleInnerRect)) radius: rectangleCornerRadius startAngle:180 endAngle:270];
        }
        else
        {
            [roundedRectangle2Path moveToPoint:NSMakePoint(NSMinX(rectangleFrame), NSMinY(rectangleFrame))];
        }
        
        
        //bottom-right
        if (bottomRightBorderRadius)
        {
            [roundedRectangle2Path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rectangleInnerRect), NSMinY(rectangleInnerRect)) radius: rectangleCornerRadius startAngle:270 endAngle:360];
        }
        else
        {
            [roundedRectangle2Path lineToPoint:NSMakePoint(NSMaxX(rectangleFrame), NSMinY(rectangleFrame))];
        }
        
        
        //top right
        if (topRightBorderRadius)
        {
            [roundedRectangle2Path appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(rectangleInnerRect), NSMaxY(rectangleInnerRect)) radius:rectangleCornerRadius startAngle:0 endAngle:90];
        }
        else
        {
            [roundedRectangle2Path lineToPoint:NSMakePoint(NSMaxX(rectangleFrame), NSMaxY(rectangleFrame))];
        }
        
        
        //top left
        if (topLeftBorderRadius)
        {
            [roundedRectangle2Path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rectangleInnerRect), NSMaxY(rectangleInnerRect)) radius:rectangleCornerRadius startAngle:90 endAngle:180];
        }
        else
        {
            [roundedRectangle2Path lineToPoint:NSMakePoint(NSMinX(rectangleFrame), NSMaxY(rectangleFrame))];
        }
        
        [roundedRectangle2Path closePath];
    }
    
    //// Color Declarations
    NSColor* twitterDarkBlue = [NSColor colorWithCalibratedRed: 0.02 green: 0.24 blue: 0.75 alpha: 1];
    NSColor* twitterLightBlue = [NSColor colorWithCalibratedRed: 0.05 green: 0.44 blue: 0.75 alpha: 1];
    NSColor* twitterBorderColor = [NSColor colorWithCalibratedRed: 0.04 green: 0.32 blue: 0.66 alpha: 1];
    NSColor* twitterInnerShadow = [NSColor colorWithCalibratedRed: 0.93 green: 0.94 blue: 1 alpha: 1];
    
    //// Gradient Declarations
    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor: twitterLightBlue endingColor: twitterDarkBlue];
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: twitterInnerShadow];
    [shadow setShadowOffset: NSMakeSize(0, -1)];
    [shadow setShadowBlurRadius: 1];
    
    
    //// Rounded Rectangle 2 Drawing
    //NSBezierPath* roundedRectangle2Path = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(2, 2, rtFrame.size.width, rtFrame.size.height) xRadius: 8 yRadius: 8];
    [gradient drawInBezierPath: roundedRectangle2Path angle: 90];
    
    ////// Rounded Rectangle 2 Inner Shadow
    NSRect roundedRectangle2BorderRect = NSInsetRect([roundedRectangle2Path bounds], -shadow.shadowBlurRadius, -shadow.shadowBlurRadius);
    roundedRectangle2BorderRect = NSOffsetRect(roundedRectangle2BorderRect, -shadow.shadowOffset.width, -shadow.shadowOffset.height);
    roundedRectangle2BorderRect = NSInsetRect(NSUnionRect(roundedRectangle2BorderRect, [roundedRectangle2Path bounds]), -1, -1);
    
    NSBezierPath* roundedRectangle2NegativePath = [NSBezierPath bezierPathWithRect: roundedRectangle2BorderRect];
    [roundedRectangle2NegativePath appendBezierPath: roundedRectangle2Path];
    [roundedRectangle2NegativePath setWindingRule: NSEvenOddWindingRule];
    
    [NSGraphicsContext saveGraphicsState];
    {
        NSShadow* innerShadow = [shadow copy];
        CGFloat xOffset = innerShadow.shadowOffset.width + round(roundedRectangle2BorderRect.size.width);
        CGFloat yOffset = innerShadow.shadowOffset.height;
        innerShadow.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
        [innerShadow set];
        [[NSColor grayColor] setFill];
        [roundedRectangle2Path addClip];
        NSAffineTransform* transform = [NSAffineTransform transform];
        [transform translateXBy: -round(roundedRectangle2BorderRect.size.width) yBy: 0];
        [[transform transformBezierPath: roundedRectangle2NegativePath] fill];
        [innerShadow release];
    }
    [NSGraphicsContext restoreGraphicsState];
    
    //[roundedRectangle2Path fill];
    [twitterBorderColor setStroke];
	
	if (self.isPtInElement == YES) { // highlight shape when the mouse is over the shape.
		[[NSColor colorWithCalibratedRed:1 green:0.3 blue:0.2 alpha:1.0] set];
	}
	
    [roundedRectangle2Path setLineWidth: [borderWidth floatValue]];
    [roundedRectangle2Path stroke];
    
    
    
    
    //// Abstracted Graphic Attributes
    NSString* text2Content = [[NSString alloc]initWithString:self.buttonText];
    
    
    //// Text 2 Drawing
    NSMutableParagraphStyle* text2Style = [[[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [text2Style setAlignment: NSCenterTextAlignment];
    
    NSDictionary* text2FontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSFont fontWithName: @"Helvetica Neue" size: 12], NSFontAttributeName,
                                         [NSColor whiteColor], NSForegroundColorAttributeName,
                                         text2Style, NSParagraphStyleAttributeName, nil];
    NSSize sizeOfTextBox = [text2Content sizeWithAttributes:text2FontAttributes];
    NSRect textFrame = NSMakeRect(0, 0, sizeOfTextBox.width, sizeOfTextBox.height);
    textFrame.origin.y = (self.frame.size.height/2) - textFrame.size.height/2;
    textFrame.origin.x = (self.frame.size.width/2) - textFrame.size.width/2;
    self.buttonTextContainer = textFrame;
    [text2Content drawInRect:textFrame withAttributes: text2FontAttributes];
    
    
    
    
    //// Cleanup
    [shadow release];
    [gradient release];
    
    
    /*
     
     CGColorRef outerTop = CGColorCreateGenericRGB(1.0, 0.0, 0.0, 1.0);
     CGColorRef shadowColor = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 0.5);
     CGMutablePathRef outerPath;
     
     outerPath = createRoundedRectForRect(rtFrame,
     [[borderRadius objectForKey:@"top-left"] floatValue],
     [[borderRadius objectForKey:@"top-right"] floatValue],
     [[borderRadius objectForKey:@"bottom-left"] floatValue],
     [[borderRadius objectForKey:@"bottom-right"] floatValue]);
     
     
     
     
     CGContextSaveGState(context);
     
     CGContextAddPath(context, outerPath);
     CGContextSetFillColorWithColor(context, outerTop);
     CGContextSetShadowWithColor(context, CGSizeMake(0, -2), 5.0, shadowColor);
     CGContextAddPath(context, outerPath);
     CGContextFillPath(context);
     
     CGContextRestoreGState(context);
     
     
     */
    if (isSelected == YES)
    {
        [self DrawBorderFrame:context];
    }
    
}



CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat topleft, CGFloat topright, CGFloat bottomleft, CGFloat bottomright ) {
    
    NSLog(@"calling createRoundedForRect with topRight as: %f", topright);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    
    //Bottom left corner
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect),
                        CGRectGetMaxX(rect), CGRectGetMaxY(rect), bottomright );
    
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect),
                        CGRectGetMinX(rect), CGRectGetMaxY(rect), topright);
    
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect),
                        CGRectGetMinX(rect), CGRectGetMinY(rect), topleft);
    
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect),
                        CGRectGetMaxX(rect), CGRectGetMinY(rect), bottomleft);
    
    CGPathCloseSubpath(path);
    
    return path;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"calling setValueFoRUndefinedKey in htmlButton FOR KEY: %@, and VALUE: %@", key, value);
}

-(void)setButtonText:(NSMutableString *)b
{
    NSLog(@"called buttony");
    [super setButtonText:b];
    [super postNotificationToRedraw];
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
	CGContextRef ctx = (CGContextRef) [tvarNSGraphicsContext graphicsPort];
    //Singleton *sg = [[Singleton alloc]init];
    
    [self DrawShape: ctx];
}

@end
