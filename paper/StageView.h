#import <AppKit/AppKit.h>
#import "DrawShapeTypeDelegate.h"
#import "SetAttributeDelegate.h"
#import "ChangeElementAttributeDelegate.h"
#import "OperationInsideShapeDelegate.h"
#import "SetLayerOrderDelegate.h"
#import "DocumentSettingsView.h"


@class Element;
@class StageTextView;
@class GroupingBox;




enum
{
	ALIGN_LEFT			= 0,
	ALIGN_RIGHT,
	ALIGN_VERT,
	ALIGN_TOP,
	ALIGN_BOTTOM,
	ALIGN_HORZ
};
typedef NSInteger		AlignType;



enum
{
	DISTRIBUTION_LEFT	= 0,
	DISTRIBUTION_RIGHT,
	DISTRIBUTION_CENTER
};
typedef NSInteger		DistributionType;



enum
{
	SPACING_HORZ		= 0,
	SPACING_VERT
};
typedef NSInteger		SpacingType;


enum
{
	SHAPE_NORMAL		= 0,
	SHAPE_CUT,
	SHAPE_COPY
};
typedef NSInteger		ShapeCutCopyType;

/*
 StageView is the draw board of all shapes.
 It contains drawn shape array and drawing shape object.
 Once user draw the shape, new shape is added in shape array.
 
 @params:	shapeType:			current shape type to draw
 curShape:			current shape object to draw
 shapeArray:			drawn shape array
 isDragingShape:		when the shape is draging, YES. otherwise NO
 isSelectedShape:	when the shape is selected already, YES. otherwise NO
 isSelArea:			when the mouse select the range rect, YES. otherwise NO
 isCutOrCopy:		when the selected shape is cut/copy, YES. otherwise NO
 clipBoardArray:		using by cut/copy/paste of shape. We don't use NSPasteBoard because it is standard system ability.
 attributeDelegate:	delegate to attribute panel
 textboxView:		it shows when the text box shape is editing
 gridLineArray:		grid line array.
 */

@interface StageView : NSView
<DrawShapeTypeDelegate,OperationInsideElementDelegate, ChangeElementAttributeDelegate, NSTextViewDelegate, NSCoding, NSTableViewDataSource, NSTableViewDelegate>

{
	ElementType							elementType;
	Element                             *currentElement;
	NSMutableArray						*elementArray;
    NSMutableArray                      *selElementArray;
	
	NSInteger							nHitTest; // where the mouse last touched down ? Confirm with Ming.
	
	NSPoint								ptStart;
	NSPoint								ptEnd;
	
	BOOL								isDragingShape;
	BOOL								isSelectedShape;
    BOOL								isSelArea;
	
	id<SetAttributeDelegate>			attributeDelegate;
    id<SetLayerOrderDelegate>			layerDelegate;
	
	IBOutlet StageTextView              *textboxView;
    IBOutlet NSScrollView               *sv;
    
    NSFont                              *lastFontSelected;
    
    BOOL isDraggingElement;
    
    int elementCount;
    
    
    int numberOfGroupings;
    IBOutlet NSButton *groupItems;
    IBOutlet NSButton *documentSettingsButton;
    IBOutlet NSPopover *documentSettingsPopover;
    
    IBOutlet NSPanel *panel;

    
    NSMutableArray *groupingBoxes;
    
    NSMutableArray *rows;
    NSMutableArray *rowMargins; // The margin for the nth row. So the first margin in this array is for row(1) and so on
    
    NSMutableArray *leftToRightTopToBottom;
	
	NSMutableArray						*gridLineArray;
	
	NSMutableArray						*clipBoardArray;
	
	ShapeCutCopyType					CutOrCopyFlag;
    
    //document settings
    IBOutlet DocumentSettingsView *documentSettingsView;
    NSRect documentContainer; // change this to an element with a rect in it
    NSColor *stageBackgroundColor;
    
    IBOutlet NSPopUpButton *typeFaceName;
    IBOutlet NSPopUpButton *typeFaceTrait;
    
    //Font panel bits
    IBOutlet NSColorWell *fontColorWell;
    IBOutlet NSStepper                  *kerningStepper;
    IBOutlet NSTextField                *kerningTextField;
    IBOutlet NSStepper                  *leadingStepper;
    IBOutlet NSTextField                *leadingTextField;
    IBOutlet NSTextField                *fontSizeTextField;
    IBOutlet NSSegmentedControl         *fontTraitControl;
    
    //Flags
    BOOL elementBeenDroppedToStage; //Has an element ever touched the stage since the app last opened?
    
    NSMutableString *layoutType;
    
    NSMutableArray *orderOfLayers;


    BOOL								isShowFontTab;
	NSMutableArray						*fontFaceArray;
	IBOutlet NSTableView				*fontTableView;
}
@property (nonatomic, assign) NSMutableArray *sortedArray;
@property (nonatomic, assign) NSMutableString *jsCode2;
@property (nonatomic, assign) NSMutableString *pageTitle;
@property (nonatomic, assign) NSMutableArray *finalGrouping;
@property (nonatomic, assign) NSMutableArray *solos;
@property (nonatomic, assign) NSMutableArray *firstAndLastRowsInContainer;
@property (nonatomic, assign) NSMutableDictionary *textStyles;
@property (nonatomic, assign) NSURL *directoryURLToPlaceFiles;
@property (nonatomic, assign) NSString *outputFolderPath;


