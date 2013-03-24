#import <Cocoa/Cocoa.h>
#import "ChangeBuilderWindowElementsAttributes.h"

@interface TriggersDataSourceDelegate : NSObject <NSTableViewDataSource, NSTableViewDelegate>

{
    NSMutableString *selectedTrigger;
    IBOutlet NSView *triggerView;
    IBOutlet id <ChangeBuilderWindowElementsAttributes> delegate;
}


@property (assign, nonatomic) NSMutableString *selectedTrigger;
@property (retain) id<ChangeBuilderWindowElementsAttributes>	delegate;
@end
