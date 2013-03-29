#import "ActionsDataSourceDelegate.h"
#import "Document.h"
#import "Element.h"
#import "Singleton.h"
#import "DropDown.h"
#import "TextInputField.h"
#import "Box.h"
#import "Image.h"
#import "BuilderWindowController.h"
#import "SelectedActionsDataSourceDelegate.h"
#import "Singleton.h"
#import "Container.h"
#import "NSString+shortcuts.h"
#import "CustomTableCellView.h"

@implementation ActionsDataSourceDelegate
@synthesize actionsLabel;
@synthesize commandsAndActions;
@synthesize delegate;
@synthesize selectedActionsTableview;
@synthesize selRow;
@synthesize arrayToCheck;

-(id)init
{
    NSMutableArray *actions = [self loadActions];
    [actions addObjectsFromArray:[self genericCommands]];
    self.commandsAndActions = actions;
    self.arrayToCheck = [NSMutableArray array];
    return self;
}

-(IBAction)addActionToMyList:(id)sender
{
    
    if ([actionsTableView selectedRow] > -1 )
    {
        //Add the selected row to the datasource for the selected actions tbl
        //Add the selected row to the final actions list - should this not be done at publish time?
        id objectToAdd = [self.commandsAndActions objectAtIndex:selRow];
        if ([[((BuilderWindowController*)self.delegate) ds] containsObject:objectToAdd])
        {
            //WARNING: Throw a warning that this action is already in your actions List.
            NSLog(@"Throw a a warning.");
        }
        
        [((BuilderWindowController*)self.delegate).ds addObject:objectToAdd];
        
        NSLog(@"Actions Data Source Delegate HAS : %@", [((BuilderWindowController*)self.delegate) ds]);

        [selectedActionsTableview reloadData];
    }
}







#pragma mark - DataSource for the tableViews

-(NSMutableArray*)loadActions // This function returns the relevant actions for the element.
{
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    NSArray *elementsArray = [[curDoc stageView] elementArray];
    

    //  What element is currently selected?
    //  I'll use this to only pass back actions that are relevant to the selected element.
    // If I have a button selected 'Filter facebook friends' is not relevant here but more so for a type-ahead-textfield
    //Singleton *sg = [[Singleton alloc]init];
    //ElementType type = sg.currentElement.uType;
    
    
    NSMutableArray *arrayOfStatements = [NSMutableArray array];
    NSMutableArray *statements = [NSMutableArray array];
    for (Element *ele in elementsArray)
    {
        if ( ![ele isMemberOfClass:[Container class]] )
        {
            if (([ele isMemberOfClass:[TextInputField class]]))
            {
                //get 'xyz' value, multiply it, and divide it
                NSString *getValueString = [NSString stringWithFormat:@"Get the value of %@", ele.elementid];
                NSString *multiplyString = [NSString stringWithFormat:@"Multiply it by the value of %@", ele.elementid];
                NSString *divideItByString = [NSString stringWithFormat:@"Divide it by the value of %@", ele.elementid];
                NSString *subtractItString = [NSString stringWithFormat:@"Subtract the value of %@ to it", ele.elementid];
                NSString *addItString = [NSString stringWithFormat:@"Add the value of %@ to it", ele.elementid];
                NSString *updateTheValueString = [NSString stringWithFormat:@"Update the value of %@", ele.elementid];
                statements = [NSMutableArray arrayWithObjects:
                                     getValueString,
                                     multiplyString,
                                     divideItByString,
                                     subtractItString,
                                     addItString,
                                     updateTheValueString,
                                     nil];
                
                for (NSString *statement in statements)
                {
                    NSArray *array = [NSArray arrayWithObjects:statement, [ele imageWithSubviews], @"", nil];
                    [arrayOfStatements addObject:array];
                }
            }
            
            
            //For images
            if (([ele isMemberOfClass:[Image class]]))
            {
                NSString *myString = [NSString stringWithFormat:@"Get the url for the %@ image", ele.elementid];
                statements = [NSMutableArray arrayWithObjects:myString, nil];
                
                for (NSString *statement in statements)
                {
                    NSArray *array = [NSArray arrayWithObjects:statement, [ele imageWithSubviews], @"", nil];
                    [arrayOfStatements addObject:array];
                }
            }
            
            
            //For drop down menus
            if (([ele isMemberOfClass:[DropDown class]]))
            {
                NSArray *dataSource = ((DropDown*)ele).dataSource;
                for (NSString *key in [dataSource objectAtIndex:0]) // every row in the array has the same dictionary structure so the first will do.
                {
                    NSString *myString = [NSString stringWithFormat:@"Get the %@ for the selected %@", key, ele.elementid];
                    NSArray *dropDownArray = [NSArray arrayWithObjects:myString, [ele imageWithSubviews], @"", nil];
                    [arrayOfStatements addObject:dropDownArray];
                }
            }
            
            //Generic statements for all elements
            NSString *showElement = [NSString stringWithFormat:@"show element with tag %@", ele.elementid];
            NSArray *showElementArray = [NSArray arrayWithObjects:showElement, [ele imageWithSubviews], @"", nil];
            
            NSString *hideElement = [NSString stringWithFormat:@"hide element with tag %@", ele.elementid];
            NSArray *hideElementArray = [NSArray arrayWithObjects:hideElement, [ele imageWithSubviews], @"", nil];
            
            NSString *elementIDString = [NSString stringWithFormat:@"%@", ele.elementid];
            NSArray *eleArray = [NSArray arrayWithObjects:elementIDString, [ele imageWithSubviews], @"", nil];
            
            [arrayOfStatements addObject:showElementArray];
            [arrayOfStatements addObject:hideElementArray];
            [arrayOfStatements addObject:eleArray]; // so we have a reference to the name of each element.
            // TODO: Ensure that if I now update the value of elementid, this updates the actions list.
        }
        

        
    } // end of for loop
    
    
   
    // catch all generic statements that do not belong in a loop
    NSLog(@"Now at 5");
    NSArray *genericStatements = [NSArray arrayWithObjects:
                               @"get Facebook photos posted by me",
                               @"get Facebook photos posted by friends",
                               @"get Facebook photos I've liked",
                               @"get Facebook photos liked by friends", // which includes data on the likes and is ordered by time by default
                               @"logged into Facebook",
                               @"login to FB",
                               @"get Facebook photos they've liked",
                               @"show the login button",
                               @"add row",
                               @"delete row",
                               nil];
    NSImage *appIcon = [NSImage imageNamed:NSImageNameApplicationIcon];
    NSArray *genericAction = nil;
    
    for (NSString *statement in genericStatements)
    {
        if ([statement containsString:@"facebook"])
        {
            NSRange rangeOfString = {0,0};
            rangeOfString = [statement rangeOfString:@"facebook" options:NSCaseInsensitiveSearch];
            //rangeOfString.length++; // get rid of the following space
            
            NSString *textBeforeIcon = [statement substringWithRange:NSMakeRange(0, rangeOfString.location)];
            NSUInteger currentPoint = rangeOfString.location + rangeOfString.length;
            NSString *textAfterIcon = [statement substringWithRange:NSMakeRange(currentPoint, statement.length - currentPoint)];
            genericAction = [NSArray arrayWithObjects:textBeforeIcon, appIcon, textAfterIcon, nil];
        }
        [arrayOfStatements addObject:genericAction];
    }
    
    //NSLog(@"Returning : %@", arrayOfStatements);
    return arrayOfStatements;
}



