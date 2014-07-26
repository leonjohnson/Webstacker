//
//  DynamicImage.m
//  designer
//
//  Created by Leon Johnson on 10/01/2013.
//
//

#import "DynamicImage.h"

@implementation DynamicImage



- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	
	if (self) {
        self.borderWidth = [NSNumber numberWithInt:2];
	}
	
	return self;
}


- (void)dealloc
{
	
	if (imageView) {
		[imageView removeFromSuperview];
	}
	
}


/*
 @function:		getShapeData
 @params:		nothing
 @return:       returns the dictionary data of the image shape.
 @purpose:		This function create the dictionary data from image shape and return it.
 */
- (NSMutableDictionary *)getShapeData
{
    return [super getShapeData];
}


/*
 @function:		setImageURL
 @params:		name:	image file's path
 @return:		void
 @purpose:		Set the image file's path to filename and draw image.
 */
- (void)setImageURL:(NSURL*)name
{

    [super setImageURL:name];
}


/*
 @function:		setImageData
 @params:		data:	image file's data
 @return:		void
 @purpose:		Set the image from data and draw image.
 */
- (void)setImageData:(NSData*)data
{

    [super setImageData:data];
}


/*
 @function:		setBoundRect
 @params:		rt:   triangle's bound rect
 @return:       void
 @purpose:		Set the triangle's bound rect "rtFrame" to rt.
 */
- (void)setBoundRect:(NSRect)rt
{
    [super setBoundRect:rt];
}


/*
 When the view is redraw, draw the rectangle shape view
 */
- (void)drawRect:(NSRect)dirtyRect
{
	NSGraphicsContext *tvarNSGraphicsContext = [NSGraphicsContext currentContext];
	CGContextRef ctx = (CGContextRef) [tvarNSGraphicsContext graphicsPort];
    CGContextSetRGBStrokeColor( ctx, 1.0, 0.0, 0.0, 1.0 );
    
    if ([imageView image] == nil)
    {
        NSLog(@"nil");
        NSBezierPath *rectanglePath = [NSBezierPath bezierPath];
        NSRect rectangleFrame = NSMakeRect(2, 2, rtFrame.size.width, rtFrame.size.height);
        rectanglePath = [NSBezierPath bezierPathWithRect:rectangleFrame];
        [rectanglePath setLineWidth:[borderWidth floatValue]];
        [rectanglePath stroke];
    }
    
    
    
    
	if (isSelected == YES) {
		[self DrawBorderFrame:ctx];
	}
    [super drawRect:dirtyRect];
}

- (NSInteger)IsPointInElement:(NSPoint)pt
{
	return SHT_NONE;
}

- (void)setFrame:(NSRect)frameRect
{
	[super setFrame:frameRect];
}

@end


