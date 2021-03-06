#import "LayerPanel.h"
#import "Document.h"
#import "AppDelegate.h"

#define BasicTableViewDragAndDropDataType							@"BasicTableViewDragAndDropDataType"

@implementation LayerPanel


- (void)awakeFromNib
{
	[_tableViewLayer registerForDraggedTypes:[NSArray arrayWithObjects:BasicTableViewDragAndDropDataType, nil]];
	[_tableViewLayer setDoubleAction:@selector(doubleClickOnTable:)];
}

- (void)doubleClickOnTable:(id)sender
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	
	NSInteger index = [_tableViewLayer selectedRow];
	[curDoc.stageView SelectElementByIndex:index];
}


#pragma mark - table view data source implementation

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    	
	return [curDoc.stageView.elementArray count];
}

#pragma mark Drag and Drop in NSTableView

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pboard declareTypes:[NSArray arrayWithObject:BasicTableViewDragAndDropDataType] owner:self];
	[pboard setData:data forType:BasicTableViewDragAndDropDataType];
	
	return YES;
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
	return NSDragOperationEvery;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation
{
	NSPasteboard *pboard = [info draggingPasteboard];
	NSData *rowData = [pboard dataForType:BasicTableViewDragAndDropDataType];
	NSIndexSet *rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
	
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc.stageView ResortShapes:rowIndexes to:row];
	
	[_tableViewLayer reloadData];
	
	return YES;
}

/*- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
 {
 Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
 CShape *shape = [curDoc.stageView.shapeArray objectAtIndex:row];
 
 if ([[tableColumn identifier] isEqualToString:@"Name"]) {
 
 switch (shape.uType) {
 case SHAPE_CIRCLE:
 return @"Circle";
 break;
 
 case SHAPE_RECTANGLE:
 return @"Rectangle";
 break;
 
 case SHAPE_TEXTBOX:
 return @"TextBox";
 break;
 
 case SHAPE_TRIANGLE:
 return @"Triangle";
 break;
 
 case SHAPE_IMAGE:
 return @"Image";
 break;
 
 case SHAPE_GROUP:
 return @"Group";
 break;
 
 default:
 break;
 }
 } else if ([[tableColumn identifier] isEqualToString:@"Visibility"]) {
 return @"Visible";
 }
 
 return nil;
 }*/


#pragma mark - table view delegate implementation

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	NSInteger index = [curDoc.stageView.elementArray count] - row - 1;
	Element *shape = [curDoc.stageView.elementArray objectAtIndex:index];
	
	if ([[tableColumn identifier] isEqualToString:@"Name"]) {
		
		NSTextField *viewName = [tableView makeViewWithIdentifier:[NSString stringWithFormat:@"TableViewNameCell%ld", index] owner:self];
		if (viewName == nil) {
			viewName = [[[NSTextField alloc] init] autorelease];
			viewName.identifier = [NSString stringWithFormat:@"TableViewNameCell%ld", index];
		}
		
		[viewName setBordered:NO];
		[viewName setEditable:NO];
		[viewName setBackgroundColor:[NSColor clearColor]];
		
		switch (shape.uType) {
			case SHAPE_CIRCLE:
				viewName.stringValue = @"Circle";
				break;
				
			case SHAPE_RECTANGLE:
				viewName.stringValue = @"Rectangle";
				break;
				
			case SHAPE_TEXTBOX:
				viewName.stringValue = @"TextBox";
				break;
				
			case SHAPE_TRIANGLE:
				viewName.stringValue = @"Triangle";
				break;
				
			case SHAPE_IMAGE:
				viewName.stringValue = @"Image";
				break;
				
			case SHAPE_BUTTON:
				viewName.stringValue = @"Button";
				break;
				
			case SHAPE_DROPDOWN:
				viewName.stringValue = @"DropDown";
				break;
				
			case SHAPE_TEXTFIELD:
				viewName.stringValue = @"TextField";
				break;
				
			case SHAPE_PLACEHOLDER_IMAGE:
				viewName.stringValue = @"PlaceHolder Image";
				break;
				
			case SHAPE_DYNAMIC_ROW:
				viewName.stringValue = @"Dynamic Row";
				break;
				
			case SHAPE_CONTAINER:
				viewName.stringValue = @"Container";
				break;

			/*
			case SHAPE_GROUP:
				viewName.stringValue = @"Group";
				break;
             */
				
			default:
				break;
		}
		
		return viewName;
	} else if ([[tableColumn identifier] isEqualToString:@"Visibility"]) {
		
		if (shape.uType == SHAPE_CONTAINER) {
			return nil;
		}
		
		NSButton *checkVisible = [tableView makeViewWithIdentifier:[NSString stringWithFormat:@"TableViewVisibleCell%ld", row] owner:self];
		if (checkVisible == nil) {
			checkVisible = [[[NSButton alloc] init] autorelease];
			checkVisible.identifier = [NSString stringWithFormat:@"TableViewVisibleCell%ld", row];
		}
		
		[checkVisible setButtonType:NSSwitchButton];
		[checkVisible setTitle:@"Visible"];
		[checkVisible setState:(shape.isHidden == YES)? NSOffState: NSOnState];
		
		[checkVisible setAction:@selector(OnVisible:)];
		[checkVisible setTag:[curDoc.stageView.elementArray count] - row - 1];
		
		return checkVisible;
	} else if ([[tableColumn identifier] isEqualToString:@"Movement"]) {
		
		if (shape.uType == SHAPE_CONTAINER) {
			return nil;
		}
		
		NSButton *checkMove = [tableView makeViewWithIdentifier:[NSString stringWithFormat:@"TableViewMovementCell%ld", row] owner:self];
		if (checkMove == nil) {
			checkMove = [[[NSButton alloc] init] autorelease];
			checkMove.identifier = [NSString stringWithFormat:@"TableViewMovementCell%ld", row];
		}
		
		[checkMove setButtonType:NSSwitchButton];
		[checkMove setTitle:@"Movement"];
		[checkMove setState:(shape.canMove == YES)? NSOffState: NSOnState];
		
		[checkMove setAction:@selector(OnMovement:)];
		[checkMove setTag:[curDoc.stageView.elementArray count] - row - 1];
		
		return checkMove;
	}
	
	return nil;
}




#pragma mark - check box action implementation

- (IBAction)OnVisible:(id)sender
{
	NSInteger tag = [sender tag];
	
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	Element *shape = [curDoc.stageView.elementArray objectAtIndex:tag];
	
	if ([sender state] == NSOnState) {
		[shape setHidden:NO];
	} else {
		[shape setHidden:YES];
	}
}

- (IBAction)OnMovement:(id)sender
{
	NSInteger tag = [sender tag];
	
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	Element *shape = [curDoc.stageView.elementArray objectAtIndex:tag];
	
	if ([sender state] == NSOnState) {
		shape.canMove = NO;
	} else {
		shape.canMove = YES;
	}
}


#pragma mark - set layer order delegate implementation

- (void)SetLayerList
{
    [_tableViewLayer reloadData];
	
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	NSInteger count = [curDoc.stageView.elementArray count];
	[_labelLayerCount setStringValue:[NSString stringWithFormat:@"%ld", count]];
}


@end
