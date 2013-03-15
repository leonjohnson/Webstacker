//
//  BasePanel.m
//  DrawShap
//
//  Created by Bai Jin on 12/25/12.
//  Copyright (c) 2012 Cosmo Software. All rights reserved.
//

#import "BasePanel.h"
#import "Common.h"

/** Corner clipping radius **/
const CGFloat BasePanelCornerClipRadius = 8.0;
const CGFloat BaseButtonTopOffset = 6.0;


@interface NSColor (INAdditions)
- (CGColorRef)BasePanel_CGColorCreate;
@end

@implementation NSColor (INAdditions)
- (CGColorRef)BasePanel_CGColorCreate
{
    if([self isEqualTo:[NSColor blackColor]]) return CGColorGetConstantColor(kCGColorBlack);
    if([self isEqualTo:[NSColor whiteColor]]) return CGColorGetConstantColor(kCGColorWhite);
    if([self isEqualTo:[NSColor clearColor]]) return CGColorGetConstantColor(kCGColorClear);
    NSColor *rgbColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    CGFloat components[4];
    [rgbColor getComponents:components];
    
    CGColorSpaceRef theColorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGColorRef theColor = CGColorCreate(theColorSpace, components);
    CGColorSpaceRelease(theColorSpace);
	
#if !__has_feature(objc_arc)
    return (CGColorRef)[(id)theColor autorelease];
#else
    return theColor;
#endif
}
@end

NS_INLINE CGFloat BasePanelMidHeight(NSRect aRect){
    return (aRect.size.height * (CGFloat)0.5);
}

static inline CGPathRef createClippingPathWithRectAndRadius(NSRect rect, CGFloat radius)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, NSMinX(rect), NSMinY(rect));
    CGPathAddLineToPoint(path, NULL, NSMinX(rect), NSMaxY(rect)-radius);
    CGPathAddArcToPoint(path, NULL, NSMinX(rect), NSMaxY(rect), NSMinX(rect)+radius, NSMaxY(rect), radius);
    CGPathAddLineToPoint(path, NULL, NSMaxX(rect)-radius, NSMaxY(rect));
    CGPathAddArcToPoint(path, NULL,  NSMaxX(rect), NSMaxY(rect), NSMaxX(rect), NSMaxY(rect)-radius, radius);
    CGPathAddLineToPoint(path, NULL, NSMaxX(rect), NSMinY(rect));
    CGPathCloseSubpath(path);
    return path;
}

static inline CGGradientRef createGradientWithColors(NSColor *startingColor, NSColor *endingColor)
{
    CGFloat locations[2] = {0.0f, 1.0f, };
#if __has_feature(objc_arc)
    CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(__bridge id)[startingColor BasePanel_CGColorCreate], (__bridge id)[endingColor BasePanel_CGColorCreate], nil];
#else
    CFArrayRef colors = (CFArrayRef)[NSArray arrayWithObjects:(id)[startingColor BasePanel_CGColorCreate], (id)[endingColor BasePanel_CGColorCreate], nil];
#endif
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, locations);
    CGColorSpaceRelease(colorSpace);
    return gradient;
}

@interface BasePanelDelegateProxy : NSProxy <NSWindowDelegate>
@property (nonatomic, assign) id<NSWindowDelegate> secondaryDelegate;
@end

@implementation BasePanelDelegateProxy

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [[self.secondaryDelegate class] instanceMethodSignatureForSelector:selector];
    NSAssert(signature != nil, @"The method signature(%@) should not be nil becuase of the respondsToSelector: check", NSStringFromSelector(selector));
    return signature;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.secondaryDelegate respondsToSelector:aSelector]) {
        return YES;
    } else if (aSelector == @selector(window:willPositionSheet:usingRect:)) {
        return YES;
    }
    return NO;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([self.secondaryDelegate respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:self.secondaryDelegate];
    }
}

