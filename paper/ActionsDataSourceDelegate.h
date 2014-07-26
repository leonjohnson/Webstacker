#import <Foundation/Foundation.h>
#import "ChangeBuilderWindowElementsAttributes.h"
#import "ChangeSelectedActionsDataSource.h"
@interface ActionsDataSourceDelegate : NSObject <NSTableViewDataSource, NSTableViewDelegate, NSComboBoxDataSource, NSComboBoxDelegate>
{    
    NSInteger selRow;
    NSMutableArray *commandsAndActions;
    NSTableView *actionsTableView;
    IBOutlet NSTableView *__strong selectedActionsTableview;
    IBOutlet id <ChangeBuilderWindowElementsAttributes> delegate;
    NSMutableArray *arrayToCheck;
    
}

//Actions
@property NSInteger selRow;
@property (nonatomic, strong) NSMutableArray *commandsAndActions;
@property (strong, nonatomic) NSTextField *actionsLabel;
@property (strong, nonatomic) NSTableView *selectedActionsTableview;
@property (strong) id<ChangeBuilderWindowElementsAttributes>	delegate;
@property (strong) NSMutableArray *arrayToCheck;
@end
