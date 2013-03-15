//
//  BasePanel.h
//  DrawShap
//
//  Created by Bai Jin on 12/25/12.
//  Copyright (c) 2012 Cosmo Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#if __has_feature(objc_arc)
#define BasePanelCopy nonatomic, strong
#define BasePanelRetain nonatomic, strong
#else
#define BasePanelCopy nonatomic, copy
#define BasePanelRetain nonatomic, retain
#endif

/** @class BasePanelTitlebarView
 Draws a default style Mac OS X title bar.
 */
@interface BasePanelTitlebarView : NSView
@end

/** @class BasePanelContentView
 Draws a black view
 */
@interface BasePanelContentView : NSView
@end

/** @class BasePanel
 Creates a window similar to the Mac App Store window, with centered traffic lights and an
 enlarged title bar. This does not handle creating the toolbar.
 */
@interface BasePanel : NSPanel

/** The height of the title bar. By default, this is set to the standard title bar height. */
@property (nonatomic) CGFloat titleBarHeight;

/** The title bar view itself. Add subviews to this view that you want to show in the title bar
 (e.g. buttons, a toolbar, etc.). This view can also be set if you want to use a different
 styled title bar aside from the default one (textured, etc.). */
@property (BasePanelRetain) NSView *titleBarView;

/** Set whether the fullscreen or traffic light buttons are horizontally centered */
@property (nonatomic) BOOL centerFullScreenButton;
@property (nonatomic) BOOL centerTrafficLightButtons;
@property (nonatomic) BOOL verticalTrafficLightButtons;

/** If you want to hide the title bar in fullscreen mode, set this boolean to YES */
@property (nonatomic) BOOL hideTitleBarInFullScreen;

/** Use this API to hide the baseline BasePanel draws between itself and the main window contents. */
@property (nonatomic) BOOL showsBaselineSeparator;

/** Adjust the left and right padding of the trafficlight and fullscreen buttons */
@property (nonatomic) CGFloat trafficLightButtonsLeftMargin;
@property (nonatomic) CGFloat fullScreenButtonRightMargin;

/** The colors of the title bar background gradient and baseline separator, in main and non-main variants. */
@property (BasePanelRetain) NSColor *titleBarStartColor;
@property (BasePanelRetain) NSColor *titleBarEndColor;
@property (BasePanelRetain) NSColor *baselineSeparatorColor;

@property (BasePanelRetain) NSColor *inactiveTitleBarStartColor;
@property (BasePanelRetain) NSColor *inactiveTitleBarEndColor;
@property (BasePanelRetain) NSColor *inactiveBaselineSeparatorColor;


/** So much logic and work has gone into this window subclass to achieve a custom title bar,
 it would be a shame to have to re-invent that just to change the look. So this block can be used
 to override the default Mac App Store style titlebar drawing with your own drawing code!
 */
/*typedef void (^BasePanelTitleBarDrawingBlock)(BOOL drawsAsMainWindow,
CGRect drawingRect, CGPathRef clippingPath);
@property (BasePanelCopy) INAppStoreWindowTitleBarDrawingBlock titleBarDrawingBlock;

- (void)setTitleBarDrawingBlock:(INAppStoreWindowTitleBarDrawingBlock)titleBarDrawingBlock;*/

@end
