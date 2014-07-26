#import "TextBox.h"
#import "Singleton.h"

@implementation TextBox


//@synthesize text;
@synthesize isEditing;

@synthesize text2Style, bodyCopy, headerWhiteStyle, headerBlackStyle, customTextStyles, choosenStyle;


- (id)init
{
	self = [super init];

	if (self) {
		isEditing = TRUE;
		contentText = [[NSMutableAttributedString alloc]initWithString:@""];
        text2Style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        bodyCopy = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  [NSFont fontWithName: @"Helvetica Neue Light" size: 14], NSFontAttributeName,
                                  [NSColor grayColor], NSForegroundColorAttributeName,
                                  text2Style, NSParagraphStyleAttributeName, nil];
        
        headerWhiteStyle = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     [NSFont fontWithName: @"Helvetica Neue Bold" size: 36], NSFontAttributeName,
                                     [NSColor whiteColor], NSForegroundColorAttributeName,
                                     text2Style, NSParagraphStyleAttributeName, nil];
        
        
        headerBlackStyle = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     [NSFont fontWithName: @"Helvetica Neue Bold" size: 36], NSFontAttributeName,
                                     [NSColor blackColor], NSForegroundColorAttributeName,
                                     text2Style, NSParagraphStyleAttributeName, nil];
	}
	
	return self;
}


- (void)dealloc
{
	if (contentText) {
		contentText = nil;
	}
	
}


/*
 @function:		setBoundRect
 @params:		rt:   triangle's bound rect
 @return:       void
 @purpose:		Set the triangle's bound rect "rtFrame" to rt.
 */
- (void)setBoundRect:(NSRect)rt
{
	rtFrame = CGRectStandardize(rt);
    [self setFrame:CGRectMake(rtFrame.origin.x - 2, rtFrame.origin.y - 2, rtFrame.size.width + 8, rtFrame.size.height + 8)];
	[self setNeedsDisplay:YES];
    
}


/*
 @function:		setText
 @params:		txt:		text to draw
 @return:		void
 @purpose:		This function is to set the text to draw and redraw.
 */
- (void)setText:(NSAttributedString *)txt //Called when finish editing textview.
{
	if (contentText) {
		contentText = nil;
	}
	
	contentText = [[NSMutableAttributedString alloc]initWithAttributedString:txt];
	[self setNeedsDisplay:YES];
}


- (NSInteger)IsPointInElement:(NSPoint)pt
{
	NSBezierPath* path = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(2, 2, rtFrame.size.width, rtFrame.size.height)];
	
	if ([path containsPoint:pt] == YES) {
		return SHT_PTINELEMENT;
	}
	
	return SHT_NONE;
}



/*
 @function:		DrawShape
 @params:		context:   Graphics context reference
 @return:       void
 @purpose:		Draw the triangle in rtFrame rectangle area.
 */
- (void)DrawShape:(CGContextRef)context
{
    
    //CGFloat lengths[2] = {9.0, 6.0};
    //CGContextSetLineDash(context, 0., lengths, 2);
    //CGContextSetLineWidth(context, 0.5);
    //CGContextSetLineWidth(context, [[[border objectForKey:@"all"] objectForKey:@"width"] floatValue]);
    
    
    //CGContextSetRGBStrokeColor( context, 0.05, 0.05, 0.05, 1.0 );
	//CGContextStrokeRect( context, CGRectMake(2, 2, rtFrame.size.width, rtFrame.size.height) );
    
    
    NSRect rectangleFrame = NSMakeRect(2, 2, rtFrame.size.width, rtFrame.size.height);
    
    NSBezierPath *rectanglePath = [NSBezierPath bezierPathWithRect:rectangleFrame];
        
        
	if (isSelected == YES) {
		[self DrawBorderFrame:context];
	}
	
	//[[NSColor blueColor] set];
	//[[NSFont fontWithName:@"Helvetica" size:44] set];
    
    
    Singleton *sg = [[Singleton alloc]init];
    [[sg lastSelectedFont] set]; 
    
    [text2Style setAlignment: NSLeftTextAlignment];
	
    
	if (self.isPtInElement == YES) { // highlight shape when the mouse is over the shape.
		CGContextSetRGBStrokeColor(context, 0.34, 0.4, 0.9, 1.0);
        NSLog(@"first textbox hover");
	}
    
    
    if (self.isPtInElement == YES) { // highlight shape when the mouse is over the shape.
        NSLog(@"mouse in");
		[self.elementHighlightColor set];
		if ([borderWidth floatValue] == 0) {
			[rectanglePath setLineWidth:1.0f];
			[rectanglePath stroke];
		}
	}
    
    
    [contentText drawInRect:CGRectMake(5, 0, rtFrame.size.width - 10, rtFrame.size.height)];
}


/*
 When the view is redraw, draw the rectangle shape view
 */
- (void)drawRect:(NSRect)dirtyRect
{
    NSGraphicsContext *tvarNSGraphicsContext = [NSGraphicsContext currentContext];
	CGContextRef ctx = (CGContextRef) [tvarNSGraphicsContext graphicsPort];
    [self DrawShape:ctx];
}


@end
