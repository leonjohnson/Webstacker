#import <Cocoa/Cocoa.h>
#import "GalleryView.h"
#import "StageView.h"
#import "Common.h"
#import "DarkTitleViewButtons.h"
#import "documentBar.h"
#import "INAppStoreWindow.h"
#import "CustomScrollView.h"


@class Singleton;


#pragma mark - define project file extention macro

#define FILE_EXTENTION					@"drw"


@interface Document : NSDocument <NSWindowDelegate>
{
	BOOL								GridLineVisible;
    BOOL								RulerVisible;
	
    // shape gallery view, user can select shape type (rectangle, circle, triangl and so on).
	IBOutlet GalleryView				*galleryView;
	NSData								*dataFromeFile;
	NSInteger							scale;
    Singleton *sg;
    IBOutlet NSPanel *builderScreen;
    DarkTitleViewButtons *darkButtons;
    
    DocumentBar				*titleView;
}


// shape stage view, user can draw shape on it.
@property(assign) IBOutlet CustomScrollView			*mainStageScrollView;
@property(assign) IBOutlet StageView				*stageView;
@property(assign) IBOutlet DocumentBar				*titleView;

@property (nonatomic) BOOL				RulerVisible;
@property (nonatomic) BOOL				GridLineVisible;
@property (nonatomic) NSInteger			scale;
@property (assign, nonatomic) Singleton *sg;
@property (nonatomic, assign) DarkTitleViewButtons *darkButtons;



//  Window Delegate
- (void)windowDidBecomeKey:(NSNotification *)notification;

/*
 @function:		initWithData
 @params:		void
 @return:		void
 @purpose:		This function calls when the document's initialize.
				dataFromFile isn't nil, stage view created by dataFromFile.
 */
- (void)initWithData;
-(void)showBuilderScreen;

/*
 @function:		createAdvancedShape
 @params:		filename:	image file name to create a advanced shape
				rt:			bound rect of the new advanced shape
 @return:       void
 @purpose:		This function calls the stage view's createAdvancedShape
 */
- (void)createAdvancedShape:(NSString*)filename rtBound:(NSRect)rt;


/*
 @function:		drawShapeShadow
 @params:		angle:		shadow angle
				dist:		shadow distance
				r, g, b, alpha: color property of shadow
				direct:		shadow direction, if it's YES, outset. otherwise inset.
 @return:		void
 @purpose:		This funcation draws the shadow of shape with params.
 */
- (void)drawShapeShadow:(CGFloat)angle Distance:(CGFloat)dist ColorR:(CGFloat)r ColorG:(CGFloat)g ColorB:(CGFloat)b Opacity:(CGFloat)alpha Blur:(CGFloat)blur Direction:(BOOL)d;





/*
 @function:		ChangeAttribueOfElement
 @params:		offset:		The value to change
				hitTest:	The type of value (Moving: SHT_MOVEAPEX, Resizing: SHT_RESIZE)
 @return:		void
 @purpos:		This function called stage view's ChangeAttributeOfShape function
 */
- (void)ChangeAttribueOfElement:(CGSize)offset HitTest:(NSInteger)hitTest;


/*
 @function:		SetSizeStageView
 @params:		size
 @return:		void
 @purpos:		This function set size of stage view with size param
 */
- (void)SetSizeStageView:(CGSize)size;


/*
 @function:		SetScaleStageView
 @prarms:		nScale
 @return:		void
 @purpos:		This function zoom in/out stage view with nScale
 */
- (void)SetScaleStageView:(NSInteger)nScale;


/*
 @function:		CreateGroupingBox
 @params:		void
 @return:		void
 @purpose:		This function create the group box with selected shapes when the user click the grouping box menu item.
 */
- (void)CreateGroupingBox;

/*
 @function: OnAlignLeftButton
 @purpos:	The purpos is to align left of selected shapes.
 */
- (void)OnAlignLeftButton;


/*
 @function: OnAlignRightButton
 @purpos:	The purpos is to align right of selected shapes.
 */
- (void)OnAlignRightButton;


/*
 @function: OnAlignCenterVertButton
 @purpos:	The purpos is to align center vertically of selected shapes.
 */
- (void)OnAlignCenterVertButton;


/*
 @function: OnAlignTopButton
 @purpos:	The purpos is to align top of selected shapes.
 */
- (void)OnAlignTopButton;


/*
 @function: OnAlignBottomButton
 @purpos:	The purpos is to align bottom of selected shapes.
 */
- (void)OnAlignBottomButton;


/*
 @function:	OnAlignCenterHorzButton
 @purpos:	The pupos is to align center horizently of selected shapes.
 */
- (void)OnAlignCenterHorzButton;


/*
 @function: OnAlignDistributionLeftButton
 @purpos:	The purpos is to distribution left of selected shapes.
 */
- (void)OnAlignDistributionLeftButton;


/*
 @function: OnAlignDistributionRightButton
 @purpos:	The purpos is to distribution right of selected shapes.
 */
- (void)OnAlignDistributionRightButton;


/*
 @function: OnAlignDistributionCenterButton
 @purpos:	The purpos is to distribution center of selected shapes.
 */
- (void)OnAlignDistributionCenterButton;


/*
 @function:	OnSpaceEvenlyHorzButton
 @purpos:	The purpos is to make the same space horizentaly of selected shapes.
 */

- (void)OnSpaceEvenlyHorzButton:(NSInteger)spacing;


/*
 @function: OnSpaceEvenlyVertButton
 @purpos:	The purpos is to make the same space vertically of selected shapes.
 */
- (void)OnSpaceEvenlyVertButton:(NSInteger)spacing;


@end
