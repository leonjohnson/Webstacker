#import <Foundation/Foundation.h>


/*
 ChangeDocumentSettingDelegate is the delegate to notify the shape attribute to the shape from AttributePanel.
 This function called when the user change the value of the stepper in Attribute and
 set to the attribue of the shape by value.
 */
@protocol ChangeDocumentSettingDelegate <NSObject>


/*
 @function:		ChangeDocumentSettings
 @return:		void
 @purpos:		Set the attribute of shape by changing stepper in AttributePanel.
 */
- (void)ChangeDocumentSettings;

@end