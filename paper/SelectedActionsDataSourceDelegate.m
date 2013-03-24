#import "SelectedActionsDataSourceDelegate.h"
#import "BuilderWindowController.h"

@implementation SelectedActionsDataSourceDelegate
@synthesize SA_tableview;
@synthesize delegate;



-(IBAction)deleteActionFromMyList:(id)sender
{
    NSLog(@"hey");
    NSInteger selRow = [SA_tableview selectedRow];
    NSLog(@"selRow : %lu", selRow);
    NSLog(@"count is : %lu", ((BuilderWindowController*)self.delegate).ds.count);
    
    if (selRow > -1 )
    {
        if ( selRow <= ((BuilderWindowController*)self.delegate).ds.count )
        {
            
            NSLog(@"getting inside");
            id objectToRemove = [((BuilderWindowController*)self.delegate).ds objectAtIndex:selRow];
            [((BuilderWindowController*)self.delegate).ds removeObject:objectToRemove];
            [SA_tableview reloadData];
            NSLog(@"deleted and reloaded");
        }
        else
        {
            NSLog(@"Error occurred. Selected a row that cannot be deleted.");
        }
        
    }
}


#pragma mark - Element type toolbar table view datasource implementation

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    //Defensive: there may be cases where the nib containing the tblview loads before the data itself has been initialised.
    NSInteger count = 0;
    if (((BuilderWindowController*)self.delegate).ds)
    {
        count = ((BuilderWindowController*)self.delegate).ds.count;
    }
    return count;
    
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [((BuilderWindowController*)self.delegate).ds objectAtIndex:row];
}


-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    if ([SA_tableview selectedRow] > -1 )
    {
        //
    }
    else
    {
        //[self.nextButton setHidden:YES];
    }
}


@end
