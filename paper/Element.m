#import "Element.h"
#import "Box.h"
#import "Circle.h"
#import "DropDown.h"
#import "Triangle.h"
#import "TextBox.h"
#import "Button.h"
#import "Singleton.h"
#import "Image.h"
#import "TextInputField.h"
#import "Document.h"
#import "AppDelegate.h"
#import "StageView.h"
#import "DynamicRow.h"
#import "DynamicImage.h"
#import "Container.h"

@implementation Element


@synthesize insideOperationElement;
@synthesize elementid;
@synthesize uType, isSelected, rtFrame, color, colorAttributes, contentURL;
@synthesize borderWidth;
@synthesize border;
@synthesize borderRadius;
@synthesize opacity;
@synthesize opacityTypeSelected;
@synthesize spanGrouping;
@synthesize imgName;
@synthesize contentText;
@synthesize isUnderneathOtherElement;
@synthesize elementTag;
@synthesize elementsAboveMe;
@synthesize buttonText;
@synthesize isPtInElement;

@synthesize topLeftBorderRadius, topRightBorderRadius, bottomLeftBorderRadius, bottomRightBorderRadius;

@synthesize width_as_percentage, height_as_percentage, layoutType;
@synthesize actionStringEntered, dataSourceStringEntered;
@synthesize arrayShadows;





- (void)dealloc
{
	free( handleArray );
	
	[super dealloc];
}

+(void)initialize
{
    
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        //TODO SET THESE VARIABLES USING VALUE FOR KEY NOT DIRECTLY ACCESSING IVARS AS BELOW.
        //padding = [NSNumber numberWithInt:4];
        
        isUnderneathOtherElement = NO;
        spanGrouping = @"";
        
        borderWidth = [NSNumber numberWithInt:0];
        borderRadius = [NSNumber numberWithInt:0];

        
        bottomRightBorderRadius = bottomLeftBorderRadius = topLeftBorderRadius = topRightBorderRadius = NO;
        
        opacity = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithInt:0], @"all",
                   [NSNumber numberWithInt:0], @"border",
                   [NSNumber numberWithInt:0], @"body",
                   nil];
        layoutType = PIXEL_BASED_LAYOUT;
        
    }
    
    //[self setWantsLayer:YES];
    return self;
}


/*
 @function:		createShape
 @params:		type:   shape type to create shape class
 @return:       create successfully, returns shape class object. Otherwise, returns nil.
 @purpose:		Create and return new geometry class object from type.
 */
+ (Element *)createElement:(ElementType)type
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    
    Element *shape;
	
	switch (type) {
		case SHAPE_CIRCLE:
			shape = [[Circle alloc] init];
            NSLog(@"Creating a circle");
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
			break;
			
		case SHAPE_RECTANGLE:
			shape = [[Box alloc] init];
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
            NSLog(@"Creating a rect");
			break;
			
		case SHAPE_TRIANGLE:
			shape = [[Triangle alloc] init];
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
            NSLog(@"Creating a triangle");
			break;
			
		case SHAPE_TEXTBOX:
			shape = [[TextBox alloc] init];
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
            break;
            
        case SHAPE_BUTTON:
			shape = [[Button alloc] init];
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
            [[NSApp delegate] showButtonPanel];
            break;
            
        case SHAPE_IMAGE:
			shape = [[Image alloc] init];
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
            break;
            
        case SHAPE_TEXTFIELD:
			shape = [[TextInputField alloc] init];
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
            break;
        case SHAPE_DROPDOWN:
			shape = [[DropDown alloc] init];
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
            break;
            
        case SHAPE_PLACEHOLDER_IMAGE:
			shape = [[DynamicImage alloc] init];
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
            break;
        
        case SHAPE_DYNAMIC_ROW:
			shape = [[DynamicRow alloc] init];
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
            break;
			
		case SHAPE_CONTAINER:
			shape = [[Container alloc] init];
			[[curDoc stageView] setElementBeenDroppedToStage:YES];
			break;
			
	}
	
	if (shape) {
		shape.uType = type;
	}
	shape.isSelected = FALSE;
	shape.arrayShadows = nil;
	
	return shape;
}

-(void)DrawElement:(CGContextRef)context
{
    
}
/*
 @function:		setBoundRect
 @params:		rt:   shape's bound rect
 @return:       void
 @purpose:		It's abstract function. Function's body definitions are implemented at every shape classes.
 Set the shape's bound rect "rtFrame" to rt.
 */
