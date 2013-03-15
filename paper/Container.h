//
//  Container.h
//  designer
//
//  Created by Bai Jin on 2/24/13.
//
//

#import "Element.h"

@interface Container : Element

/*
 @function:		getShapeData
 @params:		nothing
 @return:       returns the dictionary data of the group shape.
 @purpose:		This function create the dictionary data from group shape and return it.
 */
- (NSMutableDictionary *)getShapeData;

/*
 @function:		setBoundRect
 @params:		rt:   group shape's bound rect
 @return:       void
 @purpose:		Set the group shape's bound rect "rtFrame" to rt.
 */
- (void)setBoundRect:(NSRect)rt;

/*
 @function:		DrawShape
 @params:		context:   Graphics context reference
 @return:       void
 @purpose:		Draw the group shape in rtFrame rectangle area.
 */
- (void)DrawElement:(CGContextRef)context;

/*
 @function:		drawShadows
 @params:		path:		shape's path to draw
 direction:	shadow direction. If it is YES, outer shadow. otherwise, inner shadow.
 angle:		shadow angle
 distance:	shadow distance
 color:		shadow color
 opacity:	shadow opacity
 blur:		shadow blur
 @return:		void
 @purpose:		Draw the shadow with path and params.
 */
- (void)drawShadows:(NSBezierPath *)path direction:(BOOL)direction angle:(CGFloat)angle distance:(CGFloat)distance color:(CGColorRef)color opacity:(CGFloat)opacity blur:(CGFloat)blur;

/*
 @function:		IsPointInElement
 @params:		nothing
 @return:       hitTest : hitTest is base on SHT_HANDLESTYLE
 @purpose:		Check the pt is in shape.
 */
- (NSInteger)IsPointInElement:(NSPoint)pt;


@end
