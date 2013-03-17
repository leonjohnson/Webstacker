#import <Foundation/Foundation.h>
#import "OperationInsideShapeDelegate.h"

#define REDRAW_ELEMENT_NOTIFICATION     @"redraw_element_notification"
#define UPDATE_KERNING_TEXTFIELD        @"update_kerning_textField"

enum
{
	SHAPE_BUTTON,
    SHAPE_DROPDOWN,
	SHAPE_RECTANGLE,
    SHAPE_TEXTBOX,
    SHAPE_TEXTFIELD,
    SHAPE_PLACEHOLDER_IMAGE,
    SHAPE_DYNAMIC_ROW,
	SHAPE_CONTAINER,
    SHAPE_IMAGE,
    SHAPE_CIRCLE,
	SHAPE_TRIANGLE,
    
    //SHAPE_TEXTVIEW
};
typedef NSInteger		ElementType;

enum
{
    LEFT,
    RIGHT,
    TOP,
    BOTTOM,
};
typedef NSInteger SideToTest;


enum
{
    PIXEL,
    PERCENT,
};
typedef NSInteger LayoutTag;

// handle type (shape hitTest type)

#define SHT_HANDLESTYLE			0xFF000	// hit test style mask. If the bit AND operation of hit test value and SHT_HANDLESTYLE is SHT_NONE,
// shape is not to move. Otherwise moving.

#define SHT_HANDLESIZING		0x00FFF // hit test resizeing mask.
// If the bit AND operation of the hit test value and SHT_HANDLESIZING is following resizing flag,
// shape is resizing.

// shape moving flage
#define SHT_NONE				0x00000 // Shape's normal state.
#define SHT_MOVING				0x01000 // Shape's moving state.
#define SHT_PTINELEMENT			0x10000 // Point is beside in shape.


// shape resizing flag
// The hit test value can be set following flags. This flags express the direction of resizig.
#define SHT_SIZENE				0x001	// When the cursor is on left bottom of handle, the hit test value is SHT_SIZENE.
#define SHT_SIZESE				0x002	// When the cursor is on right bottom of handle, the hit test value is SHT_SIZESE.
#define SHT_SIZESW				0x003	// When the cursor is on right top of handle, the hit test value is SHT_SIZESW.
#define SHT_SIZENW				0x004	// When the cursor is on left top of handle, the hit test value is SHT_SIZENW.
#define SHT_SIZEE				0x005	// When the cursor is on top of handle, the hit test value is SHT_SIZEE.
#define SHT_SIZEW				0x006	// When the cursor is on bottom of handle, the hit test value is SHT_SIZEW.
#define SHT_SIZES				0x007	// When the cursor is on right of hanndle, the hit test value is SHT_SIZES.
#define SHT_SIZEN				0x008	// When the cursor is on left of handle, the hit test value is SHT_SIZEN.

#define SHT_MOVEAPEX			0x010	// the apex of the shape move
#define SHT_RESIZE				0x020	// the resize of the shape




@interface Element : NSView <NSCoding>
{
	BOOL wasAcceptingMouseEvents;
    
    NSRect eyeBox;
    ElementType				uType;
    
    NSMutableString *elementid;
	
	NSRect					rtFrame;
	NSRectArray				handleArray;
	
	BOOL					isSelected;
	
	id<OperationInsideElementDelegate>				insideOperationElement;
	
	BOOL					isTouched;
    
    BOOL                    isUnderneathOtherElement;
	
	CGPoint					ptStart, ptEnd;
    
    NSString            *elementTag;
    
    NSSize              *elementSize;
    
    NSMutableDictionary *background;
    
    //NSNumber            *padding;
    
    NSNumber            *margin;
    
    NSString            *displayType;
    
    NSString            *floatType;
    
    NSNumber            *borderRadius;
    
    
    BOOL    topLeftBorderRadius;
    
    BOOL    topRightBorderRadius;
    
    BOOL    bottomLeftBorderRadius;
    
    BOOL    bottomRightBorderRadius;
    
    BOOL    fourRadii;
	
	BOOL	isPtInElement;
    
    NSNumber     *borderWidth;
    
    NSMutableDictionary *opacity;
    NSNumber            *opacityTypeSelected; //All, Border, or body
    
    NSDictionary        *linkAttributes;
    
    NSDictionary        *color; // delete this if not being used
    
    NSColor             *colorAttributes;
    
    //NSNumber            *borderWidth;
    
    NSMutableAttributedString *contentText;
    
    NSString *contentURL;
    
    /****     Needed for the markup conversion ****/
    NSString *spanGrouping;
    
    NSString *imgName;
    
    NSMutableArray *elementsAboveMe;
    
    NSMutableString *buttonText;
    
    NSString *layoutType;
    
    float width_as_percentage;
    float height_as_percentage;
    
    //Actions - this array contains other arrays, each one is a list of actions created by the user or the system.
    NSString *actionStringEntered;
    NSString *dataSourceStringEntered;
	
	NSMutableArray			*arrayShadows;
    
    
    /**********************************************/
}

@property float    width_as_percentage;
@property float    height_as_percentage;
@property (assign, nonatomic) NSString *layoutType;


@property (assign, nonatomic) ElementType				uType;
@property (assign, nonatomic) NSMutableString *elementid;
@property (nonatomic) BOOL							 isSelected;
@property (nonatomic) BOOL                           isUnderneathOtherElement;
@property (nonatomic) NSRect						rtFrame;
@property (assign) id<OperationInsideElementDelegate>				insideOperationElement;

@property (assign, nonatomic) NSString *elementTag;

@property BOOL    topLeftBorderRadius;
@property BOOL    topRightBorderRadius;
@property BOOL    bottomLeftBorderRadius;
@property BOOL    bottomRightBorderRadius;

