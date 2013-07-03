//
//  DataSourceWindowController.m
//  DrawShap
//
//  Created by Bai Jin on 1/10/13.
//  Copyright (c) 2013 Cosmo Software. All rights reserved.
//

#import "DataSourceWindowController.h"
#import "AppDelegate.h"

@interface DataSourceWindowController ()

@end

@implementation DataSourceWindowController

- (id)init
{
	self = [super initWithWindowNibName:@"DataSourceWindowController"];
	if (self) {
		
	}
	
	return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
	[super windowDidLoad];
	
	// Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
	if (_index >= 0) {
		AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
		NSMutableDictionary *dict = (NSMutableDictionary *)[appDelegate.arrayDataSource objectAtIndex:_index];
		
		NSString *name = [dict valueForKey:@"Name"];
		[_txtFieldName setStringValue:name];
		
		// create header column
		NSMutableArray *arrHeaderColumn = [_arrayDataSource objectAtIndex:0];
		for (NSInteger i = 0; i < [arrHeaderColumn count]; i ++) {
			NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"%ld", i]];
			[[column headerCell] setStringValue:[arrHeaderColumn objectAtIndex:i]];
			[_tableView addTableColumn:column];
			[column release];
		}
	} else {
		// create  3 header column by default
		for (NSInteger i = 0; i < 3; i ++) {
			NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"%ld", i]];
			[[column headerCell] setStringValue:@""];
			[_tableView addTableColumn:column];
			[column release];
		}
	}
	
	// set title of header column of table view
	[_tableView setDoubleAction:@selector(OnEditHeader:)];
	
	[_tableView reloadData];
}

- (void)initWithDataSource:(NSInteger)index
{
	_index = index;
	
	// initialize data source
	if (_index < 0) { // create new data source, if adding method
		_arrayDataSource = [[NSMutableArray alloc] init];
		
		NSMutableArray *arrHeaderColumn = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", nil];
		
		[_arrayDataSource addObject:arrHeaderColumn];
		[_txtFieldName setStringValue:@""];
		
		[arrHeaderColumn release];
	} else { // reference from data source of app delegate, if modifying method
		AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
		NSMutableDictionary *dict = (NSMutableDictionary *)[appDelegate.arrayDataSource objectAtIndex:_index];
		
		NSString *name = [dict valueForKey:@"Name"];
		_arrayDataSource = [[NSMutableArray alloc] initWithArray:[dict valueForKey:@"DataSource"]];
		[_txtFieldName setStringValue:name];
	}
	
	_txtFieldHeader = nil;
}

- (void)deleteDataSourceEntry:(NSInteger)index
{
	_index = index;
	
	// initialize data source
	if (_index < 0) { // create new data source, if adding method
		return;
	} else { // reference from data source of app delegate, if modifying method
		AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
		[appDelegate.arrayDataSource removeObjectAtIndex:_index];
	}
	
	_txtFieldHeader = nil;
}

#pragma mark - NSWindow delegate implementation

- (BOOL)windowShouldClose:(id)sender
{
	[_arrayDataSource release];
	
	[NSApp stopModal];
	
	if (_txtFieldHeader) {
		[_txtFieldHeader removeFromSuperview];
		_txtFieldHeader = nil;
	}
	
	return YES;
}


#pragma mark - button action implementation

