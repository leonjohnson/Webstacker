#import <Foundation/Foundation.h>


/*
 DrawShapeTypeDelegate is delegate to notify the creating shape of galleryView.
 Once user drag and drop shape from galleryView's ShapeTableView, new shape type is create to stageView.
 */
@protocol DrawShapeDelegate <NSObject>


/*
 @function:		createShape
 @params:		index:		index of the new shape
				pos:		position of the new shape
 @return:       void
 @purpose:		This function body's definition is implemented at GalleryView.m file.
				This function create the new shape from the gallery view.
 */
- (void)createElement:(NSInteger)index pos:(NSPoint)pt;

@end
