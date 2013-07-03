//
//  SetAttributeDelegate.h
//  DrawShape
//
//  Created by Ming Wang on 4/24/12.
//  Copyright (c) 2012 Cosmosoft Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Element;
/*
 SetAttributeDelegate is the delegate to notify the attribute of shape(position, size)
 from StageView to AttributePanel.
 Once users changed the attribute of shape on Stage(by mouse drag and drop),
 changed attribute is set to Attribute panel.
 */
@protocol SetAttributeDelegate <NSObject>


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
- (void)SetAttributeOfShapeToPanel:(CGFloat)x yPos:(CGFloat)y Width:(CGFloat)w Height:(CGFloat)h URL:(NSString*)url;


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
- (void)setShadowProperty:(CGFloat)angle Distance:(CGFloat)dist colorR:(CGFloat)r colorG:(CGFloat)g colorB:(CGFloat)b Opacity:(CGFloat)alpha Blur:(CGFloat)blur Direct:(BOOL)d Index:(NSInteger)index;


/*
 @function:		setShadowList
 @params:		shadowList:		shape's shadow array
 @return:		void
 @purpose:		This function set the shape's shadow list to table view.
 */
- (void)setShadowList:(NSArray *)shadowList;


- (void)updateLayoutDisplay:(Element *)element;
- (CGSize)stepperValues;

@end
