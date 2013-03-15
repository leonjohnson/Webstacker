#import <AppKit/AppKit.h>
#import "DrawShapeDelegate.h"

@interface NSGalleryTableView : NSTableView
{
	id<DrawShapeDelegate>					drawShapeDelegate;
	
	BOOL									isDrag;
	NSInteger								DragIndex;
}

@property (assign) id<DrawShapeDelegate>				drawShapeDelegate;
@property (assign) BOOL									isDrag;
@property (assign) NSInteger							DragIndex;

@end