-(NSArray*)genericCommands
{
    NSImage *appIcon = [NSImage imageNamed:NSImageNameApplicationIcon];
    NSMutableArray *arrayToReturn = [NSMutableArray array];
    NSArray *gCommands =   [NSArray arrayWithObjects:
                                       @"if",
                                       @"or",
                                       @"and",
                                       @"not",
                                       @"otherwise",
                                       @"is equal to",
                                       @"contains",
                                       @"that contain",
                                       nil];
    for (NSString *each in gCommands) {
        NSArray *thePair = [NSArray arrayWithObjects:each, appIcon, @"", nil];
        [arrayToReturn addObject:thePair];
    }
    
    return arrayToReturn;

}
#pragma mark - Actions NSCombobox dataSource and delegate methods

-(NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    return [[self loadActions] count];
}

-(id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
    NSLog(@"Loading : %@", [[self loadActions] objectAtIndex:index]);
    return [[self loadActions] objectAtIndex:index];
}





#pragma mark - Element type toolbar table view datasource implementation

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    //Defensive: there may be cases where the nib containing the tblview loads before the data itself has been initialised.
    NSInteger count = 0;
    if (self.commandsAndActions)
    {
        count = self.commandsAndActions.count;
    }
    return count;
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    NSArray *rowContentArray = [self.commandsAndActions objectAtIndex:row];
    result.textField.stringValue = [NSString stringWithFormat:@"%@ %@", [rowContentArray objectAtIndex:0], [rowContentArray objectAtIndex:2]];
    result.imageView.image = [rowContentArray objectAtIndex:1];
    return result;
    
}



/*
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [self.commandsAndActions objectAtIndex:row];
}
*/

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    
    if ([actionsTableView selectedRow] > -1 )
    {
        selRow = [[notification object] selectedRow];
        NSLog(@"Selected row %lu", selRow);
        
        //Show the next button
        //[self.nextButton setHidden:YES];
        //NSLog(@"Actions are : %@", [self loadCommannds]);
        
        //self.selectedAction = [[NSMutableString alloc] initWithFormat:@"%@", [[self loadCommannds] objectAtIndex:[actionsTableView selectedRow]]];
        //NSLog(@"Selected Action : %@", self.selectedAction);
    }
    else
    {
        //[self.nextButton setHidden:YES];
    }
}

@end
