/* DOCUMENTATION:
 
 The Singleton is called upon in this class
 but it is never assigned to an element, this
 privilege is only given to the stageView
 via the DocumentController. Brap!
 
 */


#import "AppDelegate.h"
#import "StageTextView.h"
#import "DocumentBar.h"
#import "Document.h"
#import "DataSourceWindowController.h"
//#import "NewContainerWindowController.h"



@implementation AppDelegate

//@synthesize thewindow = _window;
@synthesize stageView;
@synthesize sg;
@synthesize nu, pl;
@synthesize sl, borderValue;
@synthesize borderRadiusSlider, borderRadiusValue, buttonURLField;
@synthesize dBar;
@synthesize typeFaceName, typeFaceTrait;
@synthesize fontColorWell;
@synthesize fontSizeComboBox;
@synthesize arrayDataSource;
//@synthesize kerningValue;
//@synthesize leadingValue;

@synthesize buttonPanel;
@synthesize colorHexValue;
@synthesize labelWarningField;
@synthesize elementidField;
//@synthesize layoutType;

@synthesize alignmentPanel;
@synthesize attributePanel;
@synthesize galleryPanel;
@synthesize dataSourcePanel;

@synthesize dataSourceField;
@synthesize actionField;
@synthesize visibilityField;

@synthesize xCoordinateLabel;
@synthesize yCoordinateLabel;
@synthesize layoutTypeLabel;
@synthesize widthLabel;
@synthesize heightLabel;
@synthesize backgroundColorLabel;
@synthesize borderWidthLabel;
@synthesize borderRadiusLabel;
@synthesize topLeftLabel;
@synthesize topRightLabel;
@synthesize bottomLeftLabel;
@synthesize bottomRightLabel;
@synthesize tagLabel;



- (BOOL)windowShouldClose:(id)sender
{
    NSLog(@"Delegate method called");
    [self validateMenuItem:(NSMenuItem*)sender];
    [self togglePanelVisibility:sender];
    return YES;
}


- (void)dealloc
{
    [super dealloc];
}

/*- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	NSLog(@"----- applicationShouldOpenUntitledFile -----");
	
	isRestored = YES;
	
	return NO;
}*/

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc.stageView ResortLayer];
	galleryPanel.delegate = curDoc.stageView;
}

