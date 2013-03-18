#import "DocumentWindowController.h"


@interface DocumentWindowController ()

@end


@implementation DocumentWindowController


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        /*
        NSRect frame = [window frame];
        frame.origin.y -= frame.size.height; // remove the old height
        frame.origin.y += 520; // add the new height
        frame.size = NSMakeSize(164, 520);
        // continue as before
        [window setFrame:frame display:YES animate:NO];
        */
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    NSLog(@"DocWinCont called first!");
    //NSLog(@"Called as 1");
}



-(NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
    NSLog(@"windowTitleForDocumentDisplayName CALLED with : %@", displayName);
    return displayName;
    
}

-(void)synchronizeWindowTitleWithDocumentName
{
}


@end
