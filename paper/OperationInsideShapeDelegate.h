#import <Foundation/Foundation.h>


@class Element;

/*
 OperationInsideShapeDelegate is the delegate to notify inside of the shape.
 This function called when the user drag and drop inside of the shape.
 */
@protocol OperationInsideElementDelegate <NSObject>


/*
 @function:		isInsideShape
 @params:		shape:   current shape object
 @return:       This is inside of the shape, return TRUE. otherwise FALSE.
 @purpose:		This function body's definition is implemented at StageView.m file.
				The purpose is to check that the current shape is inside of the another shape.
 */
- (BOOL)isInsideElement:(Element*)element;


/*
 @function:		selectCurrentShape
 @params:		shape:	current shape object
 @return:		void
 @purpose:		The purpose is to select only shape param.
 */
- (void)selectCurrentElement:(Element*)element;

@end
