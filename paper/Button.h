#import <Foundation/Foundation.h>
#import "Element.h"


@interface Button : Element //<elementDelegate>
{
    
    id<NSObject> buttonColor;
    NSSize buttonSize;
    NSRect buttonTextContainer;
    

    
}


@property (assign, nonatomic) id<NSObject> buttonColor;
@property (assign, nonatomic) NSSize buttonSize;
@property (assign) NSRect buttonTextContainer;


-(void)setBoundRect:(NSRect)rt;
CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat topleft, CGFloat topright, CGFloat bottomleft, CGFloat bottomright);

@end