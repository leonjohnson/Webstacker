#import "AppDelegate.h"
#import "Document.h"
#import "StageView.h"
#import "StageTextViewDelegate.h"
#import "StageTextView.h"
#import "SBCenteringClipView.h"

#import "GroupingBox.h"
#import "Box.h"
#import "Circle.h"
#import "TextBox.h"
#import "Singleton.h"
#import "Image.h"
#import "Button.h"
#import "TextInputField.h"
#import "DropDown.h"
#import "DynamicRow.h"
#import "Triangle.h"






//#import "documentSettingsViewController.h"

@implementation StageView

@synthesize sortedArray;
@synthesize jsCode2;
@synthesize finalGrouping;

@synthesize attributeDelegate, elementCount, currentElement, numberOfGroupings, groupItems, documentSettingsButton, textboxView, sv;
@synthesize groupingBoxes;
@synthesize leftToRightTopToBottom;
@synthesize rows, rowMargins;
@synthesize selElementArray;
@synthesize elementArray;
@synthesize documentSettingsPopover;
@synthesize documentSettingsView;
@synthesize documentContainer;
@synthesize containerWidth, containerHeight;
@synthesize stageBackgroundColor;
@synthesize textPopover;


@synthesize elementBeenDroppedToStage;

@synthesize panel;

@synthesize layoutType;
@synthesize orderOfLayers;
@synthesize layerDelegate;
@synthesize isShowFontTab;

@synthesize showGridlines;

@synthesize fontFamilyLabel; //
@synthesize fontStyleLabel; //
@synthesize textSizeLabel; //
@synthesize kerningLabel; //
@synthesize leadingLabel; //
@synthesize fontcolourWellLabel; //

@synthesize fontSizeTextField2, kerningField, leadingField, fontColorWell, fontTraitControl;

@synthesize kerningStepper, leadingStepper;



/* These images are displayed as markers on the rulers. */
static NSImage *leftImage;
static NSImage *rightImage;
static NSImage *topImage;
static NSImage *bottomImage;

/* These strings are used to identify the markers. */

#define STR_LEFT   @"Left Edge"
#define STR_RIGHT  @"Right Edge"
#define STR_TOP    @"Top Edge"
#define STR_BOTTOM @"Bottom Edge"

#define xcoordinate @"xcoordinate"
#define ycoordinate @"ycoordinate"
#define bottomYcoordinate @"bottomYcoordinate"





#pragma mark - INITIALIZE AND DRAW THE STAGE

+ (void)initialize
{
    
    NSBundle *mainBundle = nil;
    NSString *imgPath = nil;
    NSArray *upArray = nil;
    NSArray *downArray = nil;
    
    
    mainBundle = [NSBundle mainBundle];
    imgPath = [mainBundle pathForImageResource:@"shape_0_circle"];
    leftImage = [[NSImage alloc] initWithContentsOfFile:imgPath];
    
    imgPath = [mainBundle pathForImageResource:@"shape_0_circle"];
    rightImage = [[NSImage alloc] initWithContentsOfFile:imgPath];
    
    imgPath = [mainBundle pathForImageResource:@"shape_0_circle"];
    topImage = [[NSImage alloc] initWithContentsOfFile:imgPath];
    
    imgPath = [mainBundle pathForImageResource:@"shape_0_circle"];
    bottomImage = [[NSImage alloc] initWithContentsOfFile:imgPath];
    
    upArray = [NSArray arrayWithObjects:[NSNumber numberWithDouble:2.0], nil];
    downArray = [NSArray arrayWithObjects:[NSNumber numberWithDouble:0.5],
                 [NSNumber numberWithDouble:0.2], nil];
    /*[NSRulerView registerUnitWithName:@"Grummets"
                         abbreviation:NSLocalizedString(@"gt", @"Grummets abbreviation string")
         unitToPointsConversionFactor:100.0
                          stepUpCycle:upArray stepDownCycle:downArray];*/
    
    
    
    
    return;
}



- (void)awakeFromNib
{
	//[self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.containerWidth = 300;
    self.containerHeight = 600;
    NSColorSpace *colorSpace = [NSColorSpace genericRGBColorSpace];
    self.stageBackgroundColor = [[NSColor whiteColor] colorUsingColorSpace:colorSpace];
    
    // set the flag to no as nothing has been dropped to the stage yet
    elementBeenDroppedToStage = NO;
    
    
    // initialise orderOfLayers variable
    orderOfLayers = [NSMutableArray array];
    
    [textboxView setDelegate:self.textboxView];
    
    
    elementArray = [[NSMutableArray alloc] init];
    selElementArray = [[NSMutableArray alloc] init];
	
	isDragingShape = NO;
	isSelectedShape = NO;
    isSelArea = NO;
	CutOrCopyFlag = SHAPE_NORMAL;
    self.showGridlines = YES;
    
	// set accepting mouse move event
	[[self window] setInitialFirstResponder:self];
	[[self window] makeFirstResponder:self];
	[[self window] setAcceptsMouseMovedEvents:YES];
    
    
    
    //Rulers
    NSScrollView *scrollView = [self enclosingScrollView];
    
    if (!scrollView) return;
    //[scrollView setHasHorizontalRuler:YES];
    //[scrollView setHasVerticalRuler:YES];
    //[self setRulerOffsets];
    //[self updateRulers];
    //[scrollView setRulersVisible:YES];
    
    // Centring the view in the scrollview
    id documentView = [[scrollView documentView] retain];
    id newClipView = [[SBCenteringClipView alloc] initWithFrame:[[scrollView contentView] frame]];
    [newClipView setBackgroundColor:[NSColor windowBackgroundColor]];
    [scrollView setContentView:newClipView];
    [newClipView release];
    [scrollView setDocumentView:documentView];
    [documentView release];
    
    
    //Fonts panel
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSArray *typeFaceFamilies = [fontManager availableFontFamilies];
    [_typeFaceName addItemsWithTitles:typeFaceFamilies];
    [_typeFaceName selectItemWithTitle:@"Helvetica Neue"];
	
	fontFaceArray = [[NSMutableArray alloc] initWithArray:typeFaceFamilies];
	
	{ // custom menu item
		for (NSString *fontName in typeFaceFamilies) {
			NSMenuItem *item = [_typeFaceName itemWithTitle:fontName];
			/*NSTextField *txtField = [[NSTextField alloc] initWithFrame:typeFaceName.frame];
			[txtField setStringValue:fontName];
			[txtField setEditable:NO];
			[item setView:txtField];*/
			NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSFont fontWithName:fontName size:12], NSFontAttributeName, nil];
			NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:fontName attributes:attributes];
			[item setAttributedTitle:attributedTitle];
		}
	}
	
    [self setTypeFaceFamily:_typeFaceName];
    [fontColorWell bind:@"value" toObject:self withKeyPath:@"textboxView.fontColor" options:nil];
    [kerningStepper bind:@"value" toObject:self withKeyPath:@"kerningValue" options:nil]; // setKerningValue //
    [kerningField bind:@"value" toObject:self withKeyPath:@"kerningValue" options:nil];
    [leadingStepper bind:@"value" toObject:self withKeyPath:@"leadingValue" options:nil];
    [leadingField bind:@"value" toObject:self withKeyPath:@"leadingValue" options:nil];
    [fontSizeTextField2 bind:@"value" toObject:self withKeyPath:@"textboxView.fontSize" options:nil];
	
	self.isShowFontTab = NO;
	
    return;
}




 - (BOOL)isFlipped
 {
     return YES;
 }

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateElementView:)
                                                     name:REDRAW_ELEMENT_NOTIFICATION
                                                   object:nil];
        
    }
    /* This is not used
    NSRect container = NSMakeRect(2, 2, 940, 700);
    container.origin.y = self.frame.size.height - container.size.height;        // This is anchored to the top, and not centered.
    container.origin.x = (self.frame.size.width/2) - container.size.width/2;    // This is centred.
    self.documentContainer = container;
    */
    
    
    
    return self;
}


-(void)updateElementView:(NSNotification *)notification
{
    [self setNeedsDisplay:YES];
}



/*
 When the view is redraw, all shapes in shape array and current shape are draw.
 */
- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *gc = [NSGraphicsContext currentContext];
	CGContextRef contextref = (CGContextRef) [gc graphicsPort];
    
	// draw stageView's bound rect with black color
    CGRect stageRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGContextSetRGBFillColor(contextref,
                             [self.stageBackgroundColor redComponent],
                             [self.stageBackgroundColor greenComponent],
                             [self.stageBackgroundColor blueComponent],
                             [self.stageBackgroundColor alphaComponent]);
    
	CGContextSetRGBStrokeColor( contextref, 0.0, 0.0, 0.0, 1.0 );
	CGContextStrokeRect( contextref, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) );
    CGContextFillRect(contextref, stageRect);
    
    // GRIDLINES
    if (showGridlines)
    {
        CGFloat gridBlockSize = 20;
        CGFloat blocksUntilThickLine = 10;
        
        for (CGFloat x = -0.5; x < self.frame.size.width; x+=gridBlockSize)
        {
            // Set line width and colour
            CGContextSetLineWidth(contextref, 1);
            CGContextSetRGBStrokeColor(contextref, 0.0, 0.0, 0.0, 0.1);
            
            // draw the horizontal line
            CGContextBeginPath(contextref);
            CGContextMoveToPoint(contextref, x, 0);
            CGContextAddLineToPoint(contextref, x, self.frame.size.height);
            
            CGFloat division = (x+0.5) / (gridBlockSize * blocksUntilThickLine);
            if ( floorf(division) == division ) // if it's an integer
            {
                CGContextSetRGBStrokeColor(contextref, 0.0, 0.0, 0.0, 0.2);
            }
            CGContextDrawPath(contextref, kCGPathStroke);
        }
        
        // draw vertically
        for (CGFloat y = -0.5; y < self.frame.size.height; y+=gridBlockSize)
        {
            // Set line width and colour
            CGContextSetLineWidth(contextref, 1);
            CGContextSetRGBStrokeColor(contextref, 0.0, 0.0, 0.0, 0.1);
            
            // draw the horizontal line
            CGContextBeginPath(contextref);
            CGContextMoveToPoint(contextref, 0, y);
            CGContextAddLineToPoint(contextref, self.frame.size.width, y);
            
            CGFloat division = (y+0.5) / (gridBlockSize * blocksUntilThickLine);
            if ( floorf(division) == division ) // if it's an integer
            {
                CGContextSetRGBStrokeColor(contextref, 0.0, 0.0, 0.0, 0.2);
            }
            CGContextDrawPath(contextref, kCGPathStroke);
        }
    }
    [fontFamilyLabel setHidden:YES];
    [fontStyleLabel setHidden:YES];
    [textSizeLabel setHidden:YES];
    [kerningLabel setHidden:YES];
    [leadingLabel setHidden:YES];
    [fontcolourWellLabel setHidden:YES];
    
    [_typeFaceName setHidden:YES];
    [_typeFaceTrait setHidden:YES];
    [fontSizeTextField2 setHidden:YES];
    [kerningField setHidden:YES];
    [leadingField setHidden:YES];
    [fontColorWell setHidden:YES];
    [fontTraitControl setHidden:YES];
    
    [kerningStepper setHidden:YES];
    [leadingStepper setHidden:YES];


    
    
    if (selElementArray.count == 1)
    {
        if ([selElementArray[0] isMemberOfClass:[TextBox class]])
        {
            [fontFamilyLabel setHidden:NO];
            [fontStyleLabel setHidden:NO];
            [textSizeLabel setHidden:NO];
            [kerningLabel setHidden:NO];
            [leadingLabel setHidden:NO];
            [fontcolourWellLabel setHidden:NO];
            
            [_typeFaceName setHidden:NO];
            [_typeFaceTrait setHidden:NO];
            [fontSizeTextField2 setHidden:NO];
            [kerningField setHidden:NO];
            [leadingField setHidden:NO];
            [fontColorWell setHidden:NO];
            [fontTraitControl setHidden:NO];
            
            [kerningStepper setHidden:NO];
            [leadingStepper setHidden:NO];
            
        }
    }
    
	
	// draw all shapes in shape array
	for (Element *shape in elementArray) {
		[shape setNeedsDisplay:YES];
	}
	
	// draw current drawing shape and it's selected bound
	for (Element *selShape in selElementArray) {
		[selShape setNeedsDisplay:YES];
	}
    
    // check the mouse select rangle, draw select area rectagle with dash line border
	if (isSelArea == YES)
    {
		NSRect rtSelArea = NSMakeRect( ptStart.x, ptStart.y, ptEnd.x - ptStart.x, ptEnd.y - ptStart.y );
		rtSelArea = CGRectStandardize( rtSelArea );
		
		CGFloat dashes[] = {2, 2};
		CGContextSetRGBStrokeColor( contextref, 0.0, 0.0, 0.0, 1.0 );
		CGContextSetShouldAntialias( contextref, NO );
		CGContextSetLineDash( contextref, 0.0, dashes, 2 );
		CGContextStrokeRect( contextref, rtSelArea );
    }
    
    if (([elementArray count] < 1) & (elementBeenDroppedToStage == NO)) //change this when adding container
    {
        
        //// Abstracted Graphic Attributes
        NSSize centeredRectSize = NSMakeSize(500, 300);
        NSString* textContent = @"To start, drag items from the gallery on the left and place them here.";
        
        NSRect centredRect = NSMakeRect((self.superview.frame.size.width/2) - centeredRectSize.width/2, (self.superview.frame.size.height/2) - centeredRectSize.height/2, centeredRectSize.width, centeredRectSize.height);
        
        
        //// Rectangle Drawing
        NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRoundedRect: centredRect xRadius: 3 yRadius: 3];
        [[NSColor whiteColor] setFill];
        [rectanglePath fill];
        
        [[NSColor headerColor] setStroke];
        [rectanglePath setLineWidth: 0.5];
        CGFloat rectanglePattern[] = {4, 4, 4, 4};
        [rectanglePath setLineDash: rectanglePattern count: 4 phase: 0];
        [rectanglePath stroke];
        
        
        //// Text Drawing
        NSSize centeredText = NSMakeSize(232, 104);
        
        NSRect textRect = NSMakeRect((self.superview.frame.size.width/2) - centeredText.width/2, (self.superview.frame.size.height/2) - centeredText.height/2, centeredText.width, centeredText.height);
        NSMutableParagraphStyle* textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [textStyle setAlignment: NSCenterTextAlignment];
        
        NSDictionary* textFontAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSFont fontWithName: @"Helvetica-Bold" size: 19], NSFontAttributeName,
                                            [NSColor keyboardFocusIndicatorColor], NSForegroundColorAttributeName,
                                            textStyle, NSParagraphStyleAttributeName, nil];
        
        [textContent drawInRect: textRect withAttributes: textFontAttributes];
        

    }
    
    
        
}




