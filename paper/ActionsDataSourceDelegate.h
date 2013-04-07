#import <Foundation/Foundation.h>
#import "ChangeBuilderWindowElementsAttributes.h"
#import "ChangeSelectedActionsDataSource.h"
@interface ActionsDataSourceDelegate : NSObject <NSTableViewDataSource, NSTableViewDelegate, NSComboBoxDataSource, NSComboBoxDelegate>
{    
    NSInteger selRow;
    NSMutableArray *commandsAndActions;
    NSTableView *actionsTableView;
    IBOutlet NSTableView *selectedActionsTableview;
    IBOutlet id <ChangeBuilderWindowElementsAttributes> delegate;
    NSMutableArray *arrayToCheck;
    
}

//Actions
@property NSInteger selRow;
@property (nonatomic, retain) NSMutableArray *commandsAndActions;
@property (assign, nonatomic) NSTextField *actionsLabel;
@property (assign, nonatomic) NSTableView *selectedActionsTableview;
@property (retain) id<ChangeBuilderWindowElementsAttributes>	delegate;
@property (retain) NSMutableArray *arrayToCheck;
@end
