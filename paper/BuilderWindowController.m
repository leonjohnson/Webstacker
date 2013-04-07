#import "BuilderWindowController.h"
#import "ImageAndTextCell.h"
#import "TriggersDataSourceDelegate.h"
#import "ActionsDataSourceDelegate.h"
#import "SelectedActionsDataSourceDelegate.h"
#import "AppDelegate.h"
#import "Common.h"
#import "Document.h"

#define builderScreenTitle_1   @"1. Enter a name for this action"
#define builderScreenTitle_2   @"2. Select a trigger"
#define builderScreenTitle_3   @"3. Choose actions from below"

// 249 LINES OF CODE ON 08-02-2013

@interface BuilderWindowController ()

@end

@implementation BuilderWindowController
@synthesize indexRowSelected;
@synthesize nextButton, backButton, addButton, deleteButton, saveButton;
@synthesize triggerView;
@synthesize triggerTableView, triggerScrollView;
@synthesize actionsLabel;
@synthesize actionList, ds;
@synthesize actionName, buttonView;


-(void)hideAndClearAllItems
{
    //Buttons
    [self.backButton setHidden:YES];
    [self.saveButton setHidden:YES];
    [self.nextButton setHidden:YES];
    [self.addButton setHidden:YES];
    [self.deleteButton setHidden:YES];
    
    //Scrollviews
    [self.actionsScrollView setHidden:YES];
    [self.actionsSelectedScrollView setHidden:YES];
    [self.triggerScrollView setHidden:YES];
    
    //Tables
    [self.actionsTableView setHidden:YES];
    [self.actionsSelectedScrollView setHidden:YES];
    [self.triggerTableView setHidden:YES];
    
    
    //Labels
    [self.actionsLabel setStringValue:@""];
    
    //TextFields
    [self.actionName setHidden:YES];
}

-(void)createEnterNameScreen //Set the first screen
{
    [self hideAndClearAllItems];
    [self.actionsLabel setStringValue:builderScreenTitle_1];
    
    [self.actionName setHidden:NO];
    [self.nextButton setHidden:NO];
    [self.nextButton setEnabled:YES];
}


-(void)createTriggerScreen // screen 2
{
    [self hideAndClearAllItems];
    [self.actionsLabel setStringValue:builderScreenTitle_2];
    
    //show the new fields
    [self.triggerScrollView setHidden:NO];
    [self.triggerTableView setHidden:NO];
    [self.nextButton setHidden:NO];
    if ([triggerTableView selectedRow] > -1)
    {
        [self.nextButton setEnabled:YES];
    }
    else
    {
        [self.nextButton setEnabled:NO];
    }
    
    [self.backButton setHidden:NO];
}




-(void)createActionsScreen
{
    [self hideAndClearAllItems];
    [self.actionsLabel setStringValue:builderScreenTitle_3];
    
    //Show action state
    [self.backButton setHidden:NO];
    [self.saveButton setHidden:NO];
    [self.addButton setHidden:NO];
    [self.deleteButton setHidden:NO];

    [self.actionsScrollView setHidden:NO];
    [self.actionsTableView setHidden:NO];
    
    [self.actionsSelectedScrollView setHidden:NO];
    
}



-(void)awakeFromNib
{
    //[self createEnterNameScreen];
     ds = [NSMutableArray array];
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
    
    NSLog(@"BuilderWindow Controller loaded");
}


-(IBAction)pressNextButton:(id)sender
{
    [builderTabs selectNextTabViewItem:sender];
    if ([builderTabs indexOfTabViewItem:builderTabs.selectedTabViewItem] == [builderTabs indexOfTabViewItemWithIdentifier:BUILDER_TRIGGERS_TAB] )
    {
        if ([triggerTableView selectedRow] > -1)
        {
            [self.nextButton setEnabled:YES];
        }
        else
        {
            [self.nextButton setEnabled:NO];
        }
    }
    
    if ([builderTabs indexOfTabViewItem:builderTabs.selectedTabViewItem] == [builderTabs indexOfTabViewItemWithIdentifier:BUILDER_COMMANDS_TAB] )
    {
        [saveButton setHidden:NO];
        [nextButton setEnabled:NO];
    }
    else
    {
        [saveButton setHidden:YES];
    }
}


-(IBAction)pressBackButton:(id)sender
{
    [builderTabs selectPreviousTabViewItem:sender];
    [saveButton setHidden:YES];
    [nextButton setEnabled:YES];
}

-(IBAction)pressSaveButton:(id)sender
{
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    NSMutableSet *elementsInvolved = [curDoc elementsReferedToInBuilderScripts];
    // save the data
    /*
     'name': NSString of the actions name
     'element': id of Element or NSString @"Application"
     'trigger': NSString of the trigger
     'recipe' : NSArray
     'documentation' : NSString, // documentation for this recipe
     'designation' : NSString, // either rowItem, standAlone, or dataSource? Unlikely.
     'customOrAdapted' : NSString // it's either a custom recipe or adapted
     */
    for (NSDictionary *each in [[NSApp delegate] actionsArray])
    {
        // check if dictionary eqists that already has a key of 'name' equal to what we're about to save
    }
    NSLog(@"ds =  %@", ds);
    NSLog(@"trigger = %@", ((TriggersDataSourceDelegate*)triggerTableView.dataSource).selectedTrigger);
    NSLog(@"action = %@", elementsInvolved);
    
    NSMutableDictionary *actionDictionaryToSave = [NSMutableDictionary dictionary];
    
    
    
    if ([actionName stringValue] == nil)
        [actionDictionaryToSave setObject:[NSNull null] forKey:@"name"];
    else
        [actionDictionaryToSave setObject:[actionName stringValue] forKey:@"name"];
    
    
    
    
    if (elementsInvolved == nil)
        [actionDictionaryToSave setObject:[NSNull null] forKey:@"elementsInvolved"];
    else
        [actionDictionaryToSave setObject:elementsInvolved forKey:@"elementsInvolved"];
    
    
    
    if (ds == nil)
        [actionDictionaryToSave setObject:[NSNull null] forKey:@"recipe"];
    else
        [actionDictionaryToSave setObject:ds forKey:@"recipe"];
    
    
    
    if (((TriggersDataSourceDelegate*)triggerTableView.dataSource).selectedTrigger == nil)
        [NSNull null];
    else
        [actionDictionaryToSave setObject:((TriggersDataSourceDelegate*)triggerTableView.dataSource).selectedTrigger forKey:@"trigger"];
    
    [actionDictionaryToSave setObject:[NSNull null] forKey:@"documentation"];
    [actionDictionaryToSave setObject:[NSNull null] forKey:@"designation"];
    [actionDictionaryToSave setObject:[NSNull null] forKey:@"customOrAdapated"];
    
    
    NSLog(@"want to save: %@", actionDictionaryToSave);
    [[[NSApp delegate] actionsArray] addObject:actionDictionaryToSave];
    NSLog(@"Saved: %@", [[NSApp delegate] actionsArray] );
    //Close the window
    
    
    //Give thanks menu
    //TODO: CONFIRM TO THE USER THE ACTION WAS SAVED :-)
    NSLog(@"Can now close the window :-)");
    
}


-(void)nextButtonWillBeEnabled:    (BOOL)hidden
{
    [self.nextButton setEnabled:hidden];
}

-(void)backButtonWillBeEnabled:  (BOOL)hidden
{
    [self.nextButton setEnabled:hidden];
}

-(void)saveButtonWillBeEnabled:  (BOOL)hidden
{
    [self.saveButton setEnabled:hidden];
}









@end