- (NSRect)window:(BasePanel *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect
{
    rect.origin.y = NSHeight(window.frame)-window.titleBarHeight;
    return rect;
}
@end

@interface BasePanel ()
- (void)_doInitialWindowSetup;
- (void)_createTitlebarView;
- (void)_setupTrafficLightsTrackingArea;
- (void)_recalculateFrameForTitleBarContainer;
- (void)_repositionContentView;
- (void)_layoutTrafficLightsAndContent;
- (CGFloat)_minimumTitlebarHeight;
- (void)_displayWindowAndTitlebar;
- (void)_hideTitleBarView:(BOOL)hidden;
- (CGFloat)_defaultTrafficLightLeftMargin;
- (CGFloat)_trafficLightSeparation;
@end


@implementation BasePanelContentView

- (void)drawRect:(NSRect)dirtyRect
{
	NSColor *color = [NSColor colorWithCalibratedRed:0.185 green:0.185 blue:0.185 alpha:1.0];
	[color set];
	NSRectFill([self bounds]);
	
	[[NSColor blackColor] setStroke];
	NSBezierPath *path = [[NSBezierPath alloc] init];
	[path setLineWidth:1.5];
	
	[path moveToPoint:NSMakePoint(0, 0)];
	[path lineToPoint:NSMakePoint(0, [self bounds].size.height)];
	[path stroke];
	
	[path moveToPoint:NSMakePoint(0, 0)];
	[path lineToPoint:NSMakePoint([self bounds].size.width, 0)];
	[path stroke];
	
	[path moveToPoint:NSMakePoint([self bounds].size.width, [self bounds].size.height)];
	[path lineToPoint:NSMakePoint([self bounds].size.width, 0)];
	[path stroke];
	
	[path release];
}

@end

@implementation BasePanelTitlebarView

- (void)drawNoiseWithOpacity:(CGFloat)opacity
{
    static CGImageRef noiseImageRef = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSUInteger width = 124, height = width;
        NSUInteger size = width*height;
        char *rgba = (char *)malloc(size); srand(120);
        for(NSUInteger i=0; i < size; ++i){rgba[i] = rand()%256;}
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef bitmapContext =
        CGBitmapContextCreate(rgba, width, height, 8, width, colorSpace, kCGImageAlphaNone);
        CFRelease(colorSpace);
        noiseImageRef = CGBitmapContextCreateImage(bitmapContext);
        CFRelease(bitmapContext);
        free(rgba);
    });
	
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(context);
    CGContextSetAlpha(context, opacity);
    CGContextSetBlendMode(context, kCGBlendModeScreen);
	
    if ( [[self window] respondsToSelector:@selector(backingScaleFactor)] ) {
        CGFloat scaleFactor = [[self window] backingScaleFactor];
        CGContextScaleCTM(context, 1/scaleFactor, 1/scaleFactor);
    }
	
    CGRect imageRect = (CGRect){CGPointZero, CGImageGetWidth(noiseImageRef), CGImageGetHeight(noiseImageRef)};
    CGContextDrawTiledImage(context, imageRect, noiseImageRef);
    CGContextRestoreGState(context);
}

