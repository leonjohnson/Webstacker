#import "Image.h"

@implementation Image
@synthesize filePath;
@synthesize imageView;


- (id)init
{
	self = [super init];
	
	if (self) {
		self.filePath = nil;
		imageView = [[NSImageView alloc] init];
		[imageView setAcceptsTouchEvents:NO];
		[self addSubview:imageView];
	}
	
	return self;
}


- (void)dealloc
{
	if (filePath) {
		[filePath release];
	}
	
	if (imageView) {
		[imageView removeFromSuperview];
		[imageView release];
	}
	
	[super dealloc];
}


/*
 @function:		getShapeData
 @params:		nothing
 @return:       returns the dictionary data of the image shape.
 @purpose:		This function create the dictionary data from image shape and return it.
 */
- (NSMutableDictionary *)getShapeData
{
	// format shape type and frame rect
	NSNumber *type = [NSNumber numberWithInteger:uType];
	NSNumber *xPos = [NSNumber numberWithFloat:rtFrame.origin.x];
	NSNumber *yPos = [NSNumber numberWithFloat:rtFrame.origin.y];
	NSNumber *width = [NSNumber numberWithFloat:rtFrame.size.width];
	NSNumber *height = [NSNumber numberWithFloat:rtFrame.size.height];
	
	// set type and frame rect value to dictionary
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:type forKey:@"ShapeType"];
	[dict setValue:xPos forKey:@"xPos"];
	[dict setValue:yPos forKey:@"yPos"];
	[dict setValue:width forKey:@"Width"];
	[dict setValue:height forKey:@"Height"];
	
	// get image data and set to dictionary
	NSArray *array = [[imageView image] representations];
	NSData *bmpData = [NSBitmapImageRep representationOfImageRepsInArray:array usingType:NSPNGFileType properties:nil];
	
	[dict setValue:bmpData forKey:@"ImageData"];
	
	// free all value
	type = nil;
	xPos = nil;
	yPos = nil;
	width = nil;
	height = nil;
	
	return dict;
}


/*
 @function:		setImageURL
 @params:		name:	image file's path
 @purpose:		Set the image file's path to filename and draw image.
 */
- (void)setImageURL:(NSURL*)name
{
    self.filePath = name;
    NSImage *img = [[NSImage alloc] initWithContentsOfURL:filePath];
	//NSImage* img = [[NSImage alloc] initWithContentsOfFile:name];
	[imageView setImage:img];
	
	
	[self setBoundRect:NSMakeRect(rtFrame.origin.x, rtFrame.origin.y, [img size].width, [img size].height)];
	[img release];
}


/*
 @function:		setImageData
 @params:		data:	image file's data
 @purpose:		Set the image from data and draw image.
 */
- (void)setImageData:(NSData*)data
{
	NSImage* img = [[NSImage alloc] initWithData:data];
	[imageView setImage:img];
	
	[self setBoundRect:NSMakeRect(rtFrame.origin.x, rtFrame.origin.y, [img size].width, [img size].height)];
	[img release];
}


/*
 @function:		setBoundRect
 @params:		rt:   triangle's bound rect
 @return:       void
 @purpose:		Set the triangle's bound rect "rtFrame" to rt.
 */
- (void)setBoundRect:(NSRect)rt
{
	rtFrame = CGRectStandardize(rt);
    [self setFrame:CGRectMake(rtFrame.origin.x - 2, rtFrame.origin.y - 2, rtFrame.size.width + 4, rtFrame.size.height + 4)];
	[imageView setFrame:CGRectMake(2, 2, rtFrame.size.width, rtFrame.size.height)];
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
}

- (NSInteger)IsPointInElement:(NSPoint)pt
{
	return SHT_NONE;
}


- (void)setFrame:(NSRect)frameRect
{
	[imageView setFrame:CGRectMake(2, 2, rtFrame.size.width, rtFrame.size.height)];
	[[imageView image] setScalesWhenResized:YES];
	[[imageView image] setSize:rtFrame.size];
	
	[super setFrame:frameRect];
}

@end
