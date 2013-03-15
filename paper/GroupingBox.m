#import "GroupingBox.h"

@implementation GroupingBox

@synthesize insideTheBox;
@synthesize marginTop;
@synthesize marginRight;
//@synthesize highestYcoordiante;
@synthesize idPreviouslyKnownAs;
@synthesize nestedGroupingBoxes;

@synthesize xcoordinate, ycoordinate, width, height;
@synthesize highestElementYco, lowestElementBottomYco;


- (void)setBoundRect:(NSRect)rt
{
	rtFrame = CGRectStandardize(rt);
    [self setFrame:CGRectMake(rtFrame.origin.x - 2, rtFrame.origin.y - 2, rtFrame.size.width + 8, rtFrame.size.height + 8)];
	[self setNeedsDisplay:YES];
}

- (NSInteger)IsPointInElement:(NSPoint)pt
{
	return SHT_NONE;
}

@end