-(void)closeSettingsPopover
{
    [documentSettingsPopover performClose:self];
}


-(IBAction)displayDocumentSettingsView:(id)sender
{
    //  Purpose: To show the popover for controlling document settings
    Class popoverclass = NSClassFromString(@"NSPopover"); //10.6 users must use an alternative method
    if (popoverclass == nil)
    {
        [panel setIsVisible:YES];
    }
    else
    {
        if (self.documentSettingsPopover.shown == YES)
        {
            [documentSettingsPopover performClose:self];
            [self setNeedsDisplay:YES];
        }
        else
        {
            [self.documentSettingsPopover showRelativeToRect:documentSettingsButton.bounds ofView:sender preferredEdge:NSMaxYEdge];
        }
         
    }
    
}

#pragma mark - VALIDATE ELEMENT CHANGE

-(BOOL)isElementIDUnique: (NSMutableString *)string
{
    for (Element *e in elementArray)
    {
        if ([string isEqualToString:e.elementid])
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark - FONT METHODS
-(void)convertFont:(NSDictionary*)fontAttributeToChange
{
    
    // Test if any text is selected, if so then select text and set its font size.
	NSRange totalRange = [[self textboxView] selectedRange];
	
	if (totalRange.length == 0) {
		totalRange.location = 0;
		totalRange.length = [[self textboxView].string length];
	}
	
    if (totalRange.length > 0)
    {
        //Get the old font
        NSFontManager *fm = [NSFontManager sharedFontManager];
        NSMutableDictionary *allAttributes = [NSMutableDictionary dictionaryWithDictionary: [[[self textboxView] textStorage] attributesAtIndex:totalRange.location effectiveRange:nil]];
        
        NSFont *fontFromSelectedText = [allAttributes objectForKey:@"NSFont"];
        NSFont *alteredFont = [NSFont systemFontOfSize:0]; //any standard font
        NSString *selectedTypeFace, *selectedTypeStyle = [[NSString alloc]init];
        
        
        if ([fontAttributeToChange objectForKey:@"size"])
        {
            CGFloat newSize = [[fontAttributeToChange objectForKey:@"size"] floatValue];
            alteredFont = [fm convertFont:fontFromSelectedText toSize:newSize];
        }
        
        if ([fontAttributeToChange objectForKey:@"typeFace"])
        {
            selectedTypeFace = [fontAttributeToChange objectForKey:@"typeFace"];
            alteredFont = [fm convertFont:fontFromSelectedText toFamily:selectedTypeFace];
        }
        
        if ([fontAttributeToChange objectForKey:@"typeStyle"])
        {
            selectedTypeStyle = [fontAttributeToChange objectForKey:@"typeStyle"];
            alteredFont = [fm convertFont:fontFromSelectedText toFace:selectedTypeStyle];
        }
        
        
        //Convert it to the new font
        [allAttributes removeObjectForKey:NSFontAttributeName];
        [allAttributes setObject:alteredFont forKey:NSFontAttributeName];
        
        
        [[[self textboxView] textStorage] setAttributes:allAttributes range:totalRange];
        [fm setSelectedFont:alteredFont isMultiple:NO];
		
		[self SetTextBoxText];
    }
	
	[layerDelegate SetLayerList];
	
	[self.window makeKeyAndOrderFront:self];
	[self.window makeFirstResponder:textboxView];
	
	[textboxView setNeedsDisplay:YES];
	[textboxView setSelectedRange:totalRange];
}

-(IBAction)setFontSize:(id)sender
{
    //Get the font size choosen
    CGFloat newSize = [sender floatValue];
    NSDictionary *newFontAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:newSize] forKey:@"size"];
    [self convertFont:newFontAttributes];
    
    /*
    // Test if any text is selected, if so then select text and set its font size.
    NSRange totalRange = [[self textboxView] selectedRange];
    if (totalRange.length > 0)
    {
        
        //Get the old font
        NSFontManager *fm = [NSFontManager sharedFontManager];
        NSMutableDictionary *allAttributes = [NSMutableDictionary dictionaryWithDictionary: [[[self textboxView] textStorage] attributesAtIndex:totalRange.location effectiveRange:nil]];
        NSFont *fontFromSelectedText = [allAttributes objectForKey:@"NSFont"];
        
        
        //Convert it to the new font
        [allAttributes removeObjectForKey:NSFontAttributeName];
        
        NSFont *alteredFont = [fm convertFont:fontFromSelectedText toSize:newSize];
        
        [allAttributes setObject:alteredFont forKey:NSFontAttributeName];
        
        
        [[[self textboxView] textStorage] setAttributes:allAttributes range:totalRange];
        
        
        [fm setSelectedFont:alteredFont isMultiple:NO];
    }
     */
}

-(IBAction)setTypeFaceFamily:(id)sender //called when respective dropdown menu choosen
{
    NSFontManager *fm = [NSFontManager sharedFontManager];
    NSString *selectedTypeFace = nil;
    if ([sender title])
    {
        selectedTypeFace = [sender title];
    }
    else
    {
        selectedTypeFace = sender;
    }
    NSArray *typeFaceFamily = [fm availableMembersOfFontFamily:selectedTypeFace];
    NSMutableArray *traits = [[NSMutableArray alloc]init];
    for (NSArray *entry in typeFaceFamily)
    {
        [traits addObject: [entry objectAtIndex:1]];
    }
    //update the textbox dropdown menu UI
    [_typeFaceTrait removeAllItems];
    [_typeFaceTrait addItemsWithTitles:traits];
    
    // Send a message to the object currently selected, tell it's text delegate to change the font of the selected text.
    Singleton *sg = [[Singleton alloc]init];
    if (sg.currentElement.uType == SHAPE_TEXTBOX)
    {
        NSDictionary *newFontAttributes = [NSDictionary dictionaryWithObject:selectedTypeFace forKey:@"typeFace"];
        [self convertFont:newFontAttributes];

        /*
        // Test if any text is selected, if so then select text and set its font size.
        NSRange totalRange = [[self textboxView] selectedRange];
        if (totalRange.length > 0)
        {
            
            //Get the old font
            NSFontManager *fm = [NSFontManager sharedFontManager];
            NSMutableDictionary *allAttributes = [NSMutableDictionary dictionaryWithDictionary: [[[self textboxView] textStorage] attributesAtIndex:totalRange.location effectiveRange:nil]];
            
            NSFont *fontFromSelectedText = [allAttributes objectForKey:@"NSFont"];
            NSFont *alteredFont = [fm convertFont:fontFromSelectedText toFamily:selectedTypeFace];
            
            //Convert it to the new font
            [allAttributes removeObjectForKey:NSFontAttributeName];
            [allAttributes setObject:alteredFont forKey:NSFontAttributeName];
            
            
            [[[self textboxView] textStorage] setAttributes:allAttributes range:totalRange];
            [fm setSelectedFont:alteredFont isMultiple:NO];
        }
         */
         
    }
    
}


