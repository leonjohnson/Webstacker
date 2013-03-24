#import <Cocoa/Cocoa.h>
#import "ChangeBuilderWindowElementsAttributes.h"
#import "INAppStoreWindow.h"
#import "Button.h"

@interface BuilderWindowController : NSWindowController <ChangeBuilderWindowElementsAttributes>

{
    IBOutlet NSTabView *builderTabs;
    
    //Test views
    Button *buttonView;
    
    //Buttons
    IBOutlet NSButton *deleteButton;
    IBOutlet NSButton *addButton;
    IBOutlet NSButton *nextButton;
    IBOutlet NSButton *backButton;
    IBOutlet NSButton *saveButton;
    
    //Enter a name for this action
    IBOutlet NSTextField *actionName;
    
    //Triggers
    IBOutlet NSScrollView *triggerScrollView;
    IBOutlet NSTableView *triggerTableView;
    

    int indexOfSelectedTrigger;
    NSUInteger *indexRowSelected;
    
    
    //Actions
    IBOutlet NSTextField *actionsLabel;
    IBOutlet NSView *actionView;
    IBOutlet NSTableView *actionsTableView;
    IBOutlet NSScrollView *actionsScrollView;

    
    //Selected Actions
    IBOutlet NSScrollView *actionsSelectedScrollView;
    IBOutlet NSTableView *actionsSelectedTableView;
  
    //Datasources
    NSMutableDictionary *actionList;
    NSMutableArray *ds; // This contains the list of actions to use in .js
}

-(IBAction)addActionToMyList:(id)sender;

@property (assign, nonatomic) Button *buttonView;

//Action
@property (retain, nonatomic) NSTextField *actionName;
//Buttons
@property (assign, nonatomic) NSButton *deleteButton;
@property (assign, nonatomic) NSButton *addButton;
@property (assign, nonatomic) NSButton *nextButton;
@property (assign, nonatomic) NSButton *backButton;
@property (assign, nonatomic) NSButton *saveButton;

//Triggers
@property (assign, nonatomic) NSScrollView *triggerScrollView;
@property (assign, nonatomic) NSTableView *triggerTableView;

@property (assign, nonatomic) NSUInteger *indexRowSelected;

@property (assign, nonatomic) NSView *triggerView;

@property (assign, nonatomic) NSTableView *actionsTableView;
@property (assign, nonatomic) NSScrollView *actionsScrollView;

//Actions
@property (assign, nonatomic) NSTextField *actionsLabel;


//Selected Actions
@property (assign, nonatomic) NSScrollView *actionsSelectedScrollView;
@property (assign, nonatomic) NSTableView *actionsSelectedTableView;

//Data sources
@property (assign, nonatomic) NSMutableDictionary *actionList;
@property (assign, nonatomic) NSMutableArray *ds;
@end
