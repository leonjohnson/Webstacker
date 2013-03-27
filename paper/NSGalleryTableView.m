#import "NSGalleryTableView.h"

@implementation NSGalleryTableView

@synthesize drawShapeDelegate;
@synthesize isDrag;
@synthesize DragIndex;

- (void)draggingEnded:(id <NSDraggingInfo>)sender
{
	
	if (isDrag == YES) {
		NSPoint pt = [sender draggingLocation];
		pt = [self convertPoint:pt toView:nil];
		
		if (drawShapeDelegate) {
			[drawShapeDelegate createElement:DragIndex pos:pt];
		}
	}
	
	isDrag = NO;
    NSLog(@"Called from NSGalleryTableView");
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
	NSLog( @"TalbeView: dragging Exited" );
	NSLog(@"Coordinate is : %@", NSStringFromPoint([sender draggingLocation]) );
	[self.dataSource tableView:self validateDrop:sender proposedRow:0 proposedDropOperation:NSTableViewDropOn];
}

- (void)dragImage:(NSImage *)anImage at:(NSPoint)viewLocation offset:(NSSize)initialOffset event:(NSEvent *)event pasteboard:(NSPasteboard *)pboard source:(id)sourceObj slideBack:(BOOL)slideFlag
{
	[super dragImage:anImage at:viewLocation offset:initialOffset event:event pasteboard:pboard source:sourceObj slideBack:NO];
}

- (void)highlightSelectionInClipRect:(NSRect)clipRect
{
	NSRange         aVisibleRowIndexes = [self rowsInRect:clipRect];
    NSIndexSet *    aSelectedRowIndexes = [self selectedRowIndexes];
    NSInteger       aRow = aVisibleRowIndexes.location;
    NSInteger       anEndRow = aRow + aVisibleRowIndexes.length;
    //NSGradient *    gradient;
    NSColor *       pathColor;
    
    //// General Declarations
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    //// Color Declarations
    NSColor* color = [NSColor colorWithCalibratedRed: 0.172 green: 0.366 blue: 0.806 alpha: 1];
    NSColor* color2 = [NSColor colorWithCalibratedRed: 0.085 green: 0.431 blue: 0.736 alpha: 1];
    NSColor* shadowColor2 = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 0.41];
    NSColor* dropShadowColor = [NSColor colorWithCalibratedRed: 0 green: 0 blue: 0 alpha: 0.34];
    
    //// Gradient Declarations
    NSGradient* gradient = [[NSGradient alloc] initWithStartingColor: color endingColor: color2];
    
    //// Shadow Declarations
    NSShadow* highlightTableRow = [[NSShadow alloc] init];
    [highlightTableRow setShadowColor: shadowColor2];
    [highlightTableRow setShadowOffset: NSMakeSize(-1.1, -1.1)];
    [highlightTableRow setShadowBlurRadius: 1];
    NSShadow* dropShadow = [[NSShadow alloc] init];
    [dropShadow setShadowColor: dropShadowColor];
    [dropShadow setShadowOffset: NSMakeSize(5.1, 5.1)];
    [dropShadow setShadowBlurRadius: 37];
    

	
	// if the view is focused, use highlight color, otherwise use the out-of-focus highlight color
    if (self == [[self window] firstResponder] && [[self window] isMainWindow] && [[self window] isKeyWindow])
    {
        /*
         gradient = [[[NSGradient alloc] initWithColorsAndLocations:
                     [NSColor colorWithDeviceRed:0.172 green:0.366 blue:0.806 alpha:1.0], 0.0,
                     [NSColor colorWithDeviceRed:0.085 green:0.431 blue:0.736 alpha:1.0], 1.0, nil] retain]; //160 80
        */
		
        pathColor = [[NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.5 alpha:1.0] retain];
    }
    else
    {
        /*
        gradient = [[[NSGradient alloc] initWithColorsAndLocations:
                     [NSColor colorWithDeviceRed:0.172 green:0.366 blue:0.806 alpha:1.0], 0.1,
                     [NSColor colorWithDeviceRed:0.085 green:0.17 blue:0.436 alpha:1.0], 0.7, nil] retain]; //160 80
         */
		
        pathColor = [[NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.5 alpha:1.0] retain];
    }
	
	// draw highlight for the visible, selected rows
    for (aRow; aRow < anEndRow; aRow++)
    {
        if([aSelectedRowIndexes containsIndex:aRow])
        {
            
            
            
            
            
            
            
            //// Rectangle Drawing
            //NSBezierPath* path = [NSBezierPath bezierPathWithRect: NSMakeRect(17.5, 14.5, 240, 31)];
            [NSGraphicsContext saveGraphicsState];
            [dropShadow set];
            CGContextBeginTransparencyLayer(context, NULL);
            //[gradient drawInBezierPath: path angle: -90];
            NSRect aRowRect = NSInsetRect([self rectOfRow:aRow], 2, 2); //first is horizontal, second is vertical
            NSBezierPath * path = [NSBezierPath bezierPathWithRoundedRect:aRowRect xRadius:1.0 yRadius:1.0]; //6.0
			[path setLineWidth: 1];
			[pathColor set];
			[path stroke];
            [gradient drawInBezierPath:path angle:-90];
            CGContextEndTransparencyLayer(context);
            
            ////// Rectangle Inner Shadow
            NSRect rectangleBorderRect = NSInsetRect([path bounds], -highlightTableRow.shadowBlurRadius, -highlightTableRow.shadowBlurRadius);
            rectangleBorderRect = NSOffsetRect(rectangleBorderRect, -highlightTableRow.shadowOffset.width, highlightTableRow.shadowOffset.height);
            rectangleBorderRect = NSInsetRect(NSUnionRect(rectangleBorderRect, [path bounds]), -1, -1);
            
            NSBezierPath* rectangleNegativePath = [NSBezierPath bezierPathWithRect: rectangleBorderRect];
            [rectangleNegativePath appendBezierPath: path];
            [rectangleNegativePath setWindingRule: NSEvenOddWindingRule];
            
            [NSGraphicsContext saveGraphicsState];
            {
                NSShadow* highlightTableRowWithOffset = [highlightTableRow copy];
                CGFloat xOffset = highlightTableRowWithOffset.shadowOffset.width + round(rectangleBorderRect.size.width);
                CGFloat yOffset = highlightTableRowWithOffset.shadowOffset.height;
                highlightTableRowWithOffset.shadowOffset = NSMakeSize(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset));
                [highlightTableRowWithOffset set];
                [[NSColor grayColor] setFill];
                [path addClip];
                NSAffineTransform* transform = [NSAffineTransform transform];
                [transform translateXBy: -round(rectangleBorderRect.size.width) yBy: 0];
                [[transform transformBezierPath: rectangleNegativePath] fill];
            }
            [NSGraphicsContext restoreGraphicsState];
            
            [NSGraphicsContext restoreGraphicsState];
            
            [[NSColor blackColor] setStroke];
            [path setLineWidth: 1];
            [path stroke];
		}
    }
}

@end
