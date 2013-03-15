#import <Cocoa/Cocoa.h>
#import "DocumentSettingsView.h"

@interface DocumentSettingsViewController : NSViewController

{
    //NSPopover *myPopover;
    NSButton *OKbutton;
    DocumentSettingsView *dsView;
    IBOutlet NSTextField *pageTitle_Snow_Leopard;
    IBOutlet NSTextField *pageTitle;

    
    
    
}

-(IBAction)saveDocumentSettings:(id)sender;
- (IBAction)setStageBackgroundColor:(id)sender;

@property (assign) IBOutlet NSButton *OKbutton;
@property (retain) NSPopover *myPopover;
@property (assign, nonatomic) DocumentSettingsView *dsView;

@property (assign) NSTextField *pageTitle;
@property (assign) NSTextField *pageTitle_Snow_Leopard;
@end
