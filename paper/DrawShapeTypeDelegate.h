#import <Foundation/Foundation.h>
#import "Element.h"


/*
 DrawShapeTypeDelegate is delegate to notify the changed shape type of galleryView.
 Once user changed shape type from galleryView's ShapeTableView, new shape type is set to stageView.
 */
@protocol DrawShapeTypeDelegate <NSObject>


/*
 @function:		setDrawShapeType
 @params:		type:   new shape type
 @return:       void
 @purpose:		This function body's definition is implemented at StageView.m file.
				This function set the current shape type from param 'type'.
 */
- (void)setDrawElementType:(ElementType)type;

/*
 @function:		createShapeByDrag
 @params:		type:	new shape type
				pt:		new shape's position
 @return:		void
 @purpos:		This function body's definition is implemented at StageView.m file.
				This function create the new shape by 'type' and position with pt.
 */
- (void)createElementByDrag:(ElementType)type pos:(NSPoint)pt;

@end