-(void)applicationWillFinishLaunching:(NSNotification *)notification
{
    
    
    NSLog(@"applicationWillFinishLaunching called.");
    
    // Check if this trial version of the app has expired and should close
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSDate* expiryDate = [df dateFromString:@"12/01/2013"];
    NSDate * today = [NSDate date];
    NSComparisonResult result = [today compare:expiryDate];
    switch (result)
    {
        case NSOrderedAscending:
            NSLog(@"Today is before the expiry date");
            break;
        case NSOrderedDescending:
            NSLog(@"Earlier Date");
            NSRunAlertPanel(@"Expired app", @"The trial version of this app has expired. Please purchase a full version to access this software.", @"OK", nil, nil);
            [NSApp terminate:self];
            break;
        case NSOrderedSame:
            NSLog(@"Today/Null Date Passed"); //Not sure why This is case when null/wrong date is passed
        default:
            NSLog(@"Error Comparing Dates");
    }
        
    //// Color Declarations
    NSColor* fillColor = [NSColor colorWithCalibratedRed: 0.9 green: 0.9 blue: 0.9 alpha: 1];
    NSColor* color2 = [NSColor colorWithCalibratedRed: 0.5 green: 0.5 blue: 0.5 alpha: 1];
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: color2];
    [shadow setShadowOffset: NSMakeSize(-1.1, -1.1)];
    [shadow setShadowBlurRadius: 0];

    // Create the attributes dictionary, you can change the font size
    // to whatever is useful to you
    NSMutableDictionary *sAttribs = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      [NSFont boldSystemFontOfSize:10.0],NSFontAttributeName,
                                      //shadow, NSShadowAttributeName,
                                      fillColor, NSForegroundColorAttributeName,
                                      nil] autorelease];
    // The shadow object has been assigned to the dictionary, so release
    [shadow release];
    // Create a new attributed string with your attributes dictionary attached
    NSAttributedString *s = [[NSAttributedString alloc] initWithString:@"Background color"
                                                            attributes:sAttribs];
    // Set your text value
    
    [xCoordinateLabel setStringValue:NSLocalizedString(@"X", nil)];
    [yCoordinateLabel setStringValue:NSLocalizedString(@"Y", nil)];
    [layoutTypeLabel setStringValue:NSLocalizedString(@"Type", nil)];
    [widthLabel setStringValue:NSLocalizedString(@"Width", nil)];
    [heightLabel setStringValue:NSLocalizedString(@"Height", nil)];
    [backgroundColorLabel setStringValue:NSLocalizedString(@"Shape color", nil)];
    [borderWidthLabel setStringValue:NSLocalizedString(@"Border Width", nil)];
    // Clean up
    [s release];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /*for (NSDocument *doc in [[NSDocumentController sharedDocumentController] documents]) {
		[((Document *)doc).stageView createContainerElement:1024];
	}*/
    
    //Airbrake initialisation
    [ABNotifier startNotifierWithAPIKey:@"208f2b2774afeb70cc750a0b7c8d655d"
                        environmentName:ABNotifierAutomaticEnvironment
                                 useSSL:NO // only if your account supports it
                               delegate:self];
    
    self.actionsArray = [NSMutableArray array];
	
    [NSColorPanel setPickerMask:NSColorPanelWheelModeMask];
    
    // Insert code here to initialize your application
    NSLog(@"applicationDidFinishLaunching called.");
    /*
    alignmentPanel.delegate = self;
    attributePanel.delegate = self;
    fontPanel.delegate = self;
    buttonPanel.delegate = self;
     */
    
    
	//HACK / BUG
	attributePanelVisible = YES;
    [attributePanel setIsVisible:YES];
    [self.attributePanel setTitle:@"Attributes"];
    
	alignmentPanelVisible = NO;
    [alignmentPanel setIsVisible:NO];

    fontPanelVisible = NO;
    [fontPanel setIsVisible:NO];
    
    buttonPanelVisible = NO;
    [buttonPanel setIsVisible:NO];
    
	
    
    
	//if (isRestored == YES) {
		//[self OnNewDocument:nil];
	//} else {
		[attributePanel setIsVisible:attributePanelVisible];
		[alignmentPanel setIsVisible:alignmentPanelVisible];
		[self.layerPanel setIsVisible:YES];
		[galleryPanel setIsVisible:YES];
	//}
    
    
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSArray *typeFaceFamilies = [fontManager availableFontFamilies];
    [typeFaceName addItemsWithTitles:typeFaceFamilies];
    [typeFaceName selectItemWithTitle:@"Helvetica Neue"];
    [self setTypeFaceFamily:typeFaceName];
    
    [fontSizeComboBox addItemWithObjectValue:[NSNumber numberWithFloat:20.0]];
    
    
	
	[attributePanel SetStepperValue:0.0 yPos:0.0 Width:0.0 Height:0.0];
    
    //leading = [NSNumber numberWithFloat:0.0];
    //kerning = [NSNumber numberWithFloat:0.0];
    
    
    sg = [[Singleton alloc]init];
    
        
    //Bind the hex value box
    [colorHexValue bind:@"value" toObject:self withKeyPath:@"sg.currentElement.colorAttributesWithHexString" options:nil];
    
    [pl bind:@"value" toObject:self withKeyPath:@"sg.currentElement.colorAttributes" options:nil];
    
    
    //Bind the Border Width slider and textfield respectively.
    //[borderWidthSlider bind:@"value" toObject:self withKeyPath:@"sg.currentElement.borderWidth" options:nil];
    [borderWidthValue bind:@"value" toObject:self withKeyPath:@"sg.currentElement.borderWidth" options:nil];
    
    
    //Bind Border Radius attribute
    [topLeftRadius bind:@"value" toObject:self withKeyPath:@"sg.currentElement.topLeftBorderRadius" options:nil];
    [topRightRadius bind:@"value" toObject:self withKeyPath:@"sg.currentElement.topRightBorderRadius" options:nil];
    [bottomLeftRadius bind:@"value" toObject:self withKeyPath:@"sg.currentElement.bottomLeftBorderRadius" options:nil];
    [bottomRightRadius bind:@"value" toObject:self withKeyPath:@"sg.currentElement.bottomRightBorderRadius" options:nil];
    
    //[borderRadiusSlider bind:@"value" toObject:self withKeyPath:@"sg.currentElement.borderRadius" options:nil];
    [borderRadiusValue bind:@"value" toObject:self withKeyPath:@"sg.currentElement.borderRadius" options:nil];
    
    
    //Bind buttonURLField
    [buttonURLField bind:@"value" toObject:self withKeyPath:@"sg.currentElement.imgName" options:nil];
    
    
    //Bind the font dropdowns to the text selected.
    [kerningStepper bind:@"value" toObject:self withKeyPath:@"kerningValue" options:nil]; // setKerningValue //
    [kerningTextField bind:@"value" toObject:self withKeyPath:@"kerningValue" options:nil];
    [leadingStepper bind:@"value" toObject:self withKeyPath:@"leadingValue" options:nil];
    [leadingTextField bind:@"value" toObject:self withKeyPath:@"leadingValue" options:nil];
    [fontSizeTextField2 bind:@"value" toObject:self withKeyPath:@"stageView.textboxView.fontSize" options:nil];
    
    //Bind the ID field
    [elementidField bind:@"value" toObject:self withKeyPath:@"sg.currentElement.elementid" options:nil];
    
    //Bind the data fields
    [dataSourceField bind:@"value" toObject:self withKeyPath:@"sg.currentElement.dataSourceStringEntered" options:nil];
    [actionField bind:@"value" toObject:self withKeyPath:@"sg.currentElement.actionStringEntered" options:nil];
    [visibilityField bind:@"value" toObject:self withKeyPath:@"sg.currentElement.visibilityActionStringEntered" options:nil];
    
    //Bind the hex value box
    [_borderHexValue bind:@"value" toObject:self withKeyPath:@"sg.currentElement.colorAttributesWithHexString" options:nil];
    
    [_borderColour bind:@"value" toObject:self withKeyPath:@"sg.currentElement.colorAttributes" options:nil];

    
    [_currentlySelectedLabel bind:@"value" toObject:self withKeyPath:@"sg.currentElement.elementid" options:nil];
    
    [_cssOverride bind:@"attributedString" toObject:self withKeyPath:@"sg.currentElement.extracss" options:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearKerningAndLeadingFields) 
                                                 name:UPDATE_KERNING_TEXTFIELD 
                                               object:nil];
    
    
	self.arrayDataSource = nil;
}


