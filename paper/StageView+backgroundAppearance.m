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

- (void)changeStageBackgroundColor:(id)sender
{
    NSLog(@"%@", [sender color]);
    self.stageBackgroundColor = [[sender color] colorUsingColorSpaceName:NSDeviceRGBColorSpace];
    [self setHexValueForStageColor:self.stageBackgroundColor];
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

-(void)hexValueForStageColor
{
    NSLog(@"GET hex VALUE ");
}

-(void)setHexValueForStageColor:(id)sender
{
    // receives an NSColor and places the hex equiv into the stageBackground colour field
    NSLog(@"SET hex VALUE %@ ", sender);
    NSString *theHex = [self hsla:sender];
    [[self stageBackgroundColorAsHex] setStringValue:theHex];
}

-(void)updateStageViewBackgroundColorWithHex:(id)sender
{
    // This method converts a hex string into an NSColor
    
    NSString *inColorString = [sender stringValue];
    
    if (!inColorString)
        return;
    
    NSLog(@"hex string received : %@", inColorString);
    NSColor* result = nil;
    unsigned colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        NSLog(@"Scanner object : %@", scanner);
        BOOL ans = [scanner scanHexInt:&colorCode]; // ignore error
        NSLog(@"THIS SHOULD WORK NOW : %i", ans);
    }
    NSLog(@"Color Code is :%i", colorCode);
    redByte = (unsigned char)(colorCode >> 16);
    greenByte = (unsigned char)(colorCode >> 8);
    blueByte = (unsigned char)(colorCode); // masks off high bits
    result = [NSColor colorWithCalibratedRed:(CGFloat)redByte / 0xff green:(CGFloat)greenByte / 0xff blue:(CGFloat)blueByte / 0xff alpha:1.0];
    NSLog(@"Color we got: %@", result);
    
    result = [self colorWithHexString:[inColorString stringByReplacingOccurrencesOfString:@"#" withString:@""]];
    self.stageBackgroundColor = result;
    [self setNeedsDisplay:YES];
    
}

- (NSColor *)colorWithHexString:(NSString *)hexString {
    
	/* convert the string into a int */
	unsigned int colorValueR,colorValueG,colorValueB,colorValueA;
	NSString *hexStringCleared = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
	if(hexStringCleared.length == 3) {
		/* short color form */
		/* im lazy, maybe you have a better idea to convert from #fff to #ffffff */
		hexStringCleared = [NSString stringWithFormat:@"%@%@%@%@%@%@", [hexStringCleared substringWithRange:NSMakeRange(0, 1)],[hexStringCleared substringWithRange:NSMakeRange(0, 1)],
                            [hexStringCleared substringWithRange:NSMakeRange(1, 1)],[hexStringCleared substringWithRange:NSMakeRange(1, 1)],
                            [hexStringCleared substringWithRange:NSMakeRange(2, 1)],[hexStringCleared substringWithRange:NSMakeRange(2, 1)]];
	}
	if(hexStringCleared.length == 6) {
		hexStringCleared = [hexStringCleared stringByAppendingString:@"ff"];
	}
    
	/* im in hurry ;) */
	NSString *red = [hexStringCleared substringWithRange:NSMakeRange(0, 2)];
	NSString *green = [hexStringCleared substringWithRange:NSMakeRange(2, 2)];
	NSString *blue = [hexStringCleared substringWithRange:NSMakeRange(4, 2)];
	NSString *alpha = [hexStringCleared substringWithRange:NSMakeRange(6, 2)];
    
	[[NSScanner scannerWithString:red] scanHexInt:&colorValueR];
	[[NSScanner scannerWithString:green] scanHexInt:&colorValueG];
	[[NSScanner scannerWithString:blue] scanHexInt:&colorValueB];
	[[NSScanner scannerWithString:alpha] scanHexInt:&colorValueA];
    
    
	return [NSColor colorWithCalibratedRed:((colorValueR)&0xFF)/255.0
                                     green:((colorValueG)&0xFF)/255.0
                                      blue:((colorValueB)&0xFF)/255.0
                                     alpha:((colorValueA)&0xFF)/255.0];
    
    
}


@end