@property (assign, nonatomic) NSNumber    *borderWidth;
@property (assign, nonatomic) NSNumber *borderRadius;

@property (readonly, nonatomic) NSDictionary *color;
@property (retain, nonatomic) NSColor *colorAttributes;
@property (assign, nonatomic) NSMutableDictionary *border;

@property (assign, nonatomic) NSMutableDictionary *opacity;
@property (assign, nonatomic) NSNumber *opacityTypeSelected;


@property (assign, nonatomic) NSMutableAttributedString *contentText;
@property (assign, nonatomic) NSString *spanGrouping;

@property (assign, nonatomic) NSString *contentURL;

@property (assign, nonatomic) NSString *imgName;

@property (assign, nonatomic) NSMutableArray *elementsAboveMe;

@property (assign) NSMutableString *buttonText;

@property (assign, nonatomic) NSString *actionStringEntered;
@property (assign, nonatomic) NSString *dataSourceStringEntered;

@property (nonatomic) BOOL							isPtInElement;
@property (assign) NSMutableArray					*arrayShadows;

- (void)dealloc;

/*
 @function:		createElement
 @params:		type:   element type to create shape class
 @return:       create successfully, returns element class object. Otherwise, returns nil.
 @purpose:		Create and return new geometry class object from type.
 */
+ (Element *)createElement:(ElementType)type;

+ (Element *)createElementFromDictionary:(NSDictionary *)dict;

/*
 @function:		setBoundRect
 @params:		rt:   shape's bound rect
 @return:       void
 @purpose:		It's abstract function. Function's body definitions are implemented at every shape classes.
 Set the shape's bound rect "rtFrame" to rt.
 */
- (void)setBoundRect:(NSRect)rt;

/*
 @function:		DrawShape
 @params:		context:   Graphics context reference
 @return:       void
 @purpose:		It's abstract function. Function's body definitions are implemented at every shape classes.
 Draw the shape in rtFrame rectangle area.
 */
- (void)DrawElement:(CGContextRef)context;

/*
 @function:		DrawBorderFrame
 @params:		context:   Graphics context reference
 @return:       void
 @purpose:		Draw the shape's bound when the shape is selected.
 */
- (void)DrawBorderFrame:(CGContextRef)context;

/*
 @function:		HitTest
 @params:		nothing
 @return:       hitTest : hitTest is base on SHT_HANDLESTYLE
 @purpose:		Check the pt is in rtFrame.
 */
- (NSInteger)HitTest:(NSPoint)pt;

/*
 @function:		MoveShape
 @params:		offset:		shape's move offset
 @return:       void
 @purpose:		shape move with offset.
 */
- (void)MoveElement:(NSSize)offset;

/*
 @function:		OnMouseMove
 @params:		offset:		shape's move/resize offset
 hitTest:	offset type (moving or resizing by direction)
 @return:		void
 @purpose:		shape move or resize with offset by hitTest
 */
- (void)OnMouseMove:(NSSize)offset HitTest:(NSInteger)hitTest;

/*
 @function:		IsPointInElement
 @params:		nothing
 @return:       hitTest : hitTest is base on SHT_HANDLESTYLE
 @purpose:		Check the pt is in shape.
 */
- (NSInteger)IsPointInElement:(NSPoint)pt;


/*
 - (void)setLocked:(BOOL)flag;
 - (BOOL)isLocked;
 */

/*
 @function:		getShapeData
 @params:		nothing
 @return:       returns the dictionary data of the shape.
 @purpose:		It's abstract function. Function's body definitions are implemented at every shape classes.
 This function create the dictionary data from shape and return it.
 */
- (NSMutableDictionary *)getShapeData;

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
- (void)setShadowOfShape:(CGFloat)angle distance:(CGFloat)dist colorR:(CGFloat)r colorG:(CGFloat)g colorB:(CGFloat)b opacity:(CGFloat)alpha Blur:(CGFloat)blur direct:(BOOL)d Index:(NSInteger)index;

/*
 @function:		addShapeShadow
 @params:		angle:		shadow angle
 dist:		shadow distance
 r, g, b, alpha: color property of shadow
 direct:		shadow direction, if it's YES, outset. otherwise inset.
 @return:		void
 @purpose:		This function add the new shadow to current shape
 */
- (void)addShapeShadow:(CGFloat)angle Distance:(CGFloat)dist ColorR:(CGFloat)r ColorG:(CGFloat)g ColorB:(CGFloat)b Opacity:(CGFloat)alpha Blur:(CGFloat)blur Direction:(BOOL)d;

/*
 @function:		removeShapeShadow
 @params:		index:		index of shadow in shadow list
 @return:		void
 @purpose:		This function remove the shape shadow from the shadow list
 */
- (void)removeShapeShadow:(NSInteger)index;

@end


@interface Element (ElementAttributes)
-(NSNumber *)borderColor;
-(NSNumber *)borderStyle;
-(void)setborderStyle:(NSNumber *)borderStyle;
-(NSString *)buttonString;
- (void)setButtonString:(NSString *)text;
-(void)setBackgroundAttributes:(NSDictionary *)backgroundAttributes;
-(void)setFloatAttribute:(NSString *)floatAttribute;
//-(void)setColor:(NSDictionary *)colorDictionary;
-(void)setColorAttributes:(id)sender;
-(void)setColorAttributesWithHexString:(id)sender;
-(void)setElementSize:(NSSize *)size;
-(void)setdisplayType:(NSString *)displayType;
-(void)setlinkAttributes:(NSMutableDictionary *)link;
-(void)setRtFrame:(NSRect)rtFrame;
-(void)postNotificationToRedraw;
@end




