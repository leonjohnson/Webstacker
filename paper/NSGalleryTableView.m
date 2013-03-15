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
    NSGradient *    gradient;
    NSColor *       pathColor;
	
	// if the view is focused, use highlight color, otherwise use the out-of-focus highlight color
    if (self == [[self window] firstResponder] && [[self window] isMainWindow] && [[self window] isKeyWindow])
    {
        gradient = [[[NSGradient alloc] initWithColorsAndLocations:
                     [NSColor colorWithDeviceRed:0.172 green:0.366 blue:0.806 alpha:1.0], 0.0,
                     [NSColor colorWithDeviceRed:0.085 green:0.431 blue:0.736 alpha:1.0], 1.0, nil] retain]; //160 80
		
        pathColor = [[NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.5 alpha:1.0] retain];
    }
    else
    {
        gradient = [[[NSGradient alloc] initWithColorsAndLocations:
                     [NSColor colorWithDeviceRed:0.172 green:0.366 blue:0.806 alpha:1.0], 0.1,
                     [NSColor colorWithDeviceRed:0.085 green:0.17 blue:0.436 alpha:1.0], 0.7, nil] retain]; //160 80
		
        pathColor = [[NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.5 alpha:1.0] retain];
    }
	
	// draw highlight for the visible, selected rows
    for (aRow; aRow < anEndRow; aRow++)
    {
        if([aSelectedRowIndexes containsIndex:aRow])
        {
            NSRect aRowRect = NSInsetRect([self rectOfRow:aRow], 1, 2); //first is horizontal, second is vertical
            NSBezierPath * path = [NSBezierPath bezierPathWithRoundedRect:aRowRect xRadius:2.0 yRadius:2.0]; //6.0
			[path setLineWidth: 2];
			[pathColor set];
			[path stroke];
			
            [gradient drawInBezierPath:path angle:90];
		}
    }
}

@end
