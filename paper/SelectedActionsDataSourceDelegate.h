#import <Foundation/Foundation.h>
#import "ChangeBuilderWindowElementsAttributes.h"
#import "ChangeSelectedActionsDataSource.h"


@interface SelectedActionsDataSourceDelegate : NSObject <NSTableViewDataSource, NSTableViewDelegate, ChangeSelectedActionsDataSource>
{
    //delete button    
    IBOutlet NSTableView *SA_tableview;
    IBOutlet id <ChangeBuilderWindowElementsAttributes> delegate;
    
}
//delete button

@property (nonatomic, assign) NSTableView *SA_tableview;
@property (nonatomic, assign) NSMutableArray *SA_dataSource;
@property (assign) id<ChangeBuilderWindowElementsAttributes>	delegate;
@end
