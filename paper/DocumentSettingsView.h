#import <Cocoa/Cocoa.h>

@interface DocumentSettingsView : NSView
{
    IBOutlet NSColorWell *documentSettingsColorWell;
    IBOutlet NSButton *myButton;
}



@property (assign, nonatomic) NSColorWell *documentSettingsColorWell;
@property (assign, nonatomic) NSButton *myButton;


@end