-(IBAction)takeLayoutType:(id)sender
{
    NSLog(@"got : %@", [sender title]);
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    [[curDoc stageView] setLayoutType:[NSMutableString stringWithString:[sender title]]];
}

#pragma mark - document operation implementation

/*
 @function:	OpenNewDocument
 @params:	width: width of containter shape
 @return:	void
 @purpose:	This function create new document.
 */
- (void)OpenNewDocument:(CGFloat)width
{
	NSLog( @"Open New Document in AppDelegate, width: %f", width );
	
	//[[NSDocumentController sharedDocumentController] openUntitledDocumentAndDisplay:YES error:nil];
	[attributePanel setIsVisible:attributePanelVisible];
	[alignmentPanel setIsVisible:alignmentPanelVisible];
	[self.layerPanel setIsVisible:YES];
	[galleryPanel setIsVisible:YES];
	
	//Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	Document *curDoc = (Document *)[[NSDocumentController sharedDocumentController] openUntitledDocumentAndDisplay:YES error:nil];
	[curDoc.stageView createContainerElement:width];
}


#pragma mark - TableView datasource and delegate methods


-(NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    //return [villains count];
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	return [[[curDoc stageView] elementArray] count];
    
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{    
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    return [[[[curDoc stageView] elementArray] objectAtIndex:row] valueForKey:[tableColumn identifier]];
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    [[[[self stageView]elementArray] objectAtIndex:row] setObject:object forKey:[tableColumn identifier]];
}




#pragma mark - Font Panel methods

-(void)colorToHex:(NSColor *)color
{
    
}

-(void)clearKerningAndLeadingFields
{
    kerningTextField = nil;
    leadingTextField = nil;
}

-(NSNumber*)kerningValue
{
    NSNumber *k = [NSNumber numberWithFloat: [[stageView textboxView] kerning]];
    return k;
}


-(void)setKerningValue:(NSNumber *)kerningValueReceived //:(NSNumber *)k //updateKerningOrLeadingFields
{
    CGFloat valueTypedIn = [kerningValueReceived floatValue];
    CGFloat kerning = [[stageView textboxView] kerning];

    int difference = valueTypedIn - kerning;
    if ( difference > 0) //The value typed in is bigger than the iVar
    {
        for (int i = 0; i < difference; i++) 
            {
                [[stageView textboxView] loosenKerning:nil];
                NSLog(@"iNCREASING THE KERNING EEE");
            }
    }
    else //The value typed in is smaller than the iVar
    {
        difference = difference * -1;
        for (int i = 0; i < difference; i++) 
            {
                // we want to treat all these replacements as a single replacement for undo purposes
            
                [[stageView textboxView] tightenKerning:nil];
                NSLog(@"DECREASING THE KERNING EEE");
            }
        
    }
    
    [[stageView textboxView] setKerning:valueTypedIn];
}


-(NSNumber*)leadingValue
{
    NSNumber *l = [NSNumber numberWithFloat: [[stageView textboxView] leading]];
    return l;
}


-(void)setLeadingValue:(NSNumber *)leadingValueReceived //Line space is measured in Points.
{
    CGFloat valueTypedIn = [leadingValueReceived floatValue];
    CGFloat leading = [[stageView textboxView] leading];
    
    
    // Test if any text is selected, if so get the selected text and set its color
    NSRange totalRange = [[stageView textboxView] selectedRange];
    if (totalRange.length > 0) 
    {
        NSMutableDictionary *allAtts = [NSMutableDictionary dictionaryWithDictionary: [[[stageView textboxView] textStorage] attributesAtIndex:totalRange.location effectiveRange:nil]];
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
            NSLog(@"iNCREASING THE LEADING");
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
            NSLog(@"DECREASING THE KERNING");
        }
        
    }
    
    [[stageView textboxView] setLeading:valueTypedIn];
    
        [allAtts removeObjectForKey:NSParagraphStyleAttributeName];
        [allAtts setObject:newParagraphStyle forKey:NSParagraphStyleAttributeName];
        [[[stageView textboxView] textStorage] setAttributes:allAtts range:totalRange];
    }
}


