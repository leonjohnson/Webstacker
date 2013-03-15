#import "DocumentSettingsViewController.h"
#import "Document.h"
@implementation DocumentSettingsViewController
@synthesize OKbutton, myPopover, dsView;
@synthesize pageTitle, pageTitle_Snow_Leopard;

-(id)init
{
    NSLog(@"yo");
    return self;
}
/*
// -------------------------------------------------------------------------------
//  createPopover
// -------------------------------------------------------------------------------
- (void)createPopover
{
    if (self.myPopover == nil)
    {
        // create and setup our popover
        myPopover = [[NSPopover alloc] init];
        
        // the popover retains us and we retain the popover,
        // we drop the popover whenever it is closed to avoid a cycle
        //
        // use a different view controller content if normal vs. HUD appearance
        //

        self.myPopover.contentViewController = self;
        
        //self.myPopover.appearance = [popoverType selectedRow];
        
        self.myPopover.animates = YES;
        
        // AppKit will close the popover when the user interacts with a user interface element outside the popover.
        // note that interacting with menus or panels that become key only when needed will not cause a transient popover to close.
        self.myPopover.behavior = NSPopoverBehaviorTransient;
        
        // so we can be notified when the popover appears or closes
        //self.myPopover.delegate = self;
    }
}
*/


- (IBAction)setStageBackgroundColor:(id)sender
{
    NSLog(@"%@", [sender color]);
    NSDictionary *stageViewSettings = [NSDictionary dictionaryWithObject:[[sender color] colorUsingColorSpaceName:NSDeviceRGBColorSpace] forKey:@"stageViewBackgroundColor"];
    
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[[curDoc stageView] updateStageViewBackgroundColor:stageViewSettings];

    
}

-(IBAction)saveDocumentSettings:(id)sender
{
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    NSWindowController *wc = [[curDoc windowControllers] objectAtIndex:0];
    NSString *newTitle = self.pageTitle.stringValue;
    if (newTitle == nil)
    {
        newTitle = self.pageTitle_Snow_Leopard.stringValue;
    }
    NSLog(@"New Title : %@", newTitle);
    //[wc windowTitleForDocumentDisplayName:self.pageTitle.stringValue];
    [[wc window] setTitle:newTitle];
	[curDoc setDisplayName:self.pageTitle.stringValue];
    //[wc synchronizeWindowTitleWithDocumentName];
    
    //close the popover
    
    [[curDoc stageView] closeSettingsPopover];
    


}


@end
