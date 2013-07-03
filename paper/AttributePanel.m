#import "AttributePanel.h"
#import "Document.h"
#import "Element.h"
#import "Singleton.h"
#import "AppDelegate.h"
#import "DataSourceWindowController.h"

@implementation AttributePanel


@synthesize changeAttributeDelegate;
@synthesize layoutTypeDisplay;
@synthesize RadioField, RadioSlider, DistanceField, DistanceSlider, OpacityField, OpacitySlider, ColorWell, Direction, BlurField, BlurSlider;
@synthesize _tabView;

- (void)awakeFromNib
{
    NSArray *anArray = [NSArray arrayWithObjects:@"Pixel",@"Percentage", nil];
    //popupButton = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(45, 421, 175, 26) pullsDown:NO];
    //[popupButton setAutoresizingMask:(!NSViewMinXMargin | NSViewMinYMargin)];
    //[popupButton setAction:@selector(setLayout:)];
    
    // TODO: Improve the appearance of the dropdown menu
    for (NSString *title in anArray)
    {
        [layoutTypeDisplay addItemWithTitle:title];
        
    }
    //[self.contentView addSubview:_popupButton];
    
}

/*- (void)setTab:(NSInteger)index
{
	[_tabView selectTabViewItemAtIndex:index];
}*/

#pragma mark - tab view delegate implementation

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
	//[self initDataSource];
}

#pragma mark - for general tab
#pragma mark  stepper signal implementation

/*
 @function:		OnXStepperClicked
 @purpose:		This function called when the user clicked the xStepper
 */
- (IBAction)OnXStepperClicked:(id)sender
{
	/*
    
    
     // UPDATE THE LAST SELECETD ITEM WITH THE RESPECTIVE FIELD
     
    */
    
    CGFloat val = [sender floatValue];
	[xStepper setFloatValue:val];
	[xTextField setFloatValue:val];
	
	CGFloat val1 = [yStepper floatValue];
	[self SetShapeAttributeByStepper:NSMakeSize(val, val1) HitTest:SHT_MOVEAPEX];
     
}

/*
 @function:		OnYStepperClicked
 @purpose:		This function called when the user clicked the yStepper
 */
- (IBAction)OnYStepperClicked:(id)sender
{
	/*
     
     
     // UPDATE THE LAST SELECETD ITEM WITH THE RESPECTIVE FIELD
     
     */
    
    CGFloat val = [sender floatValue];
	[yStepper setFloatValue:val];
	[yTextField setFloatValue:val];
	
	CGFloat val1 = [xStepper floatValue];
	[self SetShapeAttributeByStepper:NSMakeSize(val1, val) HitTest:SHT_MOVEAPEX];
     
}

/*
 @function:		OnWStepperClicked
 @purpose:		This function called when the user clicked the wStepper
 */
- (IBAction)OnWStepperClicked:(id)sender
{
	/*
     
     
     // UPDATE THE LAST SELECETD ITEM WITH THE RESPECTIVE FIELD
     
     */
    Singleton *sg = [[Singleton alloc]init];
    if (sg.currentElement.uType != SHAPE_DROPDOWN) //Drop downs cannot be resized
    {
        CGFloat val = [sender floatValue];
        [wStepper setFloatValue:val];
        [wTextField setFloatValue:val];
        
        CGFloat val1 = [hTextField floatValue];
        [self SetShapeAttributeByStepper:NSMakeSize(val, val1) HitTest:SHT_RESIZE];
    }

}

/*
 @function:		OnHStepperClicked
 @purpose:		This function called when the user clicked the hStepper
 */
- (IBAction)OnHStepperClicked:(id)sender
{
	/*
     
     
     // UPDATE THE LAST SELECETD ITEM WITH THE RESPECTIVE FIELD
     
     */
    
    Singleton *sg = [[Singleton alloc]init];
    if (sg.currentElement.uType != SHAPE_DROPDOWN) //Drop downs cannot be resized
    {
        CGFloat val = [sender floatValue];
        [hStepper setFloatValue:val];
        [hTextField setFloatValue:val];
        
        CGFloat val1 = [wTextField floatValue];
        [self SetShapeAttributeByStepper:NSMakeSize(val1, val) HitTest:SHT_RESIZE];
    }
    
}

-(IBAction)setLayout:(id)sender
{
    NSLog(@"AP got : %@", [sender title]);
    Singleton *sg = [[Singleton alloc]init];
    if (sg != nil)
    {
        sg.currentElement.layoutType =[NSString stringWithString:[sender title]];
        Document *currentDoc = [[NSDocumentController sharedDocumentController] currentDocument];
        [[currentDoc stageView] updateElementWithPercentagesAndAttributesPanelWithElementAttributes:sg.currentElement];
    }
     
}

