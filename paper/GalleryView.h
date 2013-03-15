#import <Cocoa/Cocoa.h>
#import "DrawShapeDelegate.h"
#import "DrawShapeTypeDelegate.h"
#import "NSGalleryTableView.h"
#import "BasePanel.h"


@interface GalleryView : BasePanel
<NSTableViewDataSource, NSTableViewDelegate, DrawShapeDelegate>
{
	NSMutableArray						*ElementTableDataSource;
	
	id<DrawShapeTypeDelegate>			delegate;
}

// ShapeTableView contains various shapes
@property (assign, nonatomic) IBOutlet NSGalleryTableView			*ShapeTableView;
@property (assign) id<DrawShapeTypeDelegate>						delegate;

/*
 @function:		initElementTableData
 @params:		nothing
 @purpose:		initialize ShapeTableView's data source.
 It examines png files from resource, add the file to the ShapeTableDataSource array that name's prefix is "shape_".
 For example, shape_circle.png file in resource is added to array as shape_circle.png.
 
 If you want to add new shape type, please add new file to resource by inserting a prefix shape_ to the file name.
 */
- (void)initElementTableData;
@end
