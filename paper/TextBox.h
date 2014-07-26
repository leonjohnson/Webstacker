#import "Element.h"


/*
 
 @params:	text:			the text to draw in textbox
			isEditing:		when the text box is editing, YES. otherwise FALSE.
 */
@interface TextBox : Element
{
	//NSAttributedString			*text;
	BOOL				isEditing;
    NSMutableParagraphStyle * __strong text2Style;
    NSDictionary *__strong bodyCopy;
    NSDictionary *__strong headerWhiteStyle;
    NSDictionary *__strong headerBlackStyle;
    NSString *__strong choosenStyle;
    
    NSMutableDictionary *__strong customTextStyles;
}

//@property (nonatomic, retain)	NSAttributedString *text;
@property (assign) BOOL	isEditing;

@property (strong, nonatomic) NSMutableParagraphStyle *text2Style;
@property (strong, nonatomic) NSDictionary *bodyCopy;
@property (strong, nonatomic) NSDictionary *headerWhiteStyle;
@property (strong, nonatomic) NSDictionary *headerBlackStyle;
@property (strong, nonatomic) NSString *choosenStyle;

@property (strong, nonatomic) NSMutableDictionary *customTextStyles;


- (void)dealloc;
- (void)setText:(NSAttributedString *)txt;

@end