-(void)updateLayoutDisplay:(Element *)element
{
    
    //[_popupButton selectItemWithTitle:@"Two"];
    
    if ([element.layoutType isEqualToString:@"Percentage"])
    {
        [layoutTypeDisplay selectItemWithTitle: @"Percentage"];
        NSLog(@"PC = %@", layoutTypeDisplay);
    }
    
    if ([element.layoutType isEqualToString:@"Pixel"])
    {
        [layoutTypeDisplay selectItemWithTitle:@"Pixel"];
        NSLog(@"PX = %@", layoutTypeDisplay);
    }
    
    
}

#pragma mark stepper setting implementation

/*
 @function:		SetStepperValue
 @params:		x:	value of the xStepper
				y:	value of the yStepper
				w:	value of the wStepper
				h:	value of the hStepper
 @return:		nothing
 @purpos:		This function set the value of the steppers
 */
- (void)SetStepperValue:(CGFloat)x yPos:(CGFloat)y Width:(CGFloat)w Height:(CGFloat)h
{
	[xStepper setFloatValue:x];
	[xTextField setFloatValue:x];
	
	[yStepper setFloatValue:y];
	[yTextField setFloatValue:y];
	
	[wStepper setFloatValue:w];
	[wTextField setFloatValue:w];
	
	[hStepper setFloatValue:h];
	[hTextField setFloatValue:h];
}

-(CGSize)stepperValues
{
    CGSize stepperValues = CGSizeMake(wTextField.floatValue, hTextField.floatValue);
    return stepperValues;
}

/*
 @function:		SetShapeAttributeByStepper
 @params:		offset:		The value to change
				hitTest:	The type of value (Moving: SHT_MOVEAPEX, Resizing: SHT_RESIZE)
 @return:		void
 @purpos:		This function set the attribute of the shape by stepper value
 */
- (void)SetShapeAttributeByStepper:(NSSize)offset HitTest:(NSInteger)hitTest;
{
	//[changeAttributeDelegate ChangeAttribueOfElement:offset HitTest:hitTest];
    NSLog(@"passing through");
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc ChangeAttribueOfElement:offset HitTest:hitTest];
}


#pragma mark set attribute delegate implementation

/*
 @function:		SetAttributeOfShapeToPanel
 @params:		x:	x position of the current shape
				y:	y position of the current shape
				w:	with of the current shape
				h:	height of the current shape
 @return:		void
 @purpose:		This function called from StageView when the shape's attribute(position, size) is changed
				by mouse drag and drop.
				This function set the position and size of the shape to stepper.
 */
- (void)SetAttributeOfShapeToPanel:(CGFloat)x yPos:(CGFloat)y Width:(CGFloat)w Height:(CGFloat)h URL:(NSString*)url
{
	[self SetStepperValue:x yPos:y Width:w Height:h];
    [urlTextField setStringValue:url];
}


#pragma mark - effect tab

/*
 @function:		OnRadioSlider
 @purpose:		This function called when the user controls the Radio Slider
 */
- (IBAction)OnRadioSlider:(id)sender
{
	NSInteger intVal = [sender integerValue];
	[RadioSlider setIntegerValue:intVal];
	[RadioField setIntegerValue:intVal];
	
	NSColor *curColor = [ColorWell color];
	CGFloat r, g, b, alpha;
	[curColor getRed:&r green:&g blue:&b alpha:&alpha];
	
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc.stageView drawShapeShadow:[RadioField floatValue]
							 Distance:[DistanceField floatValue]
							   ColorR:r ColorG:g ColorB:b
							  Opacity:[OpacityField floatValue]
								 Blur:[BlurField floatValue]
							Direction:([[Direction selectedCell] tag] == 0)? YES: NO
								Index:indexOfShadow];
}

/*
 @function:		OnBlurSlider
 @purpose:		This function called when the user controls the Blur Slider
 */
- (IBAction)OnBlurSlider:(id)sender
{
	CGFloat floatVal = [sender floatValue];
	[BlurSlider setFloatValue:floatVal];
	[BlurField setFloatValue:floatVal];
	
	NSColor *curColor = [ColorWell color];
	CGFloat r, g, b, alpha;
	[curColor getRed:&r green:&g blue:&b alpha:&alpha];
	
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc.stageView drawShapeShadow:[RadioField floatValue]
							 Distance:[DistanceField floatValue]
							   ColorR:r ColorG:g ColorB:b
							  Opacity:[OpacityField floatValue]
								 Blur:[BlurField floatValue]
							Direction:([[Direction selectedCell] tag] == 0)? YES: NO
								Index:indexOfShadow];
}


/*
 @function:		OnDistanceSlider
 @purpose:		This function called when the user controls the Distance Slider
 */
