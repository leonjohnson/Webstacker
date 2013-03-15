//
//  HeaderTextField.m
//  DrawShap
//
//  Created by Bai Jin on 1/13/13.
//  Copyright (c) 2013 Cosmo Software. All rights reserved.
//

#import "HeaderTextField.h"

@implementation HeaderTextField

@synthesize headerDelegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)textDidEndEditing:(NSNotification *)aNotification
{
	if ([[[aNotification userInfo] objectForKey:@"NSTextMovement"] intValue] == NSReturnTextMovement)
    {
        [headerDelegate OnEnterKeyPressed];
    } else if ([[[aNotification userInfo] objectForKey:@"NSTextMovement"] intValue] == NSTabTextMovement) {
		[headerDelegate OnTabKeyPressed];
	}
}

@end