- (IBAction)OnAdd:(id)sender
{
	// if header is editting, disable editting and set text to header column
	if (_txtFieldHeader) {
		if (_selectedColumn >= 0) {
			
			// set changed header value to array
			NSMutableArray *arrHeaderData = [_arrayDataSource objectAtIndex:0];
			
			[arrHeaderData replaceObjectAtIndex:_selectedColumn withObject:[_txtFieldHeader stringValue]];
			[_arrayDataSource replaceObjectAtIndex:0 withObject:arrHeaderData];
			
			
			// set changed header value to header cell
			NSTableColumn *column = [_tableView tableColumnWithIdentifier:[NSString stringWithFormat:@"%ld", _selectedColumn]];
			
			[[column headerCell] setStringValue:[_txtFieldHeader stringValue]];
			[[_tableView headerView] setNeedsDisplay:YES];
		}
		
		[_txtFieldHeader removeFromSuperview];
		_txtFieldHeader = nil;
		
		_selectedColumn = -1;
	}
	
	NSInteger index = [_tableView selectedColumn];
	if (index < 0) { // adding new row
		
		// add new row data to array
		NSMutableArray *arrRowDatas = [[NSMutableArray alloc] init];
		for (NSInteger i = 0; i < [_tableView numberOfColumns]; i ++) {
			[arrRowDatas addObject:@"untitled"];
		}
		[_arrayDataSource addObject:arrRowDatas];
		[arrRowDatas release];
		
		[_tableView reloadData];
		
		// set focus to new added row
		[_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:[_arrayDataSource count] - 2] byExtendingSelection:NO];
		[_tableView editColumn:0 row:[_arrayDataSource count] - 2 withEvent:nil select:YES];
		
		return;
	}
	
	
	// adding new column
	
	NSMutableArray *arrHeaderData = [_arrayDataSource objectAtIndex:0];
	for (NSInteger i = index + 1; i < [arrHeaderData count]; i ++) {
		NSTableColumn *column = [_tableView tableColumnWithIdentifier:[NSString stringWithFormat:@"%ld", i]];
		[_tableView removeTableColumn:column];
	}
	
	// add new string to array
	if (index == [arrHeaderData count] - 1) {
		for (NSInteger i = 0; i < [_arrayDataSource count]; i ++) {
			NSMutableArray *arrRow = [_arrayDataSource objectAtIndex:i];
			[arrRow addObject:@""];
			[_arrayDataSource replaceObjectAtIndex:i withObject:arrRow];
		}
	} else {
		for (NSInteger i = 0; i < [_arrayDataSource count]; i ++) {
			NSMutableArray *arrRow = [_arrayDataSource objectAtIndex:i];
			[arrRow insertObject:@"" atIndex:index + 1];
			[_arrayDataSource replaceObjectAtIndex:i withObject:arrRow];
		}
	}
		
	// add new column
	arrHeaderData = [_arrayDataSource objectAtIndex:0];
	for (NSInteger i = index + 1; i < [arrHeaderData count]; i ++) {
		NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"%ld", i]];
		[[column headerCell] setStringValue:[arrHeaderData objectAtIndex:i]];
		[_tableView addTableColumn:column];
		[column release];
	}
	
	[_tableView reloadData];
}

- (IBAction)OnRemove:(id)sender
{
	// if header is editting, disable editting and set text to header column
	if (_txtFieldHeader) {
		if (_selectedColumn >= 0) {
			
			// set changed header value to array
			NSMutableArray *arrHeaderData = [_arrayDataSource objectAtIndex:0];
			
			[arrHeaderData replaceObjectAtIndex:_selectedColumn withObject:[_txtFieldHeader stringValue]];
			[_arrayDataSource replaceObjectAtIndex:0 withObject:arrHeaderData];
			
			
			// set changed header value to header cell
			NSTableColumn *column = [_tableView tableColumnWithIdentifier:[NSString stringWithFormat:@"%ld", _selectedColumn]];
			
			[[column headerCell] setStringValue:[_txtFieldHeader stringValue]];
			[[_tableView headerView] setNeedsDisplay:YES];
		}
		
		[_txtFieldHeader removeFromSuperview];
		_txtFieldHeader = nil;
		
		_selectedColumn = -1;
	}
	
	NSInteger index = [_tableView selectedColumn];
	if (index < 0) { // remove selected row
		
		NSInteger row = [_tableView selectedRow];
		if (row < 0) {
			return;
		}
		
		[_arrayDataSource removeObjectAtIndex:row + 1];
		[_tableView reloadData];
	}
	
	// remove selected column
	NSMutableArray *arrHeaderData = [_arrayDataSource objectAtIndex:0];
	if ([arrHeaderData count] <= 1) {
		NSLog( @"Can't remove column as less than 1 columns" );
		return;
	}
	
	for (NSInteger i = index; i < [arrHeaderData count]; i ++) {
		NSTableColumn *column = [_tableView tableColumnWithIdentifier:[NSString stringWithFormat:@"%ld", i]];
		[_tableView removeTableColumn:column];
	}
	
	// add new string to array
	for (NSInteger i = 0; i < [_arrayDataSource count]; i ++) {
		NSMutableArray *arrRow = [_arrayDataSource objectAtIndex:i];
		[arrRow removeObjectAtIndex:index];
		[_arrayDataSource replaceObjectAtIndex:i withObject:arrRow];
	}
	
	// add new column
	arrHeaderData = [_arrayDataSource objectAtIndex:0];
	for (NSInteger i = index; i < [arrHeaderData count]; i ++) {
		NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:[NSString stringWithFormat:@"%ld", i]];
		[[column headerCell] setStringValue:[arrHeaderData objectAtIndex:i]];
		[_tableView addTableColumn:column];
		[column release];
	}
	
	[_tableView reloadData];
}

