#import "GalleryView.h"
#import "ImageAndTextCell.h"

@implementation GalleryView

#define MyPrivateTableViewDataType @"MyPrivateTableViewDataType"

@synthesize delegate;
@synthesize ShapeTableView;

/*
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
 */
- (void)awakeFromNib
{
    // initialize Element table datasource
	[self initElementTableData];
	
	ShapeTableView.drawShapeDelegate = self;
	
	ShapeTableView.dataSource = self;
	ShapeTableView.delegate = self;
    [ShapeTableView setIntercellSpacing:NSMakeSize(0.0, 0.0)];
	[ShapeTableView reloadData];
	
	[ShapeTableView registerForDraggedTypes:[NSArray arrayWithObject:MyPrivateTableViewDataType]];
}


#pragma mark - init table view data

/*
 @function:		initElementTableData
 @params:		nothing
 @return:       void
 @purpose:		initialize ShapeTableView's data source.
 It examines png files from resource, add the file to the ElementTableDataSource array that name's prefix is "Element_".
 For example, Element_circle.png file in resource is added to array as Element_circle.png.
 
 If you want to add new Element type, please add new file to resource by inserting a prefix Element_ to the file name.
 */
- (void)initElementTableData
{
	NSMutableArray *resourceArray = [NSMutableArray arrayWithArray:[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:nil]];
	ElementTableDataSource = [[NSMutableArray alloc] init];
	
	for (__strong NSString *fileName in resourceArray) 
    {
        fileName = [[fileName componentsSeparatedByString:@"/"] lastObject]; //get the file path and take just what's after the "/"
		
		/*if ([fileName compare:@"shape_" options:0 range:NSMakeRange(0, 6)] == 0) {
         [ElementTableDataSource addObject:fileName];
         NSLog(@"Added: %@", fileName);
         }
         */
        if ([fileName hasPrefix:@"element"]) 
        {
            [ElementTableDataSource addObject:fileName];
        }
	}
    [ElementTableDataSource sortUsingSelector:@selector(compare:)];
	
	[ShapeTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}


#pragma mark - Element type toolbar table view datasource implementation

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	NSInteger count = [ElementTableDataSource count];
	return count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return [ElementTableDataSource objectAtIndex:row];
}

#pragma mark - Element type toolbar table view delegate implementation

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	ImageAndTextCell *imgCell = (ImageAndTextCell *)cell;
	
	// This is where we place the image for each cell.
    imgCell.image = [NSImage imageNamed:[ElementTableDataSource objectAtIndex:row]];
	
	NSString *string = [ElementTableDataSource objectAtIndex:row];
	string = [[[[string componentsSeparatedByString:@"_"] lastObject] componentsSeparatedByString:@"."] objectAtIndex:0];
	[imgCell setStringValue:[string capitalizedString]];
    
    //customise look and feel
    NSFont *cellFont = [NSFont fontWithName:@"HelveticaNeue-Light" size:10];
    [cell setFont:cellFont];
    [cell setTextColor:[NSColor whiteColor]];
    [cell setAlignment:NSLeftTextAlignment];
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	ImageAndTextCell *cell = [[ImageAndTextCell alloc] init];
	
	return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
	NSImage *img = [NSImage imageNamed:[ElementTableDataSource objectAtIndex:row]];
	return [img size].height;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
	[delegate setDrawElementType:row];
	
	return YES;
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSLog(@"haha");
    return NSDragOperationEvery;
}
#pragma mark - Element type toolbar table view drag and drop implementation

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard 
{	
	// Copy the row numbers to the pasteboard.
	NSData *zNSIndexSetData = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pboard declareTypes:[NSArray arrayWithObject:MyPrivateTableViewDataType] owner:self];
	[pboard setData:zNSIndexSetData forType:MyPrivateTableViewDataType];
	//return YES;
	
	ShapeTableView.DragIndex = [rowIndexes firstIndex];
	ShapeTableView.isDrag = YES;
	
	return YES;
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation;
{
        
    //ShapeTableView.isDrag = NO;
	NSLog(@"Table view : %@", tableView);
    NSLog(@"Validate drop : %@", NSStringFromPoint([info draggingLocation]));
    NSLog(@"Proposed Row : %lu", row);
    NSLog(@"proposedDropOperation : %lu", dropOperation);
	return NSDragOperationEvery;
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation
{
	if (tableView == [info draggingSource])
    {
        NSLog(@"DO NOT ACCEPT");
        return NO;
    }
	
	NSLog(@"Drag Accept with %ld", row);
	ShapeTableView.isDrag = NO;
	
	//[tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
	
	return YES;
}

#pragma mark - DrawElementDelegate implementation

- (void)createElement:(NSInteger)index pos:(NSPoint)pt
{
    pt = [self.ShapeTableView convertPoint:pt fromView:nil];
    NSPoint org = [self frame].origin;
	pt.x = org.x + pt.x;
	pt.y = org.y + pt.y;
    NSLog(@"STRANGE POINT : %@", NSStringFromPoint(pt));
    [delegate createElementByDrag:index pos:pt];
}


@end