- (void)drawRect:(NSRect)dirtyRect
{
    BasePanel *window = (BasePanel *)[self window];
    BOOL drawsAsMainWindow = ([window isMainWindow] && [[NSApplication sharedApplication] isActive]);
    
    NSRect drawingRect = [self bounds];
    if ( /*window.titleBarDrawingBlock*/YES ) {
        CGPathRef clippingPath = createClippingPathWithRectAndRadius(drawingRect, BasePanelCornerClipRadius);
        //window.titleBarDrawingBlock(drawsAsMainWindow, NSRectToCGRect(drawingRect), clippingPath);
		
		CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
        CGContextAddPath(ctx, clippingPath);
        CGContextClip(ctx);
		
		//// Color Declarations
		NSColor* darkBlack1 = [NSColor colorWithCalibratedRed: 0.1 green: 0.1 blue: 0.1 alpha: 1];
		NSColor* lightBlack1 = [NSColor colorWithCalibratedRed: 0.19 green: 0.19 blue: 0.19 alpha: 1];
		NSColor* lightGrey = [NSColor colorWithCalibratedRed: 0.27 green: 0.27 blue: 0.27 alpha: 1];
		NSColor* panelBackground = [NSColor colorWithCalibratedRed: 0.12 green: 0.12 blue: 0.12 alpha: 0.95];
		
		//// Gradient Declarations
		NSGradient* panelBarGradient = [[NSGradient alloc] initWithColorsAndLocations:
										darkBlack1, 0.0,
										[NSColor colorWithCalibratedRed: 0.14 green: 0.14 blue: 0.14 alpha: 1], 0.64,
										lightBlack1, 1.0, nil];
		
		//// Shadow Declarations
		NSShadow* panelBarTopShadow = [[NSShadow alloc] init];
		[panelBarTopShadow setShadowColor: [NSColor lightGrayColor]];
		[panelBarTopShadow setShadowOffset: NSMakeSize(0, -1)];
		[panelBarTopShadow setShadowBlurRadius: 1.5];
		NSShadow* panelBackgroundShadow = [[NSShadow alloc] init];
		[panelBackgroundShadow setShadowColor: [NSColor whiteColor]];
		[panelBackgroundShadow setShadowOffset: NSMakeSize(0, 0)];
		[panelBackgroundShadow setShadowBlurRadius: 1.5];
		
		//// Abstracted Graphic Attributes
		//NSRect roundedRectangle2Rect = NSMakeRect(3, 4.5, 250, 30);
		
		
		//// Rounded Rectangle Drawing
		CGFloat roundedRectangleCornerRadius = 3;
		NSRect roundedRectangleFrame = self.frame;//NSMakeRect(3, 35.5, 250, 299);
		NSRect roundedRectangleInnerRect = NSInsetRect(roundedRectangleFrame, roundedRectangleCornerRadius, roundedRectangleCornerRadius);
		NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPath];
		[roundedRectanglePath moveToPoint: NSMakePoint(NSMinX(roundedRectangleFrame), NSMinY(roundedRectangleFrame))];
		[roundedRectanglePath lineToPoint: NSMakePoint(NSMaxX(roundedRectangleFrame), NSMinY(roundedRectangleFrame))];
		[roundedRectanglePath appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(roundedRectangleInnerRect), NSMaxY(roundedRectangleInnerRect)) radius: roundedRectangleCornerRadius startAngle: 0 endAngle: 90];
		[roundedRectanglePath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(roundedRectangleInnerRect), NSMaxY(roundedRectangleInnerRect)) radius: roundedRectangleCornerRadius startAngle: 90 endAngle: 180];
		[roundedRectanglePath closePath];
		
		[panelBackground setFill];
		[roundedRectanglePath fill];
		
		////// Rounded Rectangle Inner Shadow
		NSRect roundedRectangleBorderRect = NSInsetRect([roundedRectanglePath bounds], -panelBackgroundShadow.shadowBlurRadius, -panelBackgroundShadow.shadowBlurRadius);
		roundedRectangleBorderRect = NSOffsetRect(roundedRectangleBorderRect, -panelBackgroundShadow.shadowOffset.width, panelBackgroundShadow.shadowOffset.height);
		roundedRectangleBorderRect = NSInsetRect(NSUnionRect(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
		
		NSBezierPath* roundedRectangleNegativePath = [NSBezierPath bezierPathWithRect: roundedRectangleBorderRect];
		[roundedRectangleNegativePath appendBezierPath: roundedRectanglePath];
		[roundedRectangleNegativePath setWindingRule: NSEvenOddWindingRule];
		
		[NSGraphicsContext saveGraphicsState];
		{
			NSShadow* panelBackgroundShadowWithOffset = [panelBackgroundShadow copy];
			CGFloat xOffset = panelBackgroundShadowWithOffset.shadowOffset.width + round(roundedRectangleBorderRect.size.width);
			CGFloat yOffset = panelBackgroundShadowWithOffset.shadowOffset.height;
			panelBackgroundShadowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
			[panelBackgroundShadowWithOffset set];
			[[NSColor grayColor] setFill];
			[roundedRectanglePath addClip];
			NSAffineTransform* transform = [NSAffineTransform transform];
			[transform translateXBy: -round(roundedRectangleBorderRect.size.width) yBy: 0];
			[[transform transformBezierPath: roundedRectangleNegativePath] fill];
		}
		[NSGraphicsContext restoreGraphicsState];
		
		
		[[NSColor blackColor] setStroke];
		[roundedRectanglePath setLineWidth: 1.5];
		[roundedRectanglePath stroke];
		
		
		//// Rounded Rectangle 2 Drawing
		NSRect roundedRectangle2Frame = self.frame;
		
		CGFloat roundedRectangle2CornerRadius = 4;
		NSRect roundedRectangle2InnerRect = NSInsetRect(roundedRectangle2Frame, roundedRectangle2CornerRadius, roundedRectangle2CornerRadius);
		NSBezierPath* roundedRectangle2Path = [NSBezierPath bezierPath];
		[roundedRectangle2Path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(roundedRectangle2InnerRect), NSMinY(roundedRectangle2InnerRect)) radius: roundedRectangle2CornerRadius startAngle: 180 endAngle: 270];
		[roundedRectangle2Path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(roundedRectangle2InnerRect), NSMinY(roundedRectangle2InnerRect)) radius: roundedRectangle2CornerRadius startAngle: 270 endAngle: 360];
		[roundedRectangle2Path lineToPoint: NSMakePoint(NSMaxX(roundedRectangle2Frame), NSMaxY(roundedRectangle2Frame))];
		[roundedRectangle2Path lineToPoint: NSMakePoint(NSMinX(roundedRectangle2Frame), NSMaxY(roundedRectangle2Frame))];
		[roundedRectangle2Path closePath];
		
		[panelBarGradient drawInBezierPath: roundedRectangle2Path angle: -90];
		
		////// Rounded Rectangle 2 Inner Shadow
		NSRect roundedRectangle2BorderRect = NSInsetRect([roundedRectangle2Path bounds], -panelBarTopShadow.shadowBlurRadius, -panelBarTopShadow.shadowBlurRadius);
		roundedRectangle2BorderRect = NSOffsetRect(roundedRectangle2BorderRect, -panelBarTopShadow.shadowOffset.width, panelBarTopShadow.shadowOffset.height);
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
		[roundedRectangle2Path setLineWidth: 1.5];
		[roundedRectangle2Path stroke];
		
		
		//// Bezier Highlight Line Drawing
		NSBezierPath* bezierHighlightLinePath = [NSBezierPath bezierPath];
		[bezierHighlightLinePath moveToPoint: NSMakePoint(3.5, 36.5)];
		[bezierHighlightLinePath curveToPoint: NSMakePoint(251.5, 36.5) controlPoint1: NSMakePoint(252.5, 36.5) controlPoint2: NSMakePoint(251.5, 36.5)];
		[lightGrey setStroke];
		[bezierHighlightLinePath setLineWidth: 0.5];
		[bezierHighlightLinePath stroke];
		
		[[NSColor colorWithDeviceRed:0.05 green:0.05 blue:0.1 alpha:1.0] setStroke];
		[roundedRectangle2NegativePath setLineWidth: 1.5];
		[roundedRectangle2NegativePath stroke];
		
        CGPathRelease(clippingPath);
    } else {
        CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
        
        NSColor *startColor = drawsAsMainWindow ? window.titleBarStartColor : window.inactiveTitleBarStartColor;
        NSColor *endColor = drawsAsMainWindow ? window.titleBarEndColor : window.titleBarEndColor;
        
        if (IN_RUNNING_LION) {
            startColor = startColor ?: (drawsAsMainWindow ? IN_COLOR_MAIN_START_L : IN_COLOR_NOTMAIN_START_L);
            endColor = endColor ?: (drawsAsMainWindow ? IN_COLOR_MAIN_END_L : IN_COLOR_NOTMAIN_END_L);
        } else {
            startColor = startColor ?: (drawsAsMainWindow ? IN_COLOR_MAIN_START : IN_COLOR_NOTMAIN_START);
            endColor = endColor ?: (drawsAsMainWindow ? IN_COLOR_MAIN_END : IN_COLOR_NOTMAIN_END);
        }
        
        NSRect clippingRect = drawingRect;
#if IN_COMPILING_LION
        if((([window styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask)){
            [[NSColor blackColor] setFill];
            [[NSBezierPath bezierPathWithRect:self.bounds] fill];
        }
#endif
        clippingRect.size.height -= 1;
        CGPathRef clippingPath = createClippingPathWithRectAndRadius(clippingRect, BasePanelCornerClipRadius);
        CGContextAddPath(context, clippingPath);
        CGContextClip(context);
        CGPathRelease(clippingPath);
        
        CGGradientRef gradient = createGradientWithColors(startColor, endColor);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(NSMidX(drawingRect), NSMinY(drawingRect)),
                                    CGPointMake(NSMidX(drawingRect), NSMaxY(drawingRect)), 0);
        CGGradientRelease(gradient);
		
        if ([window showsBaselineSeparator]) {
            NSColor *bottomColor = drawsAsMainWindow ? window.baselineSeparatorColor : window.inactiveBaselineSeparatorColor;
            
            if (IN_RUNNING_LION) {
                bottomColor = bottomColor ? bottomColor : drawsAsMainWindow ? IN_COLOR_MAIN_BOTTOM_L : IN_COLOR_NOTMAIN_BOTTOM_L;
            } else {
                bottomColor = bottomColor ? bottomColor : drawsAsMainWindow ? IN_COLOR_MAIN_BOTTOM : IN_COLOR_NOTMAIN_BOTTOM;
            }
            
            NSRect bottomRect = NSMakeRect(0.0, NSMinY(drawingRect), NSWidth(drawingRect), 1.0);
            [bottomColor set];
            NSRectFill(bottomRect);
            
            if (IN_RUNNING_LION) {
				bottomRect.origin.y += 1.0;
				[[NSColor colorWithDeviceWhite:1.0 alpha:0.12] setFill];
				[[NSBezierPath bezierPathWithRect:bottomRect] fill];
            }
        }
        
        if (IN_RUNNING_LION && drawsAsMainWindow) {
            CGRect noiseRect = NSInsetRect(drawingRect, 1.0, 1.0);
            
            if (![window showsBaselineSeparator]) {
                noiseRect.origin.y    -= 1.0;
                noiseRect.size.height += 1.0;
            }
            
            CGPathRef noiseClippingPath =
            createClippingPathWithRectAndRadius(noiseRect, BasePanelCornerClipRadius);
            CGContextAddPath(context, noiseClippingPath);
            CGContextClip(context);
            CGPathRelease(noiseClippingPath);
            
            [self drawNoiseWithOpacity:0.1];
        }
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if ([theEvent clickCount] == 2) {
        // Get settings from "System Preferences" >  "Appearance" > "Double-click on windows title bar to minimize"
        NSString *const MDAppleMiniaturizeOnDoubleClickKey = @"AppleMiniaturizeOnDoubleClick";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL shouldMiniaturize = [[userDefaults objectForKey:MDAppleMiniaturizeOnDoubleClickKey] boolValue];
        if (shouldMiniaturize) {
            [[self window] miniaturize:self];
        }
    }
}

@end

@interface BasePanelTitlebarContainer : NSView
@end

@implementation BasePanelTitlebarContainer
- (void)mouseDragged:(NSEvent *)theEvent
{
    NSWindow *window = [self window];
    NSPoint where =  [window convertBaseToScreen:[theEvent locationInWindow]];
    
    if ([window isMovableByWindowBackground]) {
        [super mouseDragged: theEvent];
        return;
    }
    
    NSPoint origin = [window frame].origin;
    while ((theEvent = [NSApp nextEventMatchingMask:NSLeftMouseDownMask | NSLeftMouseDraggedMask | NSLeftMouseUpMask untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:YES]) && ([theEvent type] != NSLeftMouseUp)) {
        @autoreleasepool {
            NSPoint now = [window convertBaseToScreen:[theEvent locationInWindow]];
            origin.x += now.x - where.x;
            origin.y += now.y - where.y;
            [window setFrameOrigin:origin];
            where = now;
        }
    }
}
@end

@implementation BasePanel{
    CGFloat _cachedTitleBarHeight;
    BOOL _setFullScreenButtonRightMargin;
    BasePanelDelegateProxy *_delegateProxy;
    BasePanelTitlebarContainer *_titleBarContainer;
}

@synthesize titleBarView = _titleBarView;
@synthesize titleBarHeight = _titleBarHeight;
@synthesize centerFullScreenButton = _centerFullScreenButton;
@synthesize centerTrafficLightButtons = _centerTrafficLightButtons;
@synthesize verticalTrafficLightButtons = _verticalTrafficLightButtons;
@synthesize hideTitleBarInFullScreen = _hideTitleBarInFullScreen;
//@synthesize titleBarDrawingBlock = _titleBarDrawingBlock;
@synthesize showsBaselineSeparator = _showsBaselineSeparator;
@synthesize fullScreenButtonRightMargin = _fullScreenButtonRightMargin;
@synthesize trafficLightButtonsLeftMargin = _trafficLightButtonsLeftMargin;
@synthesize titleBarStartColor = _titleBarStartColor;
@synthesize titleBarEndColor = _titleBarEndColor;
@synthesize baselineSeparatorColor = _baselineSeparatorColor;
@synthesize inactiveTitleBarStartColor = _inactiveTitleBarStartColor;
@synthesize inactiveTitleBarEndColor = _inactiveTitleBarEndColor;
@synthesize inactiveBaselineSeparatorColor = _inactiveBaselineSeparatorColor;

#pragma mark -
#pragma mark Initialization

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])) {
        [self _doInitialWindowSetup];
    }
    return self;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen
{
    if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen])) {
        [self _doInitialWindowSetup];
    }
    return self;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	//    [self setDelegate:nil];