@property (assign) NSPanel *panel;
//Flags
@property (assign) BOOL elementBeenDroppedToStage;

@property (nonatomic, strong)  NSPopUpButton *typeFaceName;
@property (nonatomic, strong)  NSPopUpButton *typeFaceTrait;

@property (nonatomic, assign) int containerWidth;
@property (nonatomic, assign) int containerHeight;

@property (nonatomic, assign) Element *currentElement;
@property (assign) id<SetAttributeDelegate>		attributeDelegate;
@property (assign) id<SetLayerOrderDelegate>		layerDelegate;
@property (nonatomic, assign) int elementCount;
@property (nonatomic, assign) int numberOfGroupings;
@property (nonatomic, assign) NSButton *groupItems;
@property (nonatomic, assign) NSButton *documentSettingsButton;
@property (nonatomic, assign) NSPopover *documentSettingsPopover;
@property (nonatomic, assign) NSMutableArray *groupingBoxes;
@property (nonatomic, assign) NSMutableArray *rows;
@property (nonatomic, assign) NSMutableArray *rowMargins;
@property (nonatomic, assign) NSMutableArray *leftToRightTopToBottom;

@property (nonatomic, assign) StageTextView *textboxView;
@property (assign, nonatomic) NSScrollView *sv;

@property (nonatomic, assign) NSMutableArray *elementArray;
@property (nonatomic, assign) NSMutableArray *selElementArray;
@property (nonatomic, assign) DocumentSettingsView *documentSettingsView;
@property (nonatomic, assign) NSRect documentContainer;
@property (nonatomic, assign) NSColor *stageBackgroundColor;

// Text objects
@property (nonatomic, assign) IBOutlet NSPopover *textPopover;//NSPopover *textPopover;
@property (assign, nonatomic) NSColorWell *fontColorWell;

@property (assign, nonatomic) NSTextField *fontSizeTextField;

@property (assign, nonatomic) NSMutableString *layoutType;
@property (assign, nonatomic) NSMutableArray *orderOfLayers;

@property (assign) IBOutlet NSView			*fontView;
@property (assign) IBOutlet NSSearchField	*searchField;
@property (nonatomic) BOOL					isShowFontTab;


//Font based methods
-(IBAction)setFontTrait:(id)sender;
-(IBAction)setFontSize:(id)sender;
-(IBAction)setTypeFaceFamily:(id)sender;
-(IBAction)setTypeStyle:(id)sender;
-(void)setKerningValue:(NSNumber *)kerningValueReceived;
-(void)setLeadingValue:(NSNumber *)leadingValueReceived;
-(IBAction)setAlignmentOfText:(id)sender;
-(void)updateCustomFontMenu:(NSDictionary*)attributes;


