#import <AppKit/AppKit.h>
#import "DrawShapeDelegate.h"

@interface NSGalleryTableView : NSTableView
{
	id<DrawShapeDelegate>					__strong drawShapeDelegate;
	
	BOOL									isDrag;
	NSInteger								DragIndex;
}

@property (strong) id<DrawShapeDelegate>				drawShapeDelegate;
@property (assign) BOOL									isDrag;
@property (assign) NSInteger							DragIndex;

@end