- (void)setBoundRect:(NSRect)rt
{
    rtFrame = CGRectStandardize(rt);
    [self setFrame:CGRectMake(rtFrame.origin.x - 2, rtFrame.origin.y - 6, rtFrame.size.width + 8, rtFrame.size.height + 8)];
	[self setNeedsDisplay:YES];
}


#pragma mark - shadow operation implementation

#pragma mark - shape operation implementation

/*
 @function:		setShadowOfShape
 @params:		angle:		shadow angle
 dist:		shadow distance
 r, g, b, alpha: color property of shadow
 direct:		shadow direction, if it's YES, outset. otherwise inset.
 index:		index of shadow in shadow list
 @return:		void
 @purpose:		This function draws the shadow of shape with params.
 */
- (void)setShadowOfShape:(CGFloat)angle distance:(CGFloat)dist colorR:(CGFloat)r colorG:(CGFloat)g colorB:(CGFloat)b opacity:(CGFloat)alpha Blur:(CGFloat)blur direct:(BOOL)d Index:(NSInteger)index
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	[dict setValue:[NSNumber numberWithBool:d] forKey:@"Direction"];
	[dict setValue:[NSNumber numberWithFloat:angle] forKey:@"Angle"];
	[dict setValue:[NSNumber numberWithFloat:dist] forKey:@"Distance"];
	[dict setValue:[NSNumber numberWithFloat:r] forKey:@"RColor"];
	[dict setValue:[NSNumber numberWithFloat:g] forKey:@"GColor"];
	[dict setValue:[NSNumber numberWithFloat:b] forKey:@"BColor"];
	[dict setValue:[NSNumber numberWithFloat:alpha] forKey:@"Opacity"];
	[dict setValue:[NSNumber numberWithFloat:blur] forKey:@"Blur"];
	
	[arrayShadows replaceObjectAtIndex:index withObject:dict];
	
	[self setNeedsDisplay:YES];
}


/*
 @function:		addShapeShadow
 @params:		angle:		shadow angle
 dist:		shadow distance
 r, g, b, alpha: color property of shadow
 direct:		shadow direction, if it's YES, outset. otherwise inset.
 @return:		void
 @purpose:		This function add the new shadow to current shape
 */
- (void)addShapeShadow:(CGFloat)angle Distance:(CGFloat)dist ColorR:(CGFloat)r ColorG:(CGFloat)g ColorB:(CGFloat)b Opacity:(CGFloat)alpha Blur:(CGFloat)blur Direction:(BOOL)d
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	
	[dict setValue:[NSNumber numberWithBool:d] forKey:@"Direction"];
	[dict setValue:[NSNumber numberWithFloat:angle] forKey:@"Angle"];
	[dict setValue:[NSNumber numberWithFloat:dist] forKey:@"Distance"];
	[dict setValue:[NSNumber numberWithFloat:r] forKey:@"RColor"];
	[dict setValue:[NSNumber numberWithFloat:g] forKey:@"GColor"];
	[dict setValue:[NSNumber numberWithFloat:b] forKey:@"BColor"];
	[dict setValue:[NSNumber numberWithFloat:alpha] forKey:@"Opacity"];
	[dict setValue:[NSNumber numberWithFloat:blur] forKey:@"Blur"];
	
	if (arrayShadows == nil) {
		arrayShadows = [[NSMutableArray alloc] init];
	}
	
	[arrayShadows addObject:dict];
	NSLog(@"done added shadows");
	[self setNeedsDisplay:YES];
}


/*
 @function:		removeShapeShadow
 @params:		index:		index of shadow in shadow list
 @return:		void
 @purpose:		This function remove the shape shadow from the shadow list
 */
- (void)removeShapeShadow:(NSInteger)index
{
	if ([arrayShadows count] > index) {
		[arrayShadows removeObjectAtIndex:index];
	}
	
	[self setNeedsDisplay:YES];
}


#pragma mark - shape operation implementation

/*
 @function:		createHandleArray
 @params:		nothing
 @return:		void
 @purpose:		This function create the handle pointer's array of the shape
 */
- (void)createHandleArray
{
	if (handleArray == nil) {
		handleArray = malloc(sizeof(NSRect) * 8);
	}
	
	// create handle points array
	
	handleArray[0] = CGRectMake(0, 0, 6, 6);
	handleArray[1] = CGRectMake(rtFrame.size.width, 0, 6, 6);
	handleArray[2] = CGRectMake(rtFrame.size.width, rtFrame.size.height, 6, 6);
	handleArray[3] = CGRectMake(0, rtFrame.size.height, 6, 6);
	handleArray[4] = CGRectMake(rtFrame.size.width / 2, 0, 6, 6);
	handleArray[5] = CGRectMake(rtFrame.size.width / 2, rtFrame.size.height, 6, 6);
	handleArray[6] = CGRectMake(rtFrame.size.width, rtFrame.size.height / 2, 6, 6);
	handleArray[7] = CGRectMake(0, rtFrame.size.height / 2, 6, 6);
}