-(IBAction)setTypeStyle:(id)sender //called when respective dropdown menu choosen
{
    NSString *selectedTypeStyle = [sender title];
    
    
    
    //Get the old font
    NSRange selectedText = [[self textboxView] selectedRange];
    NSDictionary *fontAtt = [[[self textboxView] textStorage] fontAttributesInRange:selectedText];
    NSFont *fontFromSelectedText = [fontAtt objectForKey:@"NSFont"];
    NSString *nameOfFontToConvertTo = [[[fontFromSelectedText familyName] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingFormat:@"-%@", [selectedTypeStyle stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSDictionary *newFontAttributes = [NSDictionary dictionaryWithObject:nameOfFontToConvertTo forKey:@"typeStyle"];
    [self convertFont:newFontAttributes];

    
}



-(IBAction)setFontTrait:(id)sender
{
    NSLog(@"in font trait");
    //BOOL underlineflag = NO;
    BOOL isBold = NO;
    BOOL isItaic = NO;
    //BOOL isUnderLined = NO;
    
    NSMutableDictionary *ad = [[NSMutableDictionary alloc]init];
    NSUInteger clickedSegment = [sender selectedSegment];
    NSUInteger clickedSegmentTag = [[sender cell] tagForSegment:clickedSegment];
    
    NSFontTraitMask traitToAdd;
    
    NSRange selectedText = [[self textboxView] selectedRange];
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    
    
    
    //Get the old font
    NSDictionary *fontAtt = [[[self textboxView] textStorage] fontAttributesInRange:selectedText];
    NSMutableDictionary *allAtts = [[NSMutableDictionary alloc]initWithDictionary:[[[self textboxView] textStorage] attributesAtIndex:selectedText.location effectiveRange:nil]];
    NSFont *fontFromSelectedText = [fontAtt objectForKey:@"NSFont"];
    NSFont *alteredFont = nil;
    NSNumber *underlineStyle = nil;
    
    
    //Set varaibles to indicate which traits are present
    if ([fontManager traitsOfFont:fontFromSelectedText]  == NSBoldFontMask)
    {
        isBold = YES;
    }
    if ([fontManager traitsOfFont:fontFromSelectedText]  == NSItalicFontMask)
    {
        isItaic = YES;
    }
    if ([fontManager traitsOfFont:fontFromSelectedText]  == (NSBoldFontMask|NSItalicFontMask))
    {
        isItaic = YES;
        isBold = YES;
    }
    
    
    
    
    if (clickedSegmentTag == 0)
    {
        NSLog(@"Bold pressed.");
        if (isBold == YES)
        {
            traitToAdd = NSUnboldFontMask;
        }
        if (isBold == NO)
        {
            traitToAdd = NSBoldFontMask;
        }
        alteredFont = [fontManager convertFont:fontFromSelectedText toHaveTrait:traitToAdd];
        [ad setObject:alteredFont forKey:NSFontAttributeName];
        
    }
    if (clickedSegmentTag == 1)
    {
        NSLog(@"Italic pressed.");
        if (isItaic == YES)
        {
            traitToAdd = NSUnitalicFontMask;
        }
        if (isItaic == NO)
        {
            traitToAdd = NSItalicFontMask;
        }
        alteredFont = [fontManager convertFont:fontFromSelectedText toHaveTrait:traitToAdd];
        [ad setObject:alteredFont forKey:NSFontAttributeName];
        
    }
    if (clickedSegmentTag == 2)
    {
        NSLog(@"Underline pressed.");
        //underlineflag = YES;
        if ([fontAtt objectForKey:NSUnderlineStyleAttributeName] == [NSNumber numberWithInt:1])
        {
            //isUnderLined = YES;
            underlineStyle = [NSNumber numberWithInt:0];
            //[ad setObject:[NSNumber numberWithInt:0] forKey:NSUnderlineStyleAttributeName];
            // isUnderLined = NO;
        }
        else
        {
            //isUnderLined = NO;
            underlineStyle = [NSNumber numberWithInt:1];
            //[ad setObject:[NSNumber numberWithInt:1] forKey:NSUnderlineStyleAttributeName];
            //isUnderLined = YES;
        }
        
        [ad setObject:fontFromSelectedText forKey:NSFontAttributeName];
    }
    
    if (alteredFont != nil)
    {
        [allAtts removeObjectForKey:NSFontAttributeName];
        [allAtts setObject:alteredFont forKey:NSFontAttributeName];
    }
    
    
    //Underline attribute
    if (underlineStyle != nil)
    {
        [allAtts setObject:underlineStyle forKey:NSUnderlineStyleAttributeName];
    }
    
    
    
    // Make the change, with undo support
    NSValue *storingRanges = [NSValue valueWithRange:selectedText];
    NSArray *arrayOfSelections = [NSArray arrayWithObject:storingRanges];
    if ([[self textboxView] shouldChangeTextInRanges:arrayOfSelections replacementStrings:nil])
    {
        // we want to treat all these replacements as a single replacement for undo purposes
        [[[self textboxView] textStorage] beginEditing];
        
        [[[self textboxView] textStorage] setAttributes:allAtts range:selectedText];
        //NSStrikethroughStyleAttributeName
        
        [[[self textboxView] textStorage] endEditing];
    }
    
    NSLog(@"finished set font trait");
}


- (void)textDidChange:(NSNotification *)pNotification //called whenever the text or its attributes are changed.
{
    [self setNeedsDisplay:YES];
}

-(void)textDidEndEditing:(NSNotification *)notification
{
    NSRange totalRange = NSMakeRange (0, [[textboxView textStorage]length]);
    NSMutableAttributedString *textJustEdited = [[NSMutableAttributedString alloc]initWithAttributedString:[[textboxView textStorage]attributedSubstringFromRange:totalRange]];
    Singleton *sg = [[Singleton alloc]init];
    sg.currentElement.contentText = textJustEdited;
    


    [self setNeedsDisplay:YES];
    //[[textboxView textStorage] setAttributedString:[[NSMutableAttributedString alloc]initWithString:@""]];
    NSLog(@"Called from THE STAGE textDidEndEditing");
}

-(void)textViewDidChangeSelection:(NSNotification *)notification 
{
    
    // Get where the cursor is
    NSRange totalRange = NSMakeRange (0, [[textboxView textStorage]length]);
    NSMutableAttributedString *textJustEdited = [[NSMutableAttributedString alloc]initWithAttributedString:[[textboxView textStorage]attributedSubstringFromRange:totalRange]];
    NSUInteger cursorAt = [textboxView selectedRange].location - 1; //so we get the attribute of the character to the left not right of the cursor
    if ([textboxView selectedRange].length > 0 ) //if text is selecetd
    {
        cursorAt++;
    }
    if (cursorAt == -1) 
    {
        cursorAt++;
    }

    
    //Get the attributes for the character to the right of the cursor
    NSDictionary *attributes = [textJustEdited attributesAtIndex:cursorAt effectiveRange:nil];
    [[NSApp delegate] updateCustomFontMenu:attributes];
    
    // Display these attributes in the Font Panel
    // [[NSApp delegate] updateLeadingMenuAsCursorChanges]; // AN: Commented this out as the declaration and definition have also been commented out.
    NSLog(@"Called from THE STAGE textDidChangeSelection");
     
}


-(void)updateCustomFontMenu:(NSDictionary*)attributes //called when the text selection is changed, from the stageView
{
    
    NSLog(@"START updateCustomFontMenu");
    NSFontManager *fm = [NSFontManager sharedFontManager];
    NSFont *theFont = [attributes objectForKey:NSFontAttributeName];
    
        
    //UPDATE THE FONT FAMILY
    NSString *selectedTypeFace = [theFont familyName];
    [_typeFaceName selectItemWithTitle:selectedTypeFace];
	[self selectFontofCurrentTextBox:selectedTypeFace];
    
    // Get all of the traits
    NSArray *typeFaceFamily = [fm availableMembersOfFontFamily:selectedTypeFace];
    NSMutableArray *traits = [[NSMutableArray alloc]init];
    for (NSArray *entry in typeFaceFamily)
    {
        [traits addObject: [entry objectAtIndex:1]];
    }
    
    
    
    // POPULATE THE TRAIT POPUP
    [_typeFaceTrait removeAllItems];
    [_typeFaceTrait addItemsWithTitles:traits];
    
    NSString *fullFontName = [theFont displayName];
    NSString *seperateFamilyName = [selectedTypeFace stringByAppendingString:@" "];
    seperateFamilyName = [[fullFontName componentsSeparatedByString:seperateFamilyName]componentsJoinedByString:@""];
    
    if ([selectedTypeFace isEqualToString:seperateFamilyName])
    {
        seperateFamilyName = @"Regular";
    }
    [_typeFaceTrait selectItemWithTitle:seperateFamilyName];
    
    
    
    //UPDATE THE FONT TRAIT - FOR WHEN IT DOES WORK WITH MULTIPLE SELECTIONS & MULTIPLE INDENTIONS
    if ([fm traitsOfFont:theFont]  == NSBoldFontMask)
    {
        [fontTraitControl setSelectedSegment:0];
    }
    else
    {
        [fontTraitControl setSelected:NO forSegment:0];
    }
    
    
    if ([fm traitsOfFont:theFont]  == NSItalicFontMask)
    {
        [fontTraitControl setSelectedSegment:1];
    }
    else
    {
        [fontTraitControl setSelected:NO forSegment:1];
    }
    
    
    if ([fm traitsOfFont:theFont]  == 3) //this is both bold and italic - although 3 is not mentioned in the Apple documentation - it's what returned when =font has both italic and bold traits.
    {
        [fontTraitControl setSelectedSegment:0];
        [fontTraitControl setSelectedSegment:1];
    }
    else
    {
        //[fontTraitControl setSelected:NO forSegment:2];
    }
    
    
    if ([attributes objectForKey:NSUnderlineStyleAttributeName] == [NSNumber numberWithInt:1])
    {
        [fontTraitControl setSelected:YES forSegment:2];
    }
    else
    {
        [fontTraitControl setSelected:NO forSegment:2];
    }
    
    
    //UPDATE THE ALIGNMENT BUTTON
    
    
    
    //UPDATE THE FONT COLOR
    if ([attributes objectForKey:NSForegroundColorAttributeName]) //check if the key exists as when the text box is first dropped to the stage there is no text and thus no attribute for foreground color.
    {
        [fontColorWell setColor:[attributes objectForKey:NSForegroundColorAttributeName]];
    }
    else
    {
        [fontColorWell setColor:[NSColor blackColor]];
    }
    
    
    
    //UPDATE THE FONT SIZE
    [fontSizeTextField2 setStringValue:[NSString stringWithFormat:@"%d",((int)[theFont pointSize])]];
    
    NSLog(@"END : updateCustomFontMenu.");
}


-(void)clearKerningAndLeadingFields
{
    kerningTextField = nil;
    leadingTextField = nil;
}



-(NSNumber*)kerningValue
{
    NSNumber *k = [NSNumber numberWithFloat: [[self textboxView] kerning]];
    return k;
}


-(void)setKerningValue:(NSNumber *)kerningValueReceived //:(NSNumber *)k //updateKerningOrLeadingFields
{
    NSLog(@"IN SETKERNING IN STAGEVIEW");
    CGFloat valueTypedIn = [kerningValueReceived floatValue];
    CGFloat kerning = [[self textboxView] kerning];
    
    int difference = valueTypedIn - kerning;
    if ( difference > 0) //The value typed in is bigger than the iVar
    {
        for (int i = 0; i < difference; i++)
        {
            [[self textboxView] loosenKerning:nil];
        }
    }
    else //The value typed in is smaller than the iVar
    {
        difference = difference * -1;
        for (int i = 0; i < difference; i++)
        {
            // we want to treat all these replacements as a single replacement for undo purposes
            
            [[self textboxView] tightenKerning:nil];
        }
        
    }
    
    [[self textboxView] setKerning:valueTypedIn];
    NSLog(@"done with kerning");
}


-(NSNumber*)leadingValue
{
    NSNumber *l = [NSNumber numberWithFloat: [[self textboxView] leading]];
    return l;
}


-(void)setLeadingValue:(NSNumber *)leadingValueReceived //Line space is measured in Points.
{
    CGFloat valueTypedIn = [leadingValueReceived floatValue];
    CGFloat leading = [[self textboxView] leading];
    
    
    // Test if any text is selected, if so get the selected text and set its color
    NSRange totalRange = [[self textboxView] selectedRange];
    if (totalRange.length > 0)
    {
        NSMutableDictionary *allAtts = [NSMutableDictionary dictionaryWithDictionary: [[[self textboxView] textStorage] attributesAtIndex:totalRange.location effectiveRange:nil]];
        CGFloat oldLeading;
        CGFloat newLeading;
        
        NSMutableParagraphStyle *paragraphStyle = [allAtts objectForKey:NSParagraphStyleAttributeName];
        NSMutableParagraphStyle *newParagraphStyle = [self copyOfExistingParagraphStyle:paragraphStyle];
        
        int difference = valueTypedIn - leading;
        if ( difference > 0) //The value typed in is bigger than the iVar
        {
            for (int i = 0; i < difference; i++)
            {
                oldLeading = [newParagraphStyle lineSpacing];
                newLeading = oldLeading+1.0;
                NSLog(@"Trying to set leading of:%f", newLeading);
                [newParagraphStyle setLineSpacing:newLeading];
            }
        }
        else //The value typed in is smaller than the iVar
        {
            difference = difference * -1;
            for (int i = 0; i < difference; i++)
            {
                oldLeading = [newParagraphStyle lineSpacing];
                newLeading = oldLeading-1;
                [newParagraphStyle setLineSpacing:newLeading];
            }
            
        }
        
        [[self textboxView] setLeading:valueTypedIn];
        
        [allAtts removeObjectForKey:NSParagraphStyleAttributeName];
        [allAtts setObject:newParagraphStyle forKey:NSParagraphStyleAttributeName];
        [[[self textboxView] textStorage] setAttributes:allAtts range:totalRange];
    }
}



-(IBAction)setAlignmentOfText:(id)sender
{
    // check to makes sure the replace can occur
    int alignment = (int)[sender selectedSegment];
    if (alignment == 1)
    {
        alignment++;
    }
    else
    {
        if (alignment == 2)
        {
            alignment--;
        }
    }
    NSRange selectedText = [[self textboxView] selectedRange];
    NSValue *storingRanges = [NSValue valueWithRange:selectedText];
    NSArray *arrayOfSelections = [NSArray arrayWithObject:storingRanges];
    if ([[self textboxView] shouldChangeTextInRanges:arrayOfSelections replacementStrings:nil])
    {
        // we want to treat all these replacements as a single replacement for undo purposes
        [[[self textboxView] textStorage] beginEditing];
        
        [[self textboxView] setAlignment:alignment range:selectedText];
        
        [[[self textboxView] textStorage] endEditing];
    }
}


-(NSMutableParagraphStyle*)copyOfExistingParagraphStyle:(NSParagraphStyle*)pStyle
{
    NSMutableParagraphStyle *newParagraphStyle = [[NSMutableParagraphStyle alloc]init];
    [newParagraphStyle setAlignment:[pStyle alignment]];
    [newParagraphStyle setFirstLineHeadIndent:[pStyle firstLineHeadIndent]];
    [newParagraphStyle setHeadIndent:[pStyle headIndent]];
    [newParagraphStyle setTailIndent:[pStyle tailIndent]];
    [newParagraphStyle setTabStops:[pStyle tabStops]];
    [newParagraphStyle setDefaultTabInterval:[pStyle defaultTabInterval]];
    [newParagraphStyle setLineHeightMultiple:[pStyle lineHeightMultiple]];
    [newParagraphStyle setLineSpacing:[pStyle lineSpacing]];
    [newParagraphStyle setMaximumLineHeight:[pStyle maximumLineHeight]];
    [newParagraphStyle setMinimumLineHeight:[pStyle minimumLineHeight]];
    [newParagraphStyle setLineSpacing:[pStyle lineSpacing]];
    [newParagraphStyle setParagraphSpacing:[pStyle paragraphSpacing]];
    [newParagraphStyle setParagraphSpacingBefore:[pStyle paragraphSpacingBefore]];
    
    return newParagraphStyle;
}


#pragma mark - RULER METHODS
- (void)updateRulers
{
    [self updateHorizontalRuler];
    [self updateVerticalRuler];
    return;
}


- (void)updateHorizontalRuler
{
    NSScrollView *scrollView;
    NSRulerView *horizRuler;
    NSRulerMarker *leftMarker;
    NSRulerMarker *rightMarker;
    
    
    scrollView = [self enclosingScrollView];
    if (!scrollView) return;
    
    horizRuler = [scrollView horizontalRulerView];
    if (!horizRuler) return;
    
    if ([horizRuler clientView] != self) {
        [horizRuler setClientView:self];
        [horizRuler setMeasurementUnits:@"Grummets"];
    }
    
    if (!currentElement) {
        [horizRuler setMarkers:nil];
        return;
    }
    
    leftMarker = [[NSRulerMarker alloc] initWithRulerView:horizRuler
                                           markerLocation:NSMinX([currentElement frame]) image:leftImage
                                              imageOrigin:NSMakePoint(0.0, 0.0)];
    
    rightMarker = [[NSRulerMarker alloc] initWithRulerView:horizRuler
                                            markerLocation:NSMaxX([currentElement frame]) image:rightImage
                                               imageOrigin:NSMakePoint(7.0, 0.0)];
    
    [horizRuler setMarkers:[NSArray arrayWithObjects:leftMarker, rightMarker, nil]];
    
    [leftMarker setRemovable:YES];
    [rightMarker setRemovable:YES];
    [leftMarker setRepresentedObject:STR_LEFT];
    [rightMarker setRepresentedObject:STR_RIGHT];
    
    return;
}


- (void)updateVerticalRuler
{
    NSScrollView *scrollView;
    NSRulerView *vertRuler;
    NSPoint thePoint;   /* Just a temporary scratch variable */
    CGFloat location;
    NSRulerMarker *topMarker;
    NSRulerMarker *bottomMarker;
    
    scrollView = [self enclosingScrollView];
    if (!scrollView) return;
    
    vertRuler = [scrollView verticalRulerView];
    if (!vertRuler) return;
    
    if ([vertRuler clientView] != self) {
        [vertRuler setClientView:self];
        [vertRuler setMeasurementUnits:@"Grummets"];
    }
    
    if (!currentElement) {
        [vertRuler setMarkers:nil];
        return;
    }
    
    if ([self isFlipped]) location = NSMaxY([currentElement frame]);
    else location = NSMinY([currentElement frame]);
    
    thePoint = NSMakePoint(8.0, 1.0);
    bottomMarker = [[NSRulerMarker alloc] initWithRulerView:vertRuler
                                             markerLocation:location image:bottomImage
                                                imageOrigin:thePoint];
    [bottomMarker setRemovable:YES];
    [bottomMarker setRepresentedObject:STR_BOTTOM];
    
    
    if ([self isFlipped]) location = NSMinY([currentElement frame]);
    else location = NSMaxY([currentElement frame]);
    
    thePoint = NSMakePoint(8.0, 8.0);
    topMarker = [[NSRulerMarker alloc] initWithRulerView:vertRuler
                                          markerLocation:location image:topImage
                                             imageOrigin:thePoint];
    [topMarker setRemovable:YES];
    [topMarker setRepresentedObject:STR_TOP];
    
    [vertRuler setMarkers:[NSArray arrayWithObjects:bottomMarker, topMarker, nil]];
    
    return;
}


- (void)setRulerOffsets
{
    NSScrollView *scrollView = [self enclosingScrollView];
    NSRulerView *horizRuler;
    NSRulerView *vertRuler;
    NSView *docView;
    NSView *clientView;
    NSPoint zero;
    docView = [scrollView documentView];
    clientView = self;
    
    if (!scrollView) return;
    horizRuler = [scrollView horizontalRulerView];
    vertRuler = [scrollView verticalRulerView];
    
    zero = [docView convertPoint:[clientView bounds].origin fromView:clientView];
    [horizRuler setOriginOffset:zero.x - [docView bounds].origin.x];
    
    [vertRuler setOriginOffset:zero.y - [docView bounds].origin.y];
    
    return;
}

#pragma mark - UPDATE UI

-(void)highlightTheElementWithMouseHover:(NSRect)rtFrame
{
    NSGraphicsContext *gc = [NSGraphicsContext currentContext];
	CGContextRef contextref = (CGContextRef) [gc graphicsPort];
    
	// draw stageView's bound rect with black color
	CGContextStrokeRect( contextref, CGRectMake(rtFrame.origin.x+2, rtFrame.origin.y+2, rtFrame.size.width+2, rtFrame.size.height+2) );

}






#pragma mark - SHAPE CONTROL


/*
 @function:		createContainerElement
 @params:		width: width of container shape
 @return:		void
 @purpose:		This function create container shape.
 */
- (void)createContainerElement:(CGFloat)width
{
	NSLog( @"Create Container Shape" );
	
	Element *shape = [Element createElement:SHAPE_CONTAINER];
	[shape setBoundRect:NSMakeRect((self.frame.size.width - width) / 2, 0, width, self.frame.size.height)];
	//shape.isSelected = YES;
	
    [self addSubview:shape];
	//[shapeArray addObject:shape];
	[elementArray insertObject:shape atIndex:0];
	//[selShapesArray addObject:shape];
	
	// set shadow array to shadow list panel
	//[shadowDelegate setShadowList:shape.arrayShadows];
	
	// Resort layers to layer Panel
	[layerDelegate SetLayerList];
}


/*
 @function:		DeselectAllShaps
 @params:		nothing
 @return:       void
 @purpose:		deselect all shapes in shapeArray.
 */
- (void)DeselectAllShaps
{
	// set selected flag to FALSE
	for (Element *shape in elementArray) {
		shape.isSelected = NO;
	}
	
	// remove all selected shapes from selection shapes array
	[selElementArray removeAllObjects];
	
	// set 0 to the attribute panel when the shape is not selected
	[attributeDelegate SetAttributeOfShapeToPanel:0 yPos:0 Width:0 Height:0];

    // Empty the text in the StageTextView
    [[self.textboxView textStorage] setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
}


/*
 @function:		DisableEditing
 @params:		nothing
 @return:		void
 @purpose:		disable editing all text boxes
 */
- (void)DisableEditing
{
	[textboxView setHidden:YES];
	
	for (Element *shape in elementArray) {
		if (shape.uType == SHAPE_TEXTBOX) {
			((TextBox*)shape).isEditing = NO;
		}
	}
}


/*
 @function:		SetTextBoxText
 @params:		nothing
 @return:		void
 @purpose:		set the text of textbox to selected text box shape
 */
- (void)SetTextBoxText //if the one I'm touching right now, set its text to that of the stageviewTextBox
{
	for (NSInteger i = [selElementArray count] - 1; i >= 0; i --) {
		//Element* shape = [selElementArray objectAtIndex:i];
        Singleton *sg = [[Singleton alloc]init];
		if (sg.currentElement.uType == SHAPE_TEXTBOX /*&& ((TextBox*)shape).isEditing == YES*/) {
            NSRange totalRange = NSMakeRange (0, [[textboxView textStorage]length]);
			[((TextBox*)sg.currentElement) setText:[[textboxView textStorage]attributedSubstringFromRange:totalRange]]; //getAttributed string from the svTextView and place it in the shape ivar
			
			//[textboxView setHidden:YES];
                     //   [[textboxView textStorage] setAttributedString:[[NSAttributedString alloc]initWithString:@""]]; //This resets the textstorage to blank when I create a want to create a new text object.
			return;
		}
	}
}




/*
 @function:		MoveSelectedShapes
 @params:		offset:			shapes's move offset
				hitTest:		shapes's hit test
 @return:		void
 @purpose:		move all selected shapes in selElementArray
 */
- (void)MoveSelectedElements:(NSSize)offset HitTest:(NSInteger)hitTest;
{
    //NSLog(@"MoveSelectedElements called");

    
	for (Element *selElement in selElementArray)
    {
		
        [selElement OnMouseMove:offset HitTest:hitTest];
        [self updateElementWithPercentagesAndAttributesPanelWithElementAttributes:selElement];

		[attributeDelegate setShadowList:selElement.arrayShadows];
	}
    [self updateOverlappingVariable];
}


-(BOOL)updateOverlappingVariable
{
    BOOL test = NO;
    for (Element *ele in elementArray) 
    {
        if (ele != currentElement) 
        {
            test = CGRectIntersectsRect([ele rtFrame], [currentElement rtFrame]);
            
            if (test == YES) 
                {
                    NSUInteger indexA = [elementArray indexOfObjectIdenticalTo:ele];
                    NSUInteger indexB = [elementArray indexOfObjectIdenticalTo:currentElement];
                    if (indexA > indexB) 
                    {
                        [currentElement setIsUnderneathOtherElement:YES];
                    }
                    
                    if (indexB > indexA) 
                    {
                        [ele setIsUnderneathOtherElement:YES];
                    }
                    
                }
        }
    }
    return test;
}


/*
 @function:		IsContainShape
 @params:		shape1:			source shape object to contain
				shape2:			dest shape object to be contained
 point:			source shape's offset
 @return:		The shape1 contains the shape2, return YES. otherwise NO.
 @purpos:		This function check the shape1 contains the shape that the shape2's position pluse offset.
 */
- (BOOL)IsContainShape:(Element *)shape1 dst:(Element *)shape2 offset:(NSPoint)point
{
	NSRect srcRt = shape1.rtFrame;
	NSRect dstRt = shape2.rtFrame;
	
	dstRt = NSOffsetRect(dstRt, point.x, point.y);
	
	return CGRectContainsRect(srcRt, dstRt);
}


/*
 @function:		AlignShapes
 @params:		flag:			alignment flag: this parameter is one of
				ALIGN_LEFT, ALIGN_RIGHT, ALIGN_VERT, ALIGN_TOP, ALIGN_BOTTOM, ALIGN_HORZ
 @return:		void
 @purpos:		This function called when the user click the align button in alignment panel.
				The purpos is to align of the selected shapes by flag.
 */
- (void)AlignElements:(AlignType)flag
{
	// seleted shape count is 1 or non-selected shape, return
	if ([selElementArray count] < 1) {
		return;
	}
	NSRect baseRect, rtFrame;
	
	// get the basis shape's rect of the selected shape
	baseRect = ((Element*)[selElementArray lastObject]).rtFrame;
	
	// move all selected shapes to basis position
	for	(Element* shape in selElementArray) {
		
		rtFrame = shape.rtFrame;
		
		switch (flag) {
			case ALIGN_LEFT:
				[shape OnMouseMove:NSMakeSize(baseRect.origin.x, rtFrame.origin.y) HitTest:SHT_MOVEAPEX];
				break;
				
			case ALIGN_RIGHT:
				[shape OnMouseMove:NSMakeSize(baseRect.origin.x + baseRect.size.width - rtFrame.size.width, rtFrame.origin.y)
						   HitTest:SHT_MOVEAPEX];
				break;
				
			case ALIGN_VERT:
				[shape OnMouseMove:NSMakeSize(baseRect.origin.x + (baseRect.size.width - rtFrame.size.width) / 2, rtFrame.origin.y)
						   HitTest:SHT_MOVEAPEX];
				break;
				
			case ALIGN_BOTTOM:
				[shape OnMouseMove:NSMakeSize(rtFrame.origin.x, baseRect.origin.y) HitTest:SHT_MOVEAPEX];
				break;
				
			case ALIGN_TOP:
				[shape OnMouseMove:NSMakeSize(rtFrame.origin.x, baseRect.origin.y + baseRect.size.height - rtFrame.size.height)
						   HitTest:SHT_MOVEAPEX];
				break;
				
			case ALIGN_HORZ:
				[shape OnMouseMove:NSMakeSize(rtFrame.origin.x, baseRect.origin.y + (baseRect.size.height - rtFrame.size.height) / 2)
						   HitTest:SHT_MOVEAPEX];
				break;
				
			default:
				break;
		}
	}
}


/*
 @function:		DistributionShapes
 @params:		flag:			distribution flag: this parameter is one of
				DISTRIBUTION_LEFT, DISTRIBUTION_RIGHT, DISTRIBUTION_CENTER
 @return:		void
 @purpos:		This function called when the user click the distribution button in alignment panel.
				The purpos is to align distribution of the selected shapes by flag.
 */
- (void)DistributionElement:(DistributionType)flag
{
	// seleted shape count is 1 or non-selected shape, return
	if ([selElementArray count] < 1) {
		return;
	}
	
	CGFloat distance = [self GetDistributionDistance:flag];
	CGFloat xPos;
	NSInteger index;
	Element* shape;
	
	// move all selected shapes by distance
	xPos = ((Element*)[selElementArray objectAtIndex:0]).rtFrame.origin.x +
			((Element*)[selElementArray objectAtIndex:0]).rtFrame.size.width;
	
	for (index = 1; index < [selElementArray count] - 1; index ++) {
		
		shape = [selElementArray objectAtIndex:index];
		
		xPos += distance;
		[shape OnMouseMove:NSMakeSize(xPos, shape.rtFrame.origin.y) HitTest:SHT_MOVEAPEX];
		xPos += shape.rtFrame.size.width;
	}
}


/*
 @function:		GetDistributionDistance
 @params:		flag:			it is same with the paramenter of DistributionShapes
 @return:		distance between shapes
 @purpos:		This function returns the distance between the selected shapes.
 */
- (CGFloat)GetDistributionDistance:(DistributionType)flag
{
	CGFloat distance = 0.0f;
	NSRect rtFirst, rtLast;
	NSInteger index;
	
	rtFirst = ((Element*)[selElementArray objectAtIndex:0]).rtFrame;
	rtLast = ((Element*)[selElementArray lastObject]).rtFrame;
	
	switch (flag) {
		case DISTRIBUTION_LEFT:
			distance = rtLast.origin.x - rtFirst.origin.x;
			
			for (index = 0; index < [selElementArray count] - 1; index ++) {
				distance -= ((Element*)[selElementArray objectAtIndex:index]).rtFrame.size.width;
			}
			break;
			
		case DISTRIBUTION_RIGHT:
			distance = rtLast.origin.x + rtLast.size.width - rtFirst.origin.x - rtFirst.size.width;
			
			for (index = 1; index < [selElementArray count]; index ++) {
				distance -= ((Element*)[selElementArray objectAtIndex:index]).rtFrame.size.width;
			}
			break;
			
		case DISTRIBUTION_CENTER:
			distance = rtLast.origin.x- rtFirst.origin.x - rtFirst.size.width;
			
			for (index = 1; index < [selElementArray count] - 1; index ++) {
				distance -= ((Element*)[selElementArray objectAtIndex:index]).rtFrame.size.width;
			}
			break;
			
		default:
			break;
	}
	
	distance = distance / ([elementArray count] - 1);
	
	return distance;
}


/*
 @function:		SpaceEvenlyShapes
 @params:		spacing:		distance between the selected shapes
				flag:			spacing flag: this paramenter is one of SPACING_VERT, SPACING_HORZ
 @return:		void
 @purpos:		This function called when the user click the spaceing evenly button in alignment panel.
				The purpos is to make the same distance between shapes by spacing.
 */
- (void)SpaceEvenlyElement:(NSInteger)spacing flag:(SpacingType)flag
{
	CGFloat Pos;
	Element* shape;
	
	shape = [selElementArray objectAtIndex:0];
	if (flag == SPACING_VERT) {
		Pos = shape.rtFrame.origin.x;
	} else {
		Pos = shape.rtFrame.origin.y;
	}
	
	for (NSInteger index = 0; index < [selElementArray count]; index ++) {
		shape = [selElementArray objectAtIndex:index];
		
		switch (flag) {
			case SPACING_VERT:
				Pos = Pos + index * spacing;
				[shape OnMouseMove:NSMakeSize(Pos, shape.rtFrame.origin.y) HitTest:SHT_MOVEAPEX];
				Pos += shape.rtFrame.size.width;
				break;
				
			case SPACING_HORZ:
				Pos = Pos + index * spacing;
				[shape OnMouseMove:NSMakeSize(shape.rtFrame.origin.x, Pos) HitTest:SHT_MOVEAPEX];
				Pos += shape.rtFrame.size.height;
				break;
		}
	}
}


/*
 @function:		SelectElementByIndex
 @params:		index: index of shape to select
 @return:		void
 @purpose:		This function select the shape by index
 */
- (void)SelectElementByIndex:(NSInteger)index
{
	[self DeselectAllShaps];
	[self DisableEditing];
	
	Element *shape = [elementArray objectAtIndex:index];
	
	[selElementArray addObject:shape];
	shape.isSelected = YES;
	
	// set the current shape's attribute to the attribute panel
	if (shape.uType != SHAPE_CONTAINER) {
		[attributeDelegate SetAttributeOfShapeToPanel:shape.rtFrame.origin.x
												 yPos:shape.rtFrame.origin.y
												Width:shape.rtFrame.size.width
											   Height:shape.rtFrame.size.height];
	}
	
	// set shadow property to shadow panel
	/*const CGFloat *components = CGColorGetComponents( ((CShape *)[selShapesArray lastObject]).shadowCGColor );
	 [shadowDelegate setShadowProperty:((CShape *)[selShapesArray lastObject]).shadowAngle
	 Distance:((CShape *)[selShapesArray lastObject]).shadowDistance
	 colorR:components[0] colorG:components[1] colorB:components[2]
	 Opacity:((CShape *)[selShapesArray lastObject]).shadowOpacity
	 Blur:((CShape *)[selShapesArray lastObject]).shadowBlur
	 Direct:((CShape *)[selShapesArray lastObject]).shadowDirection];*/
	
	// set shadow array to shadow list panel
	//[shadowDelegate setShadowList:shape.arrayShadows];
	
	[self setNeedsDisplay:YES];
}




#pragma mark - mouse touch and move event implementation & cursor set implementation

- (void)resetCursorRects
{
	switch (nHitTest & SHT_HANDLESIZING) {
		case SHT_SIZENE:
		case SHT_SIZESW:
			[self addCursorRect:[self frame] cursor:[NSCursor crosshairCursor]];
			break;
			
		case SHT_SIZESE:
		case SHT_SIZENW:
			[self addCursorRect:[self frame] cursor:[NSCursor crosshairCursor]];
			break;
			
		case SHT_SIZEE:
		case SHT_SIZEW:
			[self addCursorRect:[self frame] cursor:[NSCursor resizeUpDownCursor]];
			break;
			
		case SHT_SIZES:
		case SHT_SIZEN:
			[self addCursorRect:[self frame] cursor:[NSCursor resizeLeftRightCursor]];
			break;
			
		default:
			[self addCursorRect:[self frame] cursor:[NSCursor arrowCursor]];
			break;
	}
}

- (void)mouseMoved:(NSEvent *)theEvent
{
	// get the mouse position
	NSPoint point;
	point = [theEvent locationInWindow];
	point = [self convertPoint:point fromView:nil];
	
	// hightlight the shape which be overed by mouse
	BOOL isOvered = NO;
	//for (Element *shape in elementArray) {
	for (NSInteger index = [elementArray count] - 1; index >= 0; index -- ) {
		Element *shape = [elementArray objectAtIndex:index];
		
		NSPoint ptShape;
		
		if (shape.uType != SHAPE_TEXTBOX) {
			ptShape = NSMakePoint(point.x - shape.frame.origin.x, point.y - shape.frame.origin.y);
		} else {
			ptShape = point;
		}
		
		shape.isPtInElement = NO;
		
		if (!isOvered && [shape IsPointInElement:ptShape] != SHT_NONE) {
			shape.isPtInElement = YES;
			isOvered = YES;
		}
	}
	[self setNeedsDisplay:YES];
	
	// selected nothing shape, don't change mouse cursor
	if ([selElementArray count] != 1) {
		return;
	}
	
	for (Element *selShape in selElementArray) {
		
		nHitTest = [selShape HitTest:point];
		
		[[self window] invalidateCursorRectsForView:self];
		return;
	}
}

- (void)mouseDown:(NSEvent *)theEvent
{
	[self clearPopover:self];
    
    BOOL isShift;
    BOOL stageClicked = YES;
	
	// get the mouse position
	ptStart = [theEvent locationInWindow];
	ptStart = [self convertPoint:ptStart fromView:nil];
	ptEnd = ptStart;
	
    //Singleton *sg = [[Singleton alloc]init];
    //sg.currentElement = nil;
	// set text to olden text shape
	//[self SetTextBoxText];
    
    
	
	// set accepting mouse move event
	[[self window] setInitialFirstResponder:self];
	[[self window] makeFirstResponder:self];
	[[self window] setAcceptsMouseMovedEvents:YES];
	
	// check the shift key is pressed
	if ([theEvent modifierFlags] & NSShiftKeyMask) {
		isShift = YES;
	} else {
		//[self DeselectAllShaps];
		isShift = NO;
	}
	[groupItems setTitle:@"Group items"];
	// check shape selection
    
    
	//for (Element *shape in elementArray) {
	for (NSInteger index = [elementArray count] - 1; index >= 0; index --) {
		Element *shape = [elementArray objectAtIndex:index];
		
        [shape setHidden:NO];
        [textboxView setHidden:YES];
        [sv setHidden:YES];
        nHitTest = [shape HitTest:ptStart];
        
        if (CGRectContainsPoint([shape frame], ptStart ) == YES)
            {
                stageClicked = NO;
            }
		
        
		if (nHitTest)
        {
            stageClicked = NO;
            currentElement = [shape retain];
            Singleton *sg = [[Singleton alloc]init];
            sg.currentElement = currentElement;
            
            [attributeDelegate updateLayoutDisplay:sg.currentElement];
            
			if (shape.uType == SHAPE_TEXTBOX && [theEvent clickCount] == 2) //double click
            { 
				// get the mouse position
                
                
                
                //[self SetTextBoxText];
				[self DeselectAllShaps];
				[self DisableEditing];
				
                [sv setFrame:shape.rtFrame]; //Move the scrollview and the textbox to where the text is
				[textboxView setFrame:shape.rtFrame];
                
				[textboxView setHidden:NO]; //Make the textbox and the scrollview are visible
                [sv setHidden:NO];
                [shape setHidden:YES]; //hide the shape
                
				[[textboxView textStorage] setAttributedString:((TextBox*)shape).contentText];
				//[((TextBox*)shape) setText:[[NSAttributedString alloc]initWithString:@""]];
				
				[[self window] makeKeyAndOrderFront:self];
				[[self window] makeFirstResponder:textboxView];
                
                //Select just the word that is underneath the mouse - nice
                [self.textboxView selectWordUnderMouse:theEvent];
				
				//[textView setSelectable:YES];
				//[textboxView setSelectedRange:NSMakeRange(0, [((TextBox*)shape).text length])];
				
				shape.isSelected = YES;
				[selElementArray addObject:shape];
				
				[self showFontTab];
			}
            else
            {
				isDragingShape = YES;
				
				if (shape.isSelected == YES) {                  //   if it's already selected  
					if (isShift == YES) {                       //   and we're pressing the shift key,
						shape.isSelected = NO;                  //   unselect it
						[selElementArray removeObject:shape];   //   then remove it from the selected ele array.
					} else if (shape.uType == SHAPE_TEXTBOX) {
						[[textboxView textStorage] setAttributedString:((TextBox*)shape).contentText];
						[self updateElementWithPercentagesAndAttributesPanelWithElementAttributes:sg.currentElement];
						[self.textboxView selectWordUnderMouse:theEvent];
						[self showFontTab];
						
						return;
					}
				} else {                                        //   if the shape is not selected
					/*if (shape.uType == SHAPE_CONTAINER) {		//   if selected a container shape, all selected shape will be deselect and select only it
						[self DeselectAllShaps];
						
						shape.isSelected = YES;
						[selElementArray addObject:shape];
					} else*/ {
						if (isShift == YES) {                       //   and the shift key is pressed
							shape.isSelected = YES;                 //   make this object selected
							[selElementArray addObject:shape];      //   and add it to the selected array
						} else {                                    //   but if the shape is not selected and no shift key
							[self DeselectAllShaps];                //   deselect all elements
							shape.isSelected = YES;                 //   and make this element selected
							[selElementArray addObject:shape];      //   and add this element to the sel ele array
							
							if (shape.uType == SHAPE_TEXTBOX) {
								//[self DisableEditing];
								
								[[textboxView textStorage] setAttributedString:((TextBox*)shape).contentText];
								[self updateElementWithPercentagesAndAttributesPanelWithElementAttributes:sg.currentElement];
								[self.textboxView selectWordUnderMouse:theEvent];
								[self showFontTab];
								
								return;
							}
							
							if ([elementArray count] > 1)
								{
									[groupItems setTitle:@"Unlink item"];
								}
							else
								{
									[groupItems setTitle:@"Group items"];
								}
                        }
					}
					
				}
                
			}
            
			
			// set the current shape's attribute to the attribute panel
			//if (shape.uType != SHAPE_CONTAINER) {
				[self updateElementWithPercentagesAndAttributesPanelWithElementAttributes:sg.currentElement];
			//}
            
			/*
            [attributeDelegate SetAttributeOfShapeToPanel:((Element *)[selElementArray lastObject]).rtFrame.origin.x
													 yPos:((Element *)[selElementArray lastObject]).rtFrame.origin.y
													Width:((Element *)[selElementArray lastObject]).rtFrame.size.width
												   Height:((Element *)[selElementArray lastObject]).rtFrame.size.height]; 
             */

			return;
		}
        else
        {
            stageClicked = YES;
            
        }
	}
	
	//[self DeselectAllShaps];
    
    if (isShift == NO) {
        [self DeselectAllShaps];
    }
    
    // mouse rectangle to select area
	isSelArea = YES;
    
    if (stageClicked == YES)
    {
        [self DeselectAllShaps];
    }
    
    
}

-(IBAction)clearPopover:(id)sender
{
    if (self.textPopover.isShown)
    {
        [self.textPopover performClose:self];
    }
	
	if (self.isShowFontTab) {
		[self hideFontTab];
	}
    
    if (self.documentSettingsPopover.isShown)
    {
        [self.documentSettingsPopover performClose:self];
    }
}




-(void)postNotificationForImageToResize
{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOW_REZISE_IMAGE object:self];
}

-(void)postNotificationForImageToHold
{
    [[NSNotificationCenter defaultCenter]postNotificationName:HOLD_RESIZING object:self];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	if ([selElementArray count] == 0/* || ((Element *)[selElementArray objectAtIndex:0]).uType == SHAPE_CONTAINER*/) {
		return;
	}
	
	Singleton *sg = [[Singleton alloc]init];
    
	// get the mouse position
	NSPoint point;
	point = [theEvent locationInWindow];
	point = [self convertPoint:point fromView:nil];

	// check the shape dragging
	if (isDragingShape == YES)
    {
        if (sg.currentElement.uType == SHAPE_DROPDOWN && nHitTest != SHT_MOVING)
        {
            // Throw a warning that you cannot resize a dropdown menu manually. It will resize to fit the size of the text automatically.
        }
        else
        {
            [self MoveSelectedElements:NSMakeSize(point.x - ptEnd.x, point.y - ptEnd.y) HitTest:nHitTest];
            ptEnd = point;
        }
		
	}
    
    // check the mouse select rangle, draw select area rectagle with dash line border
	if (isSelArea == YES) {
		ptEnd = point;
	}
    
    // FIX THIS...
	
    if (sg.currentElement.uType == SHAPE_IMAGE)
    {
        [self postNotificationForImageToHold];
        
    }
    
	[self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent
{
	
    Singleton *sg = [[Singleton alloc]init];
    if (sg.currentElement.uType == SHAPE_IMAGE)
    {
        [self postNotificationForImageToResize];
    }
	// get the mouse position
	NSPoint point;
	point = [theEvent locationInWindow];
	point = [self convertPoint:point fromView:nil];
	
	// if shape do not move, must be return
	/*if (NSEqualPoints(ptEnd, point) == YES) {
		[self setNeedsDisplay:YES];
		return;
	}*/
		
	// check the shape dragging
	if (isDragingShape == YES) {
		
		if ([selElementArray count] == 1) {
			Element* selShape = [selElementArray objectAtIndex:0];
			
			/*if (selShape.uType == SHAPE_CONTAINER) {
				return;
			}*/
			
			NSRect rtSelShape;//, rtShape;
			
			// if shape moved out of stage view
			rtSelShape = NSOffsetRect(selShape.rtFrame, point.x - ptEnd.x, point.y - ptEnd.y);
			if (CGRectContainsRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), rtSelShape) == NO) {
				[self MoveSelectedElements:NSMakeSize(ptStart.x - ptEnd.x, ptStart.y - ptEnd.y) HitTest:SHT_MOVING];
				
				isDragingShape = NO;
				nHitTest = SHT_NONE;
				[self setNeedsDisplay:YES];
				
				return;
			}
			
			/* if one shape move to inside of another shape
			for (Element* shape in elementArray) {
				if ((selShape != shape) && [self IsLayOnRect:shape.rtFrame Dst:selShape.rtFrame] == NO)
                {
					if (selShape.uType == SHAPE_RECTANGLE && //THIS LINE TO EDIT INNER SHAPE !!!!!!!!!! **** @@@ $%^^&
						shape.uType == SHAPE_RECTANGLE &&
						[self IsContainShape:shape dst:selShape offset:NSMakePoint(point.x - ptEnd.x, point.y - ptEnd.y)] == YES)
                    {
						
						// if selShape is contained to inside of shape, move it into to shape
						[selShape removeFromSuperview];
						[shape addSubview:selShape];
						
						rtSelShape = selShape.rtFrame;
						rtShape = shape.rtFrame;
						rtSelShape.origin.x = rtSelShape.origin.x + point.x - ptEnd.x - rtShape.origin.x;
						rtSelShape.origin.y = rtSelShape.origin.y + point.y - ptEnd.y - rtShape.origin.y;
						[self MoveSelectedElements:NSMakeSize(rtSelShape.origin.x, rtSelShape.origin.y) HitTest:SHT_MOVEAPEX];
					} else  
                    {
						[self MoveSelectedElements:NSMakeSize(ptStart.x - ptEnd.x, ptStart.y - ptEnd.y) HitTest:SHT_MOVING];
					}
					
					isDragingShape = NO;
					nHitTest = SHT_NONE;
					[self setNeedsDisplay:YES];
					
					return;
             
				}
			}*/
		}
		if (sg.currentElement.uType == SHAPE_DROPDOWN && nHitTest != SHT_MOVING) //The user is trying to resize the drop down menu
        {
            // Warning message already thrown?
        }
        else
        {
            [self MoveSelectedElements:NSMakeSize(point.x - ptEnd.x, point.y - ptEnd.y) HitTest:nHitTest];
        }
		
	}
	

    // check the mouse select rangle, draw select area rectagle with dash line border
	if (isSelArea == YES) {
		ptEnd = point;
		
		// check the shift key is pressed, if shift key is not pressed, deselect all shapes.
		if (([theEvent modifierFlags] & NSShiftKeyMask) != NSShiftKeyMask) {
			[self DeselectAllShaps];
		}
		
		//for (Element* element in elementArray) {
		for (NSInteger index = [elementArray count] - 1; index >= 0; index --) {
			Element *element = [elementArray objectAtIndex:index];
			
			NSRect rtSelArea = NSMakeRect( ptStart.x, ptStart.y, ptEnd.x - ptStart.x, ptEnd.y - ptStart.y );
			if ( CGRectContainsRect( rtSelArea, element.frame ) == YES ) {
				element.isSelected = YES;
				[selElementArray addObject:element];
			}
		}
	}
	
	// if the user selects multiple shapes, attributes pannel shows zero.
	if ([selElementArray count] > 1) {
		[attributeDelegate SetAttributeOfShapeToPanel:0 yPos:0 Width:0 Height:0];
	}
	
	isDragingShape = NO;
	isSelArea = NO;
	nHitTest = SHT_NONE;
	[self setNeedsDisplay:YES];
}


#pragma mark - DrawShapeType delegate implementation

/*
 @function:		setDrawShapeType
 @params:		type:   new shape type
 @return:       void
 @purpose:		This function body's definition is implemented at StageView.m file.
 This function set the current shape type from param 'type'.
 */
- (void)setDrawElementType:(ElementType)type
{
	elementType = type;
}

-(NSSize)defaultSizeOfElement:(ElementType)type
{
    // Enable the user to set these to his own prefrences and save in his settings
    NSSize defaultSizeOfElement;
    switch (type)
    {
        case SHAPE_BUTTON:
            defaultSizeOfElement = NSMakeSize(200, 40);
            break;
        
        case SHAPE_RECTANGLE:
            defaultSizeOfElement = NSMakeSize(200, 100);
            break;
        
        case SHAPE_TEXTBOX:
            defaultSizeOfElement = NSMakeSize(200, 50);
            break;
            
        case SHAPE_TEXTFIELD:
            defaultSizeOfElement = NSMakeSize(150, 18);
            break;
            
        case SHAPE_DROPDOWN:
            defaultSizeOfElement = NSMakeSize(218, 25);
            break;
            
        case SHAPE_PLACEHOLDER_IMAGE:
            defaultSizeOfElement = NSMakeSize(200, 200);
            NSLog(@"IMG PLACEHOLDER SIZE SET!\n \n");
            break;
        
        case SHAPE_DYNAMIC_ROW:
            defaultSizeOfElement = NSMakeSize(600, 200);
            break;
			
		case SHAPE_CONTAINER:
			defaultSizeOfElement = NSMakeSize(300, 300);
            break;
            
        default:
            NSLog(@"default called. Type passed of : %lu", type);
            break;
            
    }
    return defaultSizeOfElement;
}

/*
 @function:		createElementByDrag
 @params:		type:	new shape type
				pt:		new shape's position
 @return:		void
 @purpos:		This function body's definition is implemented at StageView.m file.
 This function create the new shape by 'type' and position with pt.
 */
- (void)createElementByDrag:(ElementType)type pos:(NSPoint)pt
{
	[self DeselectAllShaps];
	[self DisableEditing];
	
	pt = [self convertPoint:pt fromView:nil];
	//pt.y = self.frame.size.height - pt.y;
	
	Element *shape = [Element createElement:type];
	shape.insideOperationElement = self;
    NSSize defaultSizeOfElement = [self defaultSizeOfElement:type];
	[shape setBoundRect:NSMakeRect(pt.x - defaultSizeOfElement.width / 2,
                                   pt.y - defaultSizeOfElement.height / 2,
                                   defaultSizeOfElement.width,
                                   defaultSizeOfElement.height)];
	shape.isSelected = YES;
    //[self addSubview:shape];
	if (type == SHAPE_CONTAINER) {
		[self addSubview:shape positioned:NSWindowBelow relativeTo:nil];
		[elementArray insertObject:shape atIndex:0];
		[selElementArray addObject:shape];
	} else {
		[self addSubview:shape positioned:NSWindowAbove relativeTo:[elementArray lastObject]];
		[elementArray addObject:shape];
		[selElementArray addObject:shape];
	}
    
    int oldTag = [self elementCount];
    int newTag = oldTag+1;
    [shape setValue:[[NSNumber numberWithInt:newTag] stringValue] forKey:@"elementTag"];
    [shape setValue:[[NSNumber numberWithInt:newTag] stringValue] forKey:@"elementid"];
	
    self.elementCount = newTag;
    [self locateElementOnStage:shape];
    Singleton *sg = [[Singleton alloc]init]; // AN: If you have a singleton - you shouldn't be creating it like this.
    sg.currentElement = shape;
    
    if (sg.currentElement.uType == SHAPE_IMAGE) 
    {
        [self postNotificationForImageToResize];
    }

	// if creating shape is text box
	if (type == SHAPE_TEXTBOX) {
        [sv setFrame:shape.rtFrame];
        [shape setValue:[[NSAttributedString alloc]initWithString:@""] forKey:@"text"];
        
        [textboxView setFrame:shape.rtFrame];
		[textboxView setHidden:NO];
        [sv setHidden:NO];
		
		//[textboxView setStringValue:@""];
		[[self window] makeKeyAndOrderFront:self];
		[[self window] makeFirstResponder:textboxView];
	} 
       
    else {
		// set accepting mouse move event
		[[self window] setInitialFirstResponder:self];
		[[self window] makeFirstResponder:self];
		[[self window] setAcceptsMouseMovedEvents:YES];
	}
       
	
	[self setNeedsDisplay:YES];
	
	// set the attribute to AttriutePanel
	[attributeDelegate SetAttributeOfShapeToPanel:pt.x - defaultSizeOfElement.width / 2
                                             yPos:pt.y - defaultSizeOfElement.height / 2
											Width:defaultSizeOfElement.width
                                           Height:defaultSizeOfElement.height];

    // Re-sort the layers panel
    [layerDelegate SetLayerList];

    [self updateOverlappingVariable];
}

-(NSPoint)convertToTopRight:(NSPoint)point
{
    CGFloat highestPoint;
    if (self.documentContainer.size.height == 0) // when an instance is initialiSed, all its ivar are cleared to bits of zero
    {
        highestPoint = self.frame.size.height;
    }
    else
    {
        highestPoint = self.documentContainer.size.height;
    }

    float convertedYCoordinate = highestPoint - point.y;
    NSPoint appPlane = NSMakePoint(point.x, convertedYCoordinate);
    return appPlane;
}


-(NSPoint)locateElementOnStage:(Element*)element
{
    NSPoint location;
    location = element.rtFrame.origin;
    location.x = [self convertToTopRight:location].x;
    location.y = [self convertToTopRight:location].y;
    return location;
}

#pragma mark - Change shape attribute delegate implementation

/*
 @function:		ChangeAttribueOfShape
 @params:		offset:		The value to change
				hitTest:	The type of value (Moving: SHT_MOVEAPEX, Resizing: SHT_RESIZE)
 @return:		void
 @purpos:		Set the attribute of shape by changing stepper in AttributePanel.
 */
- (void)ChangeAttribueOfElement:(CGSize)offset HitTest:(NSInteger)hitTest;
{
	if ([self IsSelectedShape] == NO) {
		return;
	}
	
	if ([selElementArray count] > 1) {
		NSLog( @"You are selected 2 or more pages" );
		return;
	}
	
    /*
	if (((Element *)[selElementArray lastObject]).uType == SHAPE_CONTAINER) {
		return;
	}
     */
    
    NSLog(@"MOVING or changing size");
    
    // Change the size of the element as requested.
	if ([[[selElementArray lastObject] layoutType] isEqualToString:PERCENTAGE_BASED_LAYOUT] & (hitTest != SHT_MOVEAPEX))
    {
        NSLog(@"PERCENTAGE BASED");
        // ask the stageView who I'm overlapping and get its size
        // calculate the percentage entered in as a pixel value
        // Update OnMouseMove method in Element.m
        

        NSSize meAsAPercentageOfMyContainingView = [self sizeAsPercentageOfHighestContainingElement:[selElementArray lastObject]];
        NSLog(@"SIZE OF CONTAINING ELEMENT : %@", NSStringFromSize(meAsAPercentageOfMyContainingView));
        
        CGFloat containerW = [selElementArray.lastObject rtFrame].size.width/(meAsAPercentageOfMyContainingView.width/100);
        CGFloat containerH = [selElementArray.lastObject rtFrame].size.height/(meAsAPercentageOfMyContainingView.height/100);
        CGSize sizeOfContainer = CGSizeMake(containerW, containerH);
        NSLog(@"sizeOfContainer : %@", NSStringFromSize(sizeOfContainer));
        
        
        
        CGFloat widthEntered = [attributeDelegate stepperValues].width;
        CGFloat heightEntered = [attributeDelegate stepperValues].height;
        
        CGFloat wp = (widthEntered/100);
        NSLog(@"WP : %f",wp);
        CGFloat hp = (heightEntered/100);
        NSLog(@"HP: %f",hp);
        
        CGFloat newWidthInPixels = (sizeOfContainer.width*wp);
        NSLog(@"New Width : %f",newWidthInPixels);
        
        CGFloat newHeightInPixels = (sizeOfContainer.height*hp);
        NSLog(@"New Width : %f",newHeightInPixels);
        
        CGSize newSize = CGSizeMake(newWidthInPixels, newHeightInPixels);
        
        NSLog(@"PERCENT BASED SIZE IS : %@", NSStringFromSize(newSize));
        NSLog(@"Would have been: %@", NSStringFromSize(offset));
        [((Element *)[selElementArray lastObject]) OnMouseMove:newSize HitTest:hitTest];
        
        
        
    }
    else
    {
        //it's pixel based
        NSLog(@"PIXEL BASED OR I'M JUST USING THE TEXTBOXES TO CHANGE THE ELEMENT.");
        [((Element *)[selElementArray lastObject]) OnMouseMove:offset HitTest:hitTest];
    }
	
}


#pragma mark - operation inside of the another shape delegate implementation

/*
 @function:		isInsideShape
 @params:		shape:   current shape
 @return:       This is inside of the shape, return TRUE. otherwise FALSE.
 @purpose:		This function body's definition is implemented at StageView.m file.
				The purpose is to check that the current shape is inside of the another shape.
 */
- (BOOL)isInsideElement:(Element *)element
{
	if ([element superview] == self) {
		return NO;
	}
	
	return YES;
}


/*
 @function:		selectCurrentShape
 @params:		shape:	current shape object
 @return:		void
 @purpose:		The purpose is to select only shape param.
 */
- (void)selectCurrentElement:(Element*)element
{
	[self DeselectAllShaps];
	element.isSelected = YES;
	[selElementArray addObject:element];
    NSLog(@"OBJECT SELECTED");
	if (elementBeenDroppedToStage == NO)
    {
        elementBeenDroppedToStage = YES;
    }
	[self setNeedsDisplay:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


//Rulers

#define ZOOMINFACTOR   (2.0)
#define ZOOMOUTFACTOR  (1.0 / ZOOMINFACTOR)

- (IBAction)zoomIn:(id)sender
{
#pragma unused (sender)
    NSRect tempRect;
    NSRect oldBounds;
    NSScrollView *scrollView = [self enclosingScrollView];
    
    oldBounds = [self bounds];
    
    tempRect = [self frame];
    tempRect.size.width = ZOOMINFACTOR * NSWidth(tempRect);
    tempRect.size.height = ZOOMINFACTOR * NSHeight(tempRect);
    [self setFrame:tempRect];
    
    [self setBoundsSize:oldBounds.size];
    [self setBoundsOrigin:oldBounds.origin];
    
    if (scrollView) [scrollView setNeedsDisplay:YES];
    else [[self superview] setNeedsDisplay:YES];
    
    return;
}


- (IBAction)zoomOut:(id)sender
{
#pragma unused (sender)
    NSRect tempRect;
    NSRect oldBounds;
    NSScrollView *scrollView = [self enclosingScrollView];
    
    oldBounds = [self bounds];
    
    tempRect = [self frame];
    tempRect.size.width = ZOOMOUTFACTOR * NSWidth(tempRect);
    tempRect.size.height = ZOOMOUTFACTOR * NSHeight(tempRect);
    [self setFrame:tempRect];
    
    [self setBoundsSize:oldBounds.size];
    [self setBoundsOrigin:oldBounds.origin];
    
    if (scrollView) [scrollView setNeedsDisplay:YES];
    else [[self superview] setNeedsDisplay:YES];
    
    return;
}


/*****************************/


-(IBAction)bringElementToFront:(id)sender
{
    if (currentElement) 
    {
        
    
        NSLog(@"Current object Behind: %d", [currentElement isUnderneathOtherElement]);
        NSWindowOrderingMode orderType;
    
        if ([[sender title] isEqualToString:@"Bring to Front"]) 
        {
            if ([currentElement isUnderneathOtherElement] == NO) 
            {
                NSLog(@"All ready at the front");
                return;
            }
            orderType = NSWindowAbove;
        }
        else if ([[sender title] isEqualToString:@"Send to Back"])
        {
            if ([currentElement isUnderneathOtherElement] == YES) 
            {
                NSLog(@"All ready at the back.");
                return;
            }
            
            orderType = NSWindowBelow;
            [currentElement setIsUnderneathOtherElement:YES];
        }
        else {
            // AN: I added this clause because there isn't a default or an assertion on the input string.
            NSLog(@"We shouldn't have gotten to this point");
            return;
        }
        
        [currentElement retain];
        [currentElement removeFromSuperviewWithoutNeedingDisplay];
        [elementArray removeObject:currentElement];
        
        if (orderType == NSWindowAbove) 
        {
             [self addSubview:currentElement positioned:orderType relativeTo:[elementArray lastObject]];
            [currentElement setIsUnderneathOtherElement:NO];
            [elementArray addObject:currentElement];
        }
        if (orderType ==  NSWindowBelow) 
        {
             [self addSubview:currentElement positioned:orderType relativeTo:[elementArray objectAtIndex:0]];
            [elementArray insertObject:currentElement atIndex:0];
        }
       
        
        [selElementArray addObject:currentElement];
    
    }
}




#pragma mark - shape cut/copy/paste management implementation

/*
 @function:		IsSelectedShape
 @params:		void
 @return:		if some shape is selected, return TRUE. otherwise FALSE
 @purpose:		The purpose is to check some shape are selected.
 */
- (BOOL)IsSelectedShape
{
	if ([selElementArray count] < 1) {
		return NO;
	}
	
	return YES;
}



- (void)DeleteAllElements
{
	if ([elementArray count] == 0) {
		return;
	}
	
	while ([elementArray count]) {
		Element* element = [elementArray objectAtIndex:0];
		[self DeleteSubElements:element];
	}
}



- (void)DeleteSelElements
{
	/*
    if ([self IsSelectedShape] == NO || ((Element *)[selElementArray lastObject]).uType == SHAPE_CONTAINER) {
		return;
	}
     */
	
	while ([selElementArray count]) {
		Element* element = [selElementArray objectAtIndex:0];
		[self DeleteSubElements:element];
	}
}


/*
 @function:		DeleteSubElements
 @params:		shape:		parent shape to delete
 @return:		void
 @purpose:		This function delete all sub shapes of param element.
 */
- (void)DeleteSubElements:(Element*)element
{
	NSArray *subElements = [element subviews];
	
	if ([subElements count] == 0)
	{
		[element removeFromSuperview];
		[elementArray removeObject:element];
		[selElementArray removeObject:element];
		if ((CutOrCopyFlag == SHAPE_CUT) && (clipBoardArray != nil))
        {
			[clipBoardArray removeObject:element];
		}
		[element release];
		
		return;
	}
	
	while ([subElements count])
    {
		Element* subElement = (Element*)[subElements objectAtIndex:0];
		[self DeleteSubElements:subElement];
	}
}



- (void)CutSelElements
{
	if ([selElementArray count] == 0 || ((Element *)[selElementArray lastObject]).uType == SHAPE_CONTAINER) {
		return;
	}
	
	CutOrCopyFlag = SHAPE_CUT;
	
	if (clipBoardArray != nil) {
		[clipBoardArray removeAllObjects];
		[clipBoardArray release];
		clipBoardArray = nil;
	}
	
	clipBoardArray = [[NSMutableArray alloc] init];
	for (Element* element in selElementArray) {
		if ([element superview] == self) {
			[clipBoardArray addObject:element];
			[element removeFromSuperview];
		}
	}
}


- (void)CopySelElements
{
	if ([selElementArray count] == 0 || ((Element *)[selElementArray lastObject]).uType == SHAPE_CONTAINER) {
		return;
	}
	
	CutOrCopyFlag = SHAPE_COPY;
	
	if (clipBoardArray != nil) {
		[clipBoardArray removeAllObjects];
		[clipBoardArray release];
		clipBoardArray = nil;
	}
	
	clipBoardArray = [[NSMutableArray alloc] init];
	for (Element* element in selElementArray) {
		if ([element superview] == self) {
			[clipBoardArray addObject:element];
		}
	}
}



- (void)PasteSelElements
{
	if (CutOrCopyFlag == SHAPE_NORMAL || [clipBoardArray count] == 0) {
		return;
	}
	
	[self DeselectAllShaps];
	
	// create ele buffer from clipboard
	NSMutableArray* bufferArray = [[NSMutableArray alloc] init];
	for (Element* element in  clipBoardArray) {
		[self CreateClipBoardRecursive:bufferArray src:element dst:nil];
	}
	
	// add shapes to elementArray and selElementsArray of buffer elements
	for (Element* element in bufferArray) {
		if ([element superview] == self) {
			[selElementArray addObject:element];
		}
		[elementArray addObject:element];
	}
	
	switch (CutOrCopyFlag) {
		case SHAPE_CUT:
			while ([clipBoardArray count]) {
				Element* element = [clipBoardArray objectAtIndex:0];
				[self DeleteSubElements:element];
			}
			
			[clipBoardArray removeAllObjects];
			[clipBoardArray release];
			clipBoardArray = nil;
			
			CutOrCopyFlag = SHAPE_NORMAL;
			break;
			
		case SHAPE_COPY:
			break;
			
		default:
			break;
	}
	
	[bufferArray removeAllObjects];
	[bufferArray release];
}


/*
 @function:		CreateClipBoardRecursive
 @params:		buffer:				shape buffer
 srcShape:			original parent shape
 dstShape:			target parent shape
 @return:		void
 @purpose:		The purpose is to create shape into buffer recursively from selShapeArray again.
 */
- (void)CreateClipBoardRecursive:(NSMutableArray*)buffer src:(Element*)srcShape dst:(Element*)dstShape
{
	// creating new element view from srcShape
	Element *element = [Element createElement:srcShape.uType];
	element.insideOperationElement = self;
	
	if (dstShape == nil) {
		[element setBoundRect:NSOffsetRect(srcShape.rtFrame, 10, 10)];
		element.isSelected = YES;
		[self addSubview:element];
	} else {
		[element setBoundRect:srcShape.rtFrame];
		//shape.isSelected = YES;
		[dstShape addSubview:element];
	}
	
	[buffer addObject:element];
	
	// creating sub views of srcShape
	NSArray* subViews = [srcShape subviews];
	if ([subViews count] == 0) {
		return;
	}
	
	for (Element* subView in subViews) {
		[self CreateClipBoardRecursive:buffer src:subView dst:element];
	}
}


#pragma mark - Insert Image methods


/*
 @function:		OnImageButton
 @purpose:		This function called when the user clicked image shape button on advance tool panel.
 */
- (IBAction)InsertImageToStage:(id)sender
{
	
    NSLog(@"In InsertImage To Stage method");
    NSURL *url = [NSURL fileURLWithPath:NSHomeDirectory() isDirectory:YES];
    NSArray* fileTypes = [NSArray arrayWithObjects:@"jpg", @"png", @"tiff", @"jpeg", @"gif", nil];
    
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setDirectoryURL:url];
    [openPanel setAllowedFileTypes:fileTypes];
	[openPanel setAllowsMultipleSelection:YES];
	
	
	if ([openPanel runModal] == NSOKButton) {
		NSArray* fileURLs = [openPanel URLs];
		
		for (NSURL* url in fileURLs) {
			NSLog( @"file URL: %@", url );
			
			[self CreateImageOnStage:url rtBound:NSZeroRect];
		}
	}
}




- (void)CreateImageOnStage:(NSURL *)filePath rtBound:(NSRect)rt
{
	[self DeselectAllShaps];
	[self DisableEditing];
	
	Element *element = [Element createElement:SHAPE_IMAGE];
	element.insideOperationElement = self;
	[((Image *)element) setImageURL:filePath];
	element.isSelected = YES;
	
	[self addSubview:element];
	[elementArray addObject:element];
	[selElementArray addObject:element];
    
    //Set the tag id
    int oldTag = [self elementCount];
    int newTag = oldTag+1;
    [element setValue:[[NSNumber numberWithInt:newTag] stringValue] forKey:@"tag"];
    [element setValue:[[NSNumber numberWithInt:newTag] stringValue] forKey:@"elementid"];
	
    //Update the element count
    self.elementCount = newTag;
    [self locateElementOnStage:element]; // used for debugging
	
	// set accepting mouse move event
	[[self window] setInitialFirstResponder:self];
	[[self window] makeFirstResponder:self];
	[[self window] setAcceptsMouseMovedEvents:YES];
    
	[self setNeedsDisplay:YES];
    
	// set the attribute to AttriutePanel
	[attributeDelegate SetAttributeOfShapeToPanel:element.rtFrame.origin.x yPos:element.rtFrame.origin.y
											Width:element.rtFrame.size.width Height:element.rtFrame.size.height];
    
    //re-sort the layers panel
    [layerDelegate SetLayerList];
}



#pragma mark - MENU BAR CONTROLLING METHODS
- (IBAction)copy:(id)sender
{
    BOOL success;
    NSArray *types = [NSArray arrayWithObjects:
                      NSStringPboardType, NSTIFFPboardType, nil];
    NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSGeneralPboard];
    [pb declareTypes:types owner:self];
    success = [pb setString:@"yodi" forType:NSStringPboardType];
    if (!success) { // very unlikely!
        NSBeep();
    }
}

- (IBAction)delete:(id)sender
{
    [self DeleteSelElements];
}

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem
{
    SEL theAction = [anItem action];
    
    if (theAction == @selector(delete:))
    {
        if (self.selElementArray.count > 0)
        {
            return YES;
        }
        return NO;
    }
    else
    {
        return YES;
    }
    
    // Subclass of NSDocument, so invoke super's implementation
    //return [super validateUserInterfaceItem:anItem];
}


#pragma mark - Encoding and decoding
/*
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.firstName forKey:ASCPersonFirstName];
    [coder encodeObject:self.lastName forKey:ASCPersonLastName];
    [coder encodeFloat:self.height forKey:ASCPersonHeight];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _firstName = [coder decodeObjectForKey:ASCPersonFirstName];
        _lastName = [coder decodeObjectForKey:ASCPersonLastName];
        _height = [coder decodeFloatForKey:ASCPersonHeight];
    }
    return self;
}
*/

#pragma mark - shape control implementation

/*
 @function:		initDrawStage
 @params:		nothing
 @return:		void
 @purpose:		This function called to initialize shapes.
 */
- (void)initDrawStage
{
	//[self DeleteAllShapes];
	for (NSView *view in elementArray) {
		[view removeFromSuperview];
	}
	
	[elementArray removeAllObjects];
	[selElementArray removeAllObjects];
	[clipBoardArray removeAllObjects];
	
	[elementArray release];
	[selElementArray release];
	[clipBoardArray release];
	
	elementArray = [[NSMutableArray alloc] init];
    selElementArray = [[NSMutableArray alloc] init];
	clipBoardArray = nil;
	
	[textboxView setHidden:YES];
	
	isDragingShape = NO;
	isSelectedShape = NO;
	isSelArea = NO;
	CutOrCopyFlag = SHAPE_NORMAL;
	
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSArray *typeFaceFamilies = [fontManager availableFontFamilies];
	
	fontFaceArray = [[NSMutableArray alloc] initWithArray:typeFaceFamilies];
}

#pragma mark - stage save and open implementation

/*
 @function:		SaveProjectToFile
 @params:		filename:			file name to save
 @return:		save successfully, return data of shapes. otherwise nil.
 @purpose:		This function saves all shapes of shape's array to filename.
 */
- (NSData *)SaveProjectToFile:(NSString*)filename;
{
	NSMutableArray *savedDataArray = [[NSMutableArray alloc] init];
	
	for (Element* element in elementArray) {
		NSMutableDictionary *dict = [element getShapeData];
		[savedDataArray addObject:dict];
		dict = nil;
	}
	
	//BOOL bResult = [savedDataArray writeToFile:filename atomically:YES];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:savedDataArray];
	[savedDataArray release];
	
	return data;
}


/*
 @function:		OpenProjectFromFile
 @params:		data:			file data
 @return:		open sucessfully, return YES. otherwise NO.
 @purpose:		This function read shapes value from filename and create shapes of stageview.
 */
- (BOOL)OpenProjectFromFile:(NSData *)data
{
	NSArray *openDataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	if (openDataArray == nil) {
		return NO;
	}
	
	// initialize stage view
	[self initDrawStage];
	
	for (NSDictionary *dict in openDataArray) {
		Element *element = [Element createElementFromDictionary:dict];
		if (element) {
			element.insideOperationElement = self;
			[self addSubview:element];
			[elementArray addObject:element];
			//[shape setBoundRect:shape.rtFrame];
		}
	}
	
	// set accepting mouse move event
	[[self window] setInitialFirstResponder:self];
	[[self window] makeFirstResponder:self];
	[[self window] setAcceptsMouseMovedEvents:YES];
	
	[self setNeedsDisplay:YES];
	
	// set the attribute to AttriutePanel
	[attributeDelegate SetAttributeOfShapeToPanel:0 yPos:0 Width:0 Height:0];
	//[shadowDelegate setShadowProperty:0 Distance:0 colorR:0 colorG:0 colorB:0 Opacity:0 Blur:0 Direct:YES];
	
	return YES;
}

-(BOOL)insideMyFrame:(NSPoint)pt
{
    NSPoint aLocationInSelf = [self convertPoint: pt fromView: nil];
    NSLog(@"THE POINT IS : %@", NSStringFromPoint(aLocationInSelf));
    if (aLocationInSelf.x < 0 || aLocationInSelf.y < 0)
    {
        NSLog(@"INSIDE MYFRAME : returnng no");
        return NO;
    }
    NSLog(@"INSIDE MYFRAME : returnng YES");
    return YES;
}




#pragma mark - layer operation implementation

/*
 @fuction:		ResortLayer
 @params:		nothing
 @return:		void
 @purpose:		This function calls LayerPanel's SetLayerList to resort shape list to layer panel.
 */
- (void)ResortLayer
{
	[layerDelegate SetLayerList];
}

/*
 @function:		ResortShapes
 @params:		from:	index of source shape item to move
 to:		index of dest shape item
 @return:		void
 @purpose:		This function move the shape item according to table item moving.
 */
- (void)ResortShapes:(NSIndexSet *)from to:(NSInteger)to
{
	NSUInteger index = [from lastIndex];
	NSInteger aboveInsertIndex = 0;
	id object;
	NSInteger removeIndex;
	
	while (index != NSNotFound) {
		if (index >= to) {
			removeIndex = index + aboveInsertIndex;
			aboveInsertIndex += 1;
		} else {
			removeIndex = index;
			to -= 1;
		}
		
		object = [elementArray objectAtIndex:removeIndex];
		[elementArray removeObjectAtIndex:removeIndex];
		[elementArray insertObject:object atIndex:to];
		
		index = [from indexLessThanIndex:index];
	}
	
	for (int i = 0; i < [elementArray count]; i ++) {
		Element *shape = [elementArray objectAtIndex:i];
		[shape removeFromSuperview];
		[self addSubview:shape positioned:NSWindowAbove relativeTo:nil];
	}
}


/*
 @function:		IsLayOnRect
 @params:		src:		the source rectangle
 dst:		the dest rectangle
 @return:		If one rect is lay on other rect, it's YES. otherwise NO.
 @purpose:		This function check that one rect is lay on other rect.
 */
- (BOOL)IsLayOnRect:(CGRect)src Dst:(CGRect)dst
{
	src = CGRectStandardize(src);
	dst = CGRectStandardize(dst);
	
	if (src.origin.x + src.size.width < dst.origin.x || src.origin.y + src.size.height < dst.origin.y) {
		return YES;
	}
	
	if (dst.origin.x + dst.size.width < src.origin.x || dst.origin.y + dst.size.height < src.origin.y) {
		return YES;
	}
	
	return NO;
}


-(float)nicelyFormattedFloat:(float)f //1.500000
{
    NSString *stringFromFloat=[NSString stringWithFormat:@"%f",f];
    NSArray *arrayFromString=[stringFromFloat componentsSeparatedByString:@"."];
    arrayFromString = [[arrayFromString objectAtIndex:1] componentsSeparatedByString:@""];
    NSLog(@"String is is : %@", arrayFromString);
    NSUInteger arrayLength = [[arrayFromString objectAtIndex:1] length]; //everything after the decimal place
    NSLog(@"String length is : %lu", arrayLength);
    NSUInteger loopCount = arrayLength;
    
    while (loopCount !=0)
    {
        if ([[arrayFromString objectAtIndex:loopCount-1] isEqualToString:@"0"] == NO)
        {
            //we've found a non zero digit after the decimal place
            return loopCount;
        }
        else
        {
            loopCount=loopCount-1;
            NSLog(@"else COUNG : %lu", loopCount);
            
        }
    }
    //if we've got this far, then all the digits after the decimal place are zeros.
    NSAssert((loopCount == 0),@"Loop count is not zero in nicelyFormattedFloat method ");
    return loopCount;
  
    
}







#pragma mark - create background for stageView



typedef struct MyImagePatternInfo
{
    CGRect rect;
    struct CGImage *imageDoc;
}MyImagePatternInfo;


static void MyDrawImagePattern (void *info, CGContextRef patternCellContext)
{
    //This pattern proc draws the first page of a PDF document to a destination rectangle
    MyImagePatternInfo *patternInfoP = (MyImagePatternInfo *)info;
    
    CGContextSaveGState(patternCellContext);
    CGContextClipToRect(patternCellContext, patternInfoP->rect);
    CGContextDrawImage(patternCellContext, patternInfoP->rect, patternInfoP->imageDoc);
    CGContextRestoreGState(patternCellContext);
}


static void myImagePatternRelease (void *info)
{
    if (info)
    {
        MyImagePatternInfo *patternInfoP = (MyImagePatternInfo *)info;
        CGImageRelease(patternInfoP->imageDoc);
    }
    
}


static CGPatternRef createImagePatternPattern(CGAffineTransform *additionalTransformP, CFURLRef url)
{
    CGPatternCallbacks myPatternCallbacks;
    MyImagePatternInfo *patternInfoP;
    CGPatternRef pattern;
    CGAffineTransform patternTransform;
    float tileOffsetX, tileOffsetY;
    
    //ONLY VERSION 0 OF THE PATTERN CALLBACK IS DEFINED AS OF MOUNTAIN LION
    myPatternCallbacks.version = 0;
    
    //The pattern's drawpattern procedure us the routine Quartz calls to draw a pattern cell when it needs to draw one.
    myPatternCallbacks.drawPattern = MyDrawImagePattern;
    //Since the pattern has the Image as a a resource, it should be released when Quartz no longer needs the pattern.
    myPatternCallbacks.releaseInfo = myImagePatternRelease;
    patternInfoP = (MyImagePatternInfo *)malloc(sizeof(MyImagePatternInfo));
    
    if (patternInfoP == NULL)
    {
        fprintf(stderr, "Couldn't allocate pattern info data! \n");
        return NULL;
    }
    NSImage *theImage = [[NSImage alloc]initWithContentsOfURL:(NSURL*)url];
    NSRect imgRect = NSMakeRect(0, 0, theImage.size.width, theImage.size.height);
    CGImageRef imgRef = [theImage CGImageForProposedRect:&imgRect context:NULL hints:NULL];
    patternInfoP->imageDoc = imgRef;
                              
    if (patternInfoP ->imageDoc == NULL)
    {
        fprintf(stderr, "Couldn't create Image doc reference!\n");
        free(patternInfoP);
        return NULL;
    }
    
    patternInfoP->rect = imgRect;
    patternInfoP->rect.origin = CGPointZero;
    
    if (additionalTransformP)
        patternTransform = *additionalTransformP;
    else
        patternTransform = CGAffineTransformIdentity;
    
    //To emulate the example from the Bitmap context drawing chapter, the title offset in each dimension is the title size in that dimension plus 6 units.
    tileOffsetX = 6 + patternInfoP->rect.size.width;
    tileOffsetY = 6 + patternInfoP->rect.size.height;
    
    pattern = CGPatternCreate(patternInfoP, // the pattern
                              patternInfoP->rect,// the size
                              patternTransform,
                              tileOffsetX,
                              tileOffsetY,
                              kCGPatternTilingConstantSpacingMinimalDistortion,
                              true, //this pattern has intrinsic color
                              &myPatternCallbacks);
    
    //if the pattern can't be created, then release the pattern resources and info paramenter.
    if (pattern == NULL) {
        myPatternCallbacks.releaseInfo(patternInfoP);
        patternInfoP = NULL;
    }
    
    return pattern;
}



static void drawWithImagePattern(CGContextRef context, CFURLRef url)

{
    CGColorSpaceRef patternColorSpace;
    CGFloat color[1];
    //Scale the
    
    CGPatternRef imagePattern = createImagePatternPattern(NULL, url);
    if (imagePattern == NULL) {
        fprintf(stderr, "Couldn't create pattern!\n");
        return;
    }
    
    //Since the pattern itself has intrinsic color, the 'baseColorspace' paremeter pased to CGColorspacecreatepattern must be null.
    patternColorSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternColorSpace);
    //Quartz retains the color space so this code can now release it since it no longer needs it
    CGColorSpaceRelease(patternColorSpace);
    
    //paint the patt with an alpha of 1
    color[0] = 1;
    CGContextSetFillPattern(context, imagePattern, color);
    //quartz retains the pattern so this code can now release it since it no longer needs it.
    CGPatternRelease(imagePattern);
    
    
    //fill a us-letter size rectangle with the pattern
    CGContextFillRect(context, CGRectMake(0, 0, 612, 792));
}



#pragma mark - for dynamically displaying the font tab

- (void)showFontTab
{
	[(AppDelegate *)[[NSApplication sharedApplication] delegate] showDinamicFontTab:self.fontView];
	self.isShowFontTab = YES;
	
	// set font tab
	[self.searchField setStringValue:@""];
	
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSArray *typeFaceFamilies = [fontManager availableFontFamilies];
	
	[fontFaceArray release];
	fontFaceArray = [[NSMutableArray alloc] initWithArray:typeFaceFamilies];
	
	[fontTableView reloadData];
	
	// select current font
	/* start comm
    NSRange totalRange;
	totalRange.location = 0;
	totalRange.length = [[self textboxView].string length];
    if (totalRange.length > 0)
    {
        //Get the old font
		NSMutableDictionary *allAttributes = [NSMutableDictionary dictionaryWithDictionary: [[[self textboxView] textStorage] attributesAtIndex:totalRange.location effectiveRange:nil]];
		NSFont *theFont = [allAttributes objectForKey:NSFontAttributeName];
	
		//UPDATE THE FONT FAMILY
		NSString *selectedTypeFace = [theFont familyName];
		[self selectFontofCurrentTextBox:selectedTypeFace];
	}
    */
}

- (void)hideFontTab
{
	[self.fontView removeFromSuperview];
	[(AppDelegate *)[[NSApplication sharedApplication] delegate] hideDinamicFontTab];
	self.isShowFontTab = NO;
}


#pragma mark - NSSearchField delegate implementation

- (void)controlTextDidChange:(NSNotification *)obj
{
	[fontTableView deselectAll:nil];
	
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSArray *typeFaceFamilies = [fontManager availableFontFamilies];
	
	[fontFaceArray release];
	fontFaceArray = [[NSMutableArray alloc] init];
	
	for (NSString *fontName in typeFaceFamilies) {
		if ([fontName compare:self.searchField.stringValue options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.searchField.stringValue.length)] == NSOrderedSame) {
			[fontFaceArray addObject:fontName];
		}
	}
	
	[fontTableView reloadData];
}


#pragma mark - table view delegate implementation

- (void)selectFontofCurrentTextBox:(NSString *)fontName
{
	NSLog(@"Ming: selectFonttoCurrentTextBox called---------------");
	[fontTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:[fontFaceArray indexOfObject:fontName]] byExtendingSelection:NO];
	[fontTableView scrollRowToVisible:[fontFaceArray indexOfObject:fontName]];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
	return 21;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
	// Send a message to the object currently selected, tell it's text delegate to change the font of the selected text.
    Singleton *sg = [[Singleton alloc] init];
    if (sg.currentElement.uType == SHAPE_TEXTBOX)
    {
		NSLog(@"Ming: shouldSelectRow called*************************");
		
		NSString *fontname = [fontFaceArray objectAtIndex:row];
        NSDictionary *newFontAttributes = [NSDictionary dictionaryWithObject:fontname forKey:@"typeFace"];
        [self convertFont:newFontAttributes];
		
    }
	
	return YES;
}


#pragma mark - table view data source implementation

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [fontFaceArray count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	if ([[tableColumn identifier] isEqualToString:@"FontName"]) {
		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSFont fontWithName:[fontFaceArray objectAtIndex:row] size:12], NSFontAttributeName, nil];
		NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:[fontFaceArray objectAtIndex:row] attributes:attributes];
		
		return attributedTitle;
	}
	
	return nil;
}


@end
