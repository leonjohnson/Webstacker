#import <AppKit/AppKit.h>
#import "AttributePanel.h"
#import "AlignmentPanel.h"
#import "LayerPanel.h"
#import "GalleryView.h"
#import "StageView.h"
#import "Singleton.h"
#import "DataSourcePanel.h"


@class DocumentBar;


#define ATTRIBUTE_SHOW_MENU				100
#define ALIGNMENT_SHOW_MENU				101
#define GRIDLINE_SHOW_MENU				102
#define RULER_SHOW_MENU					103

@interface AppDelegate : NSObject <NSApplicationDelegate>
{

	Singleton *sg;
    IBOutlet DocumentBar                *dBar;
    
    IBOutlet GalleryView				*galleryPanel;
	IBOutlet StageView					*stageView;
	IBOutlet AttributePanel				*attributePanel;
	BOOL								attributePanelVisible;
	
	IBOutlet AlignmentPanel				*alignmentPanel;
    BOOL								alignmentPanelVisible;
    
	IBOutlet NSTextField				*spacingTextField;
    
    IBOutlet NSColorWell                *fontColorWell;
    IBOutlet NSPanel					*fontPanel;
    IBOutlet NSPopUpButton              *typeFaceName;
    IBOutlet NSPopUpButton              *typeFaceTrait;
    BOOL								fontPanelVisible;
    BOOL                                buttonPanelVisible;
	
	// for Data Source Window
	NSMutableArray						*arrayDataSource;
    
    IBOutlet NSStepper                  *kerningStepper;
    IBOutlet NSTextField                *kerningTextField;
    //NSNumber                            *kerning;
    
    IBOutlet NSStepper                  *leadingStepper;
    IBOutlet NSTextField                *leadingTextField;
    //NSNumber                            *leading;
    
    IBOutlet NSSegmentedControl         *fontTraitControl;
    
    IBOutlet NSColorWell *pl;
    NSNumber *nu;
    
    IBOutlet NSTextField                *fontSizeTextField2;
    IBOutlet NSComboBox *fontSizeComboBox;
    
    //For the border width
    IBOutlet NSSlider *borderWidthSlider;
    IBOutlet NSTextField *borderWidthValue;
    IBOutlet NSMatrix *borderSelection;
    
    //For the border radius
    IBOutlet NSSlider *borderRadiusSlider;
    IBOutlet NSMatrix *borderCornerSelection;
    IBOutlet NSTextField *borderRadiusValue;
    
    IBOutlet NSButtonCell *topLeftRadius;
    IBOutlet NSButtonCell *topRightRadius;
    IBOutlet NSButtonCell *bottomRightRadius;
    IBOutlet NSButtonCell *bottomLeftRadius;
    
    
    //For the Button
    IBOutlet NSTextField *buttonURLField;
    IBOutlet NSTextField *buttonLabel;
    IBOutlet NSPanel *buttonPanel;
    
    
    //For the border radius
    IBOutlet NSSlider *opacitySlider;
    IBOutlet NSMatrix *opacitySelection;
    IBOutlet NSTextField *opacityValue;
    
    //For the color inputbox
    IBOutlet NSTextField *colorHexValue;
    
    //For the ID label
    IBOutlet NSTextField *elementidField;
    IBOutlet NSTextField *labelWarningField;
        
    //Layout type - px or %
    //IBOutlet NSPopUpButton *layoutType;
    
    //data fields
    IBOutlet NSComboBox *actionField;
    IBOutlet NSComboBox *dataSourceField;
    IBOutlet NSTextField *visibilityField;
    
	BOOL isRestored;
}

// Labels on Attributes Panel
@property (assign) IBOutlet NSTextField *xCoordinateLabel;
@property (assign) IBOutlet NSTextField *yCoordinateLabel;
@property (assign) IBOutlet NSTextField *layoutTypeLabel;
@property (assign) IBOutlet NSTextField *widthLabel;
@property (assign) IBOutlet NSTextField *heightLabel;
@property (assign) IBOutlet NSTextField *backgroundColorLabel;
@property (assign) IBOutlet NSTextField *borderWidthLabel;
@property (assign) IBOutlet NSTextField *borderRadiusLabel;
@property (assign) IBOutlet NSTextField *topLeftLabel;
@property (assign) IBOutlet NSTextField *topRightLabel;
@property (assign) IBOutlet NSTextField *bottomLeftLabel;
@property (assign) IBOutlet NSTextField *bottomRightLabel;
@property (assign) IBOutlet NSTextField *tagLabel;


