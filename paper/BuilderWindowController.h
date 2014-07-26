#import <Cocoa/Cocoa.h>
#import "ChangeBuilderWindowElementsAttributes.h"
#import "INAppStoreWindow.h"
#import "Button.h"

@interface BuilderWindowController : NSWindowController <ChangeBuilderWindowElementsAttributes>

{
    IBOutlet NSTabView *builderTabs;
    
    //Test views
    Button *__strong buttonView;
    
    //Buttons
    IBOutlet NSButton *__strong deleteButton;
    IBOutlet NSButton *__strong addButton;
    IBOutlet NSButton *__strong nextButton;
    IBOutlet NSButton *__strong backButton;
    IBOutlet NSButton *__strong saveButton;
    
    //Enter a name for this action
    IBOutlet NSTextField *actionName;
    
    //Triggers
    IBOutlet NSScrollView *__strong triggerScrollView;
    IBOutlet NSTableView *__strong triggerTableView;
    

    int indexOfSelectedTrigger;
    NSUInteger *indexRowSelected;
    
    
    //Actions
    IBOutlet NSTextField *__strong actionsLabel;
    IBOutlet NSView *actionView;
    IBOutlet NSTableView *actionsTableView;
    IBOutlet NSScrollView *actionsScrollView;

    
    //Selected Actions
    IBOutlet NSScrollView *actionsSelectedScrollView;
    IBOutlet NSTableView *actionsSelectedTableView;
  
    //Datasources
    NSMutableDictionary *__strong actionList;
    NSMutableArray *__strong ds; // This contains the list of actions to use in .js
}

-(IBAction)addActionToMyList:(id)sender;

@property (strong, nonatomic) Button *buttonView;

//Action
@property (strong, nonatomic) NSTextField *actionName;
//Buttons
@property (strong, nonatomic) NSButton *deleteButton;
@property (strong, nonatomic) NSButton *addButton;
@property (strong, nonatomic) NSButton *nextButton;
@property (strong, nonatomic) NSButton *backButton;
@property (strong, nonatomic) NSButton *saveButton;

//Triggers
@property (strong, nonatomic) NSScrollView *triggerScrollView;
@property (strong, nonatomic) NSTableView *triggerTableView;

@property (assign, nonatomic) NSUInteger *indexRowSelected;

@property (strong, nonatomic) NSView *triggerView;

@property (strong, nonatomic) NSTableView *actionsTableView;
@property (strong, nonatomic) NSScrollView *actionsScrollView;

//Actions
@property (strong, nonatomic) NSTextField *actionsLabel;


//Selected Actions
@property (strong, nonatomic) NSScrollView *actionsSelectedScrollView;
@property (strong, nonatomic) NSTableView *actionsSelectedTableView;

//Data sources
@property (strong, nonatomic) NSMutableDictionary *actionList;
@property (strong, nonatomic) NSMutableArray *ds;
@end
