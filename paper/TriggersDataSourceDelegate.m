#import "TriggersDataSourceDelegate.h"
#import "BuilderWindowController.h"
#import "Element.h"
#import "Singleton.h"
#import "Document.h"
#import "Container.h"
#import "TextInputField.h"
#import "Image.h"
#import "DropDown.h"
#import "customTableCellView.h"



@implementation TriggersDataSourceDelegate
@synthesize delegate;
@synthesize selectedTrigger;


-(NSMutableArray *)triggers
{
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    NSArray *elementsArray = [[curDoc stageView] elementArray];
    NSMutableArray *arrayOfStatements = [NSMutableArray array];
    
    for (Element *ele in elementsArray)
    {
        if ( ![ele isMemberOfClass:[Container class]] )
        {
            if (([ele isMemberOfClass:[TextInputField class]]))
            {
                //get 'xyz' value, multiply it, and divide it
                NSString *getValueString = [NSString stringWithFormat:@"When I enter or delete a character into %@", ele.elementid];
                
                /*
                NSBitmapImageRep* bitmap = [ele bitmapImageRepForCachingDisplayInRect:[ele bounds]];
                [ele cacheDisplayInRect:ele.rtFrame toBitmapImageRep:bitmap];
                
                NSImage *im = [[NSImage alloc] init];
                [im addRepresentation:bitmap];
                [im setSize:NSMakeSize(16, 16)];
                [im setName:@"boxi"];
                 */
                                
                NSDictionary *editTextInTextInputField = @{TRIGGER : getValueString, IMAGE_TO_DISPLAY : [ele imageWithSubviews] };
                [arrayOfStatements addObject:editTextInTextInputField];
            }
            
            
            //For images
            if (([ele isMemberOfClass:[Image class]]))
            {
                //NSString *myString = [NSString stringWithFormat:@"Get the url for the %@ image", ele.elementid];
                //[arrayOfStatements addObject:myString];
            }
            
            
            //For drop down menus
            if (([ele isMemberOfClass:[DropDown class]]))
            {
               /*
                NSArray *dataSource = ((DropDown*)ele).dataSource;
                for (NSString *key in [dataSource objectAtIndex:0]) // every row in the array has the same dictionary structure so the first will do.
                {
                    NSString *myString = [NSString stringWithFormat:@"Get the %@ for the selected %@", key, ele.elementid];
                    [arrayOfStatements addObject:myString];
                }
                */
            }
        }
        
        
        
    }

    // catch all generic statements that do not belong in a loop
    
    NSArray *genericStatements = [NSArray arrayWithObjects:
                                  @"When the page loads",
                                  @"When the user leaves the page", nil];
    NSImage *appIcon = [NSImage imageNamed:NSImageNameApplicationIcon];
    NSDictionary *genericTriggers = nil;
    
    for (NSString *statement in genericStatements)
    {
        genericTriggers = [NSDictionary dictionaryWithObjectsAndKeys:
                           statement, TRIGGER,
                           appIcon, IMAGE_TO_DISPLAY, nil];
        [arrayOfStatements addObject:genericTriggers];
    }
   
    
    return arrayOfStatements;
}




#pragma mark - Element type toolbar table view datasource implementation

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    
    //Defensive: there may be cases where the nib containing the tblview loads before the data itself has been initialised.
    NSInteger count = 0;
    NSArray *triggerEvents = [self triggers];
    if (triggerEvents)
    {
        count = triggerEvents.count;
    }    
    return count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    NSDictionary *dictionaryWithValues = [[self triggers] objectAtIndex:row];
    
    NSString * titleToDisplay = [dictionaryWithValues objectForKey:TRIGGER];
    NSImage *imageToDisplay = [dictionaryWithValues objectForKey:IMAGE_TO_DISPLAY];
    //[[result.builderWindowTextViewCell textStorage] setAttributedString:[[NSAttributedString alloc]initWithString:titleToDisplay]];
    //result.builderWindowTextViewCell.backgroundColor = [NSColor clearColor];
    
    NSDictionary* text2FontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSFont fontWithName: @"Helvetica Neue" size: 12], NSFontAttributeName,
                                         [NSColor blackColor], NSForegroundColorAttributeName, nil];
    NSSize sizeOfTextBox = [titleToDisplay sizeWithAttributes:text2FontAttributes];
    NSRect textFrame = NSMakeRect(0, 0, sizeOfTextBox.width, sizeOfTextBox.height);
    
    
    result.textField.stringValue = titleToDisplay;
    
        
    if ([dictionaryWithValues objectForKey:IMAGE_TO_DISPLAY] != [NSNull null])
    {
        if ( imageToDisplay != [NSImage imageNamed:NSImageNameApplicationIcon] )
        {
            int xCoForSubView = result.imageView.frame.size.width + textFrame.size.width + 50;
            NSImageView *subView = [[NSImageView alloc]init];
            [subView setImage:[dictionaryWithValues objectForKey:IMAGE_TO_DISPLAY]];
            [subView setFrame:NSMakeRect(xCoForSubView, 5, imageToDisplay.size.width, imageToDisplay.size.height)];
            [result addSubview:subView];
        }
        else
        {
            result.imageView.image = [dictionaryWithValues objectForKey:IMAGE_TO_DISPLAY];
        }
        
    }
    
    
    
    return result;
    
}

/*
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return [[self triggers] objectAtIndex:row];
    //return [((BuilderWindowController*)self.delegate).dataSources.triggers objectAtIndex:row];
}
*/

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tView = [notification object];
    if ([[notification object] selectedRow] > -1 )
    {
        [delegate nextButtonWillBeEnabled:YES];
        
        self.selectedTrigger = [[NSMutableString alloc] initWithFormat:@"%@", [[self triggers] objectAtIndex:[tView selectedRow]]];
        //NSLog(@"Selected Trigger : %@", self.selectedTrigger);
        NSLog(@"Selection changed");
    }
    else
    {
        
        [delegate nextButtonWillBeEnabled:NO];
        
    }
}




@end
