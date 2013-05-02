//
//  Document.m
//  DrawShap
//
//  Created by Wang Ming on 7/16/12.
//  Copyright (c) 2012 Cosmo Software. All rights reserved.
//

#import "Document.h"
#import "Common.h"
#import "AppDelegate.h"
#import "DocumentWindowController.h"
#import "TextBox.h"
#import "CustomRulerView.h"
#import "BuilderWindowController.h"

@implementation Document


@synthesize mainStageScrollView;
@synthesize stageView;
@synthesize RulerVisible;
@synthesize GridLineVisible;
@synthesize scale;
@synthesize sg;
@synthesize darkButtons;
@synthesize titleView;

- (id)init
{
    self = [super init];
    if (self) {
		// Add your subclass-specific initialization here.
		// If an error occurs here, return nil.
		scale = 100;
    }
    self.elementsReferedToInBuilderScripts = [NSMutableSet new];
    

    return self;
}

/*
 @function:		initWithData
 @params:		void
 @return:		void
 @purpose:		This function calls when the document's initialize.
 dataFromFile isn't nil, stage view created by dataFromFile.
 */
- (void)initWithData
{
	if (dataFromeFile) {
		//[stageView OpenProjectFromFile:dataFromeFile];
		[dataFromeFile release];
		dataFromeFile = nil;
		scale = 100;
	}
    
}

/*
- (NSString *)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"Document";
}

*/
- (void)makeWindowControllers
{
	DocumentWindowController *mainWindowController = [[DocumentWindowController alloc] initWithWindowNibName:@"Document" owner:self];
    [mainWindowController setShouldCloseDocument:NO];
    
    
    
    [self addWindowController:mainWindowController];
	
	
}


-(void)showBuilderScreen
{
    
    NSLog(@"gonna try and show the builder screen");
    BuilderWindowController *builderWindowController = [[BuilderWindowController alloc] initWithWindowNibName:@"Builder" owner:self];
    [builderWindowController setShouldCloseDocument:NO];
    [self addWindowController:builderWindowController];
    [builderWindowController showWindow:self];
    NSLog(@"Done with showBuilderScreen");
}


- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];

	// Add any code here that needs to be executed once the windowController has loaded the document's window.
	
    
    NSWindowController *controller = [[self windowControllers] objectAtIndex:0];
    INAppStoreWindow *window = (INAppStoreWindow *)[controller window];
    window.titleBarHeight = 40.f;
    
    /*
    NSView *titleBarView = window.titleBarView;
    self.titleView.frame = window.titleBarView.bounds;
    self.titleView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [window.titleBarView addSubview:self.titleView];
    
    
    NSSize buttonSize = NSMakeSize(100.f, 100.f);
    NSRect buttonFrame = NSMakeRect(NSMidX(titleBarView.bounds) - (buttonSize.width / 2.f), NSMidY(titleBarView.bounds) - (buttonSize.height / 2.f), buttonSize.width, buttonSize.height);
    NSButton *button = [[NSButton alloc] initWithFrame:buttonFrame];
    //[button setTitle:@"A Button"];
    [button setTarget:stageView];
    [button setAction:@selector(hey)];
    darkButtons = [[DarkTitleViewButtons  alloc]init];
    [button setCell:darkButtons];
    [titleBarView addSubview:button];
    */
    
    //
    /*
    NSSize segmentSize = NSMakeSize(104, 25);
    NSRect segmentFrame = NSMakeRect(NSMidX(titleBarView.bounds) - (segmentSize.width / 2.f),
                                     NSMidY(titleBarView.bounds) - (segmentSize.height / 2.f),
                                     segmentSize.width, segmentSize.height);
    NSButton *button = [[NSButton alloc] initWithFrame:segmentFrame];
    [titleBarView addSubview:button];
    
    NSSegmentedControl *segment = [[NSSegmentedControl alloc] initWithFrame:segmentFrame];
    [segment setSegmentCount:3];
    [segment setImage:[NSImage imageNamed:NSImageNameIconViewTemplate] forSegment:0];
    [segment setImage:[NSImage imageNamed:NSImageNameListViewTemplate] forSegment:1];
    [segment setImage:[NSImage imageNamed:NSImageNameFlowViewTemplate] forSegment:2];
    [segment setSelectedSegment:0];
    [segment setSegmentStyle:NSSegmentStyleTexturedRounded];
    [titleBarView addSubview:segment];
    */
    
	// Insert code here to initialize your application
	
    NSLog(@"Called as 2. Just loaded :  %@", aController);
    galleryView.delegate = stageView;
	
	GridLineVisible = YES;
	RulerVisible = YES;
	
	// set ruler of main stage's scroll view
	[mainStageScrollView setDocumentView:stageView];
	
	[mainStageScrollView setRulersVisible:YES];
	
	CustomRulerView *vertRulerView = [[CustomRulerView alloc] initWithScrollView:mainStageScrollView orientation:NSVerticalRuler];
	//[vertRulerView setFrame:NSMakeRect(0, 30, 30, mainStageScrollView.frame.size.height - 30)];
	[vertRulerView setMeasurementUnits:@"Points"];
	[mainStageScrollView setVerticalRulerView:vertRulerView];
	
	CustomRulerView *horzRulerView = [[CustomRulerView alloc] initWithScrollView:mainStageScrollView orientation:NSHorizontalRuler];
	//[horzRulerView setFrame:NSMakeRect(30, 0, mainStageScrollView.frame.size.width - 30, 30)];
	[horzRulerView setMeasurementUnits:@"Points"];
	[mainStageScrollView setHorizontalRulerView:horzRulerView];
	
	/*[mainStageScrollView setHasHorizontalRuler:YES];
	[mainStageScrollView setHasVerticalRuler:YES];
	
	NSRulerView* horzRulerView = [mainStageScrollView horizontalRulerView];
	[horzRulerView setMeasurementUnits:@"Points"];
	NSRulerView* vertRulerView = [mainStageScrollView verticalRulerView];
	[vertRulerView setMeasurementUnits:@"Points"];*/
	
	AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
	stageView.attributeDelegate = appDelegate.attributePanel;
    stageView.layerDelegate = appDelegate.layerPanel; // THIS WAS THE MISSING LAYER TO MAKE THE DELEGATE WORK!!!
	//stageView.shadowDelegate = appDelegate.shadowPanel;
	[appDelegate.attributePanel SetStepperValue:0.0 yPos:0.0 Width:0.0 Height:0.0];
	//[appDelegate.shadowPanel setShadowProperty:0 Distance:0 colorR:0 colorG:0 colorB:0 Opacity:0 Blur:0 Direct:YES];
	
	[self initWithData];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	/*
	 Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
	You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
	*/
	
	return [stageView SaveProjectToFile:typeName];
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	/*
	Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
	You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
	*/
	
	dataFromeFile = [[NSData alloc] initWithData:data];
	
	return YES;
}

#pragma mark - window delegate implementation

- (void)windowDidBecomeKey:(NSNotification *)notification
{
	[stageView ResortLayer];
	AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
	appDelegate.galleryPanel.delegate = stageView;
}