#if !__has_feature(objc_arc)
	//    [_delegateProxy release];
    [_titleBarView release];
    [super dealloc];
#endif
}

#pragma mark -
#pragma mark NSWindow Overrides

- (void)becomeKeyWindow
{
    [super becomeKeyWindow];
    [self _updateTitlebarView];
    [self _layoutTrafficLightsAndContent];
    [self _setupTrafficLightsTrackingArea];
}

- (void)resignKeyWindow
{
    [super resignKeyWindow];
    [self _updateTitlebarView];
    [self _layoutTrafficLightsAndContent];
}

- (void)becomeMainWindow
{
    [super becomeMainWindow];
    [self _updateTitlebarView];
}

- (void)resignMainWindow
{
    [super resignMainWindow];
    [self _updateTitlebarView];
}

- (void)setContentView:(NSView *)aView
{
	//BasePanelContentView *view = [[BasePanelContentView alloc] init];
	//[super setContentView:view];
	
    [super setContentView:aView];
	
#if IN_COMPILING_LION
    if (IN_RUNNING_LION)
        [self layoutIfNeeded];
#endif
    
    [self _repositionContentView];
}

- (void)setTitle:(NSString *)aString
{
    [super setTitle:aString];
    [self _layoutTrafficLightsAndContent];
    [self _displayWindowAndTitlebar];
}