/*
 @function:		DrawBorderFrame
 @params:		context:   Graphics context reference
 @return:       void
 @purpose:		Draw the shape's bound when the shape is selected.
 */
- (void)DrawBorderFrame:(CGContextRef)context
{
	// create handle points array
	[self createHandleArray];
    
   	CGContextSetLineWidth( context, 0 );
	CGContextSetRGBStrokeColor( context, 230/255, 230/255, 230/255, 0.2 );
	
    
    //// Color Declarations
    NSColor* fillColor = [NSColor colorWithCalibratedRed: 1 green: 1 blue: 1 alpha: 0.4];
    NSColor* strokeColor = [NSColor colorWithCalibratedRed: 0 green: 0 blue: 0 alpha: 0.1];
    NSColor* colorA = [NSColor colorWithCalibratedRed: 0.902 green: 0.902 blue: 0.902 alpha: 0.2];
    
    //// Gradient Declarations
    NSGradient* gradient = [[NSGradient alloc] initWithColorsAndLocations:
                            colorA, 0.0,
                            [NSColor colorWithCalibratedRed: 0.951 green: 0.951 blue: 0.951 alpha: 1], 0.26,
                            fillColor, 1.0, nil];
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: [NSColor lightGrayColor]];
    [shadow setShadowOffset: NSMakeSize(0.1, -1.1)];
    [shadow setShadowBlurRadius: 0];
    
    
    
    
    for (int i=0; i<sizeof(handleArray); i++) {
        /// Rectangle Drawing
        NSBezierPath* rectanglePath = [NSBezierPath bezierPathWithRect: handleArray[i]];
        [NSGraphicsContext saveGraphicsState];
        [shadow set];
        CGContextBeginTransparencyLayer(context, NULL);
        [gradient drawInBezierPath: rectanglePath angle: -90];
        CGContextEndTransparencyLayer(context);
        [NSGraphicsContext restoreGraphicsState];
        
        [strokeColor setStroke];
        [rectanglePath setLineWidth: 1];
        [rectanglePath stroke];
        
        //[gradient drawInRect: handleArray[i] angle: 90];
        //[strokeColor setStroke];
        
        
        //[rectanglePath setLineWidth: 1];
        //[rectanglePath stroke];
        //CGContextStrokeRect( context, handleArray[i] );
        //CGContextFillRect( context, handleArray[i] );
    }
	//}
}

/*
 @function:		HitTest
 @params:		nothing
 @return:       hitTest : hitTest is base on SHT_HANDLESTYLE
 @purpose:		Check the pt is in rtFrame.
 */
- (NSInteger)HitTest:(NSPoint)pt
{
	CGRect bound = [self frame];
	if (CGRectContainsPoint( bound, pt ) == NO || handleArray == nil) {
		return SHT_NONE;
	}
	
	NSPoint inPt = NSMakePoint(pt.x - bound.origin.x - 2, pt.y - bound.origin.y - 2);
	for (NSInteger i = 0; i < 8; i ++) {
		if (CGRectContainsPoint( handleArray[i], inPt ) == YES) {
			return (SHT_MOVING | (i + 1));
		}
	}
	
	return SHT_MOVING;
}


/*
 @function:		MoveShape
 @params:		offset:		shape's move offset
 @return:       void
 @purpose:		shape move with offset.
 */
- (void)MoveElement:(NSSize)offset
{
	rtFrame = NSOffsetRect( rtFrame, offset.width, offset.height );
	[self setFrame:CGRectMake(rtFrame.origin.x - 2, rtFrame.origin.y - 2, rtFrame.size.width + 4, rtFrame.size.height + 4)];
}


/*
 @function:		OnMouseMove
 @params:		offset:		shape's move/resize offset
 hitTest:	offset type (moving or resizing by direction)
 @return:		void
 @purpose:		shape move or resize with offset by hitTest
 */
