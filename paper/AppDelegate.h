#import <AppKit/AppKit.h>
#import "AttributePanel.h"
#import "AlignmentPanel.h"
#import "LayerPanel.h"
#import "GalleryView.h"
#import "StageView.h"
#import "Singleton.h"
#import "DataSourcePanel.h"
#import "ABNotifier.h"

@class DocumentBar;


#define ATTRIBUTE_SHOW_MENU				100
#define ALIGNMENT_SHOW_MENU				101
#define GRIDLINE_SHOW_MENU				102
#define RULER_SHOW_MENU					103

@interface AppDelegate : NSObject <NSApplicationDelegate, ABNotifierDelegate>
{

	Singleton *sg;
    IBOutlet DocumentBar                *__strong dBar;
    
    IBOutlet GalleryView				*__strong galleryPanel;
	IBOutlet StageView					*__strong stageView;
	IBOutlet AttributePanel				*__strong attributePanel;
	BOOL								attributePanelVisible;
	
	IBOutlet AlignmentPanel				*__strong alignmentPanel;
    BOOL								alignmentPanelVisible;
    
	IBOutlet NSTextField				*spacingTextField;
    
    IBOutlet NSColorWell                *__strong fontColorWell;
    IBOutlet NSPanel					*fontPanel;
    IBOutlet NSPopUpButton              *__strong typeFaceName;
    IBOutlet NSPopUpButton              *__strong typeFaceTrait;
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
    
    IBOutlet NSColorWell *__strong pl;
    NSNumber *__strong nu;
    
    IBOutlet NSTextField                *fontSizeTextField2;
    IBOutlet NSComboBox *__strong fontSizeComboBox;
    
    //For the border width
    IBOutlet NSSlider *borderWidthSlider;
    IBOutlet NSTextField *borderWidthValue;
    IBOutlet NSMatrix *borderSelection;
    
    //For the border radius
    IBOutlet NSSlider *__strong borderRadiusSlider;
    IBOutlet NSMatrix *borderCornerSelection;
    IBOutlet NSTextField *__strong borderRadiusValue;
    
    IBOutlet NSButtonCell *topLeftRadius;
    IBOutlet NSButtonCell *topRightRadius;
    IBOutlet NSButtonCell *bottomRightRadius;
    IBOutlet NSButtonCell *bottomLeftRadius;
    
    
    //For the Button
    IBOutlet NSTextField *__strong buttonURLField;
    IBOutlet NSTextField *buttonLabel;
    IBOutlet NSPanel *__strong buttonPanel;
    
    
    //For the border radius
    IBOutlet NSSlider *opacitySlider;
    IBOutlet NSMatrix *opacitySelection;
    IBOutlet NSTextField *opacityValue;
    
    //For the color inputbox
    IBOutlet NSTextField *__strong colorHexValue;
    
    //For the ID label
    IBOutlet NSTextField *__strong elementidField;
    IBOutlet NSTextField *__strong labelWarningField;
        
    //Layout type - px or %
    //IBOutlet NSPopUpButton *layoutType;
    
    //data fields
    IBOutlet NSComboBox *__strong actionField;
    IBOutlet NSComboBox *__strong dataSourceField;
    IBOutlet NSTextField *__strong visibilityField;
    
	BOOL isRestored;
}

// Labels on Attributes Panel
@property (strong) IBOutlet NSTextField *xCoordinateLabel;
@property (strong) IBOutlet NSTextField *yCoordinateLabel;
@property (strong) IBOutlet NSTextField *layoutTypeLabel;
@property (strong) IBOutlet NSTextField *widthLabel;
@property (strong) IBOutlet NSTextField *heightLabel;
@property (strong) IBOutlet NSTextField *backgroundColorLabel;
@property (strong) IBOutlet NSTextField *borderWidthLabel;
@property (strong) IBOutlet NSTextField *borderRadiusLabel;
@property (strong) IBOutlet NSTextField *topLeftLabel;
@property (strong) IBOutlet NSTextField *topRightLabel;
@property (strong) IBOutlet NSTextField *bottomLeftLabel;
@property (strong) IBOutlet NSTextField *bottomRightLabel;
@property (strong) IBOutlet NSTextField *tagLabel;
@property (strong) IBOutlet NSTextField *currentlySelectedLabel;
@property (strong) IBOutlet NSTextView *cssOverride;



@property(strong) IBOutlet NSComboBox *actionField;
@property(strong) IBOutlet NSComboBox *dataSourceField;
@property(strong) IBOutlet NSTextField *visibilityField;

@property (strong) IBOutlet NSTextField *colorHexValue;
@property (strong) IBOutlet NSTextField *labelWarningField;
@property (strong) IBOutlet NSTextField *elementidField;

@property (strong) IBOutlet NSColorWell *borderColour; 
@property (strong) IBOutlet NSTextField *borderHexValue;;

@property(strong) IBOutlet DataSourcePanel *dataSourcePanel;




@property (strong, nonatomic) DocumentBar *dBar;

@property ( nonatomic) Singleton *sg;

@property (strong, nonatomic) NSColorWell *pl;
@property (strong, nonatomic) NSNumber *nu;
@property (strong, nonatomic) NSComboBox *fontSizeComboBox;

@property (strong, nonatomic) NSSlider *sl;
@property (strong, nonatomic) NSTextField *borderValue;

@property (strong, nonatomic) NSSlider *borderRadiusSlider;
@property (strong, nonatomic) NSTextField *borderRadiusValue;

@property (strong, nonatomic) NSTextField *buttonURLField;

@property (strong, nonatomic) NSColorWell *fontColorWell;
@property (strong, nonatomic) NSPopUpButton *typeFaceName;
@property (strong, nonatomic) NSPopUpButton *typeFaceTrait;

@property (strong, nonatomic) StageView *stageView;
@property(strong) IBOutlet GalleryView *galleryPanel;
@property(strong) IBOutlet LayerPanel *layerPanel;
@property(strong) IBOutlet AttributePanel *attributePanel;
@property(strong) IBOutlet AlignmentPanel *alignmentPanel;

@property(strong) IBOutlet NSPanel *buttonPanel;

@property (strong) IBOutlet NSProgressIndicator *progressIndicator;


@property (strong, nonatomic) NSMutableDictionary *masterDataSource;

// for Data Source Window
@property(strong) NSMutableArray *arrayDataSource;

@property (strong, nonatomic) NSMutableArray *actionsArray;
//@property (assign, nonatomic) NSPopUpButton *layoutType;

//@property (assign, nonatomic) NSNumber *kerningValue;
//@property (assign, nonatomic) NSNumber *leadingValue;

@property (strong, nonatomic) NSPanel *conversionProgressScreen;
@property (strong, nonatomic) NSTextField *statusMessage; 
@property (strong, nonatomic) NSTextField *percentCompleteMessage;

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

- (void)OpenNewDocument:(CGFloat)width;

@end
