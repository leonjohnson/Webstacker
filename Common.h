//
//  Common.h
//  DrawShape
//
//  Created by Wang Ming on 7/6/12.
//  Copyright (c) 2012 Cosmo Software. All rights reserved.
//

// feature1

#ifndef DrawShape_Common_h
#define DrawShape_Common_h

#define	SAVE_ERROR_MESSAGE                      @"Can't save to file."
#define OPEN_ERROR_MESSAGE                      @"Can't open from file."
#define POPOVER_AVAILABLE                       Class popoverclass = NSClassFromString(@"NSPopover"); 
#define HORIZONTALSORTDESC                      NSSortDescriptor *horizontally = [[NSSortDescriptor alloc] initWithKey:@"xcoordinate" ascending:YES];
#define HORIZONTAL_SORT_DESCRIPTOR_ARRAY        NSArray *horizontalSortDescriptor = [NSArray arrayWithObject: horizontally];

#define PIXEL_BASED_LAYOUT                      @"Pixel"
#define PERCENTAGE_BASED_LAYOUT                 @"Percentage"
#define LAYOUT_KEY                              @"layoutType"
#define PARENT_ID                               @"parentID"
#define STANDARD_BROWSER_FONT_SIZE              12
#define IN_GROUPING_BOX                         @"InGroupingBox"
#define MARGIN_LEFT_AS_A_PERCENTAGE             @"marginLeftAsAPercentage"
#define MARGIN_RIGHT_AS_A_PERCENTAGE            @"marginRightAsAPercentage"
#define WIDTH_AS_A_PERCENTAGE                   @"widthAsPercentage"

#define TEXT_INPUT_FIELD_TAG                    @"textInputField"
#define TEXT_BOX_TAG                            @"TextBox"
#define DIV_TAG                                 @"div" //Box Class
#define BUTTON_TAG                              @"button"
#define CIRCLE_TAG                              @""
#define TRIANGLE_TAG                            @""
#define PARAGRAPH_TAG                           @"paragraph" //TextBox class
#define IMAGE_TAG                               @"image"
#define DYNAMIC_IMAGE_TAG                       @"dynamicImage"
#define DYNAMIC_ROW_TAG                         @"dynamicRow"
#define DROP_DOWN_MENU_TAG                      @"dropDownMenu"
#define CONTAINER_TAG                           @"container"
#define FIRST_IN_ROW_AND_CONTAINER              @"firstInRowAndContainer"
#define LAST_IN_ROW_AND_CONTAINER               @"lastInRowAndContainer"
#define FIRST                                   @"first"
#define LAST                                    @"last"

#define CONTAINER_ID                            @"containerID"
#define ELEMENT_ID                              @"elementID"
#define RT_FRAME                                @"rtframe"

#define TRIGGER                                 @"trigger"
#define IMAGE_TO_DISPLAY                        @"image"
#define DOCUMENTATION                           @"documentation"

#define ACTION                                  @"action"
#define NAME                                    @"name"

#define BUILDER_ICON_SIZE                       17

#define BUILDER_NAME_TAB                        @"name"
#define BUILDER_TRIGGERS_TAB                    @"triggers"
#define BUILDER_COMMANDS_TAB                    @"commands"

//#define XCOORDINATE                             @"xcoordinate"
//#define YCOORDINATE                             @"ycoordinate"



#define IN_RUNNING_LION (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_6)
#define IN_COMPILING_LION __MAC_OS_X_VERSION_MAX_ALLOWED >= 1070

/** -----------------------------------------
 - There are 2 sets of colors, one for an active (key) state and one for an inactivate state
 - Each set contains 3 colors. 2 colors for the start and end of the title gradient, and another color to draw the separator line on the bottom
 - These colors are meant to mimic the color of the default titlebar (taken from OS X 10.6), but are subject
 to change at any time
 ----------------------------------------- **/

#define IN_COLOR_MAIN_START [NSColor colorWithDeviceWhite:0.659 alpha:1.0]
#define IN_COLOR_MAIN_END [NSColor colorWithDeviceWhite:0.812 alpha:1.0]
#define IN_COLOR_MAIN_BOTTOM [NSColor colorWithDeviceWhite:0.318 alpha:1.0]

#define IN_COLOR_NOTMAIN_START [NSColor colorWithDeviceWhite:0.851 alpha:1.0]
#define IN_COLOR_NOTMAIN_END [NSColor colorWithDeviceWhite:0.929 alpha:1.0]
#define IN_COLOR_NOTMAIN_BOTTOM [NSColor colorWithDeviceWhite:0.600 alpha:1.0]

/** Lion */

#define IN_COLOR_MAIN_START_L [NSColor colorWithDeviceWhite:0.66 alpha:1.0]
#define IN_COLOR_MAIN_END_L [NSColor colorWithDeviceWhite:0.9 alpha:1.0]
#define IN_COLOR_MAIN_BOTTOM_L [NSColor colorWithDeviceWhite:0.408 alpha:1.0]

#define IN_COLOR_NOTMAIN_START_L [NSColor colorWithDeviceWhite:0.878 alpha:1.0]
#define IN_COLOR_NOTMAIN_END_L [NSColor colorWithDeviceWhite:0.976 alpha:1.0]
#define IN_COLOR_NOTMAIN_BOTTOM_L [NSColor colorWithDeviceWhite:0.655 alpha:1.0]



//Not available to 10.6 users.
#endif