#pragma mark -
#pragma mark Accessors

- (void)setTitleBarView:(NSView *)newTitleBarView
{
    if ((_titleBarView != newTitleBarView) && newTitleBarView) {
        [_titleBarView removeFromSuperview];
#if __has_feature(objc_arc)
        _titleBarView = newTitleBarView;
#else
        [_titleBarView release];
        _titleBarView = [newTitleBarView retain];
#endif
        [_titleBarView setFrame:[_titleBarContainer bounds]];
        [_titleBarView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [_titleBarContainer addSubview:_titleBarView];
    }
}

- (NSView *)titleBarView
{
    return _titleBarView;
}

- (void)setTitleBarHeight:(CGFloat)newTitleBarHeight
{
    if (_titleBarHeight != newTitleBarHeight) {
        _cachedTitleBarHeight = newTitleBarHeight;
        _titleBarHeight = _cachedTitleBarHeight;
        [self _layoutTrafficLightsAndContent];
        [self _displayWindowAndTitlebar];
    }
}

- (CGFloat)titleBarHeight
{
    return _titleBarHeight;
}

- (void)setShowsBaselineSeparator:(BOOL)showsBaselineSeparator
{
    if (_showsBaselineSeparator != showsBaselineSeparator) {
        _showsBaselineSeparator = showsBaselineSeparator;
        [self.titleBarView setNeedsDisplay:YES];
    }
}

- (BOOL)showsBaselineSeparator
{
    return _showsBaselineSeparator;
}

- (void)setTrafficLightButtonsLeftMargin:(CGFloat)newTrafficLightButtonsLeftMargin
{
    if (_trafficLightButtonsLeftMargin != newTrafficLightButtonsLeftMargin) {
        _trafficLightButtonsLeftMargin = newTrafficLightButtonsLeftMargin;
        [self _layoutTrafficLightsAndContent];
        [self _displayWindowAndTitlebar];
        [self _setupTrafficLightsTrackingArea];
    }
}

- (CGFloat)trafficLightButtonsLeftMargin
{
    return _trafficLightButtonsLeftMargin;
}


- (void)setFullScreenButtonRightMargin:(CGFloat)newFullScreenButtonRightMargin
{
    if (_fullScreenButtonRightMargin != newFullScreenButtonRightMargin) {
        _setFullScreenButtonRightMargin = YES;
        _fullScreenButtonRightMargin = newFullScreenButtonRightMargin;
        [self _layoutTrafficLightsAndContent];
        [self _displayWindowAndTitlebar];
    }
}

- (CGFloat)fullScreenButtonRightMargin
{
    return _fullScreenButtonRightMargin;
}

- (void)setCenterFullScreenButton:(BOOL)centerFullScreenButton{
    if( _centerFullScreenButton != centerFullScreenButton ) {
        _centerFullScreenButton = centerFullScreenButton;
        [self _layoutTrafficLightsAndContent];
    }
}

- (void)setCenterTrafficLightButtons:(BOOL)centerTrafficLightButtons
{
    if ( _centerTrafficLightButtons != centerTrafficLightButtons ) {
        _centerTrafficLightButtons = centerTrafficLightButtons;
        [self _layoutTrafficLightsAndContent];
        [self _setupTrafficLightsTrackingArea];
    }
}


- (void)setVerticalTrafficLightButtons:(BOOL)verticalTrafficLightButtons
{
    if ( _verticalTrafficLightButtons != verticalTrafficLightButtons ) {
        _verticalTrafficLightButtons = verticalTrafficLightButtons;
        [self _layoutTrafficLightsAndContent];
        [self _setupTrafficLightsTrackingArea];
    }
}

- (void)setDelegate:(id<NSWindowDelegate>)anObject
{
    [_delegateProxy setSecondaryDelegate:anObject];
    [super setDelegate:nil];
    [super setDelegate:_delegateProxy];
}

- (id<NSWindowDelegate>)delegate
{
    return [_delegateProxy secondaryDelegate];
}

#pragma mark -
#pragma mark Private

- (void)_doInitialWindowSetup
{
    _showsBaselineSeparator = YES;
    _centerTrafficLightButtons = YES;
    _titleBarHeight = 26;//[self _minimumTitlebarHeight];
    _trafficLightButtonsLeftMargin = 13;//[self _defaultTrafficLightLeftMargin];
    _delegateProxy = [BasePanelDelegateProxy alloc];
    [super setDelegate:_delegateProxy];
    
    /** -----------------------------------------
     - The window automatically does layout every time its moved or resized, which means that the traffic lights and content view get reset at the original positions, so we need to put them back in place
     - NSWindow is hardcoded to redraw the traffic lights in a specific rect, so when they are moved down, only part of the buttons get redrawn, causing graphical artifacts. Therefore, the window must be force redrawn every time it becomes key/resigns key
     ----------------------------------------- **/
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(_layoutTrafficLightsAndContent) name:NSWindowDidResizeNotification object:self];
    [nc addObserver:self selector:@selector(_layoutTrafficLightsAndContent) name:NSWindowDidMoveNotification object:self];
    [nc addObserver:self selector:@selector(_layoutTrafficLightsAndContent) name:NSWindowDidEndSheetNotification object:self];
	
    [nc addObserver:self selector:@selector(_updateTitlebarView) name:NSApplicationDidBecomeActiveNotification object:nil];
    [nc addObserver:self selector:@selector(_updateTitlebarView) name:NSApplicationDidResignActiveNotification object:nil];
#if IN_COMPILING_LION
    if (IN_RUNNING_LION) {
        [nc addObserver:self selector:@selector(_setupTrafficLightsTrackingArea) name:NSWindowDidExitFullScreenNotification object:nil];
        [nc addObserver:self selector:@selector(windowWillEnterFullScreen:) name:NSWindowWillEnterFullScreenNotification object:nil];
        [nc addObserver:self selector:@selector(windowWillExitFullScreen:) name:NSWindowWillExitFullScreenNotification object:nil];
    }
#endif
    [self _createTitlebarView];
    [self _layoutTrafficLightsAndContent];
    [self _setupTrafficLightsTrackingArea];
}