-(void)updateCustomFontMenu:(NSDictionary*)attributes //called when the text selection is changed, from the stageView
{
    NSFontManager *fm = [NSFontManager sharedFontManager];
    NSFont *theFont = [attributes objectForKey:NSFontAttributeName];
    
    
    
    //UPDATE THE FONT FAMILY
    NSString *selectedTypeFace = [theFont familyName];
    [typeFaceName selectItemWithTitle:selectedTypeFace];
    
        // Get all of the traits
    NSArray *typeFaceFamily = [fm availableMembersOfFontFamily:selectedTypeFace];
    NSMutableArray *traits = [[NSMutableArray alloc]init];
    for (NSArray *entry in typeFaceFamily) 
    {
        [traits addObject: [entry objectAtIndex:1]];
    }
    
    
    
    // POPULATE THE TRAIT POPUP
    [typeFaceTrait removeAllItems];
    [typeFaceTrait addItemsWithTitles:traits];
    
    NSString *fullFontName = [theFont displayName];
    NSString *seperateFamilyName = [selectedTypeFace stringByAppendingString:@" "];
    seperateFamilyName = [[fullFontName componentsSeparatedByString:seperateFamilyName]componentsJoinedByString:@""];
   
    if ([selectedTypeFace isEqualToString:seperateFamilyName]) 
    {
        seperateFamilyName = @"Regular";
    }
    [typeFaceTrait selectItemWithTitle:seperateFamilyName];
    
    
    
    //UPDATE THE FONT TRAIT - FOR WHEN IT DOES WORK WITH MULTIPLE SELECTIONS & MULTIPLE INDENTIONS
    if ([fm traitsOfFont:theFont]  == NSBoldFontMask) 
    {
        [fontTraitControl setSelectedSegment:0];
    }
    
    if ([fm traitsOfFont:theFont]  == NSItalicFontMask) 
    {
        [fontTraitControl setSelectedSegment:1];
    }
    
    if ([fm traitsOfFont:theFont]  == (NSBoldFontMask|NSItalicFontMask)) 
    {
        [fontTraitControl setSelectedSegment:2];
    }
    
    
    //UPDATE THE ALIGNMENT BUTTON
    
    
    
    //UPDATE THE FONT COLOR
    
    
    
    //UPDATE THE FONT SIZE
    [theFont pointSize];
    
}