-(NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize
{
    
    for (Element *e in self.stageView.elementArray)
    {
        if ([[e layoutType] isEqualToString:PERCENTAGE_BASED_LAYOUT])
        {
            [[self stageView] updateSizeInPixelsWhenScrollViewSizeChangess:e];
            
        }
    }
    [self.stageView setNeedsDisplay:YES];
    
    return frameSize;
}



#pragma mark - set property of stage view

/*
 @function:		SetScaleStageView
 @prarms:		nScale
 @return:		void
 @purpos:		This function zoom in/out stage view with nScale
 */
- (void)SetScaleStageView:(NSInteger)nScale
{
	/*scale = nScale;
	CGFloat zoomFactor = scale / 100;
	
	NSRect visible = [mainStageScrollView documentVisibleRect];
	NSRect frame = [mainStageScrollView.documentView frame];
	NSRect newRect;
	
	if (zoomFactor >= 1) {
		newRect = NSInsetRect(visible, -NSWidth(visible) * (zoomFactor - 1) / 2.0 , -NSHeight(visible) * (zoomFactor - 1) / 2.0);
	} else {
		newRect = NSInsetRect(visible, NSWidth(visible) * (1 - 1 / zoomFactor) / 2.0 , NSHeight(visible) * (1 - 1 / zoomFactor) / 2.0);
	}
	
	[mainStageScrollView.documentView scaleUnitSquareToSize:NSMakeSize(zoomFactor, zoomFactor)];
	
	if (zoomFactor >= 1) {
		[mainStageScrollView.documentView setFrame:NSMakeRect(0, 0, frame.size.width / zoomFactor, frame.size.height / zoomFactor)];
	} else {
		[mainStageScrollView.documentView setFrame:NSMakeRect(0, 0, frame.size.width * zoomFactor, frame.size.height * zoomFactor)];
	}
	
	[[mainStageScrollView documentView] scrollPoint:newRect.origin];*/
	CGSize szMainStage = [self.mainStageScrollView bounds].size;
	CGSize size = NSMakeSize(szMainStage.width * nScale / 100, szMainStage.height * nScale / 100);
	CGRect rtStage = CGRectMake((szMainStage.width <= size.width)? 0:(szMainStage.width - size.width) / 2,
								(szMainStage.height <= size.height)? 0:(szMainStage.height - size.height) / 2,
								size.width, size.height);
	
	[self.stageView setFrame:rtStage];
}


/*
 @function:		SetSizeStageView
 @params:		size
 @return:		void
 @purpos:		This function set size of stage view with size param
 */
- (void)SetSizeStageView:(CGSize)size
{
	CGSize szMainStage = [self.mainStageScrollView bounds].size;
	CGRect rtStage = CGRectMake((szMainStage.width <= size.width)? 0:(szMainStage.width - size.width) / 2,
								(szMainStage.height <= size.height)? 0:(szMainStage.height - size.height) / 2,
								size.width, size.height);
	
	[self.stageView setFrame:rtStage];
	
	//[self.mainStageScrollView.horizontalRulerView setOriginOffset:-rtStage.origin.x];
	//[self.mainStageScrollView.verticalRulerView setOriginOffset:-rtStage.origin.y];
	//CGRect rt = [[self.mainStageScrollView contentView] frame];
	
	//[self.mainStageScrollView.contentView setBoundsOrigin:CGPointMake(rtStage.origin.x, rtStage.origin.y)];
	//[self.mainStageScrollView.contentView setFrame:rtStage];
	//[self.stageView setFrame:rtStage];
	//[self.stageView setFrame:CGRectMake(0, 0, rtStage.size.width, rtStage.size.height)];
	//[self.mainStageScrollView.contentView setFrame:rtStage];
	//[self.mainStageScrollView.documentView setFrame:rtStage];
	//[[mainStageScrollView documentView] scrollPoint:rtStage.origin];
	//[[self.mainStageScrollView contentView] setBounds:NSMakeRect(rtMainStage.origin.x, rtMainStage.origin.y, szMainStage.width, szMainStage.height)];
	//[[self.mainStageScrollView contentView] setBoundsOrigin:NSMakePoint(rtStage.origin.x, rtStage.origin.y)];
	
	/*const CGFloat midX = NSMidX([mainStageScrollView.documentView bounds]);
	const CGFloat midY = NSMidY([mainStageScrollView.documentView bounds]);
	
	const CGFloat halfWidth = NSWidth([mainStageScrollView.contentView frame]) / 2.0;
	const CGFloat halfHeight = NSHeight([mainStageScrollView.contentView frame]) / 2.0;
	
	NSPoint newOrigin;
	if ([[mainStageScrollView documentView] isFlipped]) {
		newOrigin = NSMakePoint(midX - halfWidth, midY + halfHeight);
	} else {
		newOrigin = NSMakePoint(midX - halfWidth, midY - halfHeight);
	}
	
	CGRect rtStage = [[mainStageScrollView documentView] bounds];
	[[mainStageScrollView documentView] setBounds:NSMakeRect(rtStage.origin.x, rtStage.origin.y, size.width, size.height)];
	[[mainStageScrollView documentView] scrollPoint:newOrigin];*/
}


#pragma mark - advanced shape operation implementation

/*
 @function:		createAdvancedShape
 @params:		filename:	image file name to create a advanced shape
 rt:			bound rect of the new advanced shape
 @return:       void
 @purpose:		This function calls the stage view's createAdvancedShape
 */
- (void)createAdvancedShape:(NSString*)filename rtBound:(NSRect)rt
{
//	[stageView CreateAdvancedShape:filename rtBound:rt];
}


/*
 @function:		CreateGroupingBox
 @params:		void
 @return:		void
 @purpose:		This function create the group box with selected shapes when the user click the grouping box menu item.
 */
- (void)CreateGroupingBox
{
	//[stageView CreateGroupingBox];
}


/*
 @function:		drawShapeShadow
 @params:		angle:		shadow angle
				dist:		shadow distance
				r, g, b, alpha: color property of shadow
				direct:		shadow direction, if it's YES, outset. otherwise inset.
 @return:		void
 @purpose:		This funcation draws the shadow of shape with params.
 */
- (void)drawShapeShadow:(CGFloat)angle Distance:(CGFloat)dist ColorR:(CGFloat)r ColorG:(CGFloat)g ColorB:(CGFloat)b Opacity:(CGFloat)alpha Blur:(CGFloat)blur Direction:(BOOL)d
{
	//[stageView drawShapeShadow:angle Distance:dist ColorR:r ColorG:g ColorB:b Opacity:alpha Blur:blur Direction:d];
}


#pragma mark - attribute panel button action implementation

/*
 @function:		ChangeAttribueOfShape
 @params:		offset:		The value to change
 hitTest:	The type of value (Moving: SHT_MOVEAPEX, Resizing: SHT_RESIZE)
 @return:		void
 @purpos:		This function called stage view's ChangeAttributeOfShape function
 */
- (void)ChangeAttribueOfElement:(CGSize)offset HitTest:(NSInteger)hitTest
{
	[stageView ChangeAttribueOfElement:offset HitTest:hitTest];
}




#pragma mark - alignment panel button action implementation

/*
 @function: OnAlignLeftButton
 @purpos:	The purpos is to align left of selected shapes.
 */
- (void)OnAlignLeftButton
{
	[stageView AlignElements:ALIGN_LEFT];
}


/*
 @function: OnAlignRightButton
 @purpos:	The purpos is to align right of selected shapes.
 */
- (void)OnAlignRightButton
{
	[stageView AlignElements:ALIGN_RIGHT];
}


/*
 @function: OnAlignCenterVertButton
 @purpos:	The purpos is to align center vertically of selected shapes.
 */
- (void)OnAlignCenterVertButton
{
	[stageView AlignElements:ALIGN_VERT];
}


/*
 @function: OnAlignTopButton
 @purpos:	The purpos is to align top of selected shapes.
 */
- (void)OnAlignTopButton
{
	[stageView AlignElements:ALIGN_TOP];
}


/*
 @function: OnAlignBottomButton
 @purpos:	The purpos is to align bottom of selected shapes.
 */
- (void)OnAlignBottomButton
{
	[stageView AlignElements:ALIGN_BOTTOM];
}


/*
 @function:	OnAlignCenterHorzButton
 @purpos:	The pupos is to align center horizently of selected shapes.
 */
- (void)OnAlignCenterHorzButton
{
	[stageView AlignElements:ALIGN_HORZ];
}


/*
 @function: OnAlignDistributionLeftButton
 @purpos:	The purpos is to distribution left of selected shapes.
 */
- (void)OnAlignDistributionLeftButton
{
	[stageView DistributionElement:DISTRIBUTION_LEFT];
}


/*
 @function: OnAlignDistributionRightButton
 @purpos:	The purpos is to distribution right of selected shapes.
 */
- (void)OnAlignDistributionRightButton
{
	[stageView DistributionElement:DISTRIBUTION_RIGHT];
}


/*
 @function: OnAlignDistributionCenterButton
 @purpos:	The purpos is to distribution center of selected shapes.
 */
- (void)OnAlignDistributionCenterButton
{
	[stageView DistributionElement:DISTRIBUTION_CENTER];
}


/*
 @function:	OnSpaceEvenlyHorzButton
 @purpos:	The purpos is to make the same space horizentaly of selected shapes.
 */
- (void)OnSpaceEvenlyHorzButton:(NSInteger)spacing
{
	[stageView SpaceEvenlyElement:spacing flag:SPACING_HORZ];
}


/*
 @function: OnSpaceEvenlyVertButton
 @purpos:	The purpos is to make the same space vertically of selected shapes.
 */
- (void)OnSpaceEvenlyVertButton:(NSInteger)spacing
{
	[stageView SpaceEvenlyElement:spacing flag:SPACING_VERT];
}


- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem
{
    SEL theAction = [anItem action];
    NSLog(@"The Action is : %@", NSStringFromSelector(theAction));
    
    if (theAction == @selector(saveDocument:) || theAction == @selector(saveDocumentAs:) )
    {
        NSLog(@"Saying No");
        return NO;
    }
    
    
    if (theAction == @selector(cut:))
    {
        
        if (stageView.selElementArray.count > 1 )
        {
            NSLog(@"Can't cut or copy objects");
            return NO;
        }
        
        if (stageView.selElementArray.count == 1 && [[[stageView selElementArray] objectAtIndex:0] isMemberOfClass:[TextBox class]] == NO)
        {
            return NO;
        }
    }
    
    if (theAction == @selector(copy:) )
    {
        NSLog(@"COPY DISABLED");
        return NO;
    }
    
    
    return [super validateUserInterfaceItem:anItem];
}









@end
