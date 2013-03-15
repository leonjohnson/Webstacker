#import <AppKit/AppKit.h>

@interface StageTextView : NSTextView <NSTextViewDelegate>
{
    CGFloat kerning;
    CGFloat leading;
    BOOL readyToTakeFontColor;
    
}

-(void)postNotificationToClearKerningLeading;
-(NSColor *)fontColor;
-(void)setFontColor:(id)sender;

-(NSNumber *)fontSize;
-(void)setFontSize:(id)sender;
- (void)selectWordUnderMouse:(NSEvent *)theEvent;

@property (assign) CGFloat kerning;
@property (assign) CGFloat leading;
@end
