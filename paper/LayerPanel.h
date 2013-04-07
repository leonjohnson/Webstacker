#import <Cocoa/Cocoa.h>
#import "SetLayerOrderDelegate.h"
#import "BasePanel.h"
#import "Element.h"

@interface LayerPanel : BasePanel
<NSTableViewDataSource, NSTableViewDelegate, SetLayerOrderDelegate>
{
	IBOutlet NSTableView						*_tableViewLayer;
}
@property (assign) Element *ele;
/*
 @function:			OnVisible
 @purpose:			This function called when the user click the visible check box of layer table.
 */
- (IBAction)OnVisible:(id)sender;

- (void)doubleClickOnTable:(id)sender;

@end
