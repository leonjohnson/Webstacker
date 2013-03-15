//
//  CustomScrollView.m
//  designer
//
//  Created by Bai Jin on 3/2/13.
//
//

#import "CustomScrollView.h"

@implementation CustomScrollView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

/*- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}*/

- (void)scrollWheel:(NSEvent *)theEvent
{
	NSRect rtDoc = [self documentVisibleRect];
	NSRect rtFrame = [[self documentView] frame];
	
	if (rtDoc.origin.x + rtDoc.size.width >= rtFrame.size.width - 100) {
		rtFrame.size.width += 50;
		[[self documentView] setFrame:rtFrame];
	}
	
	if (rtDoc.origin.y + rtDoc.size.height >= rtFrame.size.height - 100) {
		rtFrame.size.height += 50;
		[[self documentView] setFrame:rtFrame];
	}
	
	[super scrollWheel:theEvent];
}

@end