- (void)_layoutTrafficLightsAndContent
{
    // Reposition/resize the title bar view as needed
    [self _recalculateFrameForTitleBarContainer];
    
    NSButton *close = [self standardWindowButton:NSWindowCloseButton];
    NSButton *minimize = [self standardWindowButton:NSWindowMiniaturizeButton];
    NSButton *zoom = [self standardWindowButton:NSWindowZoomButton];
    
    // Set the frame of the window buttons
    NSRect closeFrame = [close frame];
    NSRect minimizeFrame = [minimize frame];
    NSRect zoomFrame = [zoom frame];
    NSRect titleBarFrame = [_titleBarContainer frame];
    CGFloat buttonOrigin = 0.0;
    if ( !self.verticalTrafficLightButtons ) {
        if ( self.centerTrafficLightButtons ) {
            buttonOrigin = round(NSMidY(titleBarFrame) - BasePanelMidHeight(closeFrame));
        } else {
            buttonOrigin = NSMaxY(titleBarFrame) - NSHeight(closeFrame) - BaseButtonTopOffset;
        }
        closeFrame.origin.y = buttonOrigin;
        minimizeFrame.origin.y = buttonOrigin;
        zoomFrame.origin.y = buttonOrigin;
        closeFrame.origin.x = _trafficLightButtonsLeftMargin;
        minimizeFrame.origin.x = _trafficLightButtonsLeftMargin + [self _trafficLightSeparation];
        zoomFrame.origin.x = _trafficLightButtonsLeftMargin + [self _trafficLightSeparation] * 2;
    } else {
        // in vertical orientation, adjust spacing to match iTunes
        CGFloat groupHeight = NSHeight(closeFrame) + 2*([self _trafficLightSeparation]-2);
        if ( self.centerTrafficLightButtons ) {
            buttonOrigin = round( NSMidY(titleBarFrame) - 0.5*groupHeight );
        } else {
            buttonOrigin = NSMaxY(titleBarFrame) - groupHeight - BaseButtonTopOffset - 2;
        }
        closeFrame.origin.x = _trafficLightButtonsLeftMargin;
        minimizeFrame.origin.x = _trafficLightButtonsLeftMargin;
        zoomFrame.origin.x = _trafficLightButtonsLeftMargin;
        closeFrame.origin.y = buttonOrigin + 2*([self _trafficLightSeparation]-2);
        minimizeFrame.origin.y = buttonOrigin + ([self _trafficLightSeparation]-2);
        zoomFrame.origin.y = buttonOrigin;
    }
    [close setFrame:closeFrame];
    [minimize setFrame:minimizeFrame];
    [zoom setFrame:zoomFrame];
    
#if IN_COMPILING_LION
    // Set the frame of the FullScreen button in Lion if available
    if ( IN_RUNNING_LION ) {
        NSButton *fullScreen = [self standardWindowButton:NSWindowFullScreenButton];
        if( fullScreen ) {
            NSRect fullScreenFrame = [fullScreen frame];
            if ( !_setFullScreenButtonRightMargin ) {
                self.fullScreenButtonRightMargin = NSWidth([_titleBarContainer frame]) - NSMaxX(fullScreen.frame);
            }
            fullScreenFrame.origin.x = NSWidth(titleBarFrame) - NSWidth(fullScreenFrame) - _fullScreenButtonRightMargin;
            if( self.centerFullScreenButton ) {
                fullScreenFrame.origin.y = round(NSMidY(titleBarFrame) - BasePanelMidHeight(fullScreenFrame));
            } else {
                fullScreenFrame.origin.y = NSMaxY(titleBarFrame) - NSHeight(fullScreenFrame) - BaseButtonTopOffset;
            }
            [fullScreen setFrame:fullScreenFrame];
        }
    }
#endif
    
    [self _repositionContentView];
}

