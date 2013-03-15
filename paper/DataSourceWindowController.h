//
//  DataSourceWindowController.h
//  DrawShap
//
//  Created by Bai Jin on 1/10/13.
//  Copyright (c) 2013 Cosmo Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HeaderTextDelegate.h"
#import "HeaderTextField.h"
#import "DataSourceTableView.h"

@interface DataSourceWindowController : NSWindowController
<
NSWindowDelegate,
NSTableViewDataSource,
NSTableViewDelegate,
HeaderTextDelegate
>
{
	NSInteger								_index;
	NSMutableArray							*_arrayDataSource;
	
	IBOutlet NSScrollView					*_containerView;
	IBOutlet DataSourceTableView			*_tableView;
	IBOutlet NSTextField					*_txtFieldName;
	
	HeaderTextField							*_txtFieldHeader;
	NSInteger								_selectedColumn;
}

- (void)initWithDataSource:(NSInteger)index;

- (IBAction)OnAdd:(id)sender;
- (IBAction)OnRemove:(id)sender;
- (IBAction)OnSave:(id)sender;
- (void)OnEditHeader:(id)sender;


@end