@property(assign) IBOutlet NSComboBox *actionField;
@property(assign) IBOutlet NSComboBox *dataSourceField;
@property(assign) IBOutlet NSTextField *visibilityField;

@property (assign) IBOutlet NSTextField *colorHexValue;
@property (assign) IBOutlet NSTextField *labelWarningField;
@property (assign) IBOutlet NSTextField *elementidField;

@property (assign) IBOutlet NSColorWell *borderColour; 
@property (assign) IBOutlet NSTextField *borderHexValue;;

@property(assign) IBOutlet DataSourcePanel *dataSourcePanel;




@property (assign, nonatomic) DocumentBar *dBar;

@property (assign, nonatomic) Singleton *sg;

@property (assign, nonatomic) NSColorWell *pl;
@property (assign, nonatomic) NSNumber *nu;
@property (assign, nonatomic) NSComboBox *fontSizeComboBox;

@property (assign, nonatomic) NSSlider *sl;
@property (assign, nonatomic) NSTextField *borderValue;

@property (assign, nonatomic) NSSlider *borderRadiusSlider;
@property (assign, nonatomic) NSTextField *borderRadiusValue;

@property (assign, nonatomic) NSTextField *buttonURLField;

@property (assign, nonatomic) NSColorWell *fontColorWell;
@property (assign, nonatomic) NSPopUpButton *typeFaceName;
@property (assign, nonatomic) NSPopUpButton *typeFaceTrait;

@property (assign, nonatomic) StageView *stageView;
@property(assign) IBOutlet GalleryView *galleryPanel;
@property(assign) IBOutlet LayerPanel *layerPanel;
@property(assign) IBOutlet AttributePanel *attributePanel;
@property(assign) IBOutlet AlignmentPanel *alignmentPanel;
@property(assign) IBOutlet NSPanel *buttonPanel;


@property (assign, nonatomic) NSMutableDictionary *masterDataSource;

// for Data Source Window
@property(assign) NSMutableArray *arrayDataSource;


//@property (assign, nonatomic) NSPopUpButton *layoutType;

//@property (assign, nonatomic) NSNumber *kerningValue;
//@property (assign, nonatomic) NSNumber *leadingValue;

-(IBAction)showBuilderScreen:(id)sender;
-(IBAction)setTypeFaceFamily:(id)sender;
-(IBAction)setTypeStyle:(id)sender;
-(IBAction)setFontTrait:(id)sender;

-(NSNumber *)leadingValue;
-(void)setLeadingValue:(NSNumber *)leadingValueReceived;

-(NSNumber *)kerningValue;
-(void)setKerningValue:(NSNumber *)kerningValueReceived;

-(NSMutableParagraphStyle *)copyOfExistingParagraphStyle:(NSParagraphStyle *)pStyle;

-(IBAction)setAlignmentOfText:(id)sender;

//-(void)updateLeadingMenuAsCursorChanges;


-(void)updateCustomFontMenu:(NSDictionary*)attributes;

- (BOOL)windowShouldClose:(id)sender;
-(IBAction)showColorPanel:(id)sender;
-(void)showButtonPanel;


-(void)clearKerningAndLeadingFields;

/*
 @function:	OnShowShapeAttributePanel
 @purpose:	This function called when the user click the show attribute menu item.
			The purpose is to visible/hide of the shape attribute panel. 
 */
- (IBAction)togglePanelVisibility:(id)sender;

/*
 @function:	OnNewDataSource
 @purpose:	This function called when the user click the new data source menu item.
 */
- (IBAction)OnNewDataSource:(id)sender;

/*
 @function: OnEditDataSource
 @purpose:	This function called when the user click the edit data source menu item.
 */
- (IBAction)OnEditDataSource:(id)sender;


/*
 @function: showDinamicFontTab
 @purpose:	This function add new tab dinamically with parameter view to attribute panel.
 @params:	view : font view in new tab
 */
- (void)showDinamicFontTab:(NSView *)view;

/*
 @function: hideDinamicFontTab
 @purpose:	This function remove font tab from attribute panel.
 */
- (void)hideDinamicFontTab;


@end
