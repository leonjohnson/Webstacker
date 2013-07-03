//
//  DataSourcePanel.h
//  DrawShap
//
//  Created by Bai Jin on 1/10/13.
//  Copyright (c) 2013 Cosmo Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasePanel.h"

@interface DataSourcePanel : BasePanel <NSTableViewDataSource, NSTableViewDelegate>
{
	NSMutableArray					*_arrayDataSource;
	IBOutlet NSTableView			*_tableView;
}

/*
 @function:	initDataSource
 @params:	nothing
 @return:	void
 @purpose:	This function  inits the _arrayDataSource from AppDelegate's arrayDataSource and reload the table view.
 */
- (void)initDataSource;

/*
 @function:	OnEdit
 @purpose:	This function called when the user click the edit button.
 */
- (IBAction)OnEdit:(id)sender;

@end
