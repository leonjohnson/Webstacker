//
//  AligmentPanel.m
//  DrawShap
//
//  Created by Wang Ming on 7/16/12.
//  Copyright (c) 2012 Cosmo Software. All rights reserved.
//

#import "AlignmentPanel.h"
#import "Document.h"

@implementation AlignmentPanel


#pragma mak - button action implementation

/*
 @function: OnAlignLeftButton
 @purpos:	This function called when the user click the align left button.
 */
- (IBAction)OnAlignLeftButton:(id)sender
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc OnAlignLeftButton];
}


/*
 @function: OnAlignRightButton
 @purpos:	This function called when the user click the align right button.
 */
- (IBAction)OnAlignRightButton:(id)sender
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc OnAlignRightButton];
}


/*
 @function: OnAlignCenterVertButton
 @purpos:	This function called when the user click the align center vertically button.
 */
- (IBAction)OnAlignCenterVertButton:(id)sender
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc OnAlignCenterVertButton];
}


/*
 @function: OnAlignTopButton
 @purpos:	This function called when the user click the align top button.
 */
- (IBAction)OnAlignTopButton:(id)sender
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc OnAlignTopButton];
}


/*
 @function: OnAlignBottomButton
 @purpos:	This function called when the user click the align bottom button.
 */
- (IBAction)OnAlignBottomButton:(id)sender
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc OnAlignBottomButton];
}


/*
 @function:	OnAlignCenterHorzButton
 @purpos:	This function called when the user click the align center horizently button.
 */
- (IBAction)OnAlignCenterHorzButton:(id)sender
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc OnAlignCenterHorzButton];
}


/*
 @function: OnAlignDistributionLeftButton
 @purpos:	This function called when the user click the distribution left button.
 */
- (IBAction)OnAlignDistributionLeftButton:(id)sender
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc OnAlignDistributionLeftButton];
}


/*
 @function: OnAlignDistributionRightButton
 @purpos:	This function called when the user click the distribution right button.
 */
- (IBAction)OnAlignDistributionRightButton:(id)sender
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc OnAlignDistributionRightButton];
}


/*
 @function: OnAlignDistributionCenterButton
 @purpos:	This function called when the user click the distribution center button.
 */
- (IBAction)OnAlignDistributionCenterButton:(id)sender
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc OnAlignDistributionCenterButton];
}


/*
 @function:	OnSpaceEvenlyHorzButton
 @purpos:	This function called when the user click the space evenly horizently button.
 */
- (IBAction)OnSpaceEvenlyHorzButton:(id)sender
{
	NSInteger spacing = [spacingTextField integerValue];
	
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc OnSpaceEvenlyHorzButton:spacing];
}


/*
 @function: OnSpaceEvenlyVertButton
 @purpos:	This function called when the user click the space evenly vertically button.
 */
- (IBAction)OnSpaceEvenlyVertButton:(id)sender
{
	NSInteger spacing = [spacingTextField integerValue];
	
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc OnSpaceEvenlyVertButton:spacing];
}


@end
