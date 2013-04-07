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
#import "NSMutableArray+addBuilderScreenOptions.h"

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
        Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
        NSArray *elementsIDArray = [[[curDoc stageView] elementArray] valueForKeyPath:ELEMENT_ID];
        NSString *eleID = [[self.commandsAndActions objectAtIndex:selRow] objectForKey:ELEMENT_ID];
        NSLog(@"stage has : %@", elementsIDArray);
        NSLog(@"tHIS OBJECT HAS KEY OF: %@", eleID);
        //Add the selected row to the datasource for the selected actions tbl
        //Add the selected row to the final actions list - should this not be done at publish time?
        //Add just the text, so [0] in next line.
        id objectToAdd = [[self.commandsAndActions objectAtIndex:selRow]objectForKey:STATEMENT];
        if ([[((BuilderWindowController*)self.delegate) ds] containsObject:objectToAdd])
        {
            //WARNING: Throw a warning that this action is already in your actions List.
            NSLog(@"Throw a a warning.");
        }
        
        if ([elementsIDArray containsObject:eleID])
            [[curDoc elementsReferedToInBuilderScripts] addObject:eleID];
        
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
    
    // [0] = The action statement
    // [1] = The icon
    // [2] = ElementID if applicable
    // [3] = Documentation
    
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
                    NSDictionary *array = [NSDictionary addStatement:statement icon:ele.imageWithSubviews elementid:ele.elementid documentation:nil];
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
                    NSDictionary *array = [NSDictionary addStatement:statement icon:ele.imageWithSubviews elementid:ele.elementid documentation:nil];
                    [arrayOfStatements addObject:array];
                }
            }
            
            
            //For drop down menus
            if (([ele isMemberOfClass:[DropDown class]]))
            {
                NSArray *dataSource = ((DropDown*)ele).dataSource;
                if (dataSource.count > 1)
                    for (NSString *key in [dataSource objectAtIndex:0]) // every row in the array has the same dictionary structure so the first will do.
                    {
                        NSString *myString = [NSString stringWithFormat:@"Get the %@ for the selected %@", key, ele.elementid];
                        //NSArray *dropDownArray = [NSArray arrayWithObjects:myString, [ele imageWithSubviews], ele.elementid , @"", nil];
                        NSDictionary *dropDownArray = [NSDictionary addStatement:myString icon:ele.imageWithSubviews elementid:ele.elementid documentation:nil];
                        [arrayOfStatements addObject:dropDownArray];
                    }
            }
            
            /*
            //For buttons and dyRow on stage
            if ([ele isMemberOfClass:[Button class]]) {
                if ([elementsArray ]) {
                    <#statements#>
                }
            }
            */
            //Generic statements for all elements
            NSString *showElement = [NSString stringWithFormat:@"show element with tag %@", ele.elementid];
            //NSArray *showElementArray = [NSArray arrayWithObjects:showElement, [ele imageWithSubviews], @"", nil];
            NSDictionary *showElementArray = [NSDictionary addStatement:showElement icon:ele.imageWithSubviews elementid:ele.elementid documentation:nil];
            
            NSString *hideElement = [NSString stringWithFormat:@"hide element with tag %@", ele.elementid];
            //NSArray *hideElementArray = [NSArray arrayWithObjects:hideElement, [ele imageWithSubviews], @"", nil];
            NSDictionary *hideElementArray = [NSDictionary addStatement:hideElement icon:ele.imageWithSubviews elementid:ele.elementid documentation:nil];
            
            NSString *elementIDString = [NSString stringWithFormat:@"%@", ele.elementid];
            //NSArray *eleArray = [NSArray arrayWithObjects:elementIDString, [ele imageWithSubviews], @"", nil];
            NSDictionary *eleArray = [NSDictionary addStatement:elementIDString icon:ele.imageWithSubviews elementid:ele.elementid documentation:nil];
            
            [arrayOfStatements addObject:showElementArray];
            [arrayOfStatements addObject:hideElementArray];
            [arrayOfStatements addObject:eleArray]; // so we have a reference to the name of each element.
            // TODO: Ensure that if I now update the value of elementid, this updates the actions list.
        }
        

        
    } // end of for loop
    
    

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
        NSDictionary *thePair = [NSDictionary addStatement:each icon:appIcon elementid:nil documentation:nil];
        
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
    return [[[self loadActions] objectAtIndex:index] objectForKey:STATEMENT];
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
    NSDictionary *rowContent = [self.commandsAndActions objectAtIndex:row];
    result.textField.stringValue = [rowContent objectForKey:STATEMENT];
    result.imageView.image = [rowContent objectForKey:ICON];
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
