//
//  CustomTableCellView.m
//  designer
//
//  Created by Leon Johnson on 09/02/2013.
//
//

#import "CustomTableCellView.h"
@implementation CustomTableCellView
@synthesize secondTextCell = _secondTextCell;



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


- (void)dealloc {
    [_secondTextCell release], _secondTextCell = nil;
    [super dealloc];
}
@end
