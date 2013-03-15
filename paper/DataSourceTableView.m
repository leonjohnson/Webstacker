//
//  DataSourceTableView.m
//  DrawShap
//
//  Created by Bai Jin on 1/13/13.
//  Copyright (c) 2013 Cosmo Software. All rights reserved.
//

#import "DataSourceTableView.h"

@implementation DataSourceTableView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)textDidEndEditing:(NSNotification *)notification
{
	[super textDidEndEditing:notification];
	
	if ([[[notification userInfo] objectForKey:@"NSTextMovement"] intValue] == NSTabTextMovement) {
		
		NSInteger row = [self selectedRow];
		NSInteger col = [self editedColumn];
		if (col == -1) {
			_prevCol ++;
		} else {
			_prevCol = col;
		}
		
		NSInteger rows = [self numberOfRows];
		NSInteger cols = [self numberOfColumns];
		
		if (row < rows - 1 && _prevCol == cols) {
			[self selectRowIndexes:[NSIndexSet indexSetWithIndex:row + 1] byExtendingSelection:NO];
			[self editColumn:0 row:row + 1 withEvent:nil select:YES];
			_prevCol = 0;
		}
	}
}

@end
