//
//  StageView+backgroundAppearance.m
//  designer
//
//  Created by Leon Johnson on 31/03/2013.
//
//

#import "StageView.h"
#import "Document.h"




@implementation StageView (backgroundAppearance)

-(IBAction)toggleGridlineVisibility:(id)sender
{
    self.showGridlines = !self.showGridlines;
    [self setNeedsDisplay: YES];
}

- (IBAction)changeStageBackgroundColor:(id)sender
{
    NSLog(@"%@", [sender color]);
    self.stageBackgroundColor = [[sender color] colorUsingColorSpaceName:NSDeviceRGBColorSpace];
    [self setNeedsDisplay:YES];
}

-(IBAction)saveDocumentSettings:(id)sender
{
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    NSWindowController *wc = [[curDoc windowControllers] objectAtIndex:0];
    NSString *newTitle = [sender stringValue];
    NSLog(@"New Title : %@", newTitle);
    //[wc windowTitleForDocumentDisplayName:self.pageTitle.stringValue];
    [[wc window] setTitle:newTitle];
	[curDoc setDisplayName:[sender stringValue]];
    //[wc synchronizeWindowTitleWithDocumentName];
    
    //close the popover
    
    //[[curDoc stageView] closeSettingsPopover];
    
    
    
}
@end