- (void)windowWillEnterFullScreen:(NSNotification *)notification
{
    if (_hideTitleBarInFullScreen) {
        // Recalculate the views when entering from fullscreen
        _titleBarHeight = 0.0f;
        [self _layoutTrafficLightsAndContent];
        [self _displayWindowAndTitlebar];
        
        [self _hideTitleBarView:YES];
    }
}

- (void)windowWillExitFullScreen:(NSNotification *)notification
{
    if (_hideTitleBarInFullScreen) {
        _titleBarHeight = _cachedTitleBarHeight;
        [self _layoutTrafficLightsAndContent];
        [self _displayWindowAndTitlebar];
        
        [self _hideTitleBarView:NO];
    }
}

- (void)_createTitlebarView
{
    // Create the title bar view
    BasePanelTitlebarContainer *container = [[BasePanelTitlebarContainer alloc] initWithFrame:NSZeroRect];
    // Configure the view properties and add it as a subview of the theme frame
    NSView *themeFrame = [[self contentView] superview];
    NSView *firstSubview = [[themeFrame subviews] objectAtIndex:0];
    [self _recalculateFrameForTitleBarContainer];
    [themeFrame addSubview:container positioned:NSWindowBelow relativeTo:firstSubview];
#if __has_feature(objc_arc)
    _titleBarContainer = container;
    self.titleBarView = [[BasePanelTitlebarView alloc] initWithFrame:NSZeroRect];
#else
    _titleBarContainer = [container autorelease];
    self.titleBarView = [[[BasePanelTitlebarView alloc] initWithFrame:NSZeroRect] autorelease];
#endif
}

