#import "StageTextView.h"
#import "Singleton.h"
#import "AppDelegate.h"
#import "Document.h"

@implementation StageTextView

@synthesize kerning;
@synthesize leading;

-(id)init
{
    //self.delegate = self;
    
    [self setKerning:0.0];
    [self setLeading:0.0]; 
    
    return self;
}


#pragma mark - FONT COLOR METHODS
-(NSColor*)fontColor
{
    
    NSColor *color = [NSColor blackColor]; // NSNotFound
        
    if ([self selectedRange].location == NSNotFound)
    {
        //NSRange totalRange = NSMakeRange (0, [[self textStorage]length]);
        
        NSLog(@"No range was selected");
        // Test if any text is selected, if so get the selected text and set its color
        NSRange selectedRange = [self selectedRange];
        NSUInteger cursorAt = [self selectedRange].location - 1;
        if (readyToTakeFontColor == YES ) //if text is selecetd
        {
            cursorAt++;
            NSLog(@"first");
        }
        if (cursorAt == -1) 
        {
            cursorAt++;
            NSLog(@"second");
        }
        NSMutableAttributedString *textJustEdited = [[NSMutableAttributedString alloc]initWithAttributedString:[[self textStorage]attributedSubstringFromRange:selectedRange]];
        NSMutableDictionary *atts = [NSMutableDictionary dictionaryWithDictionary:[textJustEdited attributesAtIndex:cursorAt effectiveRange:nil]];
        color = [atts objectForKey:NSForegroundColorAttributeName];

    }
         
    return color;
}

-(void)setFontColor:(id)sender
{
    NSLog(@"SETFONTCOLOR being called");
    NSColor *color = sender;
    NSRange selectedRange = [self selectedRange]; //NSMakeRange (0, [[self textStorage]length]);
    NSUInteger cursorAt = selectedRange.location - 1;
    if (readyToTakeFontColor == YES ) //if text is selecetd
    {
        cursorAt++;
    }
    if (cursorAt == -1) 
    {
        cursorAt++;
    }

    NSMutableAttributedString *textJustEdited = [[NSMutableAttributedString alloc]initWithAttributedString:[[self textStorage]attributedSubstringFromRange:selectedRange]];

    
    NSMutableDictionary *atts = [NSMutableDictionary dictionaryWithDictionary:[textJustEdited attributesAtIndex:0 effectiveRange:nil]];
    
    //[atts removeObjectForKey:NSForegroundColorAttributeName]; // the next line overides existing key anyway.
    [atts setObject:color forKey:NSForegroundColorAttributeName];
    [[self textStorage] setAttributes:atts range:selectedRange];
    [super setNeedsDisplay:YES];
}



#pragma mark - FONT SIZE METHODS

-(NSNumber *)fontSize
{
    NSNumber *fontSize = nil;
    if (readyToTakeFontColor == YES)
    {
        //NSRange totalRange = NSMakeRange (0, [[self textStorage]length]);
        
        
        // Test if any text is selected, if so get the selected text and set its color
        NSRange selectedRange = [self selectedRange];
        NSUInteger cursorAt = [self selectedRange].location - 1;
        if (readyToTakeFontColor == YES ) //if text is selecetd
        {
            cursorAt++;
        }
        if (cursorAt == -1) 
        {
            cursorAt++;
        }
        NSMutableAttributedString *textJustEdited = [[NSMutableAttributedString alloc]initWithAttributedString:[[self textStorage]attributedSubstringFromRange:selectedRange]];
        NSMutableDictionary *atts = [NSMutableDictionary dictionaryWithDictionary:[textJustEdited attributesAtIndex:cursorAt effectiveRange:nil]];
        NSFont *theFont = [atts objectForKey:NSFontAttributeName];
        fontSize = [NSNumber numberWithFloat:[theFont pointSize]];
        
    }
    
    
    return fontSize;
}


