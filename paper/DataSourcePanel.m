//
//  DataSourcePanel.m
//  DrawShap
//
//  Created by Bai Jin on 1/10/13.
//  Copyright (c) 2013 Cosmo Software. All rights reserved.
//

#import "DataSourcePanel.h"
#import "DataSourceWindowController.h"
#import "AppDelegate.h"

@implementation DataSourcePanel

- (void)awakeFromNib
{
	_arrayDataSource = nil;
	[_tableView setDoubleAction:@selector(OnEdit:)];
}


/*
 @function:	initDataSource
 @params:	nothing
 @return:	void
 @purpose:	This function  inits the _arrayDataSource from AppDelegate's arrayDataSource and reload the table view.
 */
- (void)initDataSource
{
	AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
	
	if (_arrayDataSource) {
		[_arrayDataSource release];
	}
	
	_arrayDataSource = [[NSMutableArray alloc] initWithArray:appDelegate.arrayDataSource];
	[_tableView reloadData];
}


#pragma mark - button action implementation

/*
 @function:	OnEdit
 @purpose:	This function called when the user click the edit button.
 */
- (IBAction)OnEdit:(id)sender
{
	NSInteger index = [_tableView selectedRow];
	
	if (index < 0) {
		return;
	}
	
	[self setIsVisible:NO];
	
	DataSourceWindowController *dataSourceWindowController = [[DataSourceWindowController alloc] init];
	[dataSourceWindowController initWithDataSource:index];
	[NSApp runModalForWindow:dataSourceWindowController.window];
}


#pragma mark - table view data source implementation

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	if (_arrayDataSource == nil) {
		return 0;
	}
	
	return [_arrayDataSource count];
}


#pragma mark - table view delegate implementation

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	NSDictionary *dict = [_arrayDataSource objectAtIndex:row];
	
	if ([[tableColumn identifier] isEqualToString:@"_name"]) {
		
		NSTextField *viewName = [tableView makeViewWithIdentifier:[NSString stringWithFormat:@"TableViewNameCell%ld", row] owner:self];
		if (viewName == nil) {
			viewName = [[[NSTextField alloc] init] autorelease];
			viewName.identifier = [NSString stringWithFormat:@"TableViewNameCell%ld", row];
		}
		
		[viewName setBordered:NO];
		[viewName setEditable:NO];
		[viewName setBackgroundColor:[NSColor clearColor]];
		
		viewName.stringValue = [dict valueForKey:@"Name"];
		
		return viewName;
	}
	
	return nil;
}


@end