- (void)_hideTitleBarView:(BOOL)hidden
{
    [self.titleBarView setHidden:hidden];
}

// Solution for tracking area issue thanks to @Perspx (Alex Rozanski) <https://gist.github.com/972958>
- (void)_setupTrafficLightsTrackingArea
{
    [[[self contentView] superview] viewWillStartLiveResize];
    [[[self contentView] superview] viewDidEndLiveResize];
}

- (void)_recalculateFrameForTitleBarContainer
{
    NSView *themeFrame = [[self contentView] superview];
    NSRect themeFrameRect = [themeFrame frame];
    NSRect titleFrame = NSMakeRect(0.0, NSMaxY(themeFrameRect) - _titleBarHeight, NSWidth(themeFrameRect), _titleBarHeight);
    [_titleBarContainer setFrame:titleFrame];
}

- (void)_repositionContentView
{
    NSView *contentView = [self contentView];
    NSRect windowFrame = [self frame];
    NSRect currentContentFrame = [contentView frame];
    NSRect newFrame = currentContentFrame;
	
    CGFloat titleHeight = NSHeight(windowFrame) - NSHeight(newFrame);
    CGFloat extraHeight = _titleBarHeight - titleHeight;
    newFrame.size.height -= extraHeight;
	
    if (!NSEqualRects(currentContentFrame, newFrame)) {
        [contentView setFrame:newFrame];
        [contentView setNeedsDisplay:YES];
    }
}

- (CGFloat)_minimumTitlebarHeight
{
    static CGFloat minTitleHeight = 0.0;
    if ( !minTitleHeight ) {
        NSRect frameRect = [self frame];
        NSRect contentRect = [self contentRectForFrameRect:frameRect];
        minTitleHeight = NSHeight(frameRect) - NSHeight(contentRect);
    }
    return minTitleHeight;
}

- (CGFloat)_defaultTrafficLightLeftMargin
{
    static CGFloat trafficLightLeftMargin = 0.0;
    if ( !trafficLightLeftMargin ) {
        NSButton *close = [self standardWindowButton:NSWindowCloseButton];
        trafficLightLeftMargin = NSMinX(close.frame);
    }
    return trafficLightLeftMargin;
}

- (CGFloat)_trafficLightSeparation
{
    static CGFloat trafficLightSeparation = 0.0;
    if ( !trafficLightSeparation ) {
        NSButton *close = [self standardWindowButton:NSWindowCloseButton];
        NSButton *minimize = [self standardWindowButton:NSWindowMiniaturizeButton];
        trafficLightSeparation = NSMinX(minimize.frame) - NSMinX(close.frame);
    }
    return trafficLightSeparation;
}

- (void)_displayWindowAndTitlebar
{
    // Redraw the window and titlebar
    [_titleBarView setNeedsDisplay:YES];
}


- (void)_updateTitlebarView
{
    [_titleBarView setNeedsDisplay:YES];
	
    // "validate" any controls in the titlebar view
    BOOL isMainWindowAndActive = ([self isMainWindow] && [[NSApplication sharedApplication] isActive]);
    for (NSView *childView in [_titleBarView subviews]) {
        if ([childView isKindOfClass:[NSControl class]]) {
            [(NSControl *)childView setEnabled:isMainWindowAndActive];
        }
    }
}

@end