- (void)OnMouseMove:(NSSize)offset HitTest:(NSInteger)hitTest
{
	Singleton *sg = [[Singleton alloc]init];
    
    switch (hitTest & SHT_HANDLESIZING)
    {
		
        NSLog(@"String : %ld", sg.currentElement.uType);
        //if (sg.currentElement.uType != SHAPE_DROPDOWN) //Drop downs cannot be resized
        
        case SHT_SIZENE:
			rtFrame = CGRectMake(rtFrame.origin.x + offset.width, rtFrame.origin.y + offset.height,
								 rtFrame.size.width - offset.width, rtFrame.size.height - offset.height);
			break;
			
		case SHT_SIZESE:
			rtFrame = CGRectMake(rtFrame.origin.x, rtFrame.origin.y + offset.height,
								 rtFrame.size.width + offset.width, rtFrame.size.height - offset.height);
			break;
			
		case SHT_SIZESW:
			rtFrame = CGRectMake(rtFrame.origin.x, rtFrame.origin.y,
								 rtFrame.size.width + offset.width, rtFrame.size.height + offset.height);
			break;
			
		case SHT_SIZENW:
			rtFrame = CGRectMake(rtFrame.origin.x + offset.width, rtFrame.origin.y,
								 rtFrame.size.width - offset.width, rtFrame.size.height + offset.height);
			break;
			
		case SHT_SIZEE:
			rtFrame = CGRectMake(rtFrame.origin.x, rtFrame.origin.y + offset.height,
								 rtFrame.size.width, rtFrame.size.height - offset.height);
			break;
			
		case SHT_SIZEW:
			rtFrame = CGRectMake(rtFrame.origin.x, rtFrame.origin.y,
								 rtFrame.size.width, rtFrame.size.height + offset.height);
			break;
			
		case SHT_SIZES:
			rtFrame = CGRectMake(rtFrame.origin.x, rtFrame.origin.y,
								 rtFrame.size.width + offset.width, rtFrame.size.height);
			break;
			
		case SHT_SIZEN:
			rtFrame = CGRectMake(rtFrame.origin.x + offset.width, rtFrame.origin.y,
								 rtFrame.size.width - offset.width, rtFrame.size.height);
			break;
        

			
		case SHT_MOVEAPEX:
			rtFrame = CGRectMake(offset.width, offset.height, rtFrame.size.width, rtFrame.size.height);
			break;
			
		case SHT_RESIZE:
            NSLog(@"DUNNO");
            // Called when I enter a value/place the mouse - inside any of the atributes field.
			rtFrame = CGRectMake(rtFrame.origin.x, rtFrame.origin.y, offset.width, offset.height);
			break;
			
		default:
			if (hitTest & SHT_HANDLESTYLE) {
				rtFrame = NSOffsetRect( rtFrame, offset.width, offset.height );
			}
			break;
	}

	//[self setFrame:CGRectMake(rtFrame.origin.x - 2, rtFrame.origin.y - 2, rtFrame.size.width + 4, rtFrame.size.height + 4)];
	[self setBoundRect:rtFrame];
    
    // The business
    
    if ([self.layoutType isEqualToString:PERCENTAGE_BASED_LAYOUT])
    {
        Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
        CGSize w_h = [[curDoc stageView] sizeAsPercentageOfHighestContainingElement:self];
        
        [self setWidth_as_percentage:w_h.width];
        [self setHeight_as_percentage:w_h.height];
        
        NSLog(@"In Element. Width = %f. Height = %f.", w_h.width, w_h.height);
        
        
        
    }
    else
    {
        [self setWidth_as_percentage:0];
        [self setHeight_as_percentage:0];
    }
    
}


#pragma mark - mouse touch and move event implementation & cursor set implementation

- (void)mouseDown:(NSEvent *)theEvent
{	
    
    /*
     Singleton *sg = [[Singleton alloc]init];
     if ([insideOperationElement isInsideElement:self] == NO) 
     {
     isTouched = NO;
     [[self superview] mouseDown:theEvent];
     return;
     }
     
    
    [[self superview] mouseDown:theEvent];
	ptStart = [theEvent locationInWindow];
	ptEnd = ptStart;
	//[insideOperationElement selectCurrentElement:self];
	//isTouched = YES;
    */
        if ([insideOperationElement isInsideElement:self] == NO)
        {
            isTouched = NO;
            [[self superview] mouseDown:theEvent];
            return;
        }
        
        ptStart = [theEvent locationInWindow];
        ptEnd = ptStart;
        [insideOperationElement selectCurrentElement:self];
        isTouched = YES;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	if ([insideOperationElement isInsideElement:self] == NO) {
		isTouched = NO;
		[[self superview] mouseDragged:theEvent];
		return;
	}
	
	NSPoint point;
	point = [theEvent locationInWindow];
	
	[self OnMouseMove:NSMakeSize(point.x - ptEnd.x, point.y - ptEnd.y) HitTest:SHT_MOVING];
	ptEnd = point;
}