- (IBAction)OnSave:(id)sender
{
	NSLog( @"Data Saved Successfully\n---------------------" );
	
	// if header is editting, disable editting and set text to header column
	if (_txtFieldHeader) {
		if (_selectedColumn >= 0) {
			
			// set changed header value to array
			NSMutableArray *arrHeaderData = [_arrayDataSource objectAtIndex:0];
			
			[arrHeaderData replaceObjectAtIndex:_selectedColumn withObject:[_txtFieldHeader stringValue]];
			[_arrayDataSource replaceObjectAtIndex:0 withObject:arrHeaderData];
			
			
			// set changed header value to header cell
			NSTableColumn *column = [_tableView tableColumnWithIdentifier:[NSString stringWithFormat:@"%ld", _selectedColumn]];
			
			[[column headerCell] setStringValue:[_txtFieldHeader stringValue]];
			[[_tableView headerView] setNeedsDisplay:YES];
		}
		
		[_txtFieldHeader removeFromSuperview];
		_txtFieldHeader = nil;
		
		_selectedColumn = -1;
	}
	
	// save to data source of app delegate
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	[dict setValue:[_txtFieldName stringValue] forKey:@"Name"];
	[dict setValue:_arrayDataSource forKey:@"DataSource"];
	
	AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
	if (_index < 0) {
		if (appDelegate.arrayDataSource == nil) {
			appDelegate.arrayDataSource = [[NSMutableArray alloc] init];
		}
		
		[appDelegate.arrayDataSource addObject:dict];
	} else {
		[appDelegate.arrayDataSource replaceObjectAtIndex:_index withObject:dict];
	}
	
	[dict release];
	
	// print all contents of array
	NSString *strLog = [NSString stringWithFormat:@"\n"];
	
	for (NSMutableArray *arrRowData in _arrayDataSource) {
		
		for (NSString *contents in arrRowData) {
			strLog = [NSString stringWithFormat:@"%@\t%@", strLog, contents];
		}
		
		strLog = [NSString stringWithFormat:@"%@\n", strLog];
	}
	
	NSLog( @"%@", strLog );
    
    // communicate that the save was succesful
    NSAlert *alert = [NSAlert alertWithMessageText:@"Data saved" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
    [alert runModal];
    
    
    // close the window
    [[self window]performClose:self];
}

- (void)OnEditHeader:(id)sender
{
	// if header is editting, disable editting and set text to header column
	if (_txtFieldHeader) {
		if (_selectedColumn >= 0) {
			
			// set changed header value to array
			NSMutableArray *arrHeaderData = [_arrayDataSource objectAtIndex:0];
			
			[arrHeaderData replaceObjectAtIndex:_selectedColumn withObject:[_txtFieldHeader stringValue]];
			[_arrayDataSource replaceObjectAtIndex:0 withObject:arrHeaderData];
			
			
			// set changed header value to header cell
			NSTableColumn *column = [_tableView tableColumnWithIdentifier:[NSString stringWithFormat:@"%ld", _selectedColumn]];
			
			[[column headerCell] setStringValue:[_txtFieldHeader stringValue]];
			[[_tableView headerView] setNeedsDisplay:YES];
		}
		
		[_txtFieldHeader removeFromSuperview];
		_txtFieldHeader = nil;
		
		_selectedColumn = -1;
	}
	
	// set edit mode of header column and shows selected header string
	NSInteger index = [_tableView selectedColumn];
	if (index < 0) {
		return;
	}
	
	_selectedColumn = index;
	
	NSTableColumn *column;
	column = [_tableView tableColumnWithIdentifier:[NSString stringWithFormat:@"%ld", _selectedColumn]];
	
	NSTableHeaderView * headerView = [_tableView headerView];
	NSRect rtheader = [headerView headerRectOfColumn:index];
	
	NSRect rtcolumn = [_tableView rectOfColumn:index];
	
	[_tableView deselectAll:nil];
	
	//[[_containerView contentView] scrollToPoint:NSMakePoint(rtheader.origin.x, 0)];
	_txtFieldHeader = [[HeaderTextField alloc] initWithFrame:NSMakeRect(rtheader.origin.x + _containerView.frame.origin.x - _containerView.contentView.documentVisibleRect.origin.x,
																		rtcolumn.size.height + _containerView.frame.origin.y + 15,
																		rtheader.size.width,
																		rtheader.size.height)];
	_txtFieldHeader.headerDelegate = self;
	[self.window.contentView addSubview:_txtFieldHeader];
	[_txtFieldHeader setStringValue:[[column headerCell] stringValue]];
	[[self window] makeFirstResponder:_txtFieldHeader];
	[_txtFieldHeader release];
}


#pragma mark - header text field delegate implementation

- (void)OnEnterKeyPressed
{
	// if header is editting, disable editting and set text to header column
	if (_txtFieldHeader) {
		if (_selectedColumn >= 0) {
			
			// set changed header value to array
			NSMutableArray *arrHeaderData = [_arrayDataSource objectAtIndex:0];
			
			[arrHeaderData replaceObjectAtIndex:_selectedColumn withObject:[_txtFieldHeader stringValue]];
			[_arrayDataSource replaceObjectAtIndex:0 withObject:arrHeaderData];
			
			
			// set changed header value to header cell
			NSTableColumn *column = [_tableView tableColumnWithIdentifier:[NSString stringWithFormat:@"%ld", _selectedColumn]];
			
			[[column headerCell] setStringValue:[_txtFieldHeader stringValue]];
			[[_tableView headerView] setNeedsDisplay:YES];
		}
		
		[_txtFieldHeader setHidden:YES];
		
		_selectedColumn = -1;
	}
}

- (void)OnTabKeyPressed
{
	// if header is editting, disable editting and set text to header column
	if (_txtFieldHeader) {
		if (_selectedColumn >= 0) {
			
			// set changed header value to array
			NSMutableArray *arrHeaderData = [_arrayDataSource objectAtIndex:0];
			
			[arrHeaderData replaceObjectAtIndex:_selectedColumn withObject:[_txtFieldHeader stringValue]];
			[_arrayDataSource replaceObjectAtIndex:0 withObject:arrHeaderData];
			
			
			// set changed header value to header cell
			NSTableColumn *column = [_tableView tableColumnWithIdentifier:[NSString stringWithFormat:@"%ld", _selectedColumn]];
			
			[[column headerCell] setStringValue:[_txtFieldHeader stringValue]];
			[[_tableView headerView] setNeedsDisplay:YES];
		}
		
		// select next header
		_selectedColumn = (_selectedColumn + 1) % [_tableView numberOfColumns];
		NSTableColumn *column = [_tableView tableColumnWithIdentifier:[NSString stringWithFormat:@"%ld", _selectedColumn]];
		
		NSTableHeaderView * headerView = [_tableView headerView];
		NSRect rtheader = [headerView headerRectOfColumn:_selectedColumn];
		
		NSRect rtcolumn = [_tableView rectOfColumn:_selectedColumn];
		
		[_tableView deselectAll:nil];
		
		_txtFieldHeader.frame = NSMakeRect(rtheader.origin.x + _containerView.frame.origin.x - _containerView.contentView.documentVisibleRect.origin.x,
										   rtcolumn.size.height + _containerView.frame.origin.y + 15,
										   rtheader.size.width,
										   rtheader.size.height);
		[_txtFieldHeader setStringValue:[[column headerCell] stringValue]];
		[[self window] makeFirstResponder:_txtFieldHeader];
	}
}


#pragma mark - table view data source implementation

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [_arrayDataSource count] - 1;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	NSMutableArray *arrRowData = [_arrayDataSource objectAtIndex:row + 1];
	
	return [arrRowData objectAtIndex:[[tableColumn identifier] intValue]];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	NSMutableArray *arrRowData = [_arrayDataSource objectAtIndex:row + 1];
	
	[arrRowData replaceObjectAtIndex:[[tableColumn identifier] intValue] withObject:object];
	
	[_arrayDataSource replaceObjectAtIndex:row + 1 withObject:arrRowData];
}


