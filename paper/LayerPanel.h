//
//  LayerPanel.h
//  DrawShap
//
//  Created by Bai Jin on 12/6/12.
//  Copyright (c) 2012 Cosmo Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SetLayerOrderDelegate.h"
#import "BasePanel.h"

@interface LayerPanel : BasePanel
<NSTableViewDataSource, NSTableViewDelegate, SetLayerOrderDelegate>
{
	IBOutlet NSTableView						*_tableViewLayer;
}

/*
 @function:			OnVisible
 @purpose:			This function called when the user click the visible check box of layer table.
 */
- (IBAction)OnVisible:(id)sender;

- (void)doubleClickOnTable:(id)sender;

@end