- (void)mouseUp:(NSEvent *)theEvent
{
	if ([insideOperationElement isInsideElement:self] == NO) {
		isTouched = NO;
		[[self superview] mouseUp:theEvent];
		return;
	}
	
	NSPoint point;
	point = [theEvent locationInWindow];
	
	[self OnMouseMove:NSMakeSize(point.x - ptEnd.x, point.y - ptEnd.y) HitTest:SHT_MOVING];
	isTouched = NO;
}

#pragma mark - Encoding and decoding
/*
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.rtFrame forKey:@"ASCPersonFirstName"];
    [coder encodeObject:self.tag forKey:@"ASCPersonLastName"];
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


- (NSMutableDictionary *)getShapeData
{
	return nil;
}

/*
 @function:		createShapeFromDictionary
 @params:		dict:	dictionary object that contains the shape information
 @return:		create sucessfully, returns shape class object. Otherwise, return nil.
 @purpose:		Create and return new geometry shape class object from dict.
 */
+ (Element *)createElementFromDictionary:(NSDictionary *)dict
{
	Element *element;
	
	// shape information from dictionary
	NSNumber *type = [dict valueForKey:@"ShapeType"];
	NSNumber *xPos = [dict valueForKey:@"xPos"];
	NSNumber *yPos = [dict valueForKey:@"yPos"];
	NSNumber *width = [dict valueForKey:@"Width"];
	NSNumber *height = [dict valueForKey:@"Height"];
	
	// shadow information from dictionary
	NSNumber *shadowAngle = [dict valueForKey:@"shadowAngle"];
	NSNumber *shadowDistance = [dict valueForKey:@"shadowDistance"];
	NSNumber *shadowOpacity = [dict valueForKey:@"shadowOpacity"];
	NSNumber *shadowBlur = [dict valueForKey:@"shadowBlur"];
	NSNumber *shadowColorR = [dict valueForKey:@"shadowColorR"];
	NSNumber *shadowColorG = [dict valueForKey:@"shadowColorG"];
	NSNumber *shadowColorB = [dict valueForKey:@"shadowColorB"];
	NSNumber *shadowDirection = [dict valueForKey:@"shadowDirection"];
	
	NSRect rt = NSMakeRect([xPos floatValue], [yPos floatValue], [width floatValue], [height floatValue]);
	/*
	switch ([type integerValue]) {
		case SHAPE_CIRCLE:
			element = [[CCircle alloc] init];
			break;
			
		case SHAPE_RECTANGLE:
			element = [[CRectangle alloc] init];
			break;
			
		case SHAPE_TRIANGLE:
			element = [[CTriangle alloc] init];
			break;
			
		case SHAPE_TEXTBOX:
			element = [[CTextBox alloc] init];
			
			NSString *text = [dict valueForKey:@"Text"];
			[((CTextBox *)element) setContentText:text];
			break;
			
		case SHAPE_IMAGE:
			element = [[CImage alloc] init];
			
			//NSNumber *imgType = [dict valueForKey:@"ImageType"];
			NSData *imgData = [dict valueForKey:@"ImageData"];
			[((CImage *)element) setImageData:imgData];
			break;
			
		case SHAPE_GROUP:
			element = [[CGropBox alloc] init];
			break;
	}
     */
	
	if (element) {
		element.uType = [type integerValue];
		
		/* for shadow
		shape.shadowAngle = [shadowAngle floatValue];
		shape.shadowDistance = [shadowDistance floatValue];
		shape.shadowOpacity = [shadowOpacity floatValue];
		shape.shadowBlur = [shadowBlur floatValue];
		shape.shadowCGColor = CGColorCreateGenericRGB([shadowColorR floatValue], [shadowColorG floatValue], [shadowColorB floatValue], 1.0);
		shape.shadowDirection = [shadowDirection floatValue];
		
		shape.isSelected = NO;
		[shape setBoundRect:rt];
		[shape createHandleArray];
         */
	}
	
	return element;
}

#pragma mark - provide image representation
- (NSImage *)imageWithSubviews
{
    // Take a picture of itself
    NSSize mySize = self.bounds.size;
    NSSize imgSize = NSMakeSize( mySize.width, mySize.height );
    
    NSBitmapImageRep *bir = [self bitmapImageRepForCachingDisplayInRect:[self bounds]];
    [bir setSize:imgSize];
    [self cacheDisplayInRect:[self bounds] toBitmapImageRep:bir];
    
    NSImage* image = [[[NSImage alloc]initWithSize:imgSize] autorelease];
    [image addRepresentation:bir];
    return image;
}

@end
