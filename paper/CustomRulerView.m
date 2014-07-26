//
//  CustomRulerView.m
//  designer
//
//  Created by Bai Jin on 2/22/13.
//
//

#import "CustomRulerView.h"
#import "NSMeasurementUnit.h"
#import <Quartz/Quartz.h>


#define DEFAULT_RULE_THICKNESS      15.0
#define DEFAULT_MARKER_THICKNESS    15.0

@implementation CustomRulerView

- initWithScrollView:(NSScrollView *)scrollView orientation:(NSRulerOrientation)orientation
{
	self = [super initWithScrollView:scrollView orientation:orientation];
	if (self) {
		NSRect frame = [scrollView frame];
		
		if (orientation == NSHorizontalRuler)
		{
			frame.size.height = DEFAULT_RULE_THICKNESS;
		}
		else
		{
			frame.size.width = DEFAULT_RULE_THICKNESS;
		}
		
		//_measurementUnit = [NSMeasurementUnit measurementUnitNamed:@"Inches"];
		
		[self setRuleThickness:DEFAULT_RULE_THICKNESS]; // height of rulerview
		[self setReservedThicknessForMarkers:DEFAULT_MARKER_THICKNESS];
		[self setReservedThicknessForAccessoryView:0.0];		
	}
    
    return self;
}


- (NSDictionary *)attributesForMarkString
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    
    [style setLineBreakMode:NSLineBreakByClipping];
    [style setAlignment:NSLeftTextAlignment];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
			[NSFont systemFontOfSize:9], NSFontAttributeName,
			style, NSParagraphStyleAttributeName,
			[NSColor grayColor], NSForegroundColorAttributeName,
			nil];
}

- (void)drawHashMarksAndLabelsInRect:(NSRect)rect
{
	float pointsPerUnit = 1.0; // it is point now
	int from, to;
	int count = ceil(((self.orientation == NSHorizontalRuler)? rect.size.width: rect.size.height) / pointsPerUnit) / 10;
	int unitNum;
	NSRect rtUnit = rect, lineUnit;
	NSPoint ptMark;
	
	if (self.orientation == NSHorizontalRuler) {
		from = rect.origin.x + self.scrollView.documentVisibleRect.origin.x;
		to = from + rect.size.width;
		
		unitNum = from / 10 - 3;
		
		rtUnit.origin.x = rect.origin.x - (from % 10);
		rtUnit.origin.y = 0;
		rtUnit.size.width = pointsPerUnit * 10;
		rtUnit.size.height = self.bounds.size.height;
		
		lineUnit.origin.x = rtUnit.origin.x - 1;
		lineUnit.origin.y = (((unitNum+1) % 10 == 0)? 0: rect.size.height / 2);
		lineUnit.size.width = 1;
		lineUnit.size.height = (((unitNum+1) % 10 == 0)? rect.size.height: rect.size.height / 2);
		
		ptMark.x = rtUnit.origin.x - 3 * pointsPerUnit * 10;
		ptMark.y = 3;
	} else {
		from = rect.origin.y + self.scrollView.documentVisibleRect.origin.y;
		to = from + rect.size.height;
		
		unitNum = from / 10;
		
		rtUnit.origin.x = 0;
		rtUnit.origin.y = rect.origin.y - (from % 10);
		rtUnit.size.width = self.bounds.size.width;
		rtUnit.size.height = pointsPerUnit * 10;
		
		lineUnit.origin.x = (((unitNum+1) % 10 == 0)? 0: rect.size.width / 2);
		lineUnit.origin.y = rtUnit.origin.y - 1;
		lineUnit.size.width = (((unitNum+1) % 10 == 0)? rect.size.width: rect.size.width / 2);
		lineUnit.size.height = 1;
		
		ptMark.x = 3;
		ptMark.y = rtUnit.origin.y - 3 * pointsPerUnit * 10;
	}
	
	// draw uint
	for (int i = unitNum; i <= unitNum + count + 7; i ++) {
		[[NSColor whiteColor] setFill];
		NSBezierPath *path = [NSBezierPath bezierPathWithRect:rtUnit];
		[path fill];
		
		[[NSColor lightGrayColor] setFill];
		path = [NSBezierPath bezierPathWithRect:lineUnit];
		[path fill];
		
		if (self.orientation == NSHorizontalRuler) {
			rtUnit.origin.x += pointsPerUnit * 10 ;
			
			lineUnit.origin.x += pointsPerUnit * 10;
			lineUnit.origin.y = (((i+1) % 10 == 0)? 0: rect.size.height * 0.65);
			lineUnit.size.height = (((i+1) % 10 == 0)? rect.size.height: rect.size.height * 0.35);
		} else {
			rtUnit.origin.y += pointsPerUnit * 10;
			
			lineUnit.origin.x = (((i+1) % 10 == 0)? 0: rect.size.width * 0.65);
			lineUnit.origin.y += pointsPerUnit * 10;
			lineUnit.size.width = (((i+1) % 10 == 0)? rect.size.width: rect.size.width * 0.35);
		}
	}
	
	// draw mark
	for (int i = unitNum - 3; i <= unitNum + count + 7; i ++) {
		if (i % 10 == 0) {
			NSString *strMark = [NSString stringWithFormat:@"%d", i * 10];
			[strMark drawAtPoint:ptMark withAttributes:[self attributesForMarkString]];
		}
		
		if (self.orientation == NSHorizontalRuler) {
			ptMark.x += pointsPerUnit * 10;
		} else {
			ptMark.y += pointsPerUnit * 10;
		}
	}
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor whiteColor] set];
	NSRectFill(dirtyRect);
	
	NSRect rtBar = dirtyRect;
	
	if (self.orientation == NSHorizontalRuler) {
		rtBar.origin.y += rtBar.size.height - 1;
		rtBar.size.height = 1;
	} else {
		rtBar.origin.x += rtBar.size.width - 1;
		rtBar.size.width = 1;
	}
	
	[self drawHashMarksAndLabelsInRect:dirtyRect];
	
	[[NSColor lightGrayColor] set];
	NSRectFill(rtBar);
}


@end
