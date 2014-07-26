#import <Cocoa/Cocoa.h>

@interface DocumentSettingsView : NSView
{
    IBOutlet NSColorWell *__strong documentSettingsColorWell;
    IBOutlet NSButton *__strong myButton;
}



@property (strong, nonatomic) NSColorWell *documentSettingsColorWell;
@property (strong, nonatomic) NSButton *myButton;


@end
