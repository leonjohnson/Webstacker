#import "Element.h"
#import "Singleton.h"
#import "AppDelegate.h"
#import "Document.h"

#define NSColorFromRGB(rgbValue) [NSColor \
colorWithCalibratedRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface Element (privateMethods)
+(NSArray *) borderOrder;
+(NSArray *) radiusOrder;
+(NSArray *) opacityTypeToDealWith;
@end

@implementation Element (ElementAttributes)

/******************************* Class Methods *******************************/
+(NSArray *)borderOrder
{
    static NSArray *order = nil;
    if (!order) 
    {
        order = [[NSArray alloc] initWithObjects:@"top", @"right", @"bottom", @"left", @"all", nil];
    }
    return order;
}

+(NSArray *)radiusOrder
{
    static NSArray *order = nil;
    if (!order) 
    {
        order = [[NSArray alloc] initWithObjects:@"all", @"top-left", @"top-right", @"bottom-left", @"bottom-right", nil];
    }
    return order;
}

+(NSArray *)opacityTypeToDealWith
{
    static NSArray *order = nil;
    if (!order) 
    {
        order = [[NSArray alloc] initWithObjects:@"all", @"border", @"body", nil];
    }
    return order;
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



/******************************* Instance Methods *******************************/

-(void)postNotificationToRedraw
{
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:REDRAW_ELEMENT_NOTIFICATION 
     object:self
     userInfo:nil];
}


-(NSString *)buttonString
{
    return [contentText string];
    
    
}

- (void)setButtonString:(NSString *)txt
{
	/*
     if (text) {
     [text release];
     text = nil;
     }
     
     text = [[NSString alloc] initWithString:txt];
     [self setNeedsDisplay:YES];
     */
    NSLog(@"setting the button string");
    contentText = [[NSMutableAttributedString alloc] initWithString:txt];
    
}






-(NSNumber *)borderColor
{
    return [NSNumber numberWithInt:1];
}



-(NSNumber *)borderStyle
{
    return [NSNumber numberWithInt:1];
}

-(void)setborderStyle:(NSNumber *)borderStyle
{
    
}


-(void)setBackgroundAttributes:(NSDictionary *)backgroundAttributes
{
    Singleton *sg = [[Singleton alloc]init];
    [[sg currentElement] setBackgroundAttributes:backgroundAttributes];
    
    //(NSImage*)image :(NSString*)color :(NSString*)repeatX :(NSString*)repeatY;
}


-(void)setFloatAttribute:(NSString *)floatAttribute
{
    Singleton *sg = [[Singleton alloc]init];
    [[sg currentElement] setFloatAttribute:floatAttribute];
    
}

-(void)setColorAttributes:(id)sender
{
    
    // Just save the color to the ivar.
    NSLog(@"Attempting to set color attributes");
    NSColor *colorReceived = sender;
    NSLog(@"color received : %@", colorReceived);
    colorAttributes = [NSColor new];
    [colorAttributes retain];
    NSLog(@"colorattributes = %@", colorAttributes);
    colorAttributes = colorReceived;
    NSLog(@"Attempting to set color attributes 2");
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    NSLog(@"Attempting to set color attributes 3");
    //NSLog(@"STAGE VIEW IS INITIALISED ??? : %@", [curDoc stageView]);
    //NSLog(@"color got back is : %@", [[curDoc stageView] hsla:colorReceived]);
    //[[[NSApp delegate]colorHexValue] setStringValue:[[curDoc stageView] hsla:colorReceived]];
    NSLog(@"Attempting to set color attributes 4");
    [self setNeedsDisplay:YES];
}

-(void)setColorAttributesWithHexString:(id)sender
{
    // This method converts a hex string into an NSColor
    
    NSString *inColorString = sender;
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

    //NSLog(@"Check out : %@", );
    //[[NSApp delegate]pl]setColor:[self colorWithHexString:[inColorString stringByReplacingOccurrencesOfString:@"#" withString:@""]]];
     [self setColorAttributes:result];
    
}

-(NSString *)colorAttributesWithHexString
{
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    NSString *hexString = [[curDoc stageView] hsla:colorAttributes];
    return hexString;
}