//VALIDATION OF ELEMENTS EDITED
-(BOOL)isElementIDUnique: (NSMutableString *)string;




//Drawing methods
-(IBAction)displayDocumentSettingsView:(id)sender;

-(void) postNotificationForImageToResize;
-(void) postNotificationForImageToHold;

//Rulers
- (void)updateRulers;
- (void)updateHorizontalRuler;
- (void)updateVerticalRuler;
- (void)setRulerOffsets;
- (IBAction)zoomIn:(id)sender;
- (IBAction)zoomOut:(id)sender;

//Popvers
-(IBAction)clearPopover:(id)sender;
-(void)closeSettingsPopover;

//Sort layer panel
- (void)ResortLayer;
- (void)ResortShapes:(NSIndexSet *)from to:(NSInteger)to;


//Moving and positioning of Elements
-(BOOL)updateOverlappingVariable;

/*
 @function:		DeselectAllShaps
 @params:		nothing
 @return:       void
 @purpose:		deselect all Element in shapeArray.
 */
- (void)DeselectAllShaps;


/*
 @function:		DisableEditing
 @params:		nothing
 @return:		void
 @purpose:		disable editing all text boxes
 */
- (void)DisableEditing;


/*
 @function:		SetTextBoxText
 @params:		nothing
 @return:		void
 @purpose:		set the text of textbox to selected text box shape
 */
- (void)SetTextBoxText;


/*
 @function:		MoveSelectedElement
 @params:		offset:			Element's move offset
				hitTest:		Element's hit test
 @return:		void
 @purpose:		move all selected Element in selElementArray
 */
- (void)MoveSelectedElements:(NSSize)offset HitTest:(NSInteger)hitTest;

/*
 @function:		IsContainShape
 @params:		shape1:			source shape object to contain
				shape2:			dest shape object to be contained
				point:			source shape's offset
 @return:		The shape1 contains the shape2, return YES. otherwise NO.
 @purpose:		This function check the shape1 contains the shape that the shape2's position pluse offset.
 */
- (BOOL)IsContainShape:(Element *)shape1 dst:(Element *)shape2 offset:(NSPoint)point;


/*
 @function:		AlignElement
 @params:		flag:			alignment flag: this parameter is one of
								ALIGN_LEFT, ALIGN_RIGHT, ALIGN_VERT, ALIGN_TOP, ALIGN_BOTTOM, ALIGN_HORZ
 @return:		void
 @purpose:		This function called when the user click the align button in alignment panel.
				The purpos is to align of the selected Element by flag.
 */
- (void)AlignElements:(AlignType)flag;


/*
 @function:		DistributionElement
 @params:		flag:			distribution flag: this parameter is one of
								DISTRIBUTION_LEFT, DISTRIBUTION_RIGHT, DISTRIBUTION_CENTER
 @return:		void
 @purpose:		This function called when the user click the distribution button in alignment panel.
				The purpos is to align distribution of the selected Element by flag.
 */
- (void)DistributionElement:(DistributionType)flag;


/*
 @function:		GetDistributionDistance
 @params:		flag:			it is same with the paramenter of DistributionElement
 @return:		distance between Element
 @purpose:		This function returns the distance between the selected Element.
 */
- (CGFloat)GetDistributionDistance:(DistributionType)flag;


/*
 @function:		SpaceEvenlyElement
 @params:		spacing:		distance between the selected Element
				flag:			spacing flag: this paramenter is one of SPACING_VERT, SPACING_HORZ
 @return:		void
 @purpose:		This function called when the user click the spaceing evenly button in alignment panel.
				The purpos is to make the same distance between Element by spacing.
 */
- (void)SpaceEvenlyElement:(NSInteger)spacing flag:(SpacingType)flag;


/*
 @function:		SelectElementByIndex
 @params:		index: index of shape to select
 @return:		void
 @purpose:		This function select the shape by index
 */
- (void)SelectElementByIndex:(NSInteger)index;




- (NSData *)SaveProjectToFile:(NSString*)filename;




