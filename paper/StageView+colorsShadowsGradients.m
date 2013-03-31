#import "StageView.h"
#import "NSColor+colorToHex.h"
#import "NSColor+NSColorHexadecimalValue.h"

@implementation StageView (colorsShadowsGradients)


-(void)updateStageViewBackgroundColor: (NSDictionary *)dict
{
    //close the popover
    [documentSettingsPopover performClose:self];
    
    //convert the passed in string to an NSRect
    NSColor *stageViewBackgroundColor = [dict valueForKeyPath:@"stageViewBackgroundColor"];
    
    self.stageBackgroundColor = stageViewBackgroundColor;
    
    
    //Centre the container
    //resizedContainer.origin.x = (self.frame.size.width/2) - resizedContainer.size.width/2;
    //resizedContainer.origin.y = self.frame.size.height - resizedContainer.size.height;
    
    //Save this to the stageViews documentContainer variable
    //self.documentContainer = resizedContainer;
    
    [self setNeedsDisplay:YES];
}




-(NSString *)hsla:(NSColor *)color
{
    NSString *hexValue = [color hexadecimalValueOfAnNSColor];
    if (hexValue == nil)
    {
        hexValue = @"#FFFFFF";
    }
    return hexValue;
    
}




#pragma mark - shadow


/*
 @function:		drawShapeShadow
 @params:		x:			x offset of shadow
				y:			y offset of shadow
				r, g, b, alpha: color property of shadow
				direct:		shadow direction, if it's YES, outset. otherwise inset.
				index:		index of shadow in shadow list
 @return:		void
 @purpose:		This function draws the shadow of shape with params.
 */
- (void)drawShapeShadow:(CGFloat)x offY:(CGFloat)y ColorR:(CGFloat)r ColorG:(CGFloat)g ColorB:(CGFloat)b Opacity:(CGFloat)alpha Blur:(CGFloat)blur Direction:(BOOL)d Index:(NSInteger)index
{
	if ([self IsSelectedShape] == NO || [selElementArray count] > 1) {
		return;
	}
	
	Element *shape = [selElementArray objectAtIndex:0];
	[shape setShadowOfShape:x offY:y colorR:r colorG:g colorB:blur opacity:alpha Blur:blur direct:d Index:index];
	
	[attributeDelegate setShadowList:shape.arrayShadows];
	
	[self setNeedsDisplay:YES];
}


/*
 @function:		addShapeShadow
 @params:		x:		x offset of shadow
				y:		y offset of shadow
				r, g, b, alpha: color property of shadow
				direct:		shadow direction, if it's YES, outset. otherwise inset.
 @return:		void
 @purpose:		This function add the new shadow to current shape
 */
- (void)addShapeShadow:(CGFloat)x offY:(CGFloat)y ColorR:(CGFloat)r ColorG:(CGFloat)g ColorB:(CGFloat)b Opacity:(CGFloat)alpha Blur:(CGFloat)blur Direction:(BOOL)d
{
	if ([self IsSelectedShape] == NO || [selElementArray count] > 1) {
		return;
	}
	
	Element *shape = [selElementArray objectAtIndex:0];
	[shape addShapeShadow:x offY:y ColorR:r ColorG:g ColorB:b Opacity:alpha Blur:blur Direction:d];
	
	[attributeDelegate setShadowList:shape.arrayShadows];
	
	[self setNeedsDisplay:YES];
}


- (void)removeShapeShadow:(NSInteger)index
{
    
}
@end
