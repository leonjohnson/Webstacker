#import "Element.h"
#define NOW_REZISE_IMAGE @"resizeImage"
#define HOLD_RESIZING @"holdResizing"




@interface Image : Element
{
	NSURL               *__strong filePath;
	NSImageView			*imageView;
    NSString            *imgPath;
    CGImageRef          image;
}

@property (nonatomic, strong) NSURL *filePath;
@property (nonatomic) NSImageView *imageView;
/*
 @function:		getShapeData
 @params:		nothing
 @return:       returns the dictionary data of the image shape.
 @purpose:		This function create the dictionary data from image shape and return it.
 */
- (NSMutableDictionary *)getShapeData;

/*
 @function:		setImageURL
 @params:		name:	image file's path
 @return:		void
 @purpose:		Set the image file's path to filename and draw image.
 */
- (void)setImageURL:(NSURL*)name;

/*
 @function:		setImageData
 @params:		data:	image file's data
 @return:		void
 @purpose:		Set the image from data and draw image.
 */
- (void)setImageData:(NSData*)data;

- (void)setBoundRect:(NSRect)rt;


@end