- (IBAction)OnDistanceSlider:(id)sender
{
	CGFloat intVal = [sender floatValue];
	[DistanceSlider setFloatValue:intVal];
	[DistanceField setFloatValue:intVal];
	
	NSColor *curColor = [ColorWell color];
	CGFloat r, g, b, alpha;
	[curColor getRed:&r green:&g blue:&b alpha:&alpha];
	
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc.stageView drawShapeShadow:[RadioField floatValue]
							 Distance:[DistanceField floatValue]
							   ColorR:r ColorG:g ColorB:b
							  Opacity:[OpacityField floatValue]
								 Blur:[BlurField floatValue]
							Direction:([[Direction selectedCell] tag] == 0)? YES: NO
								Index:indexOfShadow];
}


/*
 @function:		OnColorChange
 @purpose:		This function called when the user clicked the Color Well
 */
- (IBAction)OnColorChange:(id)sender
{
	NSColor *curColor = [sender color];
	CGFloat r, g, b, alpha;
	[curColor getRed:&r green:&g blue:&b alpha:&alpha];
	
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc.stageView drawShapeShadow:[RadioField floatValue]
							 Distance:[DistanceField floatValue]
							   ColorR:r ColorG:g ColorB:b
							  Opacity:[OpacityField floatValue]
								 Blur:[BlurField floatValue]
							Direction:([[Direction selectedCell] tag] == 0)? YES: NO
								Index:indexOfShadow];
}


/*
 @function:		OnOpacitySlider
 @purpose:		This function called when the user controls the Opacity Slider
 */
- (IBAction)OnOpacitySlider:(id)sender
{
	CGFloat intVal = [sender floatValue];
	[OpacitySlider setFloatValue:intVal];
	[OpacityField setFloatValue:intVal];
	
	NSColor *curColor = [ColorWell color];
	CGFloat r, g, b, alpha;
	[curColor getRed:&r green:&g blue:&b alpha:&alpha];
	
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc.stageView drawShapeShadow:[RadioField floatValue]
							 Distance:[DistanceField floatValue]
							   ColorR:r ColorG:g ColorB:b
							  Opacity:[OpacityField floatValue]
								 Blur:[BlurField floatValue]
							Direction:([[Direction selectedCell] tag] == 0)? YES: NO
								Index:indexOfShadow];
}


/*
 @function:		OnDirectionChange
 @purpose:		This function called when the user clicked the Direction Matrix
 */
- (IBAction)OnDirectionChange:(id)sender
{
	id cell = [sender selectedCell];
	BOOL isOutset;
	if ([cell tag] == 0) { // outset shadow
		isOutset = YES;
	} else if ([cell tag] == 1) { // inset shadow
		isOutset = NO;
	}
	
	NSColor *curColor = [ColorWell color];
	CGFloat r, g, b, alpha;
	[curColor getRed:&r green:&g blue:&b alpha:&alpha];
	
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc.stageView drawShapeShadow:[RadioField floatValue]
							 Distance:[DistanceField floatValue]
							   ColorR:r ColorG:g ColorB:b
							  Opacity:[OpacityField floatValue]
								 Blur:[BlurField floatValue]
							Direction:isOutset
								Index:indexOfShadow];
}

/*
 @function:		OnAddShadow
 @purpose:		This function called when the user clicked the Create New Shadow Button
 */
- (IBAction)OnAddShadow:(id)sender
{
	NSLog(@"SHADOW BEING ADDED");
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    //NSArray *selectedElements = [[curDoc stageView] selElementArray];
    //for (Element *ele in selectedElements) {
    //    [ele addShapeShadow:0 Distance:15.0 ColorR:0 ColorG:0 ColorB:0 Opacity:1.0 Blur:10 Direction:YES];
    //}
	[curDoc.stageView addShapeShadow:0 Distance:15.0 ColorR:0 ColorG:0 ColorB:0 Opacity:1.0 Blur:10 Direction:YES];
	
	[_tableViewShadowList reloadData];
	
	[self tableView:_tableViewShadowList shouldSelectRow:([_arrayShadows count] - 1)];
}

/*
 @function:		OnRemoveShadow
 @purpose:		This function called when the user clicked the Remove Button
 */
- (IBAction)OnRemoveShadow:(id)sender
{
	NSInteger index = [_tableViewShadowList selectedRow];
	if (index < 0) {
		return;
	}
	
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc.stageView removeShapeShadow:index];
}



#pragma mark set shadow property delegate implementation

/*
 @function:		setShadowProperty
 @params:		angle:		shadow angle
 dist:		shadow distance
 r, g, b, alpha: color property of shadow
 direct:		shadow direction, if it's YES, outset. otherwise inset.
 index:		shadow index of the shape
 @return:		void
 @purpose:		This funcation set the shape's shadow property to shadow panel.
 */
