//
//  AligmentPanel.h
//  DrawShap
//
//  Created by Wang Ming on 7/16/12.
//  Copyright (c) 2012 Cosmo Software. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "BasePanel.h"

@interface AlignmentPanel : BasePanel
{
	IBOutlet NSTextField				*spacingTextField;
}


/*
 @function: OnAlignLeftButton
 @purpos:	This function called when the user click the align left button.
 */
- (IBAction)OnAlignLeftButton:(id)sender;


/*
 @function: OnAlignRightButton
 @purpos:	This function called when the user click the align right button.
 */
- (IBAction)OnAlignRightButton:(id)sender;


/*
 @function: OnAlignCenterVertButton
 @purpos:	This function called when the user click the align center vertically button.
 */
- (IBAction)OnAlignCenterVertButton:(id)sender;


/*
 @function: OnAlignTopButton
 @purpos:	This function called when the user click the align top button.
 */
- (IBAction)OnAlignTopButton:(id)sender;


/*
 @function: OnAlignBottomButton
 @purpos:	This function called when the user click the align bottom button.
 */
- (IBAction)OnAlignBottomButton:(id)sender;


/*
 @function:	OnAlignCenterHorzButton
 @purpos:	This function called when the user click the align center horizently button.
 */
- (IBAction)OnAlignCenterHorzButton:(id)sender;


/*
 @function: OnAlignDistributionLeftButton
 @purpos:	This function called when the user click the distribution left button.
 */
- (IBAction)OnAlignDistributionLeftButton:(id)sender;


/*
 @function: OnAlignDistributionRightButton
 @purpos:	This function called when the user click the distribution right button.
 */
- (IBAction)OnAlignDistributionRightButton:(id)sender;


/*
 @function: OnAlignDistributionCenterButton
 @purpos:	This function called when the user click the distribution center button.
 */
- (IBAction)OnAlignDistributionCenterButton:(id)sender;


/*
 @function:	OnSpaceEvenlyHorzButton
 @purpos:	This function called when the user click the space evenly horizently button.
 */
- (IBAction)OnSpaceEvenlyHorzButton:(id)sender;


/*
 @function: OnSpaceEvenlyVertButton
 @purpos:	This function called when the user click the space evenly vertically button.
 */
- (IBAction)OnSpaceEvenlyVertButton:(id)sender;


@end
