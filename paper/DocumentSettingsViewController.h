#import <Cocoa/Cocoa.h>
#import "DocumentSettingsView.h"

@interface DocumentSettingsViewController : NSViewController

{
    //NSPopover *myPopover;
    NSButton *__strong OKbutton;
    DocumentSettingsView *__strong dsView;
    IBOutlet NSTextField *__strong pageTitle_Snow_Leopard;
    IBOutlet NSTextField *__strong pageTitle;

    
    
    
}

-(IBAction)saveDocumentSettings:(id)sender;
- (IBAction)setStageBackgroundColor:(id)sender;

@property (strong) IBOutlet NSButton *OKbutton;
@property (strong) NSPopover *myPopover;
@property (strong, nonatomic) DocumentSettingsView *dsView;

@property (strong) NSTextField *pageTitle;
@property (strong) NSTextField *pageTitle_Snow_Leopard;
@end
