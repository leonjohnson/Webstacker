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
#import "NSColor+colorToHex.h"

@implementation Element


@synthesize insideOperationElement;
@synthesize elementid;
@synthesize uType, isSelected, rtFrame, color, colorAttributes;
@synthesize borderWidth;
@synthesize border;
@synthesize borderRadius;
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

@synthesize URLString;
@synthesize canMove;


- (void)dealloc
{
	free( handleArray );
	if (URLString) {
	}
	
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
        
        URLString = @"";
        
    }
    
    //[self setWantsLayer:YES];
    //self.elementHighlightColor = [NSColor colorWithCalibratedRed:1 green:0.4 blue:0.9 alpha:1.0];
    self.elementHighlightColor = [[NSColor colorWithCalibratedRed:1 green:0.4 blue:0.9 alpha:1.0] colorWithHexString:@"4CC1FC"];
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
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
			break;
			
		case SHAPE_RECTANGLE:
			shape = [[Box alloc] init];
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
			break;
			
		case SHAPE_TRIANGLE:
			shape = [[Triangle alloc] init];
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
			break;
			
		case SHAPE_TEXTBOX:
			shape = [[TextBox alloc] init];
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
            break;
            
        case SHAPE_BUTTON:
			shape = [[Button alloc] init];
            [[curDoc stageView] setElementBeenDroppedToStage:YES];
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
    shape.canMove = YES;
	shape.URLString = [[NSString alloc] initWithString:@""];
	
	return shape;
}

-(void)DrawElement:(CGContextRef)context
{
    
}


- (NSInteger)IsPointInElement:(NSPoint)pt
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
    [self setFrame:CGRectMake(rtFrame.origin.x - 3, rtFrame.origin.y - 5, rtFrame.size.width + 6, rtFrame.size.height + 7)];
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
	if (!canMove) {
		return;
	}
    
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
	
    if (!canMove) {
		return;
	}
    Singleton *sg = [[Singleton alloc]init];
    
    switch (hitTest & SHT_HANDLESIZING)
    {
		
        
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
        
        //NSLog(@"In Element. Width = %f. Height = %f.", w_h.width, w_h.height);
        
        
        
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


/*
 @function:		getShapeData
 @params:		nothing
 @return:       returns the dictionary data of the text box shape.
 @purpose:		This function create the dictionary data from text box shape and return it.
 */
- (NSMutableDictionary *)getShapeData
{
	// format shape type and frame rect
	NSNumber *type = [NSNumber numberWithInteger:uType];
	NSNumber *xPos = [NSNumber numberWithFloat:rtFrame.origin.x];
	NSNumber *yPos = [NSNumber numberWithFloat:rtFrame.origin.y];
	NSNumber *width = [NSNumber numberWithFloat:rtFrame.size.width];
	NSNumber *height = [NSNumber numberWithFloat:rtFrame.size.height];
    
    NSColor *thecolor = [self colorAttributes];
	
	// set type and frame rect value to dictionary
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:type forKey:@"ShapeType"];
    [dict setValue:elementid forKey:ELEMENT_ID];
	[dict setValue:xPos forKey:@"xPos"];
	[dict setValue:yPos forKey:@"yPos"];
	[dict setValue:width forKey:@"Width"];
	[dict setValue:height forKey:@"Height"];
    [dict setValue:thecolor forKey:@"color"];
    [dict setValue:self.layoutType forKey:@"measurementType"];
    [dict setValue:[NSNumber numberWithFloat:self.width_as_percentage] forKey:@"width_as_percentage"];
    [dict setValue:[NSNumber numberWithFloat:self.height_as_percentage] forKey:@"height_as_percentage"];
    
    [dict setObject:borderRadius forKey:@"borderRadius"];
    [dict setObject:borderWidth forKey:@"borderWidth"];
    [dict setObject:[NSNumber numberWithBool:topLeftBorderRadius] forKey:@"topLeftRadius"];
    [dict setObject:[NSNumber numberWithBool:topRightBorderRadius] forKey:@"topRightRadius"];
    [dict setObject:[NSNumber numberWithBool:bottomLeftBorderRadius] forKey:@"bottomLeftRadius"];
    [dict setObject:[NSNumber numberWithBool:bottomRightBorderRadius] forKey:@"bottomRightRadius"];
    
    [dict setObject:[NSNumber numberWithBool:canMove] forKey:@"canMove"];
    [dict setValue:URLString forKey:URLSTRING];
    
    if ([self buttonText] != nil)
    {
        [dict setObject:buttonText forKey:@"buttonText"];
    }
	
    if (actionStringEntered != nil)
    {
        [dict setObject:actionStringEntered forKey:@"actionstring"];
    }
    
    if (dataSourceStringEntered != nil)
    {
        [dict setObject:dataSourceStringEntered forKey:@"datasourcestring"];
    }
    
    if (_visibilityActionStringEntered != nil)
    {
        [dict setObject:_visibilityActionStringEntered forKey:@"visibility"];
    }
    
    
    
    
    
	// format shape shadow data
	NSNumber *shwAngle = [NSNumber numberWithFloat:_shadowAngle];
	NSNumber *shwDistance = [NSNumber numberWithFloat:_shadowDistance];
	NSNumber *shwOpacity = [NSNumber numberWithFloat:_shadowOpacity];
	const CGFloat *components = CGColorGetComponents( _shadowCGColor );
    if (components != nil)
    {
        NSNumber *shwColorR =  [NSNumber numberWithFloat:components[0]];
        NSNumber *shwColorG =  [NSNumber numberWithFloat:components[1]];
        NSNumber *shwColorB =  [NSNumber numberWithFloat:components[2]];
        NSNumber *shwDirection = [NSNumber numberWithBool:_shadowDirection];
        
        [dict setValue:shwColorR forKey:@"shadowColorR"];
        [dict setValue:shwColorG forKey:@"shadowColorG"];
        [dict setValue:shwColorB forKey:@"shadowColorB"];
        [dict setValue:shwDirection forKey:@"shadowDirection"];
        
        // set shadow information to dictionary
        [dict setValue:shwAngle forKey:@"shadowAngle"];
        [dict setValue:shwDistance forKey:@"shadowDistance"];
        [dict setValue:shwOpacity forKey:@"shadowOpacity"];
    }
	
	
	
	
	
	[dict setValue:contentText forKey:@"Text"];
	
	// free all value
	type = nil;
	xPos = nil;
	yPos = nil;
	width = nil;
	height = nil;
	
    NSLog(@"Saving dictionary : %@", dict);
    
	return dict;
}