- (void)setShadowProperty:(CGFloat)angle Distance:(CGFloat)dist colorR:(CGFloat)r colorG:(CGFloat)g colorB:(CGFloat)b Opacity:(CGFloat)alpha Blur:(CGFloat)blur Direct:(BOOL)d Index:(NSInteger)index
{
	[RadioField setFloatValue:angle];
	[RadioSlider setFloatValue:angle];
	
	[DistanceField setFloatValue:dist];
	[DistanceSlider setFloatValue:dist];
	
	[ColorWell setColor:[NSColor colorWithCalibratedRed:r green:g blue:b alpha:1.0]];
	
	[OpacityField setFloatValue:alpha];
	[OpacitySlider setFloatValue:alpha];
	
	[BlurField setFloatValue:blur];
	[BlurSlider setFloatValue:blur];
	
	if (d == YES) {
		[Direction setSelectionFrom:1 to:1 anchor:0 highlight:YES];
	} else {
		[Direction setSelectionFrom:0 to:0 anchor:0 highlight:YES];
	}
	
	indexOfShadow = index;
}


/*
 @function:		setShadowList
 @params:		shadowList:		shape's shadow array
 @return:		void
 @purpose:		This function set the shape's shadow list to table view.
 */
- (void)setShadowList:(NSArray *)shadowList
{
	if (_arrayShadows != nil) {
		[_arrayShadows release];
		_arrayShadows = nil;
	}
	
	if (shadowList != nil) {
		_arrayShadows = [[NSMutableArray alloc] initWithArray:shadowList];
	}
	
	[_tableViewShadowList reloadData];
}



#pragma mark - table view data source implementation

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	if (tableView == _tableViewShadowList) {
		if (_arrayShadows == nil) {
			return 0;
		}
		
		return [_arrayShadows count];
	}
	
	return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	if (tableView == _tableViewShadowList) {
		if ([[tableColumn identifier] isEqualToString:@"Shadow"]) {
			NSString *string = [NSString stringWithFormat:@"Shadow %ld", row];
			
			return string;
		}
	}
	
	return nil;
}



#pragma mark - table view delegate implementation

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	if (tableView == _tableViewShadowList) {
		if ([[tableColumn identifier] isEqualToString:@"Shadow"]) {
			NSTextField *viewName = [tableView makeViewWithIdentifier:[NSString stringWithFormat:@"ShadowTableViewNameCell%ld", row] owner:self];
			if (viewName == nil) {
				viewName = [[[NSTextField alloc] init] autorelease];
				viewName.identifier = [NSString stringWithFormat:@"ShadowTableViewNameCell%ld", row];
			}
			
			[viewName setBordered:NO];
			[viewName setEditable:NO];
			[viewName setBackgroundColor:[NSColor clearColor]];
			
			viewName.stringValue = [NSString stringWithFormat:@"Sahdow %ld", row];
			
			return viewName;
		}
	}
	
	return nil;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row;
{
	if (tableView == _tableViewShadowList) {
		NSDictionary *dict = [_arrayShadows objectAtIndex:row];
		
		BOOL direction = [[dict valueForKey:@"Direction"] boolValue];
		CGFloat angle = [[dict valueForKey:@"Angle"] floatValue];
		CGFloat distance = [[dict valueForKey:@"Distance"] floatValue];
		CGFloat RColor = [[dict valueForKey:@"RColor"] floatValue];
		CGFloat GColor = [[dict valueForKey:@"GColor"] floatValue];
		CGFloat BColor = [[dict valueForKey:@"BColor"] floatValue];
		CGFloat opacity = [[dict valueForKey:@"Opacity"] floatValue];
		CGFloat blur = [[dict valueForKey:@"Blur"] floatValue];
		
		[self setShadowProperty:angle Distance:distance colorR:RColor colorG:GColor colorB:BColor Opacity:opacity Blur:blur Direct:direction Index:row];
	}
	
	return YES;
}


#pragma mark - tab button action implementation

- (IBAction)OnGeneralTab:(id)sender
{
	[_tabView selectTabViewItemAtIndex:0];
}

- (IBAction)OnEffectTab:(id)sender
{
	[_tabView selectTabViewItemAtIndex:1];
}

- (IBAction)OnDataTab:(id)sender
{
	[_tabView selectTabViewItemAtIndex:2];
}

- (IBAction)OnContextualTab:(id)sender
{
	[_tabView selectTabViewItemAtIndex:3];
}


#pragma mark - NSTextField delegate implementation

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
	Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
	[curDoc.stageView ChangeURLStringOFElement:urlTextField.stringValue];
	
	return YES;
}

@end