#pragma mark - table view delegate implementation

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn
{
	// if header is editting, disable editting and set text to header column
	if (_txtFieldHeader) {
		if (_selectedColumn >= 0) {
			
			// set changed header value to array
			NSMutableArray *arrHeaderData = [_arrayDataSource objectAtIndex:0];
			
			[arrHeaderData replaceObjectAtIndex:_selectedColumn withObject:[_txtFieldHeader stringValue]];
			[_arrayDataSource replaceObjectAtIndex:0 withObject:arrHeaderData];
			
			
			// set changed header value to header cell
			NSTableColumn *column = [_tableView tableColumnWithIdentifier:[NSString stringWithFormat:@"%ld", _selectedColumn]];
			
			[[column headerCell] setStringValue:[_txtFieldHeader stringValue]];
			[[_tableView headerView] setNeedsDisplay:YES];
		}
		
		[_txtFieldHeader removeFromSuperview];
		_txtFieldHeader = nil;
		
		_selectedColumn = -1;
	}
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
	// if header is editting, disable editting and set text to header column
	if (_txtFieldHeader) {
		if (_selectedColumn >= 0) {
			
			// set changed header value to array
			NSMutableArray *arrHeaderData = [_arrayDataSource objectAtIndex:0];
			
			[arrHeaderData replaceObjectAtIndex:_selectedColumn withObject:[_txtFieldHeader stringValue]];
			[_arrayDataSource replaceObjectAtIndex:0 withObject:arrHeaderData];
			
			
			// set changed header value to header cell
			NSTableColumn *column = [_tableView tableColumnWithIdentifier:[NSString stringWithFormat:@"%ld", _selectedColumn]];
			
			[[column headerCell] setStringValue:[_txtFieldHeader stringValue]];
			[[_tableView headerView] setNeedsDisplay:YES];
		}
		
		[_txtFieldHeader removeFromSuperview];
		_txtFieldHeader = nil;
		
		_selectedColumn = -1;
	}
	
	return YES;
}


@end
