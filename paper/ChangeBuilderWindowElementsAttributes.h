#import <Foundation/Foundation.h>

@protocol ChangeBuilderWindowElementsAttributes <NSObject>

@required
-(void)nextButtonWillBeEnabled:    (BOOL)hidden;
-(void)backButtonWillBeEnabled:  (BOOL)hidden;
@end