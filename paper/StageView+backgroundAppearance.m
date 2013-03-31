//
//  StageView+backgroundAppearance.m
//  designer
//
//  Created by Leon Johnson on 31/03/2013.
//
//

#import "StageView.h"




@implementation StageView (backgroundAppearance)

-(IBAction)toggleGridlineVisibility:(id)sender
{
    self.showGridlines = !self.showGridlines;
    [self setNeedsDisplay: YES];
}
@end
