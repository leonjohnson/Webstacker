#import <Foundation/Foundation.h>
#import "ChangeBuilderWindowElementsAttributes.h"
#import "ChangeSelectedActionsDataSource.h"


@interface SelectedActionsDataSourceDelegate : NSObject <NSTableViewDataSource, NSTableViewDelegate, ChangeSelectedActionsDataSource>
{
    //delete button    
    IBOutlet NSTableView *__strong SA_tableview;
    IBOutlet id <ChangeBuilderWindowElementsAttributes> __strong delegate;
    
}
//delete button

@property (nonatomic, strong) NSTableView *SA_tableview;
@property (nonatomic, strong) NSMutableArray *SA_dataSource;
@property (strong) id<ChangeBuilderWindowElementsAttributes>	delegate;
@end