#pragma mark - Opacity
-(NSNumber *)opacity
{
    // Equals: All, body, or border.
    
    NSString *changeTheOpacityOf = [[[self class] opacityTypeToDealWith] objectAtIndex:[opacityTypeSelected unsignedIntValue]];
    NSNumber *theOpacity = [opacity objectForKey:changeTheOpacityOf];
    return theOpacity;
    
}




-(void)setOpacity:(NSNumber *)opacityValue
{
    
    NSString *fullKeyPath = [[[self class] opacityTypeToDealWith] objectAtIndex:[opacityTypeSelected unsignedIntValue]];
    [opacity setValue:opacityValue forKey:fullKeyPath];
    if ([fullKeyPath isEqualToString: @"all"])
    {
        NSLog(@"we got all sent through.");
        [opacity setValue:opacityValue forKey:@"all"];
        [opacity setValue:opacityValue forKey:@"border"];
        [opacity setValue:opacityValue forKey:@"body"];
    }
    else
    {
        [opacity setValue:opacityValue forKey:fullKeyPath];
    }
    
}

-(void)setElementid:(NSMutableString *)eleid
{
    //do some validation
    NSLog(@"gonna do some validation : %@", eleid);
    
    //TODO: Find out why curDoc is nil.
    // 1. check its unique
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    
    if (curDoc != nil)
    {
        NSLog(@"CURdOC is : %@", curDoc);
        NSLog(@"stageview initiated - %@", [curDoc stageView]);
        NSLog(@"!!@ The element array contains : %@", [[curDoc stageView] elementArray]);
        BOOL isUnique = [[curDoc stageView] isElementIDUnique:eleid];
        NSLog(@"isUnique equals %c", isUnique);
        if (isUnique == NO)
        {
            NSLog(@"vali 5");
            elementid =[NSMutableString stringWithString:@""];
            [[[NSApp delegate] labelWarningField]setHidden:NO];
            if (elementTag)
            {
                [[[NSApp delegate] elementidField]setStringValue:elementTag];
            }
            
            return;
        }
        
        // 2. Remove spaces, symbols except hypens
        NSRange whiteSpaceRange = [eleid rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
        NSRange symbolRange = [eleid rangeOfCharacterFromSet:[NSCharacterSet symbolCharacterSet]];
        if (whiteSpaceRange.location != NSNotFound || symbolRange.location != NSNotFound)
        {
            NSLog(@"Found whitespace or a symbol. ");
            elementid =[NSMutableString stringWithString:elementTag];
            [[[NSApp delegate] labelWarningField]setHidden:NO];
            [[[NSApp delegate] elementidField]setStringValue:elementTag];
            return;
        }
        
        // 3. Can't begin with a keyword including 'element' but also button,p, etc
        NSArray *keywords = [NSArray arrayWithObjects:@"button", nil];
        for (NSString *word in keywords)
        {
            if ([eleid isEqualToString:word])
            {
                NSLog(@"vali 3");
                elementid =[NSMutableString stringWithString:elementTag];
                [[[NSApp delegate] labelWarningField]setHidden:NO];
                [[[NSApp delegate] elementidField]setStringValue:elementTag];
                return;
            }
        }
        
        
        // 4. Between 3 and 16 characters
        if ( ([eleid length] < 3) || ([eleid length] > 15) )
        {
            NSLog(@"Lenth = %lu", eleid.length);
            NSLog(@"integer value = %lu", eleid.integerValue);
            
            if ( ([eleid length] < 3) & ([eleid integerValue] != 0))
            {
                //
            }
            else
            {
                NSLog(@"vali 4");
                elementid =[NSMutableString stringWithString:elementTag];
                [[[NSApp delegate] labelWarningField]setHidden:NO];
                [[[NSApp delegate] elementidField]setStringValue:elementTag];
                return;
            }
            
        }

    }
    
    
    //home free, the id label eneterd has passed all of the above tests so we can now save it :-)
    elementid = eleid;
    
    //Upldate the layers panel;
    [[curDoc stageView] ResortLayer];
    
    
    // and hide the warning label
    [[[NSApp delegate] labelWarningField]setHidden:YES];
    
}






//## UNDEFINED KVC METHODS###
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"CALLINF setValueFoRUndefinedKey. Key : %@", key);
}

-(void)setElementSize:(NSSize *)size{};
-(void)setdisplayType:(NSString *)displayType{};
-(void)setlinkAttributes:(NSMutableDictionary *)link{};
//-(void)setRtFrame:(NSRect)rtFrame{};
@end
