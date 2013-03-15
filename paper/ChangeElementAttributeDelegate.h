#import <Foundation/Foundation.h>


/*
 ChangeShapeAttributeDelegate is the delegate to notify the shape attribute to the shape from AttributePanel.
 This function called when the user change the value of the stepper in Attribute and
 set to the attribue of the shape by value.
 */
@protocol ChangeElementAttributeDelegate <NSObject>


/*
 @function:		ChangeAttribueOfShape
 @params:		offset:		The value to change
				hitTest:	The type of value (Moving: SHT_MOVEAPEX, Resizing: SHT_RESIZE)
 @return:		void
 @purpos:		Set the attribute of shape by changing stepper in AttributePanel.
 */
- (void)ChangeAttribueOfElement:(CGSize)offset HitTest:(NSInteger)hitTest;

@end
