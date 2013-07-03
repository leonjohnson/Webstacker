#import <Foundation/Foundation.h>
#import "SetAttributeDelegate.h"
#import "ChangeElementAttributeDelegate.h"
#import "BasePanel.h"

@class Element;

/*
 AttributePanel is the shape's attribute panel.
 Attribute panel contains 4 NSStepper and 4 NSTextField.
 Each NSStepper and NSTextField point to the shape's attribue(position and size).
 */
@interface AttributePanel : BasePanel <
NSTabViewDelegate,
NSTableViewDataSource,
NSTableViewDelegate,
SetAttributeDelegate
>
{
	
	/*
	 for general tab
	 */
	IBOutlet NSStepper				*xStepper;
	IBOutlet NSTextField			*xTextField;
	
	IBOutlet NSStepper				*yStepper;
	IBOutlet NSTextField			*yTextField;
	
	IBOutlet NSStepper				*wStepper;
	IBOutlet NSTextField			*wTextField;
	
	IBOutlet NSStepper				*hStepper;
	IBOutlet NSTextField			*hTextField;
    
    IBOutlet NSTextField			*urlTextField;
    
    //Layout type - px or %
    IBOutlet NSPopUpButton *layoutTypeDisplay;
	
	id<ChangeElementAttributeDelegate>		changeAttributeDelegate;
	
	
	/*
	 for effect tab
	*/
	NSInteger										indexOfShadow;
	IBOutlet NSTableView							*_tableViewShadowList;
	NSMutableArray									*_arrayShadows;
}


@property (assign) id<ChangeElementAttributeDelegate>		changeAttributeDelegate;
@property (assign, nonatomic) IBOutlet NSPopUpButton *layoutTypeDisplay;
@property (assign) IBOutlet NSTextField						*RadioField;
@property (assign) IBOutlet NSSlider						*RadioSlider;
@property (assign) IBOutlet NSTextField						*DistanceField;
@property (assign) IBOutlet NSSlider						*DistanceSlider;
@property (assign) IBOutlet NSColorWell						*ColorWell;
@property (assign) IBOutlet NSTextField						*OpacityField;
@property (assign) IBOutlet NSSlider						*OpacitySlider;
@property (assign) IBOutlet NSSlider						*BlurSlider;
@property (assign) IBOutlet NSTextField						*BlurField;
@property (assign) IBOutlet NSMatrix						*Direction;
@property (assign) IBOutlet NSTabView						*_tabView;


//- (void)setTab:(NSInteger)index;
- (IBAction)OnGeneralTab:(id)sender;
- (IBAction)OnEffectTab:(id)sender;
- (IBAction)OnDataTab:(id)sender;
- (IBAction)OnContextualTab:(id)sender;


#pragma mark for general tab
/*
 @function:		OnXStepperClicked
 @purpose:		This function called when the user clicked the xStepper
 */
- (IBAction)OnXStepperClicked:(id)sender;


/*
 @function:		OnYStepperClicked
 @purpose:		This function called when the user clicked the yStepper
 */
- (IBAction)OnYStepperClicked:(id)sender;


/*
 @function:		OnWStepperClicked
 @purpose:		This function called when the user clicked the wStepper
 */
- (IBAction)OnWStepperClicked:(id)sender;


/*
 @function:		OnHStepperClicked
 @purpose:		This function called when the user clicked the hStepper
 */
- (IBAction)OnHStepperClicked:(id)sender;


/*
 @function:		SetStepperValue
 @params:		x:	value of the xStepper
				y:	value of the yStepper
				w:	value of the wStepper
				h:	value of the hStepper
 @return:		nothing
 @purpos:		This function set the value of the steppers
 */
- (void)SetStepperValue:(CGFloat)x yPos:(CGFloat)y Width:(CGFloat)w Height:(CGFloat)h;



/*
 @function:		SetShapeAttributeByStepper
 @params:		offset:		The value to change
				hitTest:	The type of value (Moving: SHT_MOVEAPEX, Resizing: SHT_RESIZE)
 @return:		void
 @purpos:		This function set the attribute of the shape by stepper value
 */
- (void)SetShapeAttributeByStepper:(NSSize)offset HitTest:(NSInteger)hitTest;

- (CGSize)stepperValues;
-(IBAction)setLayout:(id)sender;


#pragma mark for effect tab

/*
 @function:		OnRadioSlider
 @purpose:		This function called when the user controls the Radio Slider
 */
- (IBAction)OnRadioSlider:(id)sender;

/*
 @function:		OnDistanceSlider
 @purpose:		This function called when the user controls the Distance Slider
 */
- (IBAction)OnDistanceSlider:(id)sender;

/*
 @function:		OnColorChange
 @purpose:		This function called when the user clicked the Color Well
 */
- (IBAction)OnColorChange:(id)sender;

/*
 @function:		OnOpacitySlider
 @purpose:		This function called when the user controls the Opacity Slider
 */
- (IBAction)OnOpacitySlider:(id)sender;

/*
 @function:		OnBlurSlider
 @purpose:		This function called when the user controls the Blur Slider
 */
- (IBAction)OnBlurSlider:(id)sender;

/*
 @function:		OnDirectionChange
 @purpose:		This function called when the user clicked the Direction Matrix
 */
- (IBAction)OnDirectionChange:(id)sender;

/*
 @function:		OnAddShadow
 @purpose:		This function called when the user clicked the Create New Shadow Button
 */
- (IBAction)OnAddShadow:(id)sender;

/*
 @function:		OnRemoveShadow
 @purpose:		This function called when the user clicked the Remove Button
 */
- (IBAction)OnRemoveShadow:(id)sender;

@end
