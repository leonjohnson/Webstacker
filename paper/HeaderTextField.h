//
//  HeaderTextField.h
//  DrawShap
//
//  Created by Bai Jin on 1/13/13.
//  Copyright (c) 2013 Cosmo Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HeaderTextDelegate.h"

@interface HeaderTextField : NSTextField
{
	id<HeaderTextDelegate>				headerDelegate;
}

@property (assign) id<HeaderTextDelegate>				headerDelegate;

@end
