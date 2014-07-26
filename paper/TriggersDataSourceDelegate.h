#import <Cocoa/Cocoa.h>
#import "ChangeBuilderWindowElementsAttributes.h"

@interface TriggersDataSourceDelegate : NSObject <NSTableViewDataSource, NSTableViewDelegate>

{
    NSMutableString *selectedTrigger;
    IBOutlet NSView *triggerView;
    IBOutlet id <ChangeBuilderWindowElementsAttributes> delegate;
}


@property (strong, nonatomic) NSMutableString *selectedTrigger;
@property (strong) id<ChangeBuilderWindowElementsAttributes>	delegate;
@end