/*
 @function:		createShapeFromDictionary
 @params:		dict:	dictionary object that contains the shape information
 @return:		create sucessfully, returns shape class object. Otherwise, return nil.
 @purpose:		Create and return new geometry shape class object from dict.
 */
+ (Element *)createElementFromDictionary:(NSDictionary *)dict
{
    NSLog(@"Creating an element from the dictionary received");
    Element *element = [Element new];
    
    // shape information from dictionary
    NSMutableString *eleid = [dict valueForKey:ELEMENT_ID];
    
	NSNumber *type = [dict valueForKey:@"ShapeType"];
	NSNumber *xPos = [dict valueForKey:@"xPos"];
	NSNumber *yPos = [dict valueForKey:@"yPos"];
	NSNumber *width = [dict valueForKey:@"Width"];
	NSNumber *height = [dict valueForKey:@"Height"];
	NSColor *thecolor = [dict valueForKey:@"color"];
    NSString *measurementType = [dict valueForKey:@"measurementType"];
    NSString *widthAsPercentage = [dict valueForKey:@"width_as_percentage"];
    NSString *heightAsPercentage = [dict valueForKey:@"height_as_percentage"];
    
    NSString *theBorderRadius = [dict valueForKey:@"borderRadius"];
    NSString *theBorderWidth = [dict valueForKey:@"borderWidth"];
    
    NSString *theTopLeftBorderRadius = [dict valueForKey:@"topLeftRadius"];
    NSString *theTopRightBorderRadius = [dict valueForKey:@"topRightRadius"];
    NSString *theBottomLeftBorderRadius = [dict valueForKey:@"bottomLeftRadius"];
    NSString *theBottomRightBorderRadius = [dict valueForKey:@"bottomRightRadius"];
    
    NSString *actionString = [dict valueForKey:@"actionstring"];
    NSString *dataSourceString = [dict valueForKey:@"datasourcestring"];
    NSString *visibilityString = [dict valueForKey:@"visibility"];
    
    
    
    NSNumber *shadowAngle = [dict valueForKey:@"shadowAngle"];
    NSNumber *shadowDistance = [dict valueForKey:@"shadowDistance"];
    NSNumber *shadowOpacity = [dict valueForKey:@"shadowOpacity"];
    NSNumber *shadowBlur = [dict valueForKey:@"shadowBlur"];
    NSNumber *shadowColorR = [dict valueForKey:@"shadowColorR"];
    NSNumber *shadowColorG = [dict valueForKey:@"shadowColorG"];
    NSNumber *shadowColorB = [dict valueForKey:@"shadowColorB"];
    NSNumber *shadowDirection = [dict valueForKey:@"shadowDirection"];
    
    NSString *buttonText = [dict valueForKey:@"buttonText"];
    
    // Use object forKey here as this is quicker and we know for sure that this data exists as this data is created whenever an ele is created:
    BOOL *moveable = [[dict objectForKey:@"canMove"] boolValue];
    NSString *theUrl = [dict objectForKey:URLSTRING];
    
    
    
	// shadow information from dictionary
    if ([dict objectForKey:@"shadowAngle"] != nil)
    {
        
    }
	
	
	NSRect rt = NSMakeRect([xPos floatValue], [yPos floatValue], [width floatValue], [height floatValue]);
	
    NSLog(@"ele = %@", element);
    
    
	switch ([type integerValue]) {
		case SHAPE_BUTTON:
			element = [[Button alloc] init];
            if (buttonText) {
                element.buttonText = buttonText;
            }
			break;
			
		case SHAPE_CONTAINER:
			element = [[Container alloc] init];
			break;
			
		case SHAPE_DROPDOWN:
			element = [[DropDown alloc] init];
			break;
        
        case SHAPE_DYNAMIC_ROW:
			element = [[DynamicRow alloc] init];
			break;
            
        case SHAPE_IMAGE: {
			element = [[Image alloc] init];
            //NSNumber *imgType = [dict valueForKey:@"ImageType"];
			NSData *imgData = [dict valueForKey:@"ImageData"];
			[((Image *)element) setImageData:imgData];
			break;
        
        }
        case SHAPE_PLACEHOLDER_IMAGE:
			element = [[Image alloc] init];
			break;
        
        case SHAPE_RECTANGLE:
            NSLog(@"trying to re recreate a box");
            element = [[Box alloc]init];
            NSLog(@"boxed");
            break;
			
		case SHAPE_TEXTBOX: {
			element = [[TextBox alloc] init];
			NSMutableAttributedString *text = [dict valueForKey:@"Text"];
			[((TextBox *)element) setContentText:text];
			break;
			
		}
		case SHAPE_TEXTFIELD:
			element = [[TextInputField alloc] init];
			break;
	}
    
    
    NSLog(@"ele2 = %@", element);
    
	if (element) {
		element.uType = [type integerValue];
        if (thecolor)
        {
            element.colorAttributes = thecolor;
            NSLog(@"color done");
        }
        
        if (measurementType)
        {
            element.layoutType = measurementType;
            NSLog(@"layout done");
        }
        
        if ([widthAsPercentage floatValue])
        {
            element.width_as_percentage = [widthAsPercentage floatValue];
            NSLog(@"width as perce done");
        }
        
        if ([heightAsPercentage floatValue])
        {
            element.height_as_percentage = [heightAsPercentage floatValue];
            NSLog(@"height as perce done");
        }
        
        
        if (eleid)
        {
            [element setValue:eleid forKey:@"elementTag"];
            NSLog(@"eleid is : %@", eleid);
            [element setElementid:eleid];
            NSLog(@"ELEMENTid IS now - is : %@", element.elementid);
            
        }

        
        if (theBorderRadius)
        {
            element.borderRadius = [NSNumber numberWithInteger:[theBorderRadius integerValue]];
            element.borderWidth = [NSNumber numberWithInteger:[theBorderWidth integerValue]];
            element.topLeftBorderRadius = [theTopLeftBorderRadius boolValue];
            element.topRightBorderRadius = [theTopRightBorderRadius boolValue];
            element.bottomLeftBorderRadius = [theBottomLeftBorderRadius boolValue];
            element.bottomRightBorderRadius = [theBottomRightBorderRadius boolValue];
            
        }
        
        if (actionString)
        {
            element.actionStringEntered = actionString;
        }
        
        
        if (dataSourceString)
        {
            element.dataSourceStringEntered = dataSourceString;
            
        }
        
        
        if (visibilityString)
        {
            element.visibilityActionStringEntered = visibilityString;
            
        }
        
        if (theUrl)
        {
            element.URLString = theUrl;
            
            
        }
		
        if ([dict objectForKey:@"shadowAngle"] != nil)
        {
            element.shadowAngle = [shadowAngle floatValue];
            element.shadowDistance = [shadowDistance floatValue];
            element.shadowOpacity = [shadowOpacity floatValue];
            element.shadowBlur = [shadowBlur floatValue];
            element.shadowCGColor = CGColorCreateGenericRGB([shadowColorR floatValue], [shadowColorG floatValue], [shadowColorB floatValue], 1.0);
            element.shadowDirection = [shadowDirection floatValue];
            NSLog(@"shadows done");
        }
        
        if (moveable != nil)
            element.canMove = moveable;
        else
            element.canMove = YES;
        
		// for shadow
		
		//[element setValue:eleid forKey:ELEMENT_ID];
        //[element setValue:[NSMutableString stringWithString:@"samba"] forKey:ELEMENT_ID];
		
        element.arrayShadows = nil;
		element.isSelected = NO;
		element.isPtInElement = NO;
		[element setBoundRect:rt];
		[element createHandleArray];
        
        
        
	}
    /*
    if (eleid != nil) {
        [element setElementid:[NSMutableString stringWithString:eleid]];
    }
     */
	NSLog(@"About to return an element with utype : %lu and width of: %@, and id of %@", element.uType, width, element.elementid);
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
    
    NSImage* image = [[NSImage alloc]initWithSize:imgSize];
    [image addRepresentation:bir];
    return image;
}

@end