-(void)setFontSize:(id)sender
{
    
    NSLog(@"setting font to : %@", sender);
    NSRange selectedRange = [self selectedRange]; //NSMakeRange (0, [[self textStorage]length]);
    NSUInteger cursorAt = selectedRange.location - 1;
    if (readyToTakeFontColor == YES ) //if text is selecetd
    {
        cursorAt++;
    }
    if (cursorAt == -1) 
    {
        cursorAt++;
    }
    
    NSMutableAttributedString *textJustEdited = [[NSMutableAttributedString alloc]initWithAttributedString:[[self textStorage]attributedSubstringFromRange:selectedRange]];
    
    NSMutableDictionary *atts = [NSMutableDictionary dictionaryWithDictionary:[textJustEdited attributesAtIndex:0 effectiveRange:nil]];
    NSFont *theFont = [atts objectForKey:NSFontAttributeName];
    NSFontManager *fm = [NSFontManager sharedFontManager];
    NSFont *convertedFont = [fm convertFont:theFont toSize:[sender floatValue]];
    
    [atts removeObjectForKey:NSFontAttributeName];
    [atts setObject:convertedFont forKey:NSFontAttributeName];
    [[self textStorage] setAttributes:atts range:selectedRange];
    [self setNeedsDisplay:YES];
    NSLog(@"exiting set font size");
    
    [self placeTextFromStageTextViewIntoElement];
    

}


#pragma mark - TEXTVIEW DELEGATE METHODS
/*
- (void)textDidChange:(NSNotification *)pNotification //called whenever the text or its attributes are changed.
{
	NSLog(@"text did change");
    [self setNeedsDisplay:YES];
}
*/

-(void)placeTextFromStageTextViewIntoElement
{
    NSRange totalRange = NSMakeRange (0, [[self textStorage]length]);
    NSMutableAttributedString *textJustEdited = [[NSMutableAttributedString alloc]initWithAttributedString:[[self textStorage]attributedSubstringFromRange:totalRange]];
    Singleton *sg = [[Singleton alloc]init];
    sg.currentElement.contentText = textJustEdited;
    
    [self postNotificationToClearKerningLeading];
    
    [self setNeedsDisplay:YES];
    readyToTakeFontColor = NO;
    NSLog(@"Called from textDidEndEditing in StageTextView");
}


-(void)textDidEndEditing:(NSNotification *)notification
{
    [self placeTextFromStageTextViewIntoElement];

}

-(void)textViewDidChangeSelection:(NSNotification *)notification
{
	// Called whenever the cursor is moved within the stageTextView
    
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    readyToTakeFontColor = YES;
	
    // Get where the cursor is
	NSRange totalRange = [self selectedRange];
    NSAttributedString *selectedText;

    if (totalRange.length) {
		selectedText = [[self textStorage] attributedSubstringFromRange:totalRange];
        [self showTextPopOver:selectedText isSelectedText:NO];
    }
	
	if ([self.attributedString length] == 0) {
		return;
	}
    
    NSMutableAttributedString *textJustEdited = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedString];
    NSInteger cursorAt = [self selectedRange].location - 1; //so we get the attribute of the character to the left not right of the cursor
    if ([self selectedRange].length > 0 ) //if text is selecetd
    {
        cursorAt++;
    }
    if (cursorAt == -1) // You can't have this if the cursor is an NSUInteger
    {
        cursorAt++;
    }
    
    NSDictionary *atts = [textJustEdited attributesAtIndex:cursorAt effectiveRange:NULL];
    
    CGFloat k = [[atts objectForKey:NSKernAttributeName] floatValue];
    NSNumber *kNumber = [NSNumber numberWithFloat:k];
    
    CGFloat l = [[atts objectForKey:NSParagraphStyleAttributeName] lineSpacing];
    NSNumber *lNumber = [NSNumber numberWithFloat:l];
    
    
    //[self postNotificationToRedraw];
    
    
    [self setKerning:k];
    [self setLeading:l];
    //NSLog(@"Leading is: %f", leading);
    //NSLog(@"Kerning is: %f", kerning);
    
    [[NSApp delegate] setKerningValue:kNumber];
    [[NSApp delegate] setLeadingValue:lNumber];
    
    //Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    [[curDoc stageView] updateCustomFontMenu:atts];
    
    NSLog(@"TEXT SELECTION JUST CHANGED IN THE STAGE-TEXT-VIEW");
    
    
}

