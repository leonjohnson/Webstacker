//
//  WarningMenuView.m
//  designer
//
//  Created by Bai Jin on 3/5/13.
//
//

#import "WarningMenuView.h"

@implementation WarningMenuView


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    //// General Declarations
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	
	//// Color Declarations
	NSColor* gradientColor = [NSColor colorWithCalibratedRed: 0.989 green: 0.983 blue: 0.974 alpha: 1];
	NSColor* gradientColor2 = [NSColor colorWithCalibratedRed: 0.75 green: 0.75 blue: 0.75 alpha: 1];
	NSColor* color = [NSColor colorWithCalibratedRed: 0.541 green: 0.541 blue: 0.541 alpha: 1];
	
	//// Gradient Declarations
	NSGradient* gradientBar = [[NSGradient alloc] initWithColorsAndLocations:
							   gradientColor2, 0.1,
							   gradientColor, 0.7, nil];
	
	
	//// Shadow Declarations
	NSShadow* shadow = [[NSShadow alloc] init];
	[shadow setShadowColor: color];
	[shadow setShadowOffset:NSMakeSize(1 * sin(180 * 3.141592 / 180), 1 * cos(180 * 3.141592 / 180))];
	[shadow setShadowBlurRadius: 2.5];
	
	
	//// Rectangle Drawing
	NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRect: NSMakeRect(dirtyRect.origin.x, 3, dirtyRect.size.width, dirtyRect.size.height - 3)];
	
	[NSGraphicsContext saveGraphicsState];

	[shadow set];
	
	CGContextBeginTransparencyLayer(context, NULL);
	
	[gradientBar drawInBezierPath: rectanglePath angle: 90];
	
	CGContextEndTransparencyLayer(context);
	
	[NSGraphicsContext restoreGraphicsState];
	
	/*//// Draw bottom border
	NSRect rtBottomBorder = NSMakeRect(dirtyRect.origin.x, 0, dirtyRect.size.width, 2);
	
	[NSGraphicsContext saveGraphicsState];
	
	[[NSColor colorWithCalibratedRed:0.8 green:0.8 blue:0.8 alpha:1.0] setFill];
	NSRectFill(rtBottomBorder);
	[NSGraphicsContext restoreGraphicsState];*/
}


/* programmatically create button.  This doesn't demonstrate anything new to autolayout.
 */
- (NSButton *)addPushButtonWithTitle:(NSString *)title identifier:(NSString *)identifier superView:(NSView *)superview {
    NSButton *pushButton = [[[NSButton alloc] init] autorelease];
    [pushButton setIdentifier:identifier];
    [pushButton setBezelStyle:NSRoundRectBezelStyle];
    [pushButton setFont:[NSFont systemFontOfSize:12.0]];
    [pushButton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin];
    [pushButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [superview addSubview:pushButton];
    if (title) [pushButton setTitle:title];
    
    [pushButton setTarget:self];
    [pushButton setAction:@selector(shuffleTitleOfSender:)];
    
    return pushButton;
}

/* programmatically create text field.  This doesn't demonstrate anything new to autolayout.
 */
- (NSTextField *)addTextFieldWithidentifier:(NSString *)identifier superView:(NSView *)superview {
    NSTextField *textField = [[[NSTextField alloc] init] autorelease];
    [textField setIdentifier:identifier];
    [[textField cell] setControlSize:NSSmallControlSize];
    [textField setBordered:YES];
    [textField setBezeled:YES];
    [textField setSelectable:YES];
    [textField setEditable:YES];
    [textField setFont:[NSFont systemFontOfSize:11.0]];
    [textField setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin];
    [textField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [superview addSubview:textField];
    return textField;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    /*
     Add views to the window.
     */
    
    NSView *contentView = self;
    
    id find = [self addPushButtonWithTitle:NSLocalizedString(@"Find", nil) identifier:@"find" superView:contentView];
    id findNext = [self addPushButtonWithTitle:NSLocalizedString(@"Find Next", nil) identifier:@"findNext" superView:contentView];
    id findField = [self addTextFieldWithidentifier:@"findField" superView:contentView];
    id replace = [self addPushButtonWithTitle:NSLocalizedString(@"Replace", nil) identifier:@"replace" superView:contentView];
    id replaceAndFind = [self addPushButtonWithTitle:NSLocalizedString(@"Replace & Find", nil) identifier:@"replaceAndFind" superView:contentView];
    id replaceField = [self addTextFieldWithidentifier:@"replaceField" superView:contentView];
    NSDictionary *views = NSDictionaryOfVariableBindings(find, findNext, findField, replace, replaceAndFind, replaceField);
    
    /*
     View layout
     */
    
    // Basic layout of the two rows
    // Give the text fields a hard minimum width, because it looks good.
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[find]-[findNext]-[findField(>=20)]-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[replace]-[replaceAndFind]-[replaceField(>=20)]-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    
    // Vertical layout.  We just need to specify what happens to one thing in each row, since everything within a row is already top aligned.  We'll use the text fields, since then we can align their leading edges as well in one step.
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[findField]-[replaceField]-(>=20)-|" options:NSLayoutFormatAlignAllLeading metrics:nil views:views]];
    
    // lower the content hugging priority of the text fields from NSLayoutPriorityDefaultLow, so that they expand to fill extra space rather than the buttons.
    for (NSView *view in [NSArray arrayWithObjects:findField, replaceField, nil]) {
        [view setContentHuggingPriority:NSLayoutPriorityDefaultLow - 1 forOrientation:NSLayoutConstraintOrientationHorizontal];
    }
    
    // In the row in which the buttons are smaller (whichever that is), it is still ambiguous how the buttons expand from their preferred widths to fill the extra space between the window edge and the text field.
    // They should prefer to be equal width, more weakly than our other constraints.
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[find(==findNext@25)]" options:0 metrics:nil views:views]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[replace(==replaceAndFind@25)]" options:0 metrics:nil views:views]];
    
    // see what it looks like if you visualize some of the constraints.
    //    [[contentView window] visualizeConstraints:[replaceField constraintsAffectingLayoutForOrientation:NSLayoutConstraintOrientationHorizontal]];
    
    // after you see that, try removing the calls to set content hugging priority above, and see what visualization looks like in that case.  This demonstrates an ambiguous situation.
    
    // now, see what it looks like in German and Arabic!
}


- (IBAction)shuffleTitleOfSender:(id)sender {
    NSArray *strings = [NSArray arrayWithObjects:@"S", @"Short", @"Absolutely ginormous string (for a button)", nil];
    NSInteger previousStringIndex = [strings indexOfObject:[sender title]];
    NSInteger nextStringIndex = (((previousStringIndex == NSNotFound) ? -1 : previousStringIndex) + 1) % 3;
    [sender setTitle:[strings objectAtIndex:nextStringIndex]];
}

@end