-(IBAction)selectFontColor:(id)sender
{
    // Get the font color sent
    NSColor *colorReceived = [sender color];
    NSLog(@"Found a color");
    
    // Test if any text is selected, if so get the selected text and set its color
    NSRange totalRange = [[stageView textboxView] selectedRange];
    if (totalRange.length > 0) 
    {
        
        NSMutableDictionary *allAttributes = [NSMutableDictionary dictionaryWithDictionary: [[[stageView textboxView] textStorage] attributesAtIndex:totalRange.location effectiveRange:nil]];
        
        [allAttributes removeObjectForKey:NSForegroundColorAttributeName];
        [allAttributes setObject:colorReceived forKey:NSForegroundColorAttributeName];
        
        [[[stageView textboxView] textStorage] setAttributes:allAttributes range:totalRange];
        
        
        /*
        NSFontManager *fm = [NSFontManager sharedFontManager];
        NSDictionary *fontAtt = [[[stageView textboxView] textStorage] fontAttributesInRange:totalRange];
        NSFont *fontFromSelectedText = [fontAtt objectForKey:@"NSFont"];
        [fm setSelectedFont:fontFromSelectedText isMultiple:NO];
         */
    }
        
     [[stageView textboxView] setNeedsDisplay:YES];
}


-(IBAction)setFontSize:(id)sender
{
    //Get the font size choosen
    CGFloat newSize = [sender floatValue];
    
    // Test if any text is selected, if so then select text and set its font size.
    NSRange totalRange = [[stageView textboxView] selectedRange];
    if (totalRange.length > 0) 
    {
        
        //Get the old font
        NSFontManager *fm = [NSFontManager sharedFontManager];
        NSMutableDictionary *allAttributes = [NSMutableDictionary dictionaryWithDictionary: [[[stageView textboxView] textStorage] attributesAtIndex:totalRange.location effectiveRange:nil]];
        NSFont *fontFromSelectedText = [allAttributes objectForKey:@"NSFont"];
        
        
        //Convert it to the new font
        [allAttributes removeObjectForKey:NSFontAttributeName];
        
        NSFont *alteredFont = [fm convertFont:fontFromSelectedText toSize:newSize];
        
        [allAttributes setObject:alteredFont forKey:NSFontAttributeName];

        
        [[[stageView textboxView] textStorage] setAttributes:allAttributes range:totalRange];
        

        [fm setSelectedFont:alteredFont isMultiple:NO];
    }
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
    [typeFaceTrait removeAllItems];
    [typeFaceTrait addItemsWithTitles:traits];
    
    // Send a message to the object currently selected, tell it's text delegate to change the font of the selected text.
    
    
    sg = [[Singleton alloc]init];
    if (sg.currentElement.uType == SHAPE_TEXTBOX) 
    {
        
        // Test if any text is selected, if so then select text and set its font size.
        NSRange totalRange = [[stageView textboxView] selectedRange];
        if (totalRange.length > 0) 
        {
            
            //Get the old font
            NSFontManager *fm = [NSFontManager sharedFontManager];
            NSMutableDictionary *allAttributes = [NSMutableDictionary dictionaryWithDictionary: [[[stageView textboxView] textStorage] attributesAtIndex:totalRange.location effectiveRange:nil]];
            
            NSFont *fontFromSelectedText = [allAttributes objectForKey:@"NSFont"];
            NSFont *alteredFont = [fm convertFont:fontFromSelectedText toFamily:selectedTypeFace];

            
            //Convert it to the new font
            [allAttributes removeObjectForKey:NSFontAttributeName];
            [allAttributes setObject:alteredFont forKey:NSFontAttributeName];
            
            
            [[[stageView textboxView] textStorage] setAttributes:allAttributes range:totalRange];
            
            
            [fm setSelectedFont:alteredFont isMultiple:NO];
        }

        
    }

    
}