-(void)showTextPopOver: (NSAttributedString *)attString isSelectedText:(BOOL)selected
{
    NSLog(@"Trying to show the popover");
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    
    NSSize sizeOfSelectedText = [attString size];
    
    NSRect boundingRectOfSelectedText = [attString boundingRectWithSize:sizeOfSelectedText options:NSStringDrawingUsesDeviceMetrics];
    
    NSLog(@"Size is : %@", NSStringFromSize(sizeOfSelectedText));
    NSLog(@"... %@", NSStringFromRect(boundingRectOfSelectedText));
    
    
    NSRange activeRange = [[self layoutManager] glyphRangeForCharacterRange:self.selectedRange actualCharacterRange:NULL];
    NSRect neededRect = [[self layoutManager] boundingRectForGlyphRange:activeRange inTextContainer:[self textContainer]];
    NSPoint containerOrigin = [self textContainerOrigin];
    
    neededRect.origin.x += containerOrigin.x;
    neededRect.origin.y += containerOrigin.y;
    
    neededRect = [[self superview] convertRect:neededRect fromView:self];
    
    
	if (selected == NO) {
		[[curDoc stageView] showFontTab];
	} else { // it is not called
		
		if ([[[curDoc stageView] textPopover] isShown] == YES)
		{
			//NSLog(@"GOT : %@", documentSettingsPopover.contentViewController.)
			[[[curDoc stageView] textPopover] performClose:self];
			[self setNeedsDisplay:YES];
		}
		else
		{
			[[[curDoc stageView] textPopover] showRelativeToRect:neededRect ofView:self.superview preferredEdge:NSMinYEdge];
		}
	}
}

-(void)postNotificationToClearKerningLeading
{
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:UPDATE_KERNING_TEXTFIELD 
     object:self
     userInfo:nil];
}

#pragma mark - SELECT THE WORD UNDER THE MOUSE
- (void)selectWordUnderMouse:(NSEvent *)theEvent {
    
    
    NSLayoutManager *layoutManager = [self layoutManager];
    NSTextContainer *textContainer = [self textContainer];
    NSUInteger glyphIndex, charIndex, textLength = [[self textStorage] length];
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSRange lineGlyphRange, lineCharRange, wordCharRange = NSMakeRange(0, textLength);
    NSRect glyphRect;
    
    // Remove any existing coloring.
    //[layoutManager removeTemporaryAttribute:NSBackgroundColorAttributeName forCharacterRange:textCharRange];

    // Convert view coordinates to container coordinates
    point.x -= [self textContainerOrigin].x;
    point.y -= [self textContainerOrigin].y;
    
    // Convert those coordinates to the nearest glyph index
    glyphIndex = [layoutManager glyphIndexForPoint:point inTextContainer:textContainer];
    
    // Check to see whether the mouse actually lies over the glyph it is nearest to
    glyphRect = [layoutManager boundingRectForGlyphRange:NSMakeRange(glyphIndex, 1) inTextContainer:textContainer];
    NSLog(@"THE RECT COORDINATES ARE : %@", NSStringFromRect(glyphRect));
    if (NSPointInRect(point, glyphRect)) {
        
        // Convert the glyph index to a character index
        charIndex = [layoutManager characterIndexForGlyphAtIndex:glyphIndex];
        
        // Determine the range of glyphs, and of characters, in the corresponding line
        (void)[layoutManager lineFragmentRectForGlyphAtIndex:glyphIndex effectiveRange:&lineGlyphRange];
        lineCharRange = [layoutManager characterRangeForGlyphRange:lineGlyphRange actualGlyphRange:NULL];
        
        // Determine the word containing that character
        wordCharRange = NSIntersectionRange(lineCharRange, [self selectionRangeForProposedRange:NSMakeRange(charIndex, 0) granularity:NSSelectByWord]);
        
        // Color the characters using temporary attributes
        [self setSelectedRange:wordCharRange];
        
        NSLog(@"Just selected my words");
        /*
        [layoutManager addTemporaryAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSColor cyanColor], NSBackgroundColorAttributeName, nil] forCharacterRange:lineCharRange];
        [layoutManager addTemporaryAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSColor yellowColor], NSBackgroundColorAttributeName, nil] forCharacterRange:wordCharRange];
        [layoutManager addTemporaryAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSColor magentaColor], NSBackgroundColorAttributeName, nil] forCharacterRange:NSMakeRange(charIndex, 1)];
         */
    }
}
@end
