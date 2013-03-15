//
//  HeaderTextDelegate.h
//  DrawShap
//
//  Created by Bai Jin on 1/13/13.
//  Copyright (c) 2013 Cosmo Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HeaderTextDelegate <NSObject>

- (void)OnEnterKeyPressed;
- (void)OnTabKeyPressed;

@end