/*
 @function:		IsSelectedShape
 @params:		void
 @return:		if some shape is selected, return YES. otherwise NO
 @purpose:		The purpose is to check some shape are selected.
 */
- (BOOL)IsSelectedShape;


// Cut, copy, paster and delete
- (void)CutSelElements;
- (void)CopySelElements;
- (void)PasteSelElements;
- (void)DeleteAllElements;
- (void)DeleteSelElements;
- (void)DeleteSubElements:(Element*)element;




/*
 @function:		CreateClipBoardRecursive
 @params:		buffer:				shape buffer
 srcShape:		original parent shape
 dstShape:		target parent shape
 @return:		void
 @purpose:		The purpose is to create shape into buffer recursively from selShapeArray again.
 */
- (void)CreateClipBoardRecursive:(NSMutableArray*)buffer src:(Element*)srcShape dst:(Element*)dstShape;


/*
 @function:		CreateAdvancedShape
 @params:		filename:	image file name to create a advanced shape
 rt:			bound rect of the new advanced shape
 @return:       void
 @purpose:		This function create the new advanced image shape from the advanced shape panel.
 */
- (void)CreateImageOnStage:(NSURL*)filePath rtBound:(NSRect)rt;


- (IBAction)InsertImageToStage:(id)sender;

/*
 @function:		ChangeAttribueOfElement
 @params:		offset:		The value to change
 hitTest:	The type of value (Moving: SHT_MOVEAPEX, Resizing: SHT_RESIZE)
 @return:		void
 @purpos:		Set the attribute of shape by changing stepper in AttributePanel.
 */
- (void)ChangeAttribueOfElement:(CGSize)offset HitTest:(NSInteger)hitTest;

- (BOOL)insideMyFrame:(NSPoint)pt;

/*
 @function:		createContainerElement
 @params:		width: width of container shape
 @return:		void
 @purpose:		This function create container shape.
 */
- (void)createContainerElement:(CGFloat)width;
- (void)showFontTab;
- (void)hideFontTab;
- (void)selectFontofCurrentTextBox:(NSString *)fontName;

@end



@interface StageView (flexibileWidth)
-(CGSize)sizeAsPercentageOfHighestContainingElement: (Element*)selElement;
-(CGSize)sizeOfHighestContainingElement: (Element*)selElement;
-(CGSize)updateElementWithPercentagesAndAttributesPanelWithElementAttributes:(Element*)selElement;
@end


@interface StageView (colorsShadowsGradients)
-(void)updateStageViewBackgroundColor: (NSDictionary *)dict;
-(NSString *)hsla:(NSColor *)color;
- (void)drawShapeShadow:(CGFloat)angle Distance:(CGFloat)dist ColorR:(CGFloat)r ColorG:(CGFloat)g ColorB:(CGFloat)b Opacity:(CGFloat)alpha Blur:(CGFloat)blur Direction:(BOOL)d Index:(NSInteger)index;
- (void)addShapeShadow:(CGFloat)angle Distance:(CGFloat)dist ColorR:(CGFloat)r ColorG:(CGFloat)g ColorB:(CGFloat)b Opacity:(CGFloat)alpha Blur:(CGFloat)blur Direction:(BOOL)d;
- (void)removeShapeShadow:(NSInteger)index;
@end


@interface StageView (knockout)
-(NSString*)viewModelFrom:(NSMutableDictionary*)dyRow amongstElements:(NSArray*)sortedArray;
-(NSString*)generateClassFromDynamicRow: (NSMutableDictionary*)dyRowDict withElementsOnStage: (NSArray*)sortedArrayOnStage;
-(NSString*)classStructureOf:(NSMutableDictionary*)dyRow amongstElements:(NSArray*)sortedArray;
-(NSString *)actionCodeString: (Element*)ele;
-(NSString *)dataSourceBindingCode: (Element*)ele;
-(NSString*)dataSourceNameContainingKey: (Element*)ele;
@end


@interface StageView (conversion)
-(NSArray*)elementsInside: (NSMutableDictionary *)elementBeingTested usingElements: (NSArray*) sortedArrayOnStage;
BOOL hasLeadingNumberInString(NSString* s);
@end



