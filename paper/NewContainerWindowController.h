//
//  NewContainerWindowController.h
//  DrawShap
//
//  Created by Bai Jin on 12/27/12.
//  Copyright (c) 2012 Cosmo Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NewContainerWindowController : NSWindowController
{
	IBOutlet NSTextField				*_txtFieldWidth;
}

- (IBAction)OnOK:(id)sender;
- (IBAction)OnCancel:(id)sender;


@end
