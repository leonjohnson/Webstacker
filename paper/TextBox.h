#import "Element.h"


/*
 
 @params:	text:			the text to draw in textbox
			isEditing:		when the text box is editing, YES. otherwise FALSE.
 */
@interface TextBox : Element
{
	//NSAttributedString			*text;
	BOOL				isEditing;
    NSMutableParagraphStyle * text2Style;
    NSDictionary *bodyCopy;
    NSDictionary *headerWhiteStyle;
    NSDictionary *headerBlackStyle;
    NSString *choosenStyle;
    
    NSMutableDictionary *customTextStyles;
}

//@property (nonatomic, retain)	NSAttributedString *text;
@property (assign) BOOL	isEditing;

@property (assign, nonatomic) NSMutableParagraphStyle *text2Style;
@property (assign, nonatomic) NSDictionary *bodyCopy;
@property (assign, nonatomic) NSDictionary *headerWhiteStyle;
@property (assign, nonatomic) NSDictionary *headerBlackStyle;
@property (assign, nonatomic) NSString *choosenStyle;

@property (assign, nonatomic) NSMutableDictionary *customTextStyles;


- (void)dealloc;
- (void)setText:(NSAttributedString *)txt;

@end
