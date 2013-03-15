//
//  NewContainerWindowController.m
//  DrawShap
//
//  Created by Bai Jin on 12/27/12.
//  Copyright (c) 2012 Cosmo Software. All rights reserved.
//

#import "NewContainerWindowController.h"
#import "AppDelegate.h"
#import "Document.h"

@interface NewContainerWindowController ()

@end

@implementation NewContainerWindowController

- (id)init
{
	self = [super initWithWindowNibName:@"NewContainerWindowController"];
	if (self) {
		
	}
	
	return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - button action implementation

- (IBAction)OnOK:(id)sender
{
	if ([_txtFieldWidth floatValue] > 0)
	{
		[NSApp stopModal];
		
		//Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
		
		AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
		[appDelegate OpenNewDocument:[_txtFieldWidth floatValue]];
		
		[self close];
		
		NSLog( @"OK button clicked in New Container Window" );
	}
}

- (IBAction)OnCancel:(id)sender
{
	[NSApp stopModal];
	[self close];
}


@end