-(IBAction)setTypeStyle:(id)sender //called when respective dropdown menu choosen
{
    NSFontManager *fm = [NSFontManager sharedFontManager];
    NSString *selectedTypeStyle = [sender title];
    //NSString *typeFace = [[typeFaceName selectedItem] title];
    
    //Get the old font
    NSRange selectedText = [[stageView textboxView] selectedRange];
    NSDictionary *fontAtt = [[[stageView textboxView] textStorage] fontAttributesInRange:selectedText];
    NSFont *fontFromSelectedText = [fontAtt objectForKey:@"NSFont"];
    NSString *nameOfFontToConvertTo = [[[fontFromSelectedText familyName] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByAppendingFormat:@"-%@", [selectedTypeStyle stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSLog(@"Old font was: %@", [fontFromSelectedText fontName]);
    NSLog(@"New font style: %@", nameOfFontToConvertTo);
    
    //Convert it to the new font
    NSFont *alteredFont = [fm convertFont:fontFromSelectedText toFace:nameOfFontToConvertTo];
    
    //Put the new font in an attributes dictionary
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:alteredFont forKey:NSFontAttributeName];
    
    //Give this information to the Attributed String that the user selected to change
     [[[stageView textboxView] textStorage] setAttributes:attributes range:selectedText];

}
/*
-(NSNumber *)leadingValue
{
    if (sg.currentElement.uType == SHAPE_TEXTBOX) 
    {
        
        NSRange selectedText = [[stageView textboxView] selectedRange];
        if (selectedText.length == 0)   // is the user selecting anything?
        {                               // if not, return the leading value.
            //return leading;
        }
        
        // So we're selecting the text inside of a textBox
        //NSUInteger pointToAssessLeading = selectedText.location -1;//returns NSNotFound if empty.
        //Get the attribute dictionary for the selected text and the text to the left of the cursor
        //NSParagraphStyle *existingParagraphStyle = [[[stageView textboxView] textStorage] attribute:NSParagraphStyleAttributeName atIndex:pointToAssessLeading effectiveRange:nil];
        
        // 
        //leading = [NSNumber numberWithFloat:[existingParagraphStyle lineSpacing]];
        
    }
    return leading;
}


-(void)setLeadingValue:(NSNumber *)leadingValueReceived

// Important: 
// A paragraph style object should not be mutated after adding it to an attributed string; 
// doing so can cause your program to crash.


{
    //Get the new leading value and the text it should apply to
    CGFloat newLeadingValue = [leadingValueReceived floatValue];
    NSRange selectedText = [[stageView textboxView] selectedRange];
    NSUInteger paragraphPoint = selectedText.location -1;
    if (paragraphPoint == -1) 
    {
        paragraphPoint++;
    }
    //Get the attribute dictionary for the selected text and the text to the left of the cursor
    NSParagraphStyle *existingParagraphStyle = [[[stageView textboxView] textStorage] attribute:NSParagraphStyleAttributeName atIndex:paragraphPoint effectiveRange:nil];
    NSMutableDictionary *allAttributes = [NSMutableDictionary dictionaryWithDictionary:[[[stageView textboxView] textStorage] attributesAtIndex:paragraphPoint effectiveRange:nil]];
    // Make a deep copy of the NSParagraphStyle from the old version (see warning above) and modify the paragraph styles leading
    NSMutableParagraphStyle *newParagraphStyle = [self copyOfExistingParagraphStyle:existingParagraphStyle];
    //newParagraphStyle = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject: existingParagraphStyle]];
    [newParagraphStyle setLineSpacing:newLeadingValue];
    
    //Add the paragraph attribute to the Attributes dictionary
    [allAttributes removeObjectForKey:NSParagraphStyleAttributeName];
    [allAttributes setObject:newParagraphStyle forKey:NSParagraphStyleAttributeName];
    
    //Give this information to the Attributed String that the user selected to change
    [[[stageView textboxView] textStorage] setAttributes:allAttributes range:selectedText];
    
    //and lastly... update the instance varibale
    leading = leadingValueReceived;
}


-(void)updateLeadingMenuAsCursorChanges
{
    NSRange selectedText = [[stageView textboxView] selectedRange];
    //Get the attribute dictionary for the selected text and the text to the left of the cursor
    NSUInteger paragraphPoint = selectedText.location -1;
    if (paragraphPoint == -1) 
    {
        paragraphPoint++;
    }
    NSParagraphStyle *currentParagraphStyle = nil;
    if (selectedText.length == 0) // if no text has been selected then get the atts for the character to the left of the selection
    {
        currentParagraphStyle = [[[stageView textboxView] textStorage] attribute:NSParagraphStyleAttributeName atIndex:paragraphPoint effectiveRange:nil];
        
    }
    else //some text has been selected so get the atts from the character that is to the right of the start of the selection
    {
        currentParagraphStyle = [[[stageView textboxView] textStorage] attribute:NSParagraphStyleAttributeName atIndex:paragraphPoint+1 effectiveRange:nil];
    }
    leading = [NSNumber numberWithFloat:[currentParagraphStyle lineSpacing]];
    [self setLeadingValue:[NSNumber numberWithFloat:[currentParagraphStyle lineSpacing]]];
}


-(NSNumber *)kerningValue
{
    return kerning;
}

-(void)setKerningValue:(NSNumber *)kerningValueReceived
{
    NSLog(@"Kerning: %@", kerning);
    int difference = [kerningValueReceived intValue] - [kerning intValue];
    if ( difference > 0) 
    {
        for (int i = 0; i < difference; i++) 
        {
            [[stageView textboxView] loosenKerning:nil];
        }
    }
    else
    {
        difference = difference * -1;
        for (int i = 0; i < difference; i++) 
        {
            // we want to treat all these replacements as a single replacement for undo purposes
            //[[[stageView textboxView] textStorage] beginEditing];
            
                [[stageView textboxView] tightenKerning:nil];
            
            //[[[stageView textboxView] textStorage] endEditing];
        }

    }

    kerning = kerningValueReceived;

}

*/

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
    NSRange selectedText = [[stageView textboxView] selectedRange];
    NSValue *storingRanges = [NSValue valueWithRange:selectedText];
    NSArray *arrayOfSelections = [NSArray arrayWithObject:storingRanges];
    if ([[stageView textboxView] shouldChangeTextInRanges:arrayOfSelections replacementStrings:nil]) 
    {
        // we want to treat all these replacements as a single replacement for undo purposes
        [[[stageView textboxView] textStorage] beginEditing];
        
            [[stageView textboxView] setAlignment:alignment range:selectedText];
        
        [[[stageView textboxView] textStorage] endEditing];
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







-(IBAction)setFontTrait:(id)sender
{
    //BOOL underlineflag = NO;
    BOOL isBold = NO;
    BOOL isItaic = NO;
    //BOOL isUnderLined = NO;
    
    NSMutableDictionary *ad = [[NSMutableDictionary alloc]init];
    NSUInteger clickedSegment = [sender selectedSegment];
    NSUInteger clickedSegmentTag = [[sender cell] tagForSegment:clickedSegment];
    
    NSFontTraitMask traitToAdd;
    
    NSRange selectedText = [[stageView textboxView] selectedRange];
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    
    
    
    //Get the old font
    NSDictionary *fontAtt = [[[stageView textboxView] textStorage] fontAttributesInRange:selectedText];
    NSMutableDictionary *allAtts = [[NSMutableDictionary alloc]initWithDictionary:[[[stageView textboxView] textStorage] attributesAtIndex:selectedText.location effectiveRange:nil]];
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
    if ([[stageView textboxView] shouldChangeTextInRanges:arrayOfSelections replacementStrings:nil]) 
    {
        // we want to treat all these replacements as a single replacement for undo purposes
        [[[stageView textboxView] textStorage] beginEditing];
        
            [[[stageView textboxView] textStorage] setAttributes:allAtts range:selectedText];
        //NSStrikethroughStyleAttributeName
        
        [[[stageView textboxView] textStorage] endEditing];
    }

    
}



-(IBAction)showColorPanel:(id)sender
{
    //create the color panel
    NSColorPanel *panel = [NSColorPanel sharedColorPanel];
    [panel orderFront:nil];
}

-(void)changeColor:(id)sender
{
    sg = [[Singleton alloc]init];
    [[sg currentElement] setNeedsDisplay:YES];
}



#pragma mark -  Menu validation

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    NSLog(@"AppDelegate calling validateMenuItem: %@", menuItem);
    if ([menuItem respondsToSelector:@selector(setState:)])
    {
		if ([[menuItem title] isEqualToString:@"Alignment"]) 
        {
			[menuItem setState:((alignmentPanelVisible)? NSOnState: NSOffState)];
		}
        
        
        if ([[menuItem title] isEqualToString:@"Attributes"]) 
        {
            [menuItem setState:((attributePanelVisible)? NSOnState: NSOffState)];
            NSLog(@"called to validate");
		}
        
        
        
        if ([[menuItem title] isEqualToString:@"Delete"])
        {
            NSLog(@"disable delte menu");
            
        }
        
        if ([[menuItem title] isEqualToString:@"Copy"] )
        {
            NSLog(@"COPY DISABLED");
            return NO;
        }
        
        /*
        if ([[menuItem title] isEqualToString:@"Gridline_show_menu"])
        {
			[menuItem setState:((imagePanelVisible)? NSOnState: NSOffState)];
		}
        
        if ([[menuItem title] isEqualToString:@"Ruler_show_menu"]) 
        {
			[menuItem setState:((imagePanelVisible)? NSOnState: NSOffState)];
		}
        */
        
	}
	
    
	return YES;
    
}





#pragma mark - clicked menu item event implementation



/*
 @function:	Toggle
 @purpos:	This function called when the user click the show alignment menu item.
 The purpos is to visible/hide of the shape alignment panel.
 */
- (IBAction)togglePanelVisibility:(id)sender
{
	
    NSString *caller = [[NSString alloc]initWithString:[sender title]];
    NSLog(@"caller is : %@", caller);
    if ([caller isEqualToString:SHOW_ALIGNMENT_PANEL])
    {
        NSLog(@"Before was: %d", alignmentPanelVisible);
        alignmentPanelVisible = ~alignmentPanelVisible;
        NSLog(@"After is: %d", alignmentPanelVisible);
        
        if (alignmentPanelVisible) {
            [alignmentPanel setIsVisible:YES];
        } else {
            [alignmentPanel setIsVisible:NO];
        }

    }
    
    if ([caller isEqualToString:SHOW_ATTRIBUTES_PANEL])
    {
        NSLog(@"Before was: %d", attributePanelVisible);
        if (attributePanelVisible)
        {
            attributePanelVisible = NO;
        }
        else
        {
            attributePanelVisible = YES;
        }
        NSLog(@"After was: %d", attributePanelVisible);
        
        if (attributePanelVisible) {
            [attributePanel setIsVisible:YES];
            NSLog(@"now visible");
        } else {
            [attributePanel setIsVisible:NO];
            NSLog(@"Not visible");
        }
        
    }
    
    
        
}


- (void)InsertImageToStage:(id)sender
{
    [stageView InsertImageToStage:self];
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[[curDoc stageView] InsertImageToStage:nil];
}

/*
 @function:	OnNewDataSource
 @purpose:	This function called when the user click the new data source menu item.
 */
- (IBAction)OnNewDataSource:(id)sender
{
	DataSourceWindowController *dataSourceWindowController = [[DataSourceWindowController alloc] init];
	[dataSourceWindowController initWithDataSource:-1];
	[NSApp runModalForWindow:dataSourceWindowController.window];
}


/*
 @function: OnEditDataSource
 @purpose:	This function called when the user click the edit data source menu item.
 */
- (IBAction)OnEditDataSource:(id)sender
{
	[dataSourcePanel setIsVisible:YES];
	[dataSourcePanel initDataSource];
}

/*
 @function: showDinamicFontTab
 @purpose:	This function add new tab dinamically with parameter view to attribute panel.
 @params:	view : font view in new tab
 */
- (void)showDinamicFontTab:(NSView *)view
{
	NSTabViewItem *item = [attributePanel._tabView tabViewItemAtIndex:3];
	[item setView:view];
	
	[attributePanel._tabView selectTabViewItem:item];
}

/*
 @function: hideDinamicFontTab
 @purpose:	This function remove font tab from attribute panel.
 */
- (void)hideDinamicFontTab
{
	NSTabViewItem *item = [attributePanel._tabView tabViewItemAtIndex:3];
	[attributePanel._tabView removeTabViewItem:item];
	
	item = [[NSTabViewItem alloc] init];
	[item setLabel:@"Contextual"];
	[attributePanel._tabView addTabViewItem:item];
}



#pragma mark - Builder methods

-(IBAction)showBuilderScreen:(id)sender
{
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    [[curDoc stageView] DeselectAllShaps];
    [curDoc showBuilderScreen];
}
@end
