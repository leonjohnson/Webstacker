#import "StageView.h"
#import "Common.h"
#import "AppDelegate.h"
#import "Document.h"
#import "GroupingBox.h"
#import "Box.h"
#import "Circle.h"
#import "TextBox.h"
#import "Singleton.h"
#import "Image.h"
#import "Button.h"
#import "TextInputField.h"
#import "DropDown.h"
#import "DynamicRow.h"
#import "Triangle.h"
#import "Container.h"
#import "NSColor+NSColorHexadecimalValue.h"
#import "NSColor+colorToHex.h"


@interface StageView (conversion)

@end

@implementation StageView (conversion)

#define STR_LEFT   @"Left Edge"
#define STR_RIGHT  @"Right Edge"
#define STR_TOP    @"Top Edge"
#define STR_BOTTOM @"Bottom Edge"

#define xcoordinate @"xcoordinate"
#define ycoordinate @"ycoordinate"
#define bottomYcoordinate @"bottomYcoordinate"

#pragma mark - ASSOCIATIVE GENERATION METHODS

-(NSArray *)elementsToMyRightInGroupingBox:(NSDictionary *)element
{
    // Takes an element and finds all other elements in the same groupingBox as it and orders it by xcoordinate.
    NSMutableArray *inMyRange = [NSMutableArray array];
    NSMutableArray *elementsChecked = [NSMutableArray array];
    NSMutableArray *orderedElementsAboveMe = [NSMutableArray array];
    
    NSUInteger elementY = [[element valueForKey:@"ycoordinate"] unsignedIntegerValue];
    NSUInteger elementH = [[element valueForKey:@"height"] unsignedIntegerValue];
    NSUInteger elementX = [[element valueForKey:@"xcoordinate"] unsignedIntegerValue];
    NSRange elementRightRange = NSMakeRange(elementY, elementH); //X location and the length
    
    //  Get the objects inside THIS GroupBox
    NSArray *objectsToLoopThrough = nil;
    GroupingBox *gb = [self whichGroupingBoxIsElementIn:element];
    if ([gb.insideTheBox count] == 0)
    {
        objectsToLoopThrough = leftToRightTopToBottom;
        NSLog(@"OB COUNT: %lu", [leftToRightTopToBottom count]);
    }
    else
    {
        objectsToLoopThrough = gb.insideTheBox;
    }
    NSLog(@"Theory it's not 0. Equals : %lu", [objectsToLoopThrough count]);
    
    
    for (NSDictionary *compare in objectsToLoopThrough)
    {
        if ([compare isEqualToDictionary:element] == NO)    //  If not me
        {
            if ([elementsChecked containsObject:compare] == NO) //  if this object hasn't been checked
            {
                NSUInteger compareY = [[compare valueForKey:@"ycoordinate"] unsignedIntegerValue];
                NSUInteger compareH = [[compare valueForKey:@"height"] unsignedIntegerValue];
                NSUInteger compareX = [[compare valueForKey:@"xcoordinate"] unsignedIntegerValue];
                NSRange compareRightRange = NSMakeRange(compareY, compareH); //X location and the length
                
                NSRange comparison = NSIntersectionRange(elementRightRange, compareRightRange);
                
                if ((compareX > elementX) & (comparison.length!=0)) //    We have a match
                {
                    NSLog(@"elementsToMyRightInGroupingBox MATCH FOUND = %@", NSStringFromRange(comparison));
                    [inMyRange addObject:compare]; //   Add the comparison object so it now has an order.
                    [elementsChecked addObject:compare]; // So we don't check it again
                    
                }
                else
                {
                    [elementsChecked addObject:compare];
                }
            }
        }
    } //    Closes the for loop
    
    /*
     NSSortDescriptor *horizontally = [[NSSortDescriptor alloc] initWithKey:@"xcoordinate" ascending:YES];
     NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:@"ycoordinate" ascending:NO];
     
     NSArray *sortDescriptorH = [NSArray arrayWithObject: horizontally];
     NSArray *sortDescriptorV = [NSArray arrayWithObject: vertically];
     
     NSArray *toMyRightInThisBox = [inMyRange sortedArrayUsingDescriptors:sortDescriptorH];
     NSMutableArray *elementsDirectlyAboveMe = [NSMutableArray array];
     
     for (NSDictionary *elementToTheRight in toMyRightInThisBox)
     {
     NSUInteger eleW = [[elementToTheRight valueForKey:@"width"] unsignedIntegerValue];
     NSUInteger eleY = [[elementToTheRight valueForKey:@"ycoordinate"] unsignedIntegerValue];
     NSRange eleTopRange = NSMakeRange(eleY, eleW); //X location and the length
     
     //get those in my northern range
     for (NSDictionary *comparator in inMyRange)
     {
     if ([comparator isEqualToDictionary:elementToTheRight] == NO)    //  If not me
     {
     
     NSUInteger compareW = [[comparator valueForKey:@"width"] unsignedIntegerValue];
     NSUInteger compareY = [[comparator valueForKey:@"ycoordinate"] unsignedIntegerValue];
     NSRange comparatorTopRange = NSMakeRange(compareY, compareW); //X location and the length
     
     NSRange comparison = NSIntersectionRange(eleTopRange, comparatorTopRange);
     
     if ((compareY > eleY) & (comparison.length!=0)) //    We have a match
     {
     NSLog(@"elementsDirectlyAboveMe MATCH FOUND = %@", NSStringFromRange(comparison));
     [elementsDirectlyAboveMe addObject:comparator]; //   Add the comparison object so it now has an order.
     }
     [orderedElementsAboveMe addObjectsFromArray:[elementsDirectlyAboveMe sortedArrayUsingDescriptors:sortDescriptorV]];
     [orderedElementsAboveMe addObject:elementToTheRight];
     
     }
     }
     
     
     } //    Closes the for loop
     */
    return inMyRange;
}





-(NSArray *)elementsToMyRight:(NSDictionary *)element
{
    //Returns an array of elements that are to the right of 'element' but but contained within it.
    NSMutableArray *inMyRange = [NSMutableArray array];
    NSMutableArray *elementsChecked = [NSMutableArray array];
    
    NSUInteger elementY = [[element valueForKey:@"ycoordinate"] unsignedIntegerValue];
    NSUInteger elementW = [[element valueForKey:@"width"] unsignedIntegerValue];
    NSUInteger elementH = [[element valueForKey:@"height"] unsignedIntegerValue];
    NSUInteger elementX = [[element valueForKey:@"xcoordinate"] unsignedIntegerValue];
    //NSRect elementRect = NSMakeRect(elementX, elementY, elementW, elementH);
    NSRange elementRightRange = NSMakeRange(elementY, elementH); //X location and the length
    
    for (NSDictionary *compare in leftToRightTopToBottom)
    {
        if ([compare isEqualToDictionary:element] == NO)    //  If not me
        {
            if ([elementsChecked containsObject:compare] == NO) //  if this object hasn't been checked
            {
                NSUInteger compareW = [[compare valueForKey:@"width"] unsignedIntegerValue];
                NSUInteger compareH = [[compare valueForKey:@"height"] unsignedIntegerValue];
                NSUInteger compareX = [[compare valueForKey:@"xcoordinate"] unsignedIntegerValue];
                NSUInteger compareY = [[compare valueForKey:@"ycoordinate"] unsignedIntegerValue];
                NSRange compareRightRange = NSMakeRange(compareY, compareH); //X location and the length
                //NSRect compareRect = NSMakeRect(compareX, compareY, compareW, compareH);
                
                NSRange comparison = NSIntersectionRange(elementRightRange, compareRightRange);
                
                if ( (compareX > elementX) & (comparison.length!=0) ) //    We have a match
                {
                    NSLog(@"%lu is > %lu", compareX, elementX);
                    NSLog(@"MATCH FOUND = %@", NSStringFromRange(comparison));
                    [inMyRange addObject:compare]; //   Add the comparison object so it now has an order.
                    [elementsChecked addObject:compare]; // So we don't check it again
                    
                }
                else
                {
                    [elementsChecked addObject:compare];
                }
            }
        }
    } //    Closes the for loop
    
    
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:@"ycoordinate" ascending:NO];
    NSSortDescriptor *horizontally = [[NSSortDescriptor alloc] initWithKey:@"xcoordinate" ascending:YES];
    
    NSArray *sortDescriptorA = [NSArray arrayWithObjects: vertically, horizontally, nil];
    NSArray *toMyRight = [inMyRange sortedArrayUsingDescriptors:sortDescriptorA];
    
    return toMyRight;
}


-(float)marginToElementAboveMe:(NSDictionary *)element
{
    
    NSMutableArray *inMyRange = [NSMutableArray array];
    NSMutableArray *elementsChecked = [NSMutableArray array];
    
    NSUInteger elementX = [[element valueForKey:@"xcoordinate"] unsignedIntegerValue];
    NSUInteger elementY = [[element valueForKey:@"ycoordinate"] unsignedIntegerValue];
    NSUInteger elementWidth = [[element valueForKey:@"width"] unsignedIntegerValue];
    NSUInteger elementHeight = [[element valueForKey:@"height"] unsignedIntegerValue];
    NSRange elementTopRange = NSMakeRange(elementX, elementX + elementWidth); //X location and the length
    
    for (NSDictionary *compare in leftToRightTopToBottom)
    {
        NSLog(@"Running.");
        if ([compare isEqualToDictionary:element] == NO)    //  If not me
        {
            if ([elementsChecked containsObject:compare] == NO) //  if this object hasn't been checked
            {
                NSUInteger compareX = [[compare valueForKey:@"xcoordinate"] unsignedIntegerValue];
                NSUInteger compareY = [[compare valueForKey:@"ycoordinate"] unsignedIntegerValue];
                NSUInteger compareWidth = [[compare valueForKey:@"width"] unsignedIntegerValue];
                
                NSRange compareTopRange = NSMakeRange(compareX, compareWidth);
                
                NSRange comparison = NSIntersectionRange(elementTopRange, compareTopRange);
                NSLog(@"Comparing steady : %@ with test (marginToElementAboveMe) : %@", NSStringFromRange(elementTopRange), NSStringFromRange(compareTopRange));
                if ((compareY > elementY) & (comparison.length!=0)) //    We have a match
                {
                    NSLog(@"A marginToElementAboveMe MATCH FOUND = %@", NSStringFromRange(comparison));
                    [inMyRange addObject:compare]; //   Add the comparison object so it now has an order.
                    [elementsChecked addObject:compare]; // So we don't check it again
                    
                }
                else
                {
                    [elementsChecked addObject:compare];
                }
            }
        }
    } //    Closes the for loop
    
    int lowest;
    
    if ([inMyRange count] != 0)
    {
        NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:@"ycoordinate" ascending:NO];
        NSArray *sortDescriptorA = [NSArray arrayWithObject: vertically];
        NSArray *aboveMe = [inMyRange sortedArrayUsingDescriptors:sortDescriptorA];
        lowest = [[[aboveMe lastObject]valueForKey:@"xcoordinate"] intValue];
    }
    else
    {
        CGFloat highestPoint;
        if (self.documentContainer.size.height == 0) // when an instance is initialiSed, all its ivar are cleared to bits of zero
        {
            highestPoint = self.frame.size.height;
            NSLog(@"OK OK OK - CONTAINER EQUALS ZERO.");
        }
        else
        {
            highestPoint = self.documentContainer.size.height;
            NSLog(@"OK OK OK - CONTAINER IS NOT ZERO.");
        }
        lowest = highestPoint - (elementY + elementHeight);
    }
    
    NSLog(@"marginToElementAboveMe is : %@", [NSNumber numberWithInt:lowest]);
    return lowest;
}


-(NSNumber *)getMarginTopForGroupings: (GroupingBox *)me // ** CHANGE THIS METHOD SO THAT IT NOW RETURNS A MARGIN BASED ON THE CLOSEST SOLO OBJECT ABOVE ME **
{
    NSLog(@"As a minimum...");
    //what row am I in?
    NSUInteger rowImIn;
    NSLog(@"self.rows = %@", self.rows);
    NSLog(@"Gonna compare this to : %@", [[me insideTheBox] objectAtIndex:0]);
    for (NSArray *r in self.rows)
    {
        if ([r containsObject:[[me insideTheBox] objectAtIndex:0] ])
        {
            NSLog(@"got here? 0");
            rowImIn = [self.rows indexOfObject:r];
            NSLog(@"got here? 0.5");
        }
    }
    NSMutableArray *itemsInMyRow = [NSMutableArray array];
    NSLog(@"gonna try and objectAtIndex rowImIn");
    itemsInMyRow = [self.rows objectAtIndex:rowImIn];
    
    NSLog(@"got here? 1");
    //find all the groupingBoxes above me in my y range
    NSNumber *margin = [[NSNumber alloc]init];
    NSMutableArray *groupBoxesAboveMe = [NSMutableArray array];
    NSMutableArray *elementsChecked = [NSMutableArray array];
    
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:@"ycoordinate" ascending:NO];
    NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
    
    NSUInteger meX = me.rtFrame.origin.x;
    NSUInteger meY = me.rtFrame.origin.y;
    NSUInteger meWidth = me.rtFrame.size.width;
    NSUInteger meHeight = me.rtFrame.size.height;
    NSRange meTopRange = NSMakeRange(meX, meWidth); //X location and the length
    NSLog(@"got here? 2");
    
    for (GroupingBox *g in groupingBoxes)
    {
        // for each groupingbox rtframe
        NSUInteger gX = g.rtFrame.origin.x;
        NSUInteger gY = g.rtFrame.origin.y;
        NSUInteger gWidth = g.rtFrame.size.width;
        NSUInteger gHeight = g.rtFrame.size.height;
        NSRange gTopRange = NSMakeRange(gX, gWidth); //X location and the Wwidth
        
        
        // see if anyother groupingBox rtframe is above it
        
        if ([g isEqualTo:me] == NO)    //  If not me
        {
            if ([elementsChecked containsObject:g] == NO) //  if this object hasn't been checked
            {
                NSRange comparison = NSIntersectionRange(gTopRange, meTopRange);
                NSLog(@"Comparing steady : %@ with test : %@", NSStringFromRange(gTopRange), NSStringFromRange(meTopRange));
                if ( ( gY > meY) & (comparison.length!=0) ) //    Above me and in my range.
                {
                    NSLog(@"A marginToElementAboveMe MATCH FOUND 3 = %@", NSStringFromRange(comparison));
                    [groupBoxesAboveMe addObject:g]; //   Add the comparison object so it now has an order.
                    [elementsChecked addObject:g]; // So we don't check it again
                    
                }
                else
                {
                    [elementsChecked addObject:g];
                }
            }
        }
    }
    
    // if so calculate the margin difference
    if ([groupBoxesAboveMe count] > 0)
    {
        NSArray *sortedGroupBoxesAboveMe = [groupBoxesAboveMe sortedArrayUsingDescriptors:verticalSortDescriptor];
        GroupingBox *highestGroupBox = [sortedGroupBoxesAboveMe lastObject]; //why is this the highest and not the lwoest??
        
        if ([itemsInMyRow containsObject:[[highestGroupBox insideTheBox] objectAtIndex:0]]) //if this groupingbox is in the same row as the groupingbox above it
        {
            margin = [NSNumber numberWithInt: (highestGroupBox.rtFrame.origin.y - highestGroupBox.rtFrame.size.height) - (me.rtFrame.origin.y)];
            NSLog(@"So new caluclation is : %f - %f = %@", (highestGroupBox.rtFrame.origin.y - highestGroupBox.rtFrame.size.height), (me.rtFrame.origin.y), margin);
        }
        else //if the groupingbox above is in a different row
        {
            if (rowImIn !=0)
            {
                NSDictionary *firstElementInRowAbove = [[self.rows objectAtIndex:rowImIn-1] objectAtIndex:0];
                margin = [NSNumber numberWithInt:( [self largestYcoordinateInMyRow:firstElementInRowAbove] - me.rtFrame.origin.y )];
                NSLog(@"[self lowestYcoordinateInMyRow:firstElementInRowAbove] = %d", [self largestYcoordinateInMyRow:firstElementInRowAbove]);
                NSLog(@"frame origin y : %f", me.rtFrame.origin.y);
                NSLog(@"In the getMarginTopForGroupings ELSE statement : %@", margin);
            }
        }
    }
    
    
    return margin;
}

-(NSUInteger)elementRow: (NSDictionary *)element
{
    NSUInteger rowImIn;
    for (NSArray *r in self.rows)
    {
        if ([r containsObject:element])
        {
            rowImIn = [self.rows indexOfObject:r];
        }
    }
    
    return rowImIn;
}

-(NSDictionary *)highestElementWithEmptyLeft:(NSArray *)array
{
    //  This function receives an array sorted by height.
    
    // Puts together an array of elements with an empty left ordered by height, and returns the highest
    NSMutableArray *contestants = [NSMutableArray array];
    NSMutableArray *inMyLeftRange = nil;
    NSMutableArray *elementsChecked = nil;
    for (NSDictionary *test in array)
    {
        elementsChecked = [NSMutableArray array];
        inMyLeftRange = [NSMutableArray array];
        NSUInteger testY = [[test valueForKey:@"ycoordinate"] unsignedIntegerValue];
        NSUInteger testH = [[test valueForKey:@"height"] unsignedIntegerValue];
        NSUInteger testX = [[test valueForKey:@"xcoordinate"] unsignedIntegerValue];
        NSRange testRightRange = NSMakeRange(testY, testH); //X location and the length
        
        
        for (NSDictionary *compare in array)
        {
            if ([compare isEqualToDictionary:test] == NO)    //  If not me
            {
                if ([elementsChecked containsObject:compare] == NO) //  if this object hasn't been checked
                {
                    NSUInteger compareY = [[compare valueForKey:@"ycoordinate"] unsignedIntegerValue];
                    NSUInteger compareH = [[compare valueForKey:@"height"] unsignedIntegerValue];
                    NSUInteger compareX = [[compare valueForKey:@"xcoordinate"] unsignedIntegerValue];
                    NSRange compareRightRange = NSMakeRange(compareY, compareH); //X location and the length
                    
                    NSRange comparison = NSIntersectionRange(testRightRange, compareRightRange);
                    
                    if ((compareX < testX) & (comparison.length!=0)) //    We have a match
                    {
                        [inMyLeftRange addObject:compare]; //   Add the comparison object so it now has an order.
                        [elementsChecked addObject:compare]; // So we don't check it again
                        
                    }
                    else
                    {
                        [elementsChecked addObject:compare];
                    }
                }
            }
        } //    Closes the first for loop
        
        if ([inMyLeftRange count] == 0)
        {
            [contestants addObject:test];
            //return test;
        }
        
    }
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:@"ycoordinate" ascending:NO];
    NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
    [contestants sortedArrayUsingDescriptors:verticalSortDescriptor];
    return [contestants lastObject];
    //NSLog(@"ERROR IN highestElementWithEmptyLeft !!");
    //return [NSDictionary dictionary];
    
}


-(NSDictionary *)highestElementWithEmptyLeftInMyGroupingBox:(NSArray *)array
{
    //  This function receives an array sorted by height.
    
    NSMutableArray *inMyLeftRange = nil;
    NSMutableArray *elementsChecked = nil;
    for (NSDictionary *test in array)
    {
        elementsChecked = [NSMutableArray array];
        inMyLeftRange = [NSMutableArray array];
        NSUInteger testY = [[test valueForKey:@"ycoordinate"] unsignedIntegerValue];
        NSUInteger testH = [[test valueForKey:@"height"] unsignedIntegerValue];
        NSUInteger testX = [[test valueForKey:@"xcoordinate"] unsignedIntegerValue];
        NSRange testRightRange = NSMakeRange(testY, testH); //X location and the length
        GroupingBox *grb = [self whichGroupingBoxIsElementIn:test];
        
        
        for (NSDictionary *compare in array)
        {
            if ([compare isEqualToDictionary:test] == NO)    //  If not me
            {
                if ([elementsChecked containsObject:compare] == NO) //  if this object hasn't been checked
                {
                    NSUInteger compareY = [[compare valueForKey:@"ycoordinate"] unsignedIntegerValue];
                    NSUInteger compareH = [[compare valueForKey:@"height"] unsignedIntegerValue];
                    NSUInteger compareX = [[compare valueForKey:@"xcoordinate"] unsignedIntegerValue];
                    NSRange compareRightRange = NSMakeRange(compareY, compareH); //X location and the length
                    
                    NSRange comparison = NSIntersectionRange(testRightRange, compareRightRange);
                    
                    if ((compareX < testX) & (comparison.length!=0) & ([grb.insideTheBox containsObject:compare]) ) //    We have a match
                    {
                        [inMyLeftRange addObject:compare]; //   Add the comparison object so it now has an order.
                        [elementsChecked addObject:compare]; // So we don't check it again
                        
                    }
                    else
                    {
                        [elementsChecked addObject:compare];
                    }
                }
            }
        } //    Closes the first for loop
        
        if ([inMyLeftRange count] == 0)
        {
            return test;
        }
        
    }
    
    NSLog(@"ERROR IN highestElementWithEmptyLeft !!");
    return [NSDictionary dictionary];
    
}



-(int)isThereAGroupBoxInPath:(NSRect)masterRect: (NSString *)marginType :(NSRect)comparatorRect // Question for later - unnecessary code?
{
    
    int margin = 0;
    NSMutableArray *intersectingBoxes = [NSMutableArray array];
    NSRect rectangularPath = CGRectZero;
    NSUInteger startingPoint = 0;
    NSString *marginWeShare = [[NSString alloc]initWithString:marginType];
    
    if ([marginWeShare isEqualToString:@"x"])
    {
        NSLog(@"got into x");
        startingPoint = masterRect.origin.x + masterRect.size.height;   //  Represents the starting X coordinate. Right??
        NSRange masterElementRange = NSMakeRange(startingPoint, masterRect.size.width);
        NSRange comparatorElementRange = NSMakeRange(comparatorRect.origin.x, comparatorRect.size.width);
        NSRange comparison = NSIntersectionRange(masterElementRange, comparatorElementRange);
        if (comparison.length == 0)
        {
            NSLog(@"Error in the X comparison");
        }
        
        CGFloat width = comparison.length;
        CGFloat height = (comparatorRect.origin.x) - (masterRect.origin.x + masterRect.size.height);
        
        rectangularPath = NSMakeRect(masterRect.origin.x + masterRect.size.width, masterRect.origin.y + masterRect.size.width, width, height);
        
    }
    
    
    if ([marginWeShare isEqualToString:@"y"])
    {
        
        NSLog(@"got into y");
        startingPoint = masterRect.origin.x + masterRect.size.width;    //  Represents the starting Y coordinate
        NSRange masterElementRange = NSMakeRange(startingPoint, masterRect.size.height);
        NSRange comparatorElementRange = NSMakeRange(comparatorRect.origin.x, comparatorRect.size.height);
        NSRange comparison = NSIntersectionRange(masterElementRange, comparatorElementRange);
        if (comparison.length == 0)
        {
            NSLog(@"Error in the Y comparison");
        }
        
        CGFloat width = comparatorRect.origin.x - startingPoint;
        // CGFloat height = comparison.length; //114 -> AN: Removed as it's not being used
        CGFloat height2 = masterRect.size.height;
        
        rectangularPath = NSMakeRect(startingPoint, masterRect.origin.y, width, height2);
        
    }
    
    for (GroupingBox *box in groupingBoxes)
    {
        
        NSRect gbRect = box.rtFrame;
        NSLog(@"GroupingBox... = %@. OtherRect = %@", NSStringFromRect(gbRect), NSStringFromRect(rectangularPath));
        
        NSRect intersection = NSIntersectionRect(gbRect, rectangularPath);
        if ( (intersection.size.width == 0.0) & (intersection.size.height == 0.0)) //   If there is an overlap
        {
            NSLog(@"No match with grouping box");
        }
        else
        {
            NSLog(@"method margin 01 is: %d", margin);
            if ([marginWeShare isEqualToString:@"x"])
            {
                margin = intersection.origin.y - startingPoint;
            }
            if ([marginWeShare isEqualToString:@"y"])
            {
                NSLog(@"startingPoint = %lu", startingPoint);
                NSLog(@"Intersection origin x = %f", intersection.origin.x);
                margin = intersection.origin.x - startingPoint;
                if (margin > [[intersectingBoxes lastObject] floatValue])
                {
                    [intersectingBoxes addObject:[NSNumber numberWithInt:margin]];
                }
                
            }
            
        }
    }
    
    float latestMargin = [[intersectingBoxes lastObject] floatValue];
    NSLog(@"Master has xco: %f and comparator has xco: %f", masterRect.origin.x, comparatorRect.origin.x);
    NSLog(@"method margin 02 is: %f", latestMargin);
    return margin;
}



-(int)marginToObjectWithinTransformedGroupingBox:(NSDictionary *)element onSide:(SideToTest) sideToTest
{
    NSRect rectToTest;
    int borderDistance;
    
    //which grouping box is this element in
    GroupingBox *myGroupingBox = [self whichGroupingBoxIsElementIn:element];
    
    
    //what is the NSRect from this element to the end of the grouping box
    if (sideToTest == RIGHT)
    {
        rectToTest = NSMakeRect(
                                [[element objectForKey:@"farRight"]floatValue],
                                [[element objectForKey:ycoordinate]floatValue],
                                ( [[myGroupingBox valueForKey:xcoordinate]intValue] + [[myGroupingBox valueForKey:@"width"]intValue] ) - ([[element objectForKey:@"farRight"]floatValue]),
                                [[element objectForKey:@"height"]floatValue]
                                );
        NSLog(@"x = %f, y = %f, w = %f, h = %f",[[element objectForKey:@"farRight"]floatValue], [[element objectForKey:ycoordinate]floatValue], [[myGroupingBox valueForKey:xcoordinate]intValue] + [[myGroupingBox valueForKey:@"width"]intValue] - ([[element objectForKey:@"farRight"]floatValue]), [[element objectForKey:@"height"]floatValue] );
        borderDistance =   ( [[myGroupingBox valueForKey:xcoordinate]intValue] + [[myGroupingBox valueForKey:@"width"]intValue] ) - [[element objectForKey:@"farRight"]intValue];
    }
    
    if (sideToTest == LEFT)
    {
        rectToTest = NSMakeRect(
                                [[myGroupingBox valueForKey:xcoordinate]intValue],
                                //[[myGroupingBox valueForKey:ycoordinate]intValue],
                                [[element objectForKey:ycoordinate]floatValue],
                                [[element objectForKey:xcoordinate]floatValue] - [[myGroupingBox valueForKey:xcoordinate]intValue],
                                [[element objectForKey:@"height"]floatValue]
                                );
        borderDistance =  [[element objectForKey:xcoordinate]intValue] - [[myGroupingBox valueForKey:xcoordinate]intValue];
        NSLog(@"A = %i and B = %i", [[element objectForKey:xcoordinate]intValue], [[myGroupingBox valueForKey:xcoordinate]intValue]);
        NSLog(@"Border distance to the LEFT is :%i", borderDistance);
    }
    
    if (sideToTest == TOP)
    {
        rectToTest = NSMakeRect(
                                [[element objectForKey:xcoordinate]floatValue],
                                myGroupingBox.rtFrame.origin.y,
                                //([[element objectForKey:xcoordinate]floatValue] - myGroupingBox.rtFrame.origin.x) + [[element objectForKey:@"width"]floatValue],
                                [[element objectForKey:@"width"]floatValue],
                                ([[element objectForKey:ycoordinate]floatValue] - myGroupingBox.rtFrame.origin.y)
                                );
        borderDistance = ( [[element objectForKey:ycoordinate]intValue] - myGroupingBox.rtFrame.origin.y );
        NSLog(@"Element object is : %@. GroupingBox is y: %f, x:%f, w:%f", element, myGroupingBox.rtFrame.origin.y, myGroupingBox.rtFrame.origin.x, myGroupingBox.rtFrame.size.width );
        NSLog(@"Border distance to the TOP is :%i", borderDistance);
        NSLog(@"TOP RECT : %@", NSStringFromRect(rectToTest));
    }
    
    if (sideToTest == BOTTOM)
    {
        rectToTest = NSMakeRect(
                                //[[element objectForKey:@"farRight"]floatValue],
                                [[element objectForKey:xcoordinate]floatValue],
                                [[element objectForKey:ycoordinate]floatValue],
                                (myGroupingBox.bounds.origin.x + myGroupingBox.bounds.size.width) - ([[element objectForKey:@"farRight"]floatValue]),
                                [[element objectForKey:@"height"]floatValue]
                                );
        borderDistance =  [[element objectForKey:ycoordinate]intValue] - [[myGroupingBox valueForKey:ycoordinate]intValue];
    }
    
    
    
    
    NSLog(@"this far0");
    //are there grouping boxes in this rect, order them by closest distance
    BOOL contained;
    int nearest;
    NSMutableArray *elementsInPath = [NSMutableArray array];
    NSMutableArray *groubingBoxesInPath = [NSMutableArray array];
    for (GroupingBox *gb in myGroupingBox.nestedGroupingBoxes)
    {
        contained = CGRectIntersectsRect(rectToTest, gb.bounds);
        if (contained)
        {
            [groubingBoxesInPath addObject:gb];
        }
    }
    NSLog(@"this far1");
    NSSortDescriptor *horizontally = [[NSSortDescriptor alloc] initWithKey:xcoordinate ascending:YES];
    NSArray *horizontalSortDescriptor = [NSArray arrayWithObject: horizontally];
    if ([groubingBoxesInPath count] > 0)
    {
        NSLog(@"this far2");
        [groubingBoxesInPath sortedArrayUsingDescriptors:horizontalSortDescriptor];
        NSLog(@"this far3");
    }
    
    
    
    //are there other elements in this rect, order them by closest distance
    for (NSDictionary *dc in myGroupingBox.insideTheBox)
    {
        NSLog(@"this far4");
        if ([dc isEqualToDictionary:element] == NO)
        {
            NSLog(@"this far5");
            NSRect dcRect = NSMakeRect([[dc objectForKey:xcoordinate]floatValue],
                                       [[dc objectForKey:ycoordinate]floatValue],
                                       [[dc objectForKey:@"width"] floatValue],
                                       [[dc objectForKey:@"height"]floatValue]);
            contained = CGRectIntersectsRect(rectToTest, dcRect);
            if (contained)
            {
                NSLog(@"IT intersects");
                [elementsInPath addObject:dc];
                NSLog(@"ADDED IT TO ELEMENTSINPATH ARRAY.");
            }
        }
        NSLog(@"this far6");
        
    }
    if ([elementsInPath count] > 0)
    {
        NSLog(@"this far7");
        [elementsInPath sortedArrayUsingDescriptors:horizontalSortDescriptor];
        NSLog(@"this far8");
        if ([groubingBoxesInPath count] > 0)
        {
            NSLog(@"ERROR IN 1");
            nearest = MIN([[groubingBoxesInPath objectAtIndex:0]intValue], [[elementsInPath objectAtIndex:0]intValue]);
        }
        else
        {
            NSLog(@"ERROR IN 2?");
            //nearest = [[[elementsInPath objectAtIndex:0]objectForKey:xcoordinate]intValue] - [[element objectForKey:@"farRight"]intValue];
            nearest = [[element objectForKey:ycoordinate]intValue] - [[[elementsInPath objectAtIndex:0]objectForKey:bottomYcoordinate]intValue];
            NSLog(@"Nope");
        }
        
        NSLog(@"this far9");
    }
    else
    {
        if ([groubingBoxesInPath count] > 0)
        {
            nearest = [[groubingBoxesInPath objectAtIndex:0]intValue];
        }
        else
        {
            NSLog(@"Write some magic");
            nearest = borderDistance;
        }
        
    }
    
    
    
    // One last thing...
    if (sideToTest == TOP)
    {
        NSNumber *lowest = [self lowestElementCleanAboveMe:element inGroupingBox:myGroupingBox.insideTheBox withCurrentMarginTop:nearest];
        
        if (lowest != nil) {
            nearest = [lowest floatValue];
            NSLog(@"BLOCKA! : %f", [lowest floatValue]);
        }
    }
    
    //take the lowest of the two distances and use it as the right margin
    NSLog(@"The nearest object is : %i px away. Testing : %ld", nearest, sideToTest);
    
    return nearest;
}

-(NSNumber *)lowestElementCleanAboveMe: (NSDictionary *)element inGroupingBox:(NSArray*)groupingBoxArray withCurrentMarginTop:(int)marginTop
{
    NSMutableArray *elementsCleanAboveMe = [NSMutableArray array];
    NSUInteger myIndexInSortedArray = [groupingBoxArray indexOfObject:element];
    NSNumber *newMarginTop = nil;
    
    for (NSDictionary *item in groupingBoxArray)
    {
        NSUInteger testIndexInSortedArray = [groupingBoxArray indexOfObject:item];
        if (
            ([[item valueForKey:bottomYcoordinate] intValue]  < [[element valueForKey:ycoordinate] intValue] ) && // clean above me
            (testIndexInSortedArray < myIndexInSortedArray) && // before me in SortedArray
            ([[item objectForKey:xcoordinate]floatValue] + [[item objectForKey:@"width"]floatValue] < [[element objectForKey:xcoordinate]floatValue]) // to my left
            )
        {
            
            //  Place in my basket
            NSLog(@"Element A: %@ is a match for B: %@", [item objectForKey:@"id"], [element objectForKey:@"id"]);
            [elementsCleanAboveMe addObject:item];
        }
    }
    if (elementsCleanAboveMe.count > 0)
    {
        // Get the one with the largest ycoordinate, the lowest one
        NSSortDescriptor *verticalSortDescriptor = [[NSSortDescriptor alloc] initWithKey:ycoordinate ascending:YES];
        NSArray *vertically = [NSArray arrayWithObject: verticalSortDescriptor];
        [elementsCleanAboveMe sortedArrayUsingDescriptors:vertically];
        NSDictionary *lowest = [elementsCleanAboveMe lastObject];
        
        GroupingBox *gLowest = [self whichGroupingBoxIsElementIn:lowest];
        GroupingBox *gMe = [self whichGroupingBoxIsElementIn:element];
        
        if (gMe == gLowest) {
            newMarginTop = [NSNumber numberWithFloat:( [[element objectForKey:ycoordinate]floatValue] -  [[lowest objectForKey:bottomYcoordinate]floatValue] )];
            NSLog(@"Calculation is %f - %f", [[element objectForKey:ycoordinate]floatValue], [[lowest objectForKey:bottomYcoordinate]floatValue]);
        }
        
    }
    
    return newMarginTop;
    
}

-(void)updateNestedGroupingBoxesVariable
{
    // check if this grouping box is inside another grouping box
    
    // if so then update the daddy groupingbox's nestedGroupingBoxes variable
}


-(GroupingBox*)whichGroupingBoxIsElementIn:(NSDictionary*)elementBeingTested
{
    
    NSArray *ag = nil;
    GroupingBox *groupingb = nil;
    
    for (GroupingBox *box in groupingBoxes)
    {
        ag = [box insideTheBox];
        for (NSDictionary *dict in ag)
        {
            if ([elementBeingTested isEqualToDictionary:dict] == YES)
            {
                return box;
            }
        }
        
    }
    return groupingb;
}



-(BOOL)isClosestObjectToMyLeftAnElement: (NSDictionary *)elementBeingTested
{
    //This method is used to determine whether or not
    BOOL overlap,isElementClosest;
    NSMutableArray *overlappingItems = [NSMutableArray array];
    GroupingBox *grb = [self whichGroupingBoxIsElementIn:elementBeingTested];
    NSRect rectToTest = NSMakeRect([[elementBeingTested objectForKey:xcoordinate]floatValue],
                                   [[elementBeingTested objectForKey:ycoordinate]floatValue],
                                   (grb.bounds.origin.x - [[elementBeingTested objectForKey:xcoordinate]floatValue]),
                                   [[elementBeingTested objectForKey:@"height"]floatValue]);
    for (NSDictionary *dc in grb.insideTheBox)
    {
        NSRect dcRect = NSMakeRect(
                                   [[dc objectForKey:xcoordinate]floatValue],
                                   [[dc objectForKey:ycoordinate]floatValue],
                                   [[dc objectForKey:@"width"]floatValue],
                                   [[dc objectForKey:@"height"]floatValue]);
        overlap = CGRectContainsRect(rectToTest, dcRect);
        if (overlap) {
            [overlappingItems addObject:dc];
        }
    }
    
    if ([overlappingItems count] != 0) //we have elements that are to my left inside this groupingbox
    {
        NSSortDescriptor *horizontalSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"xcoordinate" ascending:YES];
        NSArray *horizontally = [NSArray arrayWithObject: horizontalSortDescriptor];
        overlappingItems = [NSMutableArray arrayWithArray:[overlappingItems sortedArrayUsingDescriptors:horizontally]];
        isElementClosest = YES;
        
    }
    else
    {
        isElementClosest = NO;
    }
    
    return isElementClosest;
    
}

-(NSMutableDictionary *)nearestElementDirectlyAboveMeInMyRow: (NSDictionary *)elementBeingTested
{
    NSLog(@"start 0");
    NSUInteger elementBeingTestedY = [[elementBeingTested valueForKey:bottomYcoordinate] unsignedIntegerValue];
    NSUInteger elementBeingTestedW = [[elementBeingTested valueForKey:@"width"] unsignedIntegerValue];
    NSUInteger elementBeingTestedX = [[elementBeingTested valueForKey:@"xcoordinate"] unsignedIntegerValue];
    NSRange elementBeingTestedRange = NSMakeRange(elementBeingTestedX, elementBeingTestedW);
    NSUInteger rowImIn;
    NSLog(@"start 1");
    for (NSArray *r in self.rows)
    {
        if ([r containsObject:elementBeingTested])
        {
            rowImIn = [self.rows indexOfObject:r];
        }
    }
    NSLog(@"start 2: ROW I'M IN: %lu and row count is: %lu", rowImIn, self.rows.count);
    
    NSMutableArray *itemsInMyRow = [NSMutableArray array];
    itemsInMyRow = [self.rows objectAtIndex:rowImIn];
    NSMutableArray *elementsChecked = [NSMutableArray array];
    NSMutableArray *inMyRange = [NSMutableArray array];
    NSLog(@"start 3");
    
    for (NSDictionary *compare in itemsInMyRow)
    {
        if ([compare isEqualToDictionary:elementBeingTested] == NO)    //  If not me
        {
            if ([elementsChecked containsObject:compare] == NO) //  if this object hasn't been checked
            {
                NSUInteger compareY = [[compare valueForKey:bottomYcoordinate] unsignedIntegerValue];
                NSUInteger compareW = [[compare valueForKey:@"width"] unsignedIntegerValue];
                NSUInteger compareX = [[compare valueForKey:@"xcoordinate"] unsignedIntegerValue];
                NSRange compareWidthRange = NSMakeRange(compareX, compareW); //X location and the length
                
                NSRange comparison = NSIntersectionRange(elementBeingTestedRange, compareWidthRange);
                
                if ((compareY < elementBeingTestedY) & (comparison.length!=0)) //    We have a match
                {
                    NSLog(@"start 4");
                    [inMyRange addObject:compare]; //   Add the comparison object so it now has an order.
                    [elementsChecked addObject:compare]; // So we don't check it again
                    
                }
                else
                {
                    NSLog(@"start 5");
                    [elementsChecked addObject:compare];
                }
            }
        }
    } //    Closes the for loop
    
    NSLog(@"start 6");
    NSNumber *yCoordinateOfLowestElement = [NSNumber new];
    NSMutableDictionary *lowestElement = nil;
    NSLog(@"start 7");
    if ([inMyRange count] > 0)
    {
        NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:bottomYcoordinate ascending:NO];
        NSLog(@"start 8");
        NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
        NSLog(@"start 9");
        NSArray *sorteditemsInRowAboveMe = [inMyRange sortedArrayUsingDescriptors:verticalSortDescriptor];
        NSLog(@"start 10");
        lowestElement = [sorteditemsInRowAboveMe objectAtIndex:0];
        NSLog(@"start 11");
        yCoordinateOfLowestElement = [lowestElement valueForKey:bottomYcoordinate];
        NSLog(@"start 12");
    }
    NSLog(@"start 13");
    NSLog(@"yCoordinateOfLowestElement : %@", yCoordinateOfLowestElement);
    return lowestElement;
    
    
}


-(NSDictionary *)highestElementInMyRow: (NSDictionary *)elementBeingTested
{
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:ycoordinate ascending:NO];
    NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
    
    NSUInteger rowImIn;
    for (NSArray *r in self.rows)
    {
        if ([r containsObject:elementBeingTested])
        {
            rowImIn = [self.rows indexOfObject:r];
        }
    }
    
    NSMutableArray *itemsInMyRow = [NSMutableArray array];
    itemsInMyRow = [self.rows objectAtIndex:rowImIn];
    
    
    //  Sort itemsInRowAbove to get the item with the lowest Y value
    NSArray *sorteditemsInRowAboveMe = [itemsInMyRow sortedArrayUsingDescriptors:verticalSortDescriptor];
    NSDictionary *highestElement = [sorteditemsInRowAboveMe lastObject];
    
    return highestElement;
}



-(int)highestYcoordinateInMyRow: (NSDictionary *)elementBeingTested //which now means the smallest when view isFlipped.
{
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:ycoordinate ascending:NO];
    NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
    
    NSUInteger rowImIn;
    for (NSArray *r in self.rows)
    {
        if ([r containsObject:elementBeingTested])
        {
            rowImIn = [self.rows indexOfObject:r];
        }
    }
    
    NSMutableArray *itemsInMyRow = [NSMutableArray array];
    NSArray *sortedItemsInRow = [NSArray array];
    itemsInMyRow = [self.rows objectAtIndex:rowImIn];
    
    
    //  Sort itemsInRowAbove to get the item with the highest Y value
    sortedItemsInRow = [itemsInMyRow sortedArrayUsingDescriptors:verticalSortDescriptor];
    
    NSDictionary *highestElement = [sortedItemsInRow lastObject];
    int rowMarginTop = [[highestElement valueForKey:@"ycoordinate"]intValue];
    NSLog(@"  **** Returning fom highestYcoordinateInMyRow : %i", rowMarginTop);
    return rowMarginTop;
}



-(int)largestYcoordinateInMyRow: (NSDictionary *)elementBeingTested
{
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:bottomYcoordinate ascending:YES];
    NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
    
    NSUInteger rowImIn;
    for (NSArray *r in self.rows)
    {
        if ([r containsObject:elementBeingTested])
        {
            rowImIn = [self.rows indexOfObject:r];
        }
    }
    
    NSMutableArray *itemsInMyRow = [NSMutableArray array];
    itemsInMyRow = [self.rows objectAtIndex:rowImIn];
    
    
    //  Sort itemsInRowAbove to get the item with the lowest Y value
    NSArray *sorteditemsInRowAboveMe = [itemsInMyRow sortedArrayUsingDescriptors:verticalSortDescriptor];
    NSDictionary *lowestElement = [sorteditemsInRowAboveMe lastObject];
    int rowMarginBottom = [[lowestElement valueForKey:bottomYcoordinate]intValue];
    
    return rowMarginBottom;
}



-(NSMutableArray*)arrayOfSoloItems: (NSArray *)initalSorting
{
    NSLog(@"Received : %@", initalSorting);
    NSMutableArray *solos = [NSMutableArray array];
    for (NSDictionary *elementia in initalSorting)
    {
        NSMutableArray *inMyRightRange = [NSMutableArray array];
        NSUInteger xco = [[elementia valueForKey:@"xcoordinate"] unsignedIntegerValue];
        NSUInteger yco = [[elementia valueForKey:ycoordinate] unsignedIntegerValue];
        NSUInteger vSide = [[elementia valueForKey:@"height"] unsignedIntegerValue];
        NSRange eleRange = NSMakeRange(yco, vSide);
        
        for (NSDictionary *testObject in initalSorting)
        {
            NSUInteger testX = [[testObject valueForKey:@"xcoordinate"] unsignedIntegerValue];
            NSUInteger testY = [[testObject valueForKey:ycoordinate] unsignedIntegerValue];
            NSUInteger testH = [[testObject valueForKey:@"height"] unsignedIntegerValue];
            NSRange testObjectRange = NSMakeRange(testY, testH);
            NSRange comparison = NSIntersectionRange(eleRange, testObjectRange);
            
            if ((testX < xco) & (comparison.length!=0) )
            {
                [inMyRightRange addObject:testObject];
                NSLog(@"Dict with height : %lu has object in left range with height : %lu", vSide, testH);
            }
            
        }
        if ([inMyRightRange count] == 0)
        {
            [solos addObject:elementia];
            NSLog(@"SOLO IS: %@", elementia);
        }
    }
    
    return solos;
}



-(void)setGroupingBoxesBoundsRect
{
    ///  SAVE THE DIMENSIONS OF THE GROUPING BOXES AS IVARS
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:@"ycoordinate" ascending:NO]; // Biggest one is at the front
    NSSortDescriptor *horizontally = [[NSSortDescriptor alloc] initWithKey:@"xcoordinate" ascending:YES]; // Biggest at the end
    NSSortDescriptor *horizontallyFarRight = [[NSSortDescriptor alloc] initWithKey:@"farRight" ascending:YES];
    NSArray *horizontalSortDescriptor = [NSArray arrayWithObject: horizontally];
    NSArray *horizontalSortDescriptorFarRight = [NSArray arrayWithObject:horizontallyFarRight];
    NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
    
    for (GroupingBox *gb in groupingBoxes)
    {
        if ([gb idPreviouslyKnownAs] == nil)
        {
            NSArray *vSortedArrayOfGroupingBoxElements = [[gb insideTheBox] sortedArrayUsingDescriptors:verticalSortDescriptor];
            NSArray *hSortedArrayOfGroupingBoxElements = [[gb insideTheBox] sortedArrayUsingDescriptors:horizontalSortDescriptor];
            
            float firstX = [[[hSortedArrayOfGroupingBoxElements objectAtIndex:0] valueForKey:@"xcoordinate"] floatValue];
            float lastX = [[[[[gb insideTheBox] sortedArrayUsingDescriptors:horizontalSortDescriptorFarRight] lastObject] valueForKey:@"xcoordinate"] floatValue];
            float topY = [[[vSortedArrayOfGroupingBoxElements lastObject] objectForKey:ycoordinate] floatValue];
            
            
            float lastXWidth = [[[[[gb insideTheBox] sortedArrayUsingDescriptors:horizontalSortDescriptorFarRight] lastObject] valueForKey:@"width"] floatValue];
            
            NSLog(@"A = %i", [[[vSortedArrayOfGroupingBoxElements objectAtIndex:0] objectForKey:bottomYcoordinate]intValue]);
            NSLog(@"B = %i", [[[vSortedArrayOfGroupingBoxElements lastObject] objectForKey:ycoordinate]intValue]);
            float height = [[[vSortedArrayOfGroupingBoxElements objectAtIndex:0] objectForKey:bottomYcoordinate]intValue] - [[[vSortedArrayOfGroupingBoxElements lastObject] objectForKey:ycoordinate]intValue];
            float width = (lastX + lastXWidth) - firstX;
            
            /*
             
             int largestHeight = [[[gb.insideTheBox objectAtIndex:0] valueForKey:ycoordinate] intValue];
             int smallestHeight = [[[gb.insideTheBox objectAtIndex:0] valueForKey:ycoordinate] intValue];
             
             
             for (NSDictionary *dictionary in gb.insideTheBox)
             {
             int height = [[dictionary valueForKey:@"ycoordinate"] intValue] + [[dictionary valueForKey:@"height"] intValue];
             int feet = [[dictionary valueForKey:@"ycoordinate"] intValue];
             
             if (height > largestHeight)
             {
             largestHeight = height;
             }
             
             if (feet < smallestHeight)
             {
             smallestHeight = feet;
             }
             }
             
             float width = (lastX + lastXWidth) - firstX;
             float height = largestHeight - smallestHeight; //(firstY + firstYHeight) - lastY;
             */
            
            if (lastX == firstX)
            {
                width = [[[hSortedArrayOfGroupingBoxElements objectAtIndex:0] valueForKey:@"width"] floatValue];
                height = [[[hSortedArrayOfGroupingBoxElements objectAtIndex:0] valueForKey:@"height"] floatValue];
                
            }
            [gb setBoundRect:NSMakeRect(firstX, topY, width, height)];
            [gb setValue:[NSNumber numberWithFloat:firstX] forKey:xcoordinate];
            [gb setValue:[NSNumber numberWithFloat:topY] forKey:ycoordinate];
            [gb setValue:[NSNumber numberWithInt:width] forKey:@"width"];
            [gb setValue:[NSNumber numberWithInt:height] forKey:@"height"];
            [gb setRtFrame:NSMakeRect(firstX, topY, width, height)];
            NSLog(@"rtFrame : %@", NSStringFromRect(gb.rtFrame) );
            
        }
        else
        {
            NSLog(@"Skipping the provision of boundRect for groupingBox as this should be a converted GroupingBox");
        }
        
        
    }
    
}

-(void)setMarginsForElementInGroupingBox
{
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:@"ycoordinate" ascending:NO];
    NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
    
    
    NSNumber *marginTop = [NSNumber new];
    
    ///  Lastly, lets do some adjusting of marginTop and marginBottoms but only if it's not an element that was previouslyKnownAs another element
    NSArray *AG = [NSArray array];
    for (GroupingBox *box in groupingBoxes)
    {
        NSLog(@"previously know as: %@", box.idPreviouslyKnownAs);
        AG = [box insideTheBox];
        NSMutableDictionary *highest = [[AG sortedArrayUsingDescriptors:verticalSortDescriptor] lastObject];
        
        // PLACE ELSEWHERE IN SCRIPT - WRONG METHOD.
        int boxMarginTop = [[box valueForKey:ycoordinate]intValue] - [self highestYcoordinateInMyRow:highest]; //was [self marginToElementAboveMe:highest];
        NSLog(@"TEST3 TEST3 : %i and %i", boxMarginTop, [[box valueForKey:ycoordinate]intValue] );
        [box setMarginTop:boxMarginTop];
        NSLog(@"pla2");
        [highest setObject:[NSNumber numberWithInt:0] forKey:@"marginTop"]; //The row will take care of marginTops for me
        // PLACE ELSEWHERE IN SCRIPT - WRONG METHOD.
        
        
        
        if ([box idPreviouslyKnownAs] == nil)
        {
            // GET THE HIGHEST OBJECT and use its Y Coordinate to set the highest y coordinate of the grouping box
            
            
            if ([AG count] > 0)
            {
                
                // later - use a better variable rather than clog up the model object .h file
                [box setValue:[highest objectForKey:ycoordinate] forKey:ycoordinate];
                
                
                for (NSMutableDictionary *element in AG)
                {
                    NSLog(@"ELEMENT ID entered:  %@", [element valueForKey:@"id"]);
                    //Get the elements that are above me but only within this Group
                    NSArray *aboveMe = [element objectForKey:@"elementsAboveMe"];
                    NSMutableArray *elementsAboveMeInThisGroup = [NSMutableArray array];
                    for (NSDictionary *elem in aboveMe) // or I could just test for cgrectintersection
                    {
                        if ([AG containsObject:elem]) {
                            [elementsAboveMeInThisGroup addObject:elem];
                        }
                    }
                    if ([elementsAboveMeInThisGroup count] > 0) {
                        [elementsAboveMeInThisGroup sortedArrayUsingDescriptors:verticalSortDescriptor];
                    }
                    
                    /*
                     
                     // measure against the GB BORDER TOP
                     if ([elementsAboveMeInThisGroup count] == 0 && [[element valueForKey:@"leave"] isEqualToString:@"yes"] == NO)
                     //THIS SHOULD ONLY CONSIDER ELEMENTS WITH NOTHING ABOVE IT, IN MY GROUP, AND DON'T HAVE THE SPECIAL CASE OF A MINI-ROW ANYWHERE ABOVE ME.
                     {
                     
                     NSLog(@"My element id outside statement: %@", [element objectForKey:@"id"]);
                     NSUInteger myIndex = [AG indexOfObject:element];
                     if (myIndex != 0)
                     {
                     NSLog(@"My element id inside if statement: %@", [element objectForKey:@"id"]);
                     NSUInteger indexOfObjectBeforeMe = myIndex-1;
                     int ycoOfObjectBeforeMe = [[[AG objectAtIndex:indexOfObjectBeforeMe]objectForKey:ycoordinate]intValue];
                     int marginTopOfObjectBeforeMe = [[[AG objectAtIndex:indexOfObjectBeforeMe]objectForKey:@"marginTop"]intValue];
                     int ycoPlusMarginOfObjectBeforeMe = ycoOfObjectBeforeMe - marginTopOfObjectBeforeMe;
                     int myYco = [[element objectForKey:ycoordinate]intValue];
                     NSLog(@"We have ycoOfObjectBeforeMe of: %i and myYco of: %i and marginTopOfObjectBeforeMe : %i", ycoOfObjectBeforeMe, myYco, marginTopOfObjectBeforeMe);
                     
                     if ( ycoOfObjectBeforeMe > myYco )
                     {
                     int negativeDifferenceMargin = myYco - ycoPlusMarginOfObjectBeforeMe;
                     int originalMargin = [[element objectForKey:ycoordinate]intValue] - [[box valueForKey:ycoordinate]intValue];
                     NSLog(@"MARGIN TOP SET TO FROM IF STATEMENT: %i AND ORIGINAL STATEMENT IS: %i", negativeDifferenceMargin, originalMargin);
                     marginTop = [NSNumber numberWithInt:negativeDifferenceMargin];
                     }
                     [element setObject:marginTop forKey:@"marginTop"];
                     
                     }
                     
                     }
                     else
                     {
                     marginTop = [NSNumber numberWithInt: [self marginToObjectWithinTransformedGroupingBox:element onSide:TOP]];
                     [element setObject:marginTop forKey:@"marginTop"];
                     }
                     */
                    marginTop = [NSNumber numberWithInt: [self marginToObjectWithinTransformedGroupingBox:element onSide:TOP]];
                    [element setObject:marginTop forKey:@"marginTop"];
                    
                }
            }
        }
        
        
        
        //  Set all objects within this Grouping that does not have anything above it (thats inside the Grouping) to have the necessary marginTops
        if ( ([box idPreviouslyKnownAs] != nil) )
        {
            
            // get all of the solos
            // get the objects to their right
            // get the next one highest with an empty left
            // set its margin top right and possibly left if its closest left object is the wall
            NSMutableArray *sortedArrayInsideGroupingBox = [NSMutableArray array];
            NSMutableArray *solos = [[NSMutableArray alloc]init];
            box.insideTheBox = [NSMutableArray arrayWithArray:[box.insideTheBox sortedArrayUsingDescriptors:verticalSortDescriptor]];
            
            
            
            solos = [self arrayOfSoloItems:box.insideTheBox];
            for (NSMutableDictionary *g in solos)
            {
                
                int marginTop = [self marginToObjectWithinTransformedGroupingBox:g onSide:TOP];
                int marginRight = [self marginToObjectWithinTransformedGroupingBox:g onSide:RIGHT];
                int marginLeft;
                if ([self isClosestObjectToMyLeftAnElement:g] == NO)
                {
                    marginLeft = [self marginToObjectWithinTransformedGroupingBox:g onSide:LEFT];
                    [g setObject:[NSNumber numberWithInt:marginLeft] forKey:@"marginLeft"];
                }
                
                //int marginBottom = [self marginToObjectWithinTransformedGroupingBox:g onSide:BOTTOM];
                NSLog(@"SOLO TOP = %i. ID = %@", marginTop, [g objectForKey:@"id"]);
                //NSLog(@"SOLO RIGHT = %i", marginRight);
                NSLog(@"SOLO LEFT = %i", marginLeft);
                //NSLog(@"SOLO BOTTOM = %i", marginBottom);
                
                [g setObject:[NSNumber numberWithInt:marginTop] forKey:@"marginTop"];
                [g setObject:[NSNumber numberWithInt:marginRight] forKey:@"marginRight"];
                //[g setObject:[NSNumber numberWithInt:marginBottom] forKey:@"marginBottom"];
                
                // Get the highest object which doesn't have anything to its left that's already been counted.
                NSMutableArray *toMyRightInThisGroupingBox =  [NSMutableArray arrayWithArray:[self elementsToMyRightInGroupingBox:g]];
                NSArray *solidToMyRight = [NSArray arrayWithArray:toMyRightInThisGroupingBox];
                NSMutableArray *elementsNotCountedYet = [NSMutableArray arrayWithArray: toMyRightInThisGroupingBox];
                
                NSLog(@"TO MY RIGHT, INSIDE GB, CONTAINS: %lu objects.", [toMyRightInThisGroupingBox count]);
                toMyRightInThisGroupingBox = [NSMutableArray arrayWithArray:[toMyRightInThisGroupingBox sortedArrayUsingDescriptors:verticalSortDescriptor]]; // ordered by by height
                //NSMutableArray *alreadyCounted = [NSMutableArray arrayWithArray:leftToRightTopToBottom];
                //[alreadyCounted removeObjectsInArray:toMyRight];// ???
                
                [sortedArrayInsideGroupingBox addObject:g]; //   Add myself
                while ([elementsNotCountedYet count] != 0)
                {
                    NSDictionary *next = [self highestElementWithEmptyLeft:toMyRightInThisGroupingBox];//THIS EVENTUALLY WILL HAVE TO CHANGE TO BE HIGHESTELE IN GROUP.*
                    NSDictionary *previous = [sortedArrayInsideGroupingBox lastObject];
                    
                    
                    //  get all elements in the right range of the previous element and select the one with the smallest x value.
                    //  Bug fixed: So that it nows reads better, left to right, rather than just next object with nothing to its left
                    if ([elementsNotCountedYet count] != [solidToMyRight count]) // So it's not the first loop
                    {
                        NSArray *previousElementsToMyRight = [self elementsToMyRightInGroupingBox:previous];
                        if ([previousElementsToMyRight count]!=0)
                        {
                            if ([sortedArrayInsideGroupingBox containsObject:[previousElementsToMyRight objectAtIndex:0]] == NO)
                            {
                                next = [previousElementsToMyRight objectAtIndex:0];
                                NSLog(@"Inside the 'doesnt contain this object' if statement");
                            }
                            
                            NSLog(@"Next width = %@", [next valueForKey:@"width"]);
                        }
                    }
                    
                    if ([sortedArrayInsideGroupingBox containsObject:next] == NO) // As if might not hit the big if statement above and so next object may already exist in the SortedArray dataset.
                    {
                        [sortedArrayInsideGroupingBox addObject:next];
                        int marginTop = [self marginToObjectWithinTransformedGroupingBox:next onSide:TOP];
                        int marginRight = [self marginToObjectWithinTransformedGroupingBox:next onSide:RIGHT];
                        int marginLeft;
                        if ([self isClosestObjectToMyLeftAnElement:next] == NO)
                        {
                            marginLeft = [self marginToObjectWithinTransformedGroupingBox:next onSide:LEFT];
                        }
                        NSLog(@"TOP = %i\n RIGHT = %i \n. LEFT = %i \n", marginTop, marginRight, marginLeft);
                    }
                    [toMyRightInThisGroupingBox removeObject:next];
                    elementsNotCountedYet = toMyRightInThisGroupingBox;
                    
                }
            }
            
        }
        
        
    }
}

-(void)setGroupingBoxMargin: (GroupingBox*)g
{
    NSLog(@"ADJUSTMENTS SECTION. CURRENT MARGINTOP : %d FOR OBJECT WITH ID :%@", g.marginTop, [g valueForKey:ycoordinate] );
    
    // find the closest element above me in this row
    int offset;
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:@"ycoordinate" ascending:NO];
    NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
    NSArray *vSortedArrayOfGroupingBoxElements = [[g insideTheBox] sortedArrayUsingDescriptors:verticalSortDescriptor];
    
    NSMutableDictionary *firstObjectinGroupBox =[vSortedArrayOfGroupingBoxElements lastObject];
    NSLog(@"The highest box in the gb has id of: %@", [firstObjectinGroupBox objectForKey:@"id"]);
    NSMutableDictionary *directlyAboveMeInThisRow = [self nearestElementDirectlyAboveMeInMyRow:firstObjectinGroupBox];
    
    // either it exists or it doesn't
    if (directlyAboveMeInThisRow == nil)
    {
        // if there is nothing above me in this row
        offset = [[g valueForKey:ycoordinate]intValue] - [self highestYcoordinateInMyRow:firstObjectinGroupBox];
        NSLog(@"if statement : %i", offset);
    }
    else
    {
        // if there is something above me, get its gbox and offset against the lowesty in the gbox.
        GroupingBox *thegbAboveMe = [self whichGroupingBoxIsElementIn:directlyAboveMeInThisRow];
        offset = [[firstObjectinGroupBox objectForKey:ycoordinate]intValue] - (thegbAboveMe.rtFrame.origin.y + thegbAboveMe.rtFrame.size.height);
        NSLog(@"else statement : %i", offset);
        
    }
    // TODO:  I ALSO NEED TO CHECK WHETHER THERE IS A GROUPING BOX IN MY PATH - as the above may not catch it.
    
    [g setMarginTop:offset];
    
    /*
     //  Adjust the marginTop of the GroupBoxes to take into account the rows
     NSNumber *marginToSet = [[NSNumber alloc] init];
     NSLog(@"one");
     
     NSLog(@"two");
     NSUInteger rowImIn;
     NSLog(@"three");
     for (NSArray *r in self.rows)
     {
     NSLog(@"four");
     if ([r containsObject:firstObjectinGroupBox])
     {
     NSLog(@"five");
     rowImIn = [self.rows indexOfObject:r];
     NSLog(@"six");
     }
     } // FACTOR THE ABOVE OUT TO - WHICHROWAMIIN - method
     
     // * If gb contains an element that is highest in this row then apply the margin to the row not the gb. * //
     
     
     // Get the distance to the nearest item in my Y range
     
     // Get the distance to the highest item in my row
     
     // Assuming neither are minus, use the lowest of the two
     
     NSLog(@"here?");
     // 1a. check if there is a grouping box in my path that is also in my row. If not this returns NULL.
     NSNumber *themargin = [self getMarginTopForGroupings:g]; // ** PROBLEM IS HERE - MON 8TH OCTOBER --- THIS MARGIN SHOULD BE APPLIED TO THE ROW NOT THE GROUPINGBOX IF GB CONTAINS THE HIGHEST ELE IN ROW.
     NSLog(@"THEMARGIN : %@", themargin);
     if (themargin) // if there's a groupingBox above me
     {
     NSDictionary *highestElementInRow = [self highestElementInMyRow:g.insideTheBox.lastObject]; // but what about when gbs are in other gbs
     if ([[g insideTheBox] containsObject:highestElementInRow])
     {
     //[self.rowMargins insertObject:themargin atIndex:rowImIn];
     marginToSet = [NSNumber numberWithInt:0];
     // NSLog(@"GROUPINGBOX CONTAINS THE HIGHEST ELEMENT IN THE ROW. Row marging = %@", self.rowMargins);
     }
     else
     {
     // if it doesn't contain the highest element in the row then my margin should be based on the highest element in the row
     marginToSet = [NSNumber numberWithInt:([[highestElementInRow valueForKey:@"ycoordinate"]intValue] - [[highestElementInRow valueForKey:@"height"]intValue]) - g.rtFrame.origin.y ];
     NSLog(@"GROUPINGBOX * DOES NOT * CONTAIN THE HIGHEST ELEMENT IN THE ROW, BUT HAS A MARGIN OF : %@", marginToSet);
     }
     
     }
     else
     {
     // 1b. check if there is a solo in my path that is also in my row - possible? Leave for now.
     
     // 1c. if else, create marginTop based on the rowMargin for this row.
     marginToSet =[NSNumber numberWithInt:(g.rtFrame.origin.y - [self highestYcoordinateInMyRow:firstObjectinGroupBox] )];
     NSLog(@"THEMARGIN2 : %@", marginToSet);
     }
     
     [g setMarginTop:[marginToSet intValue]];
     */
}


-(NSArray*)elementsInside: (NSMutableDictionary *)elementBeingTested usingElements: (NSArray*) sortedArrayOnStage
{
    //This method returns an array containing: elements that are within its bounds or nil.
    
    NSRect containingRect = NSRectFromString([elementBeingTested objectForKey:RT_FRAME]);
    NSMutableArray *cleanInsideMe = [NSMutableArray array];
    
    for (Element *ele in sortedArrayOnStage)
    {
        NSRect elementRect = NSRectFromString([ele valueForKey:RT_FRAME]);
        if (CGRectContainsRect(containingRect, elementRect))
        {
            [cleanInsideMe addObject:ele];
        }
    }
    
    return cleanInsideMe;
}





-(NSString*)generateClassFromDynamicRow: (NSMutableDictionary*)dyRowDict withElementsOnStage: (NSArray*)sortedArrayOnStage
{
    NSString *stringContainingClass = [NSString string];
    NSArray *elementsInsideMe = [self elementsInside:dyRowDict usingElements:sortedArrayOnStage];
    NSMutableArray *elementsInsideMeIDs = [NSMutableArray array];
    for (Element *ele in elementsInsideMe)
    {
        [elementsInsideMeIDs addObject:ele.elementid];
    }
    NSMutableString *openingString = [NSMutableString stringWithFormat:@"function %@(", [dyRowDict objectForKey:ELEMENT_ID]];
    NSMutableString *classArray = [NSMutableString string];
    
    for (Element *ele in elementsInsideMe)
    {
        // Firstly I need to check if this item has an action and/or a dataSource.
        // If so, then send the ds keyword to dataSourceStringForKeyword
        
        // check if this element is a plain text field, if so then filter out.
        // I only want elements that are capturing information or calculating a result.
        
        
        if (ele.dataSourceStringEntered == nil)
        {
            if ( ([ele isMemberOfClass:[TextInputField class]] || [ele isMemberOfClass:[TextBox class]]) )
            {
                // the crap we don't want. These are text labels etc.
            }
            else
            {
                // so it doesn't have a dataSource but it's not a plain old textField used for labelling.
                [classArray appendString:[NSString stringWithFormat:@"self.%@ = %@;\n", ele.elementid, ele.elementid]];
                
                // and add the elements elementID to the function definition
                [openingString appendString:[NSString stringWithFormat:@"%@,", ele.elementid]];
                
            }
        }
        else //So this element has a dataSource
        {
            
            NSString *dsString = [self dataSourceStringForElement:ele sittingAmongstElementIDs:elementsInsideMeIDs];
            [classArray appendString:dsString];
            
            // if dataSource is based solely off of an element that is is this dyRow then no parameter is needed and string is self.meal2().price e.g.
        }
        
    }
    
    [openingString substringToIndex:[openingString length]-1]; // clean up, we remove the comma left over at the end
    [openingString appendString:@") {\n"];
    [classArray appendString:@"}\n"];
    [openingString appendString:classArray];
    
    // IF ANY ELEMENT USES DATASOURCE, THEN THE CONTROL THAT REPRESENTS THE DATASOURCE MUST BE KO.OBSERVABLE
    
    
    return stringContainingClass;
}


-(NSString*)dataSourceStringForElement:(Element*)ele sittingAmongstElementIDs: (NSArray*)elementsIDs
{
    // TODO: Once up and running check the validation tab to ensure this method generates code that considers the validation rules entered by the user.
    
    // Should be returning something like: [NSString stringWithFormat:@"self.%@ = ko.observable(%@);\n", ele.elementid, ele.elementid]
    
    // All we know is that the element has a dataSource.
    NSMutableString *codeStringToReturn = [NSMutableString string];
    
    if ([ele isMemberOfClass:[DropDown class]])
    {
        return [NSString stringWithFormat:@"self.%@ = ko.observable(%@);\n", ele.elementid, ele.elementid];
    }
    
    else if ( [ele isMemberOfClass:[TextInputField class]] )
    {
        NSArray *wordsSeperatedBySpaces = [ele.dataSourceStringEntered componentsSeparatedByString:@" "];
        NSString *firstWord = [wordsSeperatedBySpaces objectAtIndex:0];
        NSString *secondWord = [wordsSeperatedBySpaces objectAtIndex:1];
        
        for (NSString *anID in elementsIDs)
        {
            if ([firstWord isEqualToString:anID])// FIRST WORD IS EQUAL TO A eleid OF AN ELEMENT IN THIS DY ROW e.g. 'meal2 price'
            {
                //THEN TAKE THE SECOND WORD 'PRICE' AND CREATE THE STRING AS PER MONEY3.html
                codeStringToReturn = [NSMutableString stringWithFormat:@"self.%@ = ko.computed(function() {\n var %@ = self.%@().%@; \n return %@ ? \"$\" + %@.toFixed(2) : \"None\"; \n });", ele.elementid, secondWord, firstWord, secondWord, secondWord, secondWord];
                return codeStringToReturn;
                
                /*
                 
                 self.formattedPrice = ko.computed(function() {
                 var price = self.meal2().price;
                 return price ? "$" + price.toFixed(2) : "None";
                 });
                 
                 */
                
            }
        }
        
        NSLog(@"Got to the bootom of dataSourceStringElement");
        codeStringToReturn = [NSString stringWithFormat:@"self.%@ = %@;\n", ele.elementid, ele.elementid];
    }
    
    return codeStringToReturn;
}





-(NSString*)actionStringForElement:(Element*)keyword
{
    return nil;
}



-(NSString *)hsla:(NSColor *)color
{
    NSString *hexValue = [color hexadecimalValueOfAnNSColor];
    if (hexValue == nil)
    {
        hexValue = @"#FFFFFF";
    }
    return hexValue;
    
}




#pragma mark - Generate Code
-(IBAction)generateCode:(id)sender
{
    //JS code
    NSMutableString *jsCode = [NSMutableString string];
    
    self.rowMargins = [NSMutableArray array];
    NSMutableArray *whiteSpacesFound = [NSMutableArray array];
    NSMutableDictionary *textStyles = [NSMutableDictionary dictionary];
    //NSMutableDictionary *allStyles = [NSMutableDictionary dictionary];
    NSMutableArray *allStyles = [NSMutableArray array];
    NSDictionary *newDict = [NSDictionary dictionary];
    
    NSRange longestEffectiveRange;
    
    NSMutableArray *arrayOfElementDetails = [[NSMutableArray alloc]init];
    NSString *tagType = [[NSString alloc]init];
    NSString *tagContent = [[NSString alloc]init];
    int span = 0;
    
    for (Element *ele in elementArray)
    {
        //  Clean out any styles or markers for whiteSpaceFound from the last cycle.
        [allStyles removeAllObjects];
        [whiteSpacesFound removeAllObjects];
        
        //Get the tag
        NSLog(@"In the array: %@", ele.elementTag);
        
        //Get the HTML tag to use and its content
        tagType = nil;
        tagContent = nil;
        
        //Get the span - for Twitter Bootstrap
        span = ((int)ceil(ele.rtFrame.size.width/60));
        
        if (([ele isMemberOfClass:[TextInputField class]]))
        {
            tagContent = @"";
            tagType = @"textInputField";
        }
        
        
        if (([ele isMemberOfClass:[Box class]]))
        {
            tagContent = @"";
            tagType = @"div";
        }
        
        if (([ele isMemberOfClass:[Button class]]))
        {
            tagContent = ele.buttonText;
            tagType = @"button";
        }
        
        if ([ele isMemberOfClass:[Container class]])
        {
            tagContent = @"";
            tagType = CONTAINER_TAG;
        }
        
        if (([ele isMemberOfClass:[DropDown class]]))
        {
            tagContent = @"";
            tagType = DROP_DOWN_MENU_TAG;
        }
        
        
        if (([ele isMemberOfClass:[DynamicRow class]]))
        {
            // hardcoded options for selection shold go in tagContent here:
            tagContent = @"";
            tagType = DYNAMIC_ROW_TAG;
        }
        
        
        if (([ele isMemberOfClass:[Circle class]]))
        {
            tagContent = @"";
            tagType = @"circle";
        }
        
        if (([ele isMemberOfClass:[Triangle class]]))
        {
            tagContent = @"";
            tagType = @"triangle";
        }
        if (([ele isMemberOfClass:[TextBox class]]))
        {
            tagContent = ((TextBox *)ele).contentText.string;
            tagType = @"paragraph";
            
            
            NSRange rangeOfString = NSMakeRange(0, [[ele contentText] length]);
            NSUInteger stringEndPoint = rangeOfString.location + rangeOfString.length;
            NSUInteger currentPoint = 0;
            int loopCount = 0;
            while (stringEndPoint != currentPoint)
            {
                
                NSDictionary *style = [[ele contentText] attributesAtIndex:currentPoint longestEffectiveRange:&longestEffectiveRange inRange:rangeOfString];
                
                /*** STYLES ***/
                //Now clear the dictionary ready for the loop...
                [textStyles removeAllObjects];
                
                
                //The font name
                NSString *theFont = [[style objectForKey:NSFontAttributeName] fontName];
                [textStyles setObject:theFont forKey:@"fontName"];
                
                
                //The font size
                NSNumber *fontSize = [NSNumber numberWithInt:(int)[[style objectForKey:NSFontAttributeName] pointSize]];
                [textStyles setObject:fontSize forKey:@"fontSize"];
                
                
                // The text color
                NSColor *textColor = [style objectForKey:NSForegroundColorAttributeName];
                int red = 255*[textColor redComponent];
                int green = 255*[textColor greenComponent];
                int blue = 255*[textColor blueComponent];
                int alpha = [textColor alphaComponent];
                // HACK as alpha appearing as 0 when it should be 1.
                if (alpha == 0)
                {
                    NSLog(@"Hex color was: %@", [textColor hexColor]);
                    alpha = 1;
                }
                
                
                //[[style objectForKey:NSForegroundColorAttributeName] getRed:red green:green blue:blue alpha:alpha];
                NSString *fontColor = [NSString stringWithFormat:@"%d,%d,%d,%d", red, green, blue, alpha];
                [textStyles setObject:fontColor forKey:@"fontColor"];
                
                
                
                // The leading
                NSNumber *leading = [NSNumber numberWithInt:(int)[[style objectForKey:NSParagraphStyleAttributeName] lineSpacing]];
                if (leading != nil)
                {
                    [textStyles setObject:leading forKey:@"leading"];
                }
                
                
                
                //The kerning
                NSNumber *kerning = [style objectForKey:NSKernAttributeName];
                if (kerning != nil)
                {
                    [textStyles setObject:kerning forKey:@"kerning"];
                }
                
                
                
                
                // Underlined?
                NSNumber *underline = [style objectForKey:NSUnderlineStyleAttributeName];
                NSNumber *singleUnderline = [NSNumber numberWithInt:1];
                if ([underline isEqualToNumber:singleUnderline])
                {
                    [textStyles setObject:@"SingleUnderline" forKey:@"underline"];
                }
                
                
                
                // Character numbers
                //NSString *startRange = [NSString stringWithFormat:@"%lu", currentPoint];
                //NSString *endRange = [NSString stringWithFormat:@"%lu", longestEffectiveRange.location + longestEffectiveRange.length -1];
                NSUInteger startRange = currentPoint;
                NSUInteger endRange = longestEffectiveRange.location + longestEffectiveRange.length -1;
                [textStyles setObject:[NSNumber numberWithInteger:startRange] forKey:@"startRange"];
                [textStyles setObject:[NSNumber numberWithInteger:endRange] forKey:@"endRange"];
                
                
                
                
                // Find white space
                NSString *stringScanned = [NSString string];
                NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceCharacterSet];
                //NSCharacterSet *newline = [NSCharacterSet newlineCharacterSet];
                NSScanner *scanner = [NSScanner localizedScannerWithString: tagContent];
                [scanner setCharactersToBeSkipped:nil];
                
                
                while ([scanner isAtEnd] == NO)
                {
                    BOOL foundWhiteSpace = [scanner scanUpToCharactersFromSet:whiteSpace intoString:&stringScanned];
                    if (foundWhiteSpace == YES)
                    {
                        // Find out how far into the string we are, add one to the index, and add that as a marker of whitespace in the NSArray.
                        NSUInteger characterCount = [stringScanned length];
                        NSUInteger runningTotal = [[whiteSpacesFound lastObject] unsignedIntegerValue] + characterCount;
                        [whiteSpacesFound addObject:[NSNumber numberWithUnsignedInteger: runningTotal+1]];
                        
                        // Take the scanner past the object marker ready for the next scan
                        [scanner scanCharactersFromSet:whiteSpace intoString:NULL];
                        //NSString *substringLeft = [[scanner string] substringFromIndex:[scanner scanLocation]];
                    }
                    NSLog(@"The blank spaces are at index: %@", whiteSpacesFound);
                    
                }
                
                // HACK
                NSUInteger deletionIndexPoint = [whiteSpacesFound indexOfObject: [NSNumber numberWithUnsignedInteger:[tagContent length]+1]]+1;
                NSRange deleteRange = NSMakeRange(deletionIndexPoint, [whiteSpacesFound count] - deletionIndexPoint);
                NSLog(@"The deleteIndexPoint is:%lu", deletionIndexPoint);
                [whiteSpacesFound removeObjectsInRange:deleteRange];
                
                
                
                
                //At the end change the current point for the next loop...
                currentPoint = longestEffectiveRange.location + longestEffectiveRange.length;
                loopCount+=1;
                NSLog(@"Loop Count : %i", loopCount);
                NSString *subStringName = [NSString stringWithFormat:@"substring-%i",loopCount];
                [textStyles setObject:subStringName forKey:@"styleid"];
                newDict = [NSDictionary dictionaryWithDictionary:textStyles];
                //Dictionary and not Mutable dictionary so once it's in the daddy dictionary it doesn't change - which was annoying and a bug!
                //[allStyles setObject:newDict forKey:subStringName];
                [allStyles addObject:newDict];
                
            } //end while loop
            
        }
        if (([ele isMemberOfClass:[Image class]]))
        {
            
            if (((Image *)ele).imageView.image == nil)
            {
                //This is a dynamic image
                tagType = DYNAMIC_IMAGE_TAG;
                tagContent = nil;
            }
            else
            {
                tagType = IMAGE_TAG;
                tagContent = ((Image *)ele).filePath.lastPathComponent;
            }
            [allStyles removeAllObjects];
        }
        
        
        
        
        //NSDictionary *completeTextStyles = [NSDictionary dictionaryWithDictionary:allStyles];
        NSArray *completeTextStyles = [NSArray arrayWithArray:allStyles];
        //Put the details in a dictionary
        
        /*
         NSString *theborderRadius = [NSString stringWithFormat:@"%@ %@ %@ %@",
         [ele valueForKeyPath:@"borderRadius.top-left"],
         [ele valueForKeyPath:@"borderRadius.top-right"],
         [ele valueForKeyPath:@"borderRadius.bottom-right"],
         [ele valueForKeyPath:@"borderRadius.bottom-left"]];
         
         */
        
        NSMutableArray *borderRadiiOn = [NSMutableArray array];
        NSString *width = [NSString stringWithFormat:@"%@px", ele.borderRadius];
        
        if (ele.topLeftBorderRadius == YES)
        {
            [borderRadiiOn addObject:width];
        }
        else
        {
            [borderRadiiOn addObject:@"0"];
        }
        
        
        //
        if (ele.topRightBorderRadius == YES)
        {
            [borderRadiiOn addObject:width];
        }
        else
        {
            [borderRadiiOn addObject:@"0"];
        }
        
        
        //
        if (ele.bottomRightBorderRadius == YES)
        {
            width = [NSString stringWithFormat:@"%@", width];
            [borderRadiiOn addObject:width];
        }
        else
        {
            [borderRadiiOn addObject:@"0"];
        }
        
        
        //
        if (ele.bottomLeftBorderRadius == YES)
        {
            [borderRadiiOn addObject:width];
        }
        else
        {
            [borderRadiiOn addObject:@"0"];
        }
        
        //
        NSString *layoutObject = nil;
        if ([ele.layoutType isEqualToString:PERCENTAGE_BASED_LAYOUT])
        {
            layoutObject = @"%";
        }
        else
        {
            layoutObject = @"px";
        }
        
        
        
        
        NSMutableDictionary * export = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithFloat:ele.rtFrame.origin.x], @"xcoordinate",
                                        [NSNumber numberWithFloat:ele.rtFrame.origin.y], @"ycoordinate",
                                        [NSNumber numberWithFloat:ele.rtFrame.origin.y + ceilf(ele.rtFrame.size.height)], bottomYcoordinate,
                                        [NSNumber numberWithFloat:ele.rtFrame.origin.x + ceilf(ele.rtFrame.size.width)], @"rightXcoordinate",
                                        NSStringFromRect(ele.rtFrame), RT_FRAME,
                                        [NSNumber numberWithInt:ceilf(ele.rtFrame.size.width)], @"width",
                                        [NSNumber numberWithInt:ceilf(ele.rtFrame.size.height)], @"height",
                                        layoutObject, @"layoutType",
                                        //[NSNumber numberWithFloat:0.0], ycoordinate,
                                        [NSNumber numberWithInt:span], @"span",
                                        ele.spanGrouping, @"spanGrouping",
                                        tagContent, @"content",
                                        completeTextStyles, @"textStyles",
                                        whiteSpacesFound, @"whiteSpaces",
                                        [ele elementid], @"id",
                                        tagType, @"tag",
                                        @"demo", @"alt",
                                        @"blank", @"order",
                                        [ele borderWidth], @"borderWidth",
                                        ele.borderRadius, @"borderRadius",
                                        [borderRadiiOn componentsJoinedByString:@" "], @"borderRadiusAsString", //the string containing four radii mesurements
                                        [self hsla:ele.colorAttributes], @"backgroundColor",
                                        ele.dataSourceCodeString, @"dataSourceCode",
                                        ele.actionCodeString, @"actionCode",
                                        //[[ele valueForKeyPath:@"opacity"] valueForKey:@"body"], @"opacity",
                                        //Also get the NSColor as a hex value
                                        nil];
        //if there are no text styles, e.g. not a text item, then lets remove this attribute to prevent ugly (empty) plist tags.
        if ([completeTextStyles count] == 0)
        {
            [export removeObjectForKey:@"textStyles"];
        }
        
        if ([whiteSpacesFound count] == 0) //what if it's a sentence with no spaces? Is everything OK then?
        {
            [export removeObjectForKey:@"whiteSpaces"];
        }
        if ([ele isMemberOfClass:[Button class]])
        {
            int paddingTop = (ele.rtFrame.size.height) - ( ((Button *)ele).buttonTextContainer.origin.y +  ((Button*)ele).buttonTextContainer.size.height );
            [export setObject:[NSNumber numberWithInt:paddingTop+2] forKey:@"paddingTop"];
            
            float paddingLeft = ((Button *)ele).buttonTextContainer.origin.x; // The distance between the button border and the inner textFrames left side. Draw box to see.
            paddingLeft = paddingLeft - 4; // I subtract 4 becuase the button is drawn with an inset of 2 on left and right because of the handle bars in Element.m
            
            if (ele.width_as_percentage)
            {
                paddingLeft = (paddingLeft/self.frame.size.width)*100; //flexible padding
            }
            [export setObject:[NSNumber numberWithInt:paddingLeft] forKey:@"paddingLeft"];
            NSLog(@"padding to buttons : %d and %f", paddingTop, paddingLeft);
        }
        
        if (ele.width_as_percentage)
        {
            [export setObject:[NSNumber numberWithFloat:ele.width_as_percentage] forKey:@"widthAsPercentage"];
        }
        if (ele.height_as_percentage)
        {
            [export setObject:[NSNumber numberWithFloat:ele.height_as_percentage] forKey:@"heightAsPercentage"];
        }
        
        [arrayOfElementDetails addObject:export];
        NSLog(@"Exporting: %@", export);
        
    }
    
    
    // 0. PURPOSE :  FIND ALL OF THE SOLO ITEMS THEN FIND THE OBJECTS TO THE RIGHT OF THEM
    // Let's do some sorting - left to right, and then top to bottom
    NSLog(@"OKay, let's do some sorting...");
    groupingBoxes = [NSMutableArray array];
    leftToRightTopToBottom = [NSMutableArray array];
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:@"ycoordinate" ascending:NO];
    NSSortDescriptor *vertically2 = [[NSSortDescriptor alloc] initWithKey:@"ycoordinate" ascending:YES];
    NSSortDescriptor *horizontally = [[NSSortDescriptor alloc] initWithKey:@"xcoordinate" ascending:YES];
    NSSortDescriptor *horizontallyFarRight = [[NSSortDescriptor alloc] initWithKey:@"farRight" ascending:YES];
    
    NSArray *horizontalSortDescriptor = [NSArray arrayWithObject: horizontally];
    NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
    NSArray *verticalSortDescriptor2 = [NSArray arrayWithObject: vertically2];
    //NSArray *sortDescriptors = [NSArray arrayWithObjects: horizontally, vertically, nil];
    
    //For each element without anything to its left range // represents a row
    //NSArray *initalSorting = [arrayOfElementDetails sortedArrayUsingDescriptors:horizontalSortDescriptor];
    NSArray *initalSorting = [arrayOfElementDetails sortedArrayUsingDescriptors:verticalSortDescriptor];
    leftToRightTopToBottom = [NSMutableArray arrayWithArray:initalSorting];
    NSMutableArray *solos = [NSMutableArray array];
    NSLog(@"GOT : %lu items", [initalSorting count]);
    
    
    // GET SOLOS
    solos = [self arrayOfSoloItems:[initalSorting sortedArrayUsingDescriptors:verticalSortDescriptor2]];
    
    NSLog(@"Solo has : %lu items", [solos count]); //THESE ARE OBJECTS WITH NOTHING TO THE LEFT OF THEM. CORRECT. - 03/11/2012
    NSMutableArray *sortedArray = [NSMutableArray array];
    self.rows = [NSMutableArray array];
    for (NSDictionary *g in solos)
    {
        
        // Get the highest object which doesn't have anything to its left that's already been counted.
        NSRect gRect = NSMakeRect(
                                  [[g objectForKey:xcoordinate]floatValue],
                                  [[g objectForKey:ycoordinate]floatValue],
                                  [[g objectForKey:@"width"]floatValue],
                                  [[g objectForKey:@"height"]floatValue]
                                  );
        NSMutableArray *toMyRight =  [NSMutableArray arrayWithArray:[self elementsToMyRight:g]];
        NSArray *solidToMyRight = [NSArray arrayWithArray:toMyRight];
        NSMutableArray *elementsNotCountedYet = [NSMutableArray arrayWithArray: toMyRight];
        
        NSLog(@"TO MY RIGHT CONTAINS: %lu objects.", [toMyRight count]);
        toMyRight = [NSMutableArray arrayWithArray:[toMyRight sortedArrayUsingDescriptors:verticalSortDescriptor]]; // ordered by by height
        NSMutableArray *alreadyCounted = [NSMutableArray arrayWithArray:leftToRightTopToBottom];
        [alreadyCounted removeObjectsInArray:toMyRight];// ???
        [sortedArray addObject:g]; //   Add myself
        while ([elementsNotCountedYet count] != 0)
        {
            NSDictionary *next = [self highestElementWithEmptyLeft:toMyRight];//THIS EVENTUALLY WILL HAVE TO CHANGE TO BE HIGHESTELE IN GROUP.*
            NSLog(@"calling next on : %@", [next objectForKey:@"id"]);
            NSDictionary *previous = [sortedArray lastObject];
            
            
            //  get all elements in the right range of the previous element and select the one with the smallest x value.
            //  Bug fixed: So that it nows reads better, left to right, rather than just next object with nothing to its left
            /*
             if ([elementsNotCountedYet count] != [solidToMyRight count]) // So it's not the first loop
             {
             NSArray *previousElementsToMyRight = [self elementsToMyRightInGroupingBox:previous];
             if ([previousElementsToMyRight count]!=0)
             {
             if ([sortedArray containsObject:[previousElementsToMyRight objectAtIndex:0]] == NO)
             {
             NSLog(@"Trouble is being called");
             next = [previousElementsToMyRight objectAtIndex:0];
             }
             
             }
             }
             */
            if ([sortedArray containsObject:next] == NO) // As if might not hit the big if statement above and so next object may already exist in the SortedArray dataset.
            {
                [sortedArray addObject:next];
                NSLog(@"Just added : %@", [next objectForKey:@"id"]);
            }
            [toMyRight removeObject:next];
            elementsNotCountedYet = toMyRight;
        }
        NSLog(@"SORTED ARRAY AT 0 : %@", sortedArray);
        NSMutableArray *filteredSortedArray = [NSMutableArray arrayWithArray: sortedArray]; // WHICH WE'LL NOW FILTER TO ONLY INCLUDE THOSE TO MY RIGHT
        // **&*() AT THIS POINT,  CONVERT THE DIVS IN FILTEREDSORTEDARRAY WITH OVERLAPS TO GROUPINGBOXES ***&*() //
        for (NSDictionary *dict in sortedArray)
        {
            if ([solidToMyRight containsObject:dict] == NO)
            {
                [filteredSortedArray removeObject:dict];
            }
        }
        if ([solidToMyRight count] > 0) //  Check there is something in the array
        {
            GroupingBox *gb = [[GroupingBox alloc]init];
            gb.insideTheBox = [NSMutableArray array];
            NSMutableArray *itemsToRemove = [NSMutableArray array];
            NSMutableArray *twiceFiltered = [NSMutableArray arrayWithArray:filteredSortedArray];
            for (NSDictionary *dict in filteredSortedArray)
            {
                NSRect dictRect = NSMakeRect(
                                             [[dict objectForKey:xcoordinate]floatValue],
                                             [[dict objectForKey:ycoordinate]floatValue],
                                             [[dict objectForKey:@"width"]floatValue],
                                             [[dict objectForKey:@"height"]floatValue]
                                             );
                if ( (CGRectContainsRect(gRect, dictRect) == YES) )
                {
                    [itemsToRemove addObject:dict];
                    NSLog(@"I should be removing : %@", dict);
                }
                
            }
            [twiceFiltered removeObjectsInArray:itemsToRemove];
            if ([twiceFiltered count] > 0)
            {
                NSLog(@"About to add a gb!");
                for (NSMutableDictionary *eleme in twiceFiltered)
                {
                    [eleme setObject:@"yes" forKey:IN_GROUPING_BOX];
                }
                [[gb insideTheBox] addObjectsFromArray:twiceFiltered];
                [groupingBoxes addObject:gb];
            }
            
            /*
             [twiceFiltered removeObjectsInArray:itemsToRemove];
             if (twiceFiltered.count > 0)
             {
             [[gb insideTheBox] addObjectsFromArray:twiceFiltered];
             [groupingBoxes addObject:gb];
             NSLog(@"INSIDE GroupingBoxes Count is : %lu", gb.insideTheBox.count);
             NSLog(@"contents are : %@", twiceFiltered);
             }
             */
            
        }
        
        NSMutableArray *eachRow = [NSMutableArray arrayWithObject:g];
        [eachRow addObjectsFromArray:filteredSortedArray];
        [self.rows addObject:eachRow];
    } // END OF SOLO LOOP
    
    /// SUMMARY OF WHAT HAPPENED :
    NSLog(@"HERE WE GO:.... %lu ROWS!", self.rows.count);
    for (NSDictionary *d in self.rows)
    {
        NSLog(@"This row contains: %@", d);
    }
    
    NSLog(@"UPDATE GB : %lu", groupingBoxes.count);
    
    
    
    ///  Let's account for objects that are neither solo's nor in the right range or solos
    NSMutableArray *elementsCounted = [NSMutableArray array];
    NSMutableArray *elementsToAdd = [NSMutableArray array];
    for (NSMutableDictionary *elem in sortedArray)
    {
        
        float x = [[elem objectForKey:@"xcoordinate"] floatValue];
        float w = [[elem objectForKey:@"width"] floatValue];
        NSNumber *combinedWidth = [NSNumber numberWithFloat:x+w];
        //[elem setValue:combinedHeight forKey:ycoordinate];
        [elem setValue:combinedWidth forKey:@"farRight"];
        
        if ([elementsCounted containsObject:elem] == NO) // Not counted
        {
            
            NSLog(@"DOES THIS SCENARIO EVER GET CALLED?");
            NSUInteger priorElementsIndex = [sortedArray indexOfObject:elem];
            
            NSMutableArray *elemsToMyRight = [NSMutableArray arrayWithArray:[self elementsToMyRight:elem]];
            for (NSDictionary *newRightie in elemsToMyRight)
            {
                if ([sortedArray containsObject: newRightie] == NO)
                {
                    [elementsToAdd addObject:newRightie];
                }
            }
            while ([elementsToAdd count] != 0)
            {
                
                NSDictionary *next = [self highestElementWithEmptyLeft:elemsToMyRight];
                
                if ([sortedArray containsObject:next] == NO) // add it to the sorted array at the right point.
                {
                    
                    //if it's the last entry then becareful not to raise an NSRangeException
                    if ( ([sortedArray count] - 1) == (priorElementsIndex) )
                    {
                        [sortedArray addObject:next];
                    }
                    else
                    {
                        [sortedArray insertObject:next atIndex:priorElementsIndex+1];
                    }
                    
                }
                priorElementsIndex = [sortedArray indexOfObject:next];
                [elementsToAdd removeObject:next];
                [elemsToMyRight removeObject:next];
            }
            
            
            [elementsCounted addObject:elem];
        }
        
        // check if it has other shapes perfectly inside it
        CGRect rect1 = CGRectMake(
                                  [[elem objectForKey:xcoordinate] floatValue],
                                  [[elem objectForKey:ycoordinate]floatValue],
                                  [[elem objectForKey:@"width"]floatValue],
                                  [[elem objectForKey:@"height"]floatValue]);
        NSMutableArray *elementsToGoInGroupingBox = [NSMutableArray array];
        
        
        NSString *functionStart = [NSString string];
        NSMutableString *fString = [NSMutableString stringWithString:@"var self = this;"];
        NSMutableArray *classString = [NSMutableString string];
        NSMutableArray *functionArray = [NSMutableArray array];
        NSMutableArray *parametersList = [NSMutableArray array];
        for (NSMutableDictionary *elementToCheck in sortedArray)
        {
            CGRect rect2 = CGRectMake(
                                      [[elementToCheck objectForKey:xcoordinate] floatValue],
                                      [[elementToCheck objectForKey:ycoordinate]floatValue],
                                      [[elementToCheck objectForKey:@"width"]floatValue],
                                      [[elementToCheck objectForKey:@"height"]floatValue]);
            
            NSLog(@"Rect 1 (tag = %@) : %@", [elem objectForKey:@"tag"], NSStringFromRect(rect1));
            NSLog(@"Rect 2 : %@", NSStringFromRect(rect2));
            
            NSLog(@"DY TAG : %i",  [[elem objectForKey:@"tag"] isEqualToString:DYNAMIC_ROW_TAG] );
            NSLog(@"DY TAG : %i",  ([[elementToCheck objectForKey:@"tag"] isEqualToString:@"paragraph"] || [[elementToCheck objectForKey:@"tag"] isEqualToString:@"image"] || [[elementToCheck objectForKey:@"tag"] isEqualToString:DYNAMIC_IMAGE_TAG] || [[elementToCheck objectForKey:@"tag"] isEqualToString:DROP_DOWN_MENU_TAG] || [[elementToCheck objectForKey:@"tag"] isEqualToString:TEXT_INPUT_FIELD_TAG] || [[elementToCheck objectForKey:@"tag"] isEqualToString:BUTTON_TAG]) );
            NSLog(@"Containing? : %i", (CGRectContainsRect(rect1, rect2)));
            NSLog(@"Elem isEqualToDictionary : %i", [elem isEqualToDictionary:elementToCheck] == NO);
            
            
            
            
            if ( ([elem isEqualToDictionary:elementToCheck] == NO) & ([[elem objectForKey:@"tag"] isEqualToString:@"div"] || [[elem objectForKey:@"tag"] isEqualToString:DYNAMIC_ROW_TAG] ) || [[elem objectForKey:@"tag"] isEqualToString:CONTAINER_TAG] & ([[elementToCheck objectForKey:@"tag"] isEqualToString:@"paragraph"] || [[elementToCheck objectForKey:@"tag"] isEqualToString:@"image"] || [[elementToCheck objectForKey:@"tag"] isEqualToString:DYNAMIC_IMAGE_TAG] || [[elementToCheck objectForKey:@"tag"] isEqualToString:DROP_DOWN_MENU_TAG] || [[elementToCheck objectForKey:@"tag"] isEqualToString:TEXT_INPUT_FIELD_TAG] || [[elementToCheck objectForKey:@"tag"] isEqualToString:TEXT_BOX_TAG] || [[elementToCheck objectForKey:@"tag"] isEqualToString:BUTTON_TAG]) & (CGRectContainsRect(rect1, rect2)) )
            /* Not myself, but is a rectangle or dyRow, and has a:
             paragraph,
             image,
             dynamic image,
             dropDown menu,
             textfield,
             textBox, or
             button
             ontop of it, which is completely contained within the the rectangle shape then...
             */
            {
                NSLog(@"We have overlapping TEXT AND DIVS !!!!");
                // check if this element has a dictionary under PARENT_ID, if so then add a key, if not then create the dictionary
                
                if ( [elementToCheck objectForKey:PARENT_ID] != nil)
                {
                    // the parentID dictionary already exists inside of this element
                    // ASSUMPTION: AN ELEMENT CAN ONLY OVERLAP A BOX, DYROW, OR CONTAINER ONCE
                    [[elementToCheck objectForKey:PARENT_ID] setObject:[elem objectForKey:@"id"] forKey:[elem objectForKey:@"tag"]];
                }
                else
                {
                    // the parentID dictionary for this element does not currently exist
                    NSMutableDictionary *parentIDDictionary = [NSDictionary dictionaryWithObject:[elem objectForKey:@"id"] forKey:[elem objectForKey:@"tag"]];
                    [elementToCheck setObject:parentIDDictionary forKey:@"parentID"];
                }

                //[elementToCheck setObject:[elem objectForKey:@"id"] forKey:@"parentID"];
                [elementsToGoInGroupingBox addObject:elementToCheck];
                [elem setObject:[NSNumber numberWithBool:YES] forKey:@"convertToGroupingbox"];
                
                if ([elem isMemberOfClass:[Container class]])
                {
                    [elem removeObjectForKey:@"convertToGroupingbox"];
                }
                
                if ([[elem objectForKey:@"tag"] isEqualToString:DYNAMIC_ROW_TAG])
                {
                    if ([elementToCheck isMemberOfClass:[DropDown class]])
                    {
                        fString =[NSMutableString stringWithFormat:@"self.%@ = ko.observable(%@)", [elementToCheck objectForKey:@"elementID"], [elementToCheck objectForKey:@"elementID"]];
                    }
                    
                    if ([[elementToCheck objectForKey:@"elementID"] isEqualToString:@"Surcharge"])
                    {
                        fString = [NSMutableString stringWithFormat:@"self.formattedPrice = ko.computed(function() {var price = self.meal().price; return price ? \"$\" + price.toFixed(2) : \"None\"; })  "];
                    }
                    
                    else
                    {
                        fString = [NSMutableString stringWithFormat:@"self.%@ = %@", [elementToCheck objectForKey:@"elementID"], [elementToCheck objectForKey:@"elementID"]];
                    }
                    
                    [parametersList addObject:[elementToCheck objectForKey:@"elementID"]];
                    [parametersList addObject:@", "];
                    
                    
                    [functionArray addObject:fString];
                    [functionArray addObject:@";\n"];
                    [functionArray addObject:@", "];
                    /*
                     // Class to represent a row in the seat reservations grid
                     function Seat(name, initialMeal, passportNumber, numberOfBags) {
                     var self = this;
                     self.name = name;
                     self.meal = ko.observable(initialMeal);
                     self.passportNumber = passportNumber;
                     self.numberOfBags = numberOfBags;
                     
                     self.formattedPrice = ko.computed(function() {
                     var price = self.meal().price;
                     return price ? "$" + price.toFixed(2) : "None";
                     });
                     }
                     */
                }
                
            } // end of if tag to check if clean overlapping elements
            
            if (functionArray.count > 0) {
                
                [functionArray removeLastObject]; //clean up the end of the last string
                [parametersList removeLastObject]; //clean up the end of the last string
                
                NSMutableString *functionName = [elem objectForKey:@"elementid"];
                [classString addObject:@"function "];
                [classString addObject:[functionName capitalizedString]];
                [classString addObject:@" ("];
                [classString addObjectsFromArray:parametersList];
                [classString addObject:@") { \n"];
                [classString addObjectsFromArray:functionArray];
                [classString addObject:@"}\n"];
                
                [jsCode appendString:[classString componentsJoinedByString:@""]];
            }
        }
        NSLog(@"UPDATE GB2 : %lu", groupingBoxes.count);
        if ([elementsToGoInGroupingBox count] > 0)
        {
            NSLog(@"TESTING CGRECT : %@", NSStringFromRect(rect1));
            GroupingBox *convertedGroupingBox = [[GroupingBox alloc]init];
            convertedGroupingBox.insideTheBox = [NSMutableArray array];
            NSLog(@"OBJECTS THAT ARE ABOUT TO GO INTO THE GROUPINGBOX : %@", elementsToGoInGroupingBox);
            [[convertedGroupingBox insideTheBox] addObjectsFromArray:elementsToGoInGroupingBox];
            [convertedGroupingBox setIdPreviouslyKnownAs:[elem objectForKey:@"id"]];
            [convertedGroupingBox setBoundRect:rect1];
            [convertedGroupingBox setYcoordinate:[[elem objectForKey:ycoordinate]intValue]];
            [convertedGroupingBox setXcoordinate:[[elem objectForKey:xcoordinate]intValue]];
            [convertedGroupingBox setWidth:[[elem objectForKey:@"width"]intValue]];
            [convertedGroupingBox setHeight:[[elem objectForKey:@"height"]intValue]];
            NSLog(@"UPDATE GB3 : %lu", groupingBoxes.count);
            [self updateNestedGroupingBoxesVariable];
            NSLog(@"UPDATE GB4 : %lu", groupingBoxes.count);
            [groupingBoxes addObject:convertedGroupingBox];
            NSLog(@"UPDATE GB5 : %lu", groupingBoxes.count);
            NSLog(@"idprevknownas : %@", convertedGroupingBox.idPreviouslyKnownAs);
            NSLog(@"About to add: %@", convertedGroupingBox);
        }
        
    } //MORE OF SOLO LOOP
    
    
    
    /// SUMMARY OF WHAT HAPPENED :
    NSLog(@"GroupingBoxes Count is : %lu", [groupingBoxes count]);
    if ([sortedArray count] != [leftToRightTopToBottom count])
    {
        NSLog(@"ERROR -- ERROR -- ERROR -- ERROR");
    }
    NSLog(@"SORTED ARRAY AT POINT 2 : %@", sortedArray);
    for (GroupingBox *g in groupingBoxes)
    {
        NSLog(@"CONTENTS OF GROUPINGBOX IS : %@", g.insideTheBox);
    }
    
    
    
    /// SET THE BOUNDS RECT FOR EACH GROUPINGBOX
    [self setGroupingBoxesBoundsRect];
    
    
    
    
    
    
    /// CALCLULATE TOP (AND BOTTOM MARGINS WHEN NEEDED) FOR EACH OBJECT ON THE PAGE
    
    NSLog(@"STAGE1");
    NSMutableDictionary *shapeAboveMe = [NSMutableDictionary dictionary];
    NSMutableArray *lefties = [NSMutableArray array];
    NSMutableArray *righties = [NSMutableArray array];
    float lastY;
    int marginTop;
    
    
    NSUInteger indexCount = 0;
    for (NSMutableDictionary *dc in sortedArray) //  Was LeftToRightTopToBottom
    {
        NSLog(@"Index =%lu and count=%lu", indexCount+1, [sortedArray count]); //  Was LeftToRightTopToBottom
        NSUInteger myXlength = [[dc valueForKey:@"width"] unsignedIntegerValue];
        NSUInteger myYlength = [[dc valueForKey:@"height"] unsignedIntegerValue];
        NSUInteger myXCoordinate = [[dc valueForKey:@"xcoordinate"] unsignedIntegerValue];
        NSUInteger myYCoordinate = [[dc valueForKey:ycoordinate] unsignedIntegerValue];
        NSRange myXranges = NSMakeRange(myXCoordinate, myXlength);
        NSRange myYranges = NSMakeRange(myYCoordinate, myYlength);
        NSRect dRect = NSMakeRect(myXCoordinate,myYCoordinate,myXlength,myYlength);
        
        NSMutableDictionary *nextOne = nil;
        float nextX;
        if (indexCount+1 < [sortedArray count])
        {
            nextOne = [sortedArray objectAtIndex:indexCount+1];     //  Was LeftToRightTopToBottom
            nextX = [[nextOne valueForKey:@"xcoordinate"] floatValue];
        }
        
        
        NSMutableDictionary *lastOne = [NSMutableDictionary dictionary];
        float lastX;
        float lastW;
        if (indexCount != 0)
        {
            lastOne = [sortedArray objectAtIndex:indexCount-1];
            lastX = [[lastOne valueForKey:@"xcoordinate"] floatValue];
            lastW = [[lastOne valueForKey:@"width"] floatValue];
        }
        
        //nextY and lastY are special cases, see below
        
        
        //Last Y
        [dc setObject:[NSMutableArray array] forKey:@"elementsAboveMe"];
        NSMutableArray *elementsAboveMe = [dc objectForKey:@"elementsAboveMe"];
        NSMutableArray *elementsBelowMe = [NSMutableArray array];
        
        for (NSMutableDictionary *item in sortedArray)
        {
            if ( [[item valueForKey:bottomYcoordinate] intValue]  < [[dc valueForKey:bottomYcoordinate] intValue] ) //   if it's Y coordinate is above me (and in my northern range, see below)
            {
                
                //  Check if its in my Northern Range
                NSUInteger compareToXCoordinate = [[item valueForKey:@"xcoordinate"] unsignedIntegerValue];
                NSUInteger compareToXlength = [[item valueForKey:@"width"] unsignedIntegerValue];
                NSRange compareToXranges = NSMakeRange(compareToXCoordinate, compareToXlength);
                
                NSRange comparison = NSIntersectionRange(myXranges, compareToXranges);
                
                
                if (comparison.length!=0)
                {
                    //  So the two X coordinate ranges do have an overlap - they share x coordinates
                    [elementsAboveMe addObject:item];
                    
                }
            }
            
            if ( [[item valueForKey:bottomYcoordinate] intValue] <  [[dc valueForKey:bottomYcoordinate] intValue] ) //if it's Y coordinate is below mine
            {
                
                NSUInteger compareToXCoordinate = [[item valueForKey:@"xcoordinate"] unsignedIntegerValue];
                NSUInteger compareToXlength = [[item valueForKey:@"width"] unsignedIntegerValue];
                NSRange compareToXranges = NSMakeRange(compareToXCoordinate, compareToXlength);
                
                NSRange comparison = NSIntersectionRange(myXranges, compareToXranges);
                
                
                if (comparison.length!=0)
                {
                    //So the two X coordinate ranges do have an overlap - they share x coordinates
                    NSLog(@"Found objects BELOW me");
                    [elementsBelowMe addObject:item];
                    
                }
            }
            
            
        } //closes for loop
        
        
        
        //NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically]; //There may be many objects above me in my x range
        NSMutableArray *verticallyAboveMeSortedArray = [NSMutableArray arrayWithArray:[elementsAboveMe sortedArrayUsingDescriptors:verticalSortDescriptor]];
        NSMutableArray *removeTheseItems = [NSMutableArray array];
        for (NSDictionary *candidate in verticallyAboveMeSortedArray)
        {
            NSRect candidateRect = NSMakeRect(
                                              [[candidate objectForKey:xcoordinate]floatValue],
                                              [[candidate objectForKey:ycoordinate]floatValue],
                                              [[candidate objectForKey:@"width"]floatValue],
                                              [[candidate objectForKey:@"height"]floatValue]);
            if (CGRectContainsRect(dRect, candidateRect) == YES)
            {
                NSLog(@"REMOVING AN OVERLAPPING ELE");
                [removeTheseItems addObject:candidate];
            }
        }
        [verticallyAboveMeSortedArray removeObjectsInArray:removeTheseItems];
        
        NSArray *verticallyBelowMeSortedArray = [elementsBelowMe sortedArrayUsingDescriptors:verticalSortDescriptor];// y coordinate no.
        NSRect testingRect;
        NSMutableArray *offsetCandidates = [NSMutableArray array];
        
        
        // **** @@ CONSIDER DELETING THE BELEOW AS I BELIVE IT'S ALL OVERRIDEN OR IGNORED //
        
        if ( ([elementsAboveMe count] > 0) & ([verticallyAboveMeSortedArray count] > 0) )
        {
            //    If there are multiple objects above me, get the one lowest on the y coordinate axis (closest to me), as vertically is 'desc' not 'asc'.
            
            
            
            NSLog(@"eles above me");
            shapeAboveMe = [verticallyAboveMeSortedArray objectAtIndex:0];
            GroupingBox *gb1 = [self whichGroupingBoxIsElementIn:dc];
            GroupingBox *gb2 = [self whichGroupingBoxIsElementIn:shapeAboveMe];
            
            
            
            if (gb1 != nil && gb1==gb2 && [dc valueForKeyPath:@"parentID.div"] != nil) //it's inside a standard groupingbox and the shapeAboveMe is in the same Grouping box as I am.
            {
                
                testingRect = NSMakeRect([[dc objectForKey:xcoordinate]floatValue],
                                         [[dc objectForKey:ycoordinate]floatValue],
                                         (gb1.frame.origin.x + gb1.frame.size.width) - [[dc objectForKey:@"width"]floatValue],
                                         [[dc objectForKey:ycoordinate]floatValue] - [[shapeAboveMe valueForKey:bottomYcoordinate] floatValue]);
                
                for (NSDictionary *otherDictionaryInGroup in gb1.insideTheBox)
                {
                    NSLog(@"There are %lu objects in this groupingBox.", gb1.insideTheBox.count);
                    if (([sortedArray indexOfObject:otherDictionaryInGroup] < [sortedArray indexOfObject:dc])
                        && [[otherDictionaryInGroup objectForKey:ycoordinate]intValue] < [[dc objectForKey:ycoordinate]intValue])
                    {
                        //so it's before me in sortedArray and has a yco above me
                        NSRect candidateRect = NSMakeRect([[otherDictionaryInGroup objectForKey:xcoordinate]floatValue],
                                                          [[otherDictionaryInGroup objectForKey:ycoordinate]floatValue],
                                                          [[otherDictionaryInGroup objectForKey:@"width"]floatValue],
                                                          [[otherDictionaryInGroup objectForKey:@"height"]floatValue]);
                        if (CGRectIntersectsRect(testingRect, candidateRect))
                        {
                            [offsetCandidates addObject:otherDictionaryInGroup];
                        }
                    }
                    /*
                     
                     for each dictionary in the grouping box,
                     with an order before mine and a yco less than mine,
                     
                     if it's intersecting, place in an array, sort
                     the array, and select the closest one as closest.
                     
                     marginTop = my margin - the margin of the other object.
                     */
                }
                if ([offsetCandidates count] > 0)
                {
                    offsetCandidates = [NSMutableArray arrayWithArray:[offsetCandidates sortedArrayUsingDescriptors:horizontalSortDescriptor]];
                    NSDictionary *elementToOffset = [offsetCandidates objectAtIndex:0];
                    marginTop = [[dc objectForKey:ycoordinate]intValue] - [[elementToOffset objectForKey:ycoordinate]intValue];
                }
                else
                {
                    lastY = [[shapeAboveMe valueForKey:bottomYcoordinate] floatValue];
                    marginTop = [[dc valueForKey:@"ycoordinate"] intValue] - lastY;
                    NSLog(@"elementsaboveme > 0: %i", marginTop);
                }
                
            }
            
            
            
            
            
            // if the object above me is in a different row then my margin should be set against the row.
            NSLog(@"Shape above me is in row: %lu and %lu", [self elementRow:shapeAboveMe], [self elementRow:dc]);
            NSUInteger rowOfElementAboveMe = [self elementRow:shapeAboveMe];
            NSUInteger myRowId = [self elementRow:dc];
            if (rowOfElementAboveMe != myRowId)
            {
                
                marginTop =[[dc objectForKey:ycoordinate]intValue] - [self highestYcoordinateInMyRow:[[self.rows objectAtIndex:myRowId] objectAtIndex:0]];
                NSLog(@"Object I'm using to measure against: %@", [[[self.rows objectAtIndex:myRowId] objectAtIndex:0] objectForKey:@"id"]);
                NSLog(@"Returning: %i", marginTop);
                NSLog(@"Distance to my margin: %i with id: %@", marginTop, [dc objectForKey:@"id"]);
            }
            
            //question - could two objects be in different grouping boxes but the same row? If so the above code may not work.
            
        }
        else    //  There's nothing above me
        {
            //  **      Set the margin of the element, which may be readjusted LATER DOWN THE METHOD if it's inside a groupingBox    **
            int highestYPoint = [self highestYcoordinateInMyRow:dc]; //test if it's 0, which means only there's only one object in this row.
            if (highestYPoint == [[dc objectForKey:ycoordinate]intValue])
            {
                //if it's the highest object in the row then set it to 0.
                highestYPoint = 0;
            }
            float myHighestYPoint = [[dc valueForKey:@"ycoordinate"]floatValue];
            NSLog(@"Else state myhighestpoint: %f", myHighestYPoint);
            marginTop =  myHighestYPoint - highestYPoint;
            
            
            
        }
        NSLog(@"About to set id: %@ with marginTop:%i", [dc valueForKey:@"id"], marginTop);
        NSLog(@"Better  : %i", [self marginToObjectWithinTransformedGroupingBox:dc onSide:TOP]);
        [dc setValue:[NSNumber numberWithInt:marginTop] forKey:@"marginTop"];
        
        // **** @@ END OF QUESTION TO DELETE THE ABOVE ******** //
        
        
        
        
        NSLog(@"SORTED ARRAY NOVEMBER 1 : %@", sortedArray);
        
        
        
        // ********************************* //
        
        
        
        //  3. Find out whether there are objects to my left or right AND if they're in my range
        BOOL objectToMyLeft;
        BOOL objectToMyRight;
        
        righties = [NSMutableArray array];
        for (NSMutableDictionary *objectToTheRight in sortedArray) //  Was LeftToRightTopToBottom
        {
            if ([objectToTheRight isEqualToDictionary:dc] == NO) // If it's not me
            {
                
                //  If the object is t the right of me
                if ([[objectToTheRight valueForKey:@"xcoordinate"] intValue] > ( [[dc valueForKey:@"xcoordinate"] intValue] +[[dc valueForKey:@"width"] intValue]) )
                {
                    NSUInteger yLocation = [[objectToTheRight valueForKey:ycoordinate] unsignedIntegerValue];
                    NSUInteger yLength = [[objectToTheRight valueForKey:@"height"] unsignedIntegerValue];
                    NSRange comparisonToYranges = NSMakeRange(yLocation, yLength);
                    
                    NSRange comparison = NSIntersectionRange(myYranges, comparisonToYranges);
                    NSLog(@"Comparing A: %d ato B: %d", [[objectToTheRight valueForKey:@"xcoordinate"] intValue], [[dc valueForKey:@"xcoordinate"] intValue] +[[dc valueForKey:@"width"] intValue]);
                    if (comparison.length!=0) //    And it's in my range
                    {
                        GroupingBox *gb1 = [self whichGroupingBoxIsElementIn:dc];
                        GroupingBox *gb2 = [self whichGroupingBoxIsElementIn:objectToTheRight];
                        if (gb1 != nil & gb2 == nil)
                        {
                            // if the tester is in a gb but the other is outside a gb then do nothing.
                        }
                        else
                        {
                            [righties addObject:objectToTheRight];
                            NSLog(@"Just added an object which is to the right of me");
                        }
                        
                    }
                    
                }
                
            }
            //STILL IN THE FOR LOOP...
        }
        
        if ([righties count] > 0)
        {
            objectToMyRight = YES;
        }
        else
        {
            objectToMyRight = NO;
        }
        NSLog(@"Object to my right Y/N: %d", objectToMyRight);
        
        
        
        
        lefties = [NSMutableArray array];
        for (NSMutableDictionary *objectToTheLeft in sortedArray) //check this... //  Was LeftToRightTopToBottom
        {
            
            if ([objectToTheLeft isEqualToDictionary:dc] == NO)
            {
                
                if ([[objectToTheLeft valueForKey:@"xcoordinate"] intValue] < [[dc valueForKey:@"xcoordinate"] intValue] ) //   It's to my left
                {
                    //
                    NSUInteger yLocation = [[objectToTheLeft valueForKey:ycoordinate] unsignedIntegerValue];
                    NSUInteger yLength = [[objectToTheLeft valueForKey:@"height"] unsignedIntegerValue];
                    NSRange comparisonToYranges = NSMakeRange(yLocation, yLength);
                    
                    NSRange comparison = NSIntersectionRange(myYranges, comparisonToYranges);
                    NSLog(@"Comparing my location: %lu and its location: %lu", myYCoordinate, yLocation);
                    
                    if (comparison.length !=0)
                    {
                        [lefties addObject:objectToTheLeft];
                        NSLog(@"Width: %d is next to me with width: %d",[[objectToTheLeft valueForKey:@"width"] intValue], [[dc valueForKey:@"width"] intValue] );
                    }
                }
                
            }
        }
        
        if ([lefties count] > 0)
        {
            objectToMyLeft = YES;
        }
        else
        {
            objectToMyLeft = NO;
        }
        NSLog(@"Object to my left equals: %d", objectToMyLeft);
        
        
        
        
        int marginRight;
        int marginLeft;
        
        // If there are objects either side then apply relevant margins
        if (objectToMyRight == YES)
        {
            
            NSArray *horizontallySortedArray = [righties sortedArrayUsingDescriptors:horizontalSortDescriptor];
            
            for (NSDictionary *r in horizontallySortedArray)
            {
                NSLog(@"Righties are: %@", [r objectForKey:@"xcoordinate"]);
            }
            
            
            NSDictionary *closestElement = [horizontallySortedArray objectAtIndex:0];
            int closestX = [[closestElement valueForKey:@"xcoordinate"] intValue];
            NSLog(@"CLOSEST: %d", closestX);
            if (closestX > ([[dc valueForKey:@"xcoordinate"] floatValue] + [[dc valueForKey:@"width"] floatValue])) // If it's in the same row
            {
                // BUG: CHECK THIS NSMAKERECT IS CORRECT.
                marginRight = closestX - ([[dc valueForKey:@"xcoordinate"] intValue] + [[dc valueForKey:@"width"] intValue]);
                NSRect dcRect = NSMakeRect([[dc valueForKey:@"xcoordinate"] floatValue],
                                           [[dc valueForKey:bottomYcoordinate]floatValue],
                                           [[dc valueForKey:@"width"]floatValue],
                                           [[dc valueForKey:@"height"]floatValue]);
                
                NSRect closestRect = NSMakeRect([[closestElement valueForKey:@"xcoordinate"]floatValue],
                                                [[closestElement valueForKey:bottomYcoordinate]floatValue],
                                                [[closestElement valueForKey:@"width"]floatValue],
                                                [[closestElement valueForKey:@"height"]floatValue]);
                
                int marginRight2 = [self isThereAGroupBoxInPath:dcRect :@"y" :closestRect];
                
                if (marginRight2)
                {
                    NSLog(@"Using MARGINRIGHT2 : %d", marginRight2);
                    [dc setValue:[NSNumber numberWithInt:marginRight2] forKey:@"marginRight"];
                }
                else
                {
                    NSLog(@"Using MARGINRIGHT : %d", marginRight);
                    [dc setValue:[NSNumber numberWithInt:marginRight] forKey:@"marginRight"];
                }
                
                
            }
            
        }
        
        if (objectToMyLeft == YES)
        {
            //NSArray *horizontalSortDescriptor = [NSArray arrayWithObject: horizontally];
            NSArray *horizontallySortedArray = [lefties sortedArrayUsingDescriptors:horizontalSortDescriptor];
            //NSDictionary *shapeToMyImmediateLeft = [verticallyAboveMeSortedArray lastObject]; //    If there are multiple objects above me, get the one lowest on the y coordinate axis
            
            //  Find the closest item in my leftRange
            NSDictionary *closest = [horizontallySortedArray lastObject];   //THIS IS THE CLOSEST OBJECT TO MY LEFT THAT IS IN MY RANGE
            NSLog(@"Closest object to me has a width of: %d and my width is: %d", [[closest valueForKey:@"width"] intValue], [[dc valueForKey:@"width"] intValue]);
            
            for (NSDictionary *l in lefties)
            {
                NSLog(@"Lefties are: %@", [l objectForKey:@"xcoordinate"]);
            }
            //  LEFT MARGIN LOGIC: Get its marginRight, if I'm offset by more or less than that amount the give me a marginLeft. *** THIS IS ONLY THE CASE IN A GROUPING BOX ***
            for (NSDictionary *check in sortedArray)
            {
                if ([check isEqualToDictionary:closest])
                {
                    if ([[check valueForKey:@"marginRight"] intValue]) //If this object has a marginRight set on it (if object to my left is in row below, possible, then this won't be set yet
                    {
                        int mRight = [[check valueForKey:@"marginRight"] intValue];
                        int offset = [[dc valueForKey:@"xcoordinate"] intValue] - ([[closest valueForKey:@"xcoordinate"] intValue] + [[closest valueForKey:@"width"] intValue]);
                        if (mRight != offset)
                        {
                            NSLog(@"MRight is:%d and offset is:%d", mRight, offset);
                            marginLeft = offset - mRight;
                            [dc setValue:[NSNumber numberWithInt:marginLeft] forKey:@"marginLeft"];
                            //}
                            
                        }
                    }
                    
                }
            }
            
            
            
        }
        
        if ( (objectToMyLeft == NO) & ([solos containsObject:dc] == YES) )
        {
            //This is for solo objects with nothing to the left of it that isn't number one object on the page
            marginLeft = [[dc valueForKey:@"xcoordinate"] intValue];
                # pragma mark -  ADD CONTAINER CODE HERE.
            [dc setValue:[NSNumber numberWithInt:marginLeft] forKey:@"marginLeft"];
        }
        
        
        
        
        
        NSLog(@"SORTED ARRAY NOVEMBER 2 : %@", sortedArray);
        
        /*
         Make adjustments to marginTops for elements that need to float as their tops need to calc against the lowest in  the minirow above it.
         
         1. Get all elements above me, in my groupingBox, not in my left range (or in the leftrange of them) and before me in sortedArray (mini-row above, as HTML will naturally float me next to those in my mini row, so I must set my margin based the bottom of the mini-row above.)
         
         2. Get the lowest of those elements and set my margin against that element.
         
         // * New approach is to base margin off of the highest element in my row and then apply a margin to my row. * //
         */
        
        
        GroupingBox *boxImIn = [self whichGroupingBoxIsElementIn:dc];
        NSMutableArray *newMarginContenders = [NSMutableArray array];
        NSUInteger myIndexInSortedArray = [sortedArray indexOfObject:dc];
        for (NSDictionary * d in boxImIn.insideTheBox)
        {
            
            NSUInteger loopsIndexInSortedArray = [sortedArray indexOfObject:d];
            
            
            if ([[d valueForKey:bottomYcoordinate]intValue] > [[dc valueForKey:bottomYcoordinate]intValue] & [lefties containsObject:d] == NO & loopsIndexInSortedArray < myIndexInSortedArray)
            {
                [newMarginContenders addObject:d];
                
                // and if elements width for the object behind me in the sorted arrays width + my width, plus margins is not equal to or gthan groupingbox xco then flag as 'no float'
                NSUInteger myIndex = [sortedArray indexOfObject:dc];
                NSDictionary *objectBeforeMe = [sortedArray objectAtIndex:myIndex-1];
                
                int myWidth = [[dc valueForKey:@"width"]intValue];
                if ((boxImIn.rtFrame.origin.x + boxImIn.rtFrame.size.width) - [[objectBeforeMe valueForKey:@"farRight"] doubleValue] >= myWidth & [[objectBeforeMe valueForKey:@"ycoordinate"] intValue] > [[dc valueForKey:ycoordinate] intValue]) //   So I can fit in that gap, above me, but don't want to.
                {
                    [dc setValue:@"true" forKey:@"noFloat"];
                    NSLog(@"Object with width of : %@ was set with Flag - no float", [dc valueForKey:@"width"]);
                }
            }
        }
        
        if ([newMarginContenders count] != 0)
        {
            for (NSDictionary *d in newMarginContenders)
            {
                NSLog(@"newMarginContenders : %@",d);
            }
            int lowestYco = [[[[newMarginContenders sortedArrayUsingDescriptors:verticalSortDescriptor] lastObject] valueForKey:@"ycoordinate"] intValue];
            int newMarginTop = lowestYco - [[dc valueForKey:ycoordinate] intValue];
            [dc setValue:[NSNumber numberWithInt:newMarginTop] forKey:@"marginTop"];
            NSLog(@"DC ITEM %@ CHANGED AT LINE 4028. NOW : %@", [dc valueForKey:@"id"], dc);
            [dc setValue:@"yes" forKey:@"leave"];
            
        }
        
        
        
        [dc setValue:[NSNumber numberWithInteger:indexCount] forKey:@"order"];
        indexCount++;
        
        
    }; // END OF THE HUGE FOR LOOP STARTING AT AROUND 3610.
    
    /// END OF ELEMENT MARGIN TOP AND BOTTOM EDITING.
    
    
    
    NSLog(@"SORTED ARRAY NOVEMBER 3 : %@", sortedArray);
    
    [self setMarginsForElementInGroupingBox];
    
    NSLog(@"SORTED ARRAY NOVEMBER 10 : %@", sortedArray);
    
    
    
    NSMutableArray *firstAndLastRowsInContainer = [NSMutableArray array];
    for (NSMutableDictionary *each in [sortedArray reverseObjectEnumerator])
    {
        // Calclulate its bottom margin if it's the last item in the sorted Array
        if ([each valueForKeyPath:@"parentID.div"] == nil)
        {
            NSNumber *marginBottom = [NSNumber numberWithInt:(int)self.bounds.size.height - [[each objectForKey:bottomYcoordinate]intValue]];
            NSLog(@"marginBottom is : %@ for object with id: %@", marginBottom, [each objectForKey:@"id"]);
            [each setObject:marginBottom forKey:@"marginBottom"];
            break;
        }
        
        // Calculate the contents of Container - ASSUMPTION: ROWS ARE CLEAN INSIDE A CONTAINER (IF ONE EXISTS)
        if ([[each objectForKey:@"tag"] isEqualToString:CONTAINER_TAG])
        {
            NSArray *elementsInsideMe = [self elementsInside:each usingElements:sortedArray];
            NSMutableArray *idArray = [NSMutableArray array];
            for (NSString *elementID in elementsInsideMe)
            {
                [idArray addObject:elementID];
            }

            NSMutableOrderedSet *rowsInThisContainer = [NSMutableOrderedSet new];
            
            
                [self.rows enumerateObjectsUsingBlock:^(id row, NSUInteger index, BOOL *stop)
                {
                    for (NSDictionary *ele in row)
                    {
                        if ([idArray containsObject:[ele objectForKey:@"id"]])
                        {
                            //if this row contains an elementID from idArray then add this row to my list of contents
                            [rowsInThisContainer addObject:index];
                            NSLog(@"Matching element found at index: %li", (unsigned long)index);
                            //*stop = YES;
                        }
                    }
                } ];
            NSNumber *min = [rowsInThisContainer valueForKeyPath:@"min.self"];
            NSNumber *max = [rowsInThisContainer valueForKeyPath:@"max.self"];
            [firstAndLastRowsInContainer addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                                                         [each objectForKey:@"id"], CONTAINER_ID,
                                                         min, FIRST,
                                                         max, LAST,
                                                         nil]];
                
        }
        
            
        
        
    }
    
    
    
    
    
    
    
    NSError *errorMsg;
    NSString *outputFolderPath = NSHomeDirectory();
    
    outputFolderPath =[outputFolderPath stringByAppendingPathComponent:@"Documents"];
    outputFolderPath = [outputFolderPath stringByAppendingPathComponent:@"code"];
    NSString *pathToCSS = [[NSBundle mainBundle] pathForResource:@"bootstrap" ofType:@"css"];
    NSURL *urlToCSS = [[NSBundle mainBundle] URLForResource:@"bootstrap" withExtension:@"css"];
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL exists = [fm fileExistsAtPath:outputFolderPath isDirectory:&isDir];
    if (exists)
    {
        NSLog(@"It does exist");
        
    }
    else
    {
        NSLog(@"Does not exist");
        [fm createDirectoryAtPath:outputFolderPath withIntermediateDirectories:YES attributes:nil error:&errorMsg];
        
        
        NSError *error;
        NSString *stringFromFileAtURL = [[NSString alloc]
                                         initWithContentsOfURL:urlToCSS
                                         encoding:NSUTF8StringEncoding
                                         error:&error];
        NSLog(@"css = \n %@", stringFromFileAtURL);
        
        if (pathToCSS == nil)
        {
            NSLog(@"COULD NOT FIND THE BOOTSTRAP FILE IN BUNDLE");
        }
        else
        {
            NSLog(@"Bundle path: %@", pathToCSS);
            NSString *cssFullPath = [NSString stringWithString:outputFolderPath];
            cssFullPath = [cssFullPath stringByAppendingPathComponent:@"bootstrap"];
            cssFullPath = [cssFullPath stringByAppendingPathExtension:@"css"];
            NSLog(@"Destination path: %@", cssFullPath);
            [fm copyItemAtPath:pathToCSS toPath:cssFullPath error:nil];
            //[fm copyItemAtURL:urlToCSS toURL:[NSURL fileURLWithPath:outputFolderPath] error:nil];
            
        }
        NSLog(@"Does now");
    }
    
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    NSWindowController *wc = [[curDoc windowControllers] objectAtIndex:0];
    NSString *pageTitle = [[wc window] title];
    
    outputFolderPath = [outputFolderPath stringByAppendingPathComponent:pageTitle];
    outputFolderPath = [outputFolderPath stringByAppendingPathExtension:@"html"];
    
    NSLog(@"Path thus far : %@", outputFolderPath);
    
    
    NSURL *directoryURLToPlaceFiles = [NSURL fileURLWithPath:outputFolderPath isDirectory:YES];
    
    
    
    
    
    if (directoryURLToPlaceFiles == nil)
    {
        NSLog(@"COULD NOT GET DIRECTORY URL. Error");
    }
    else
    {
        NSLog(@"DirectoryURL is: %@", directoryURLToPlaceFiles);
    }
    
    
    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        documentsDirectory = [paths objectAtIndex:0];
    }
    
    for (NSMutableDictionary *d in sortedArray)
    {
        //  Clean up
        [d removeObjectForKey:@"elementsAboveMe"];
        
        //  if I ask for an int that isn't set then obj will return a crazy number - prevent this.
        if ([d valueForKey:@"marginRight"] == nil)
        {
            [d setObject:[NSNumber numberWithInt:0] forKey:@"marginRight"];
        }
        
        if ([d valueForKey:@"marginBottom"] == nil)
        {
            [d setObject:[NSNumber numberWithInt:0] forKey:@"marginBottom"];
        }
    }
    NSString * markupToSave = [documentsDirectory stringByAppendingString:@"/markup.txt"];
    NSString * groupBoxToSave = [documentsDirectory stringByAppendingString:@"/groupings.txt"];
    NSString * rowsToSave = [documentsDirectory stringByAppendingString:@"/rows.txt"];
    
    //NSString *file = [documentsDirectory stringByAppendingString:@"/testFile2.html"];
    
    NSLog(@"SORTED ARRAY CONTAINS: %@", sortedArray);
    NSMutableArray *finalGrouping = [NSMutableArray array];
    
    
    
    
    
    
    /***    CALCLUATE MARGINTOPS FOR ROWS    ***/
    NSLog(@"SELF.ROWS = %@", self.rows);
    for (NSArray *items in self.rows)
    {
        NSLog(@"In the loop.");
        // get the highest item (top left) inside that row
        NSDictionary *highestElementInRow = [self highestElementInMyRow:[items objectAtIndex:0]];
        NSUInteger rowNumber = [self elementRow:highestElementInRow];
        NSLog(@"RowNumber is : %lu", rowNumber);
        
        // calculate the distance to the lowest item in the row above, or to the top of the page if this is row 0
        int calculatedMarginTop;
        if (rowNumber != 0)
        {
            int largestYcoordinateInRowAbove = [self largestYcoordinateInMyRow:[[self.rows objectAtIndex:rowNumber-1]objectAtIndex:0]];
            NSLog(@"Lowest coordinate in the row above me is : %d", largestYcoordinateInRowAbove);
            calculatedMarginTop = [[highestElementInRow valueForKey:ycoordinate]intValue] - largestYcoordinateInRowAbove;
            NSLog(@"CALCULATED MARGINTOP IS : %d", calculatedMarginTop);
        }
        else
        {
            CGFloat highestPoint;
             # pragma mark -  ADD CONTAINER CODE HERE.
            if (self.documentContainer.size.height == 0) // when an instance is initialiSed, all its ivar are cleared to bits of zero
            {
                //highestPoint = self.frame.size.height;
                highestPoint = 0;
            }
            else
            {
                //highestPoint = self.documentContainer.size.height;
                highestPoint = 0;
            }
            NSLog(@"Highest point is : %f", highestPoint);
            //calculatedMarginTop = highestPoint - [[highestElementInRow valueForKey:ycoordinate]intValue];
            calculatedMarginTop = [[highestElementInRow valueForKey:ycoordinate]intValue];
            NSLog(@"CALCULATED MARGINTOP IS (2) : %d", calculatedMarginTop);
            
        }
        
        NSLog(@"Row number is : %lu. MarginTop is : %i", rowNumber, calculatedMarginTop);
        [self.rowMargins insertObject:[NSNumber numberWithInt:calculatedMarginTop] atIndex:rowNumber];
        NSLog(@"Just inserted %@ as the rowMarginTop for row : %lu",[NSNumber numberWithInt:calculatedMarginTop], rowNumber);
        
    }
    
    
    
    
    
    
    
    
    
    
    
    /***    CALCULATE MARGINTOPS FOR ELEMENTS NOT IN GROUPINGBOX..., BUT ALSO CONVERT MARGIN TO %    ***/
    
    for (NSMutableDictionary *dc in sortedArray)
    {
        
        BOOL insideGroupingBoxFlag = NO;
        for (GroupingBox *grb in groupingBoxes)
        {
            if ([[grb insideTheBox] containsObject:dc] == YES)
            {
                insideGroupingBoxFlag = YES;
            }
        }
        // Get the distance to the nearest item in my Y range
        NSNumber *distanceToNearestElementAboveMeInThisRow = [[self nearestElementDirectlyAboveMeInMyRow:dc] objectForKey:bottomYcoordinate];
        NSLog(@"dISTANCE TO NEAREST ELEMENT : %@", distanceToNearestElementAboveMeInThisRow);
        
        // Get the distance to the highest item in my row
        int highestItemsYco = [self highestYcoordinateInMyRow:dc];
        NSLog(@"highestItemsYco : %d", highestItemsYco);
        
        
        // Assuming neither are minus, use the lowest of the two
        NSLog(@"MIN IS : %i", MIN([distanceToNearestElementAboveMeInThisRow intValue], highestItemsYco));
        
        if ((insideGroupingBoxFlag == NO) & (distanceToNearestElementAboveMeInThisRow == nil) ) //this is not in a groupingbox nor does it have anything in its y range in this row.
        {
            int marginTopTop = [[dc valueForKey:@"ycoordinate"] intValue] - [self highestYcoordinateInMyRow:dc];
            [dc setValue:[NSNumber numberWithInt:marginTopTop] forKey:@"marginTop"];
            NSLog(@"I JUST SET MARGINTOP TO: %i", marginTopTop);
        }
        
        
        ///////////////
        // if the highest point in my row is equal to my height then I'm the tallest in the row and thus no margnTop is needed
        
        if ([[dc objectForKey:ycoordinate]intValue] == highestItemsYco)
        {
            NSLog(@"So the highest element in the GroupingBox is the highest element in the row. 0. \n");
            [dc setObject:[NSNumber numberWithInt:0] forKey:@"marginTop"];
            NSLog(@"Set marginTop to zero for highest element in row. ");
            
        }
        
    }
    
    
    
    
    
    NSLog(@"Any goodnesss? : %@", sortedArray);
    
    
    
    /***    CALCLUATE MARGINTOPS FOR GROUPINGBOX     ***/
    for (GroupingBox *g in groupingBoxes)
    {
        if ([g idPreviouslyKnownAs] == nil)
        {
            [self setGroupingBoxMargin:g];
        }
        else
        {
            NSLog(@"Skipping the tweaking of margins for the groupingBox as this was taken from the rect I was previouslyKnownAs");
            // set the margin top and right from the element PreviouslyKnownAs
            for (NSDictionary *elements in sortedArray)
            {
                if ( [[elements objectForKey:@"id"] isEqualToString:[g idPreviouslyKnownAs]] )
                {
                    [g setMarginTop:[[elements objectForKey:@"marginTop"] intValue]];
                    [g setMarginRight:[[elements objectForKey:@"marginRight"]floatValue]];
                }
            }
        }
        
        // Get the highest and lowest elements so I can determine the required padding for box
        
        NSSortDescriptor *verticallyBottom = [[NSSortDescriptor alloc] initWithKey:bottomYcoordinate ascending:NO];
        NSArray *verticalSortDescriptorBottom = [NSArray arrayWithObject: verticallyBottom];
        
        NSArray *sortedByBottomYCo = [NSMutableArray arrayWithArray:[g.insideTheBox sortedArrayUsingDescriptors:verticalSortDescriptorBottom]];
        NSArray *sortedByTopYCo = [NSMutableArray arrayWithArray:[g.insideTheBox sortedArrayUsingDescriptors:verticalSortDescriptor]]; //asc = NO.
        NSDictionary *highestElement = [sortedByTopYCo lastObject];
        NSDictionary *lowestElement = [sortedByBottomYCo lastObject];
        g.highestElementYco = [[highestElement valueForKey:ycoordinate]floatValue];
        g.lowestElementBottomYco = [[lowestElement valueForKey:bottomYcoordinate]floatValue];
        float padding = 0;
        if ([NSNumber numberWithFloat:g.highestElementYco] != nil & [NSNumber numberWithFloat:g.lowestElementBottomYco] != nil)
        {
            padding = (g.lowestElementBottomYco - g.highestElementYco)/2;
        }
        
        NSNumber *paddingAsNumber = [NSNumber numberWithFloat:padding];
        NSLog(@"My lowest object is : %@", [lowestElement valueForKey:@"id"]);
        NSLog(@"My highest object is : %@", [highestElement valueForKey:@"id"]);
        
        
        NSSortDescriptor *orderID = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        NSArray *orderIDSortDescriptor = [NSArray arrayWithObject: orderID];
        g.insideTheBox = [NSMutableArray arrayWithArray:[[g insideTheBox] sortedArrayUsingDescriptors:orderIDSortDescriptor]];
        
        [[g insideTheBox] insertObject: [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithFloat:g.marginTop], @"GroupBoxMarginTop",
                                         [NSNumber numberWithFloat:g.marginRight], @"GroupBoxMarginRight",
                                         [NSString stringWithString:[[[g insideTheBox] objectAtIndex:0] valueForKey:@"id"]], @"firstObject",
                                         [NSString stringWithString:[[[g insideTheBox] lastObject] valueForKey:@"id"]], @"lastObject",
                                         [NSNumber numberWithFloat:(g.rtFrame.size.width)], @"width",
                                         [NSNumber numberWithInt:ceilf(g.rtFrame.size.height)], @"height",
                                         g.idPreviouslyKnownAs, @"idPreviouslyKnownAs",
                                         paddingAsNumber, @"padding",
                                         nil]
                               atIndex:0];
        
        
        
        // TODO: Not vital, but check this bit is correct.
        // if the highest point in my row is equal to my height then I'm the tallest in the row and thus no margnTop is needed
        int gYco = [[g valueForKey:@"ycoordinate"] intValue];
        NSLog(@"gYco is %i", gYco);
        if (gYco == [self highestYcoordinateInMyRow:highestElement] )
        {
            NSLog(@"So the highest element in the GroupingBox is the highest element in the row");
            [[[g insideTheBox] objectAtIndex:0] removeObjectForKey:@"GroupBoxMarginTop"];
            NSLog(@"Removed GroupBoxMarginTop as it was the highest in the row.");
            
        }
        
        
        
        [finalGrouping addObject:[g insideTheBox]];
        //NSLog(@"FG = %@", finalGrouping);
        
    }
    
    BOOL allElementsAreFlexible = YES;
    // Set flexible margins - for elements with % and - widths if inside a gb; any margin lefts; and any margin rights for
    for (NSMutableDictionary *dc in sortedArray)
    {
        if ([[dc objectForKey:LAYOUT_KEY] isEqualToString:@"%"])
        {
            // CHANGE THE MARGIN-LEFT AND MARGIN-RIGHT TO %
            NSNumber *marginLeft = [dc objectForKey:@"marginLeft"];
            NSNumber *marginRight = [dc objectForKey:@"marginRight"];
            NSNumber *flexibleWidth = [dc objectForKey:WIDTH_AS_A_PERCENTAGE];
            
            if (marginLeft)
            {
                CGFloat target = [[dc objectForKey:@"marginLeft"]floatValue];
                CGFloat parent;
                
                //if the element has a container then it's context is the container, else it's the stage
                if ([dc valueForKeyPath:[NSString stringWithFormat:@"%@.%@", PARENT_ID, DIV_TAG]])
                {
                    //get the parent object
                    
                    for (NSDictionary *checking in sortedArray) {
                        if ([[checking valueForKey:@"id"] isEqualToString:[dc valueForKeyPath:[NSString stringWithFormat:@"%@.%@", PARENT_ID, DIV_TAG]]]) {
                            parent = [[checking objectForKey:@"width"]floatValue];
                        }
                    }
                }
                
                if ([dc objectForKey:IN_GROUPING_BOX])
                {
                    GroupingBox *gbMe = [self whichGroupingBoxIsElementIn:dc]; //find out which gb I'm in and then...
                    float parentWidth = [[[[gbMe insideTheBox] objectAtIndex:0] objectForKey:@"width"] floatValue]; // get it's width
                    parent = parentWidth;
                }
                else
                {
                    #pragma mark - ADD CONTAINER CODE HERE
                    parent = self.frame.size.width;
                }
                CGFloat context = parent;
                // (target/context)*100;
                CGFloat flexibleMargin = [self convertTarget:target inContext:context];
                [dc setObject:[NSNumber numberWithFloat:flexibleMargin] forKey:MARGIN_LEFT_AS_A_PERCENTAGE];
            }
            
            
            if (marginRight)
            {
                CGFloat target = [[dc objectForKey:@"marginRight"]floatValue];
                CGFloat parent;
                
                //if the element has a container then it's context is the container, else it's the stage
                if ([dc valueForKeyPath:[NSString stringWithFormat:@"%@.%@", PARENT_ID, DIV_TAG]])
                {
                    //get the parent object
                    
                    for (NSDictionary *checking in sortedArray) {
                        if ([[checking valueForKey:@"id"] isEqualToString:[dc valueForKeyPath:[NSString stringWithFormat:@"%@.%@", PARENT_ID, DIV_TAG]]]) {
                            parent = [[checking objectForKey:@"width"]floatValue];
                        }
                    }
                }
                if ([dc objectForKey:IN_GROUPING_BOX])
                {
                    GroupingBox *gbMe = [self whichGroupingBoxIsElementIn:dc]; //find out which gb I'm in and then...
                    float parentWidth = [[[[gbMe insideTheBox] objectAtIndex:0] objectForKey:@"width"] floatValue]; // get it's width
                    parent = parentWidth;
                }
                else
                {
                    #pragma mark - ADD CONTAINER CODE HERE
                    parent = self.frame.size.width;
                }
                if (parent) // if I found a parent object
                {
                    CGFloat context = parent;
                    CGFloat flexibleMargin = (target/context)*100;
                    [dc setObject:[NSNumber numberWithFloat:flexibleMargin] forKey:MARGIN_RIGHT_AS_A_PERCENTAGE];
                }
                
            }
            
            
            GroupingBox *imInAGroupingBox = [self whichGroupingBoxIsElementIn:dc];
            if (flexibleWidth && imInAGroupingBox)
            {
                NSLog(@"AH!");
                CGFloat target = [[dc objectForKey:@"width"]floatValue];
                CGFloat context = [[[[imInAGroupingBox insideTheBox] objectAtIndex:0] objectForKey:@"width"] floatValue]; // get it's width
                CGFloat flexibleWidthWhenInsideGroupingBox = (target/context)*100;
                [dc setObject:[NSNumber numberWithFloat:flexibleWidthWhenInsideGroupingBox] forKey:WIDTH_AS_A_PERCENTAGE];
                
            }
            
            
            // (target/context)*100
        }
        
        if ([[dc objectForKey:LAYOUT_KEY] isEqualToString:@"px"])
        {
            allElementsAreFlexible = NO;
            
        }
        
    }
    
    if (allElementsAreFlexible)
    {
        NSLog(@"ALL ELEMENTS ARE FLEXII!");
        for (GroupingBox *g in groupingBoxes)
        {
            NSMutableDictionary *header = [g.insideTheBox objectAtIndex:0]; // get the header inforation
            
            //Set the flexible margin Right
            NSLog(@"GOT HERE");
            Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
            CGFloat containingElementWidth = [[curDoc stageView] sizeOfHighestContainingElement:g].width; // just changed to make it work with categories
            CGFloat mRight = [[[g.insideTheBox objectAtIndex:0] objectForKey:@"GroupBoxMarginRight"] floatValue];
            NSNumber *flexibleMarginRight = [NSNumber numberWithFloat:(mRight/containingElementWidth)*100];
            [header setObject:flexibleMarginRight forKey:MARGIN_RIGHT_AS_A_PERCENTAGE];
            
            //Set the flexible width of the element
            CGFloat fw = [self sizeAsPercentageOfHighestContainingElement:g].width; // this is the size of my containing element. Even a grouping box will work here as it inherits from Element class and has an rtFrame. If nothing is enclosing this element then it uses the stageView as the enclosing element.
            NSLog(@"GOT HERE 2");
            NSNumber *newFlexibleWidth = [NSNumber numberWithFloat:fw];
            NSLog(@"GOT HERE THREE.. trying to add %@... to %@", newFlexibleWidth, header);
            [header setObject:newFlexibleWidth forKey:WIDTH_AS_A_PERCENTAGE];
            NSLog(@"WE OUT");
        }
    }
    
    
    
    
    
    NSLog(@"Row margins : %@", rowMargins);
    
    
#pragma mark - CONVERSION
    
    
    int CblockCount = 0;
    int CmarginTop, CmarginRight, CmarginBottom, CmarginLeft, Ckerning, CHeight, CPaddingTop, CPaddingLeft = 0;
    float CWidth;
    int Cleading = 1;
    float CfontSize = 12;
    
    
    NSMutableDictionary *gc = [NSMutableDictionary dictionary];
    NSMutableDictionary *gs = [NSMutableDictionary dictionary];
    NSMutableArray *codeStore = [NSMutableArray array];
    NSMutableArray *styleStore = [NSMutableArray array];
    NSString *styleString = [NSString string];
    NSMutableString *s = [NSMutableString string];
    NSArray *groupings = [NSArray arrayWithArray:finalGrouping];
    
    NSLog(@"At step : 1 in generate code function.");
    //  1.Get the Start and End rows
    
    NSMutableArray *startRows = [NSMutableArray array];
    NSMutableArray *endRows = [NSMutableArray array];
    
    NSLog(@"Self rows contains: %@", self.rows);
    
    [self.rows enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger indexCounter, BOOL *stop){
        
        //So we know which element IDs are the first and last in each row.
        [startRows addObject:[[row objectAtIndex:0] valueForKey:@"id"]]; //object 0 is a dictionary containing the values for various attribtes for this element.
        [endRows addObject:[[row lastObject] valueForKey:@"id"]];
        
        
        for (NSDictionary *eachContainer in firstAndLastRowsInContainer)
        {
            if ([[eachContainer objectForKey:FIRST] isEqualTo:[NSNumber numberWithInteger:indexCounter]])
            {
                [[row objectAtIndex:0] setObject:[eachContainer objectForKey:CONTAINER_ID] forKey:FIRST_IN_ROW_AND_CONTAINER];
            }
            
            if ([[eachContainer objectForKey:LAST] isEqualTo:[NSNumber numberWithInteger:indexCounter]])
            {
                [[row lastObject] setObject:[eachContainer objectForKey:CONTAINER_ID] forKey:LAST_IN_ROW_AND_CONTAINER];
            }
        }
        
    } ];
    
    
    
    NSLog(@"At step : 2");
    //  2.The Big Loop
    NSString *prefix = @"element";
    
    NSString *backgroundColor = [NSString string];
    NSMutableString *start = [NSMutableString string];
    NSMutableString *middle = [NSMutableString string];
    NSMutableString *end = [NSMutableString string];
    NSMutableString *doc = [NSMutableString string];
    NSMutableString *code = [NSMutableString string];
    NSMutableString *previousElementId = [NSMutableString string];
    NSMutableArray *groupBoxBits = [NSMutableArray array];
    NSMutableString *groupBoxIDCode = [NSMutableString string];
    NSMutableArray *groupBoxMarginTop = [NSMutableArray array];
    NSMutableArray *groupBoxMarginRight = [NSMutableArray array];
    NSMutableArray *groupBoxWidth = [NSMutableArray array];
    
    
    NSMutableArray *firstObjectsInGroups = [NSMutableArray array]; // We need to know when to open a groupbox div...
    NSMutableArray *lastObjectsInGroups  = [NSMutableArray array]; // and when to close one
    
    NSString *blockid = [NSString string];
    
    
    for (NSMutableDictionary *block in sortedArray)
    {
        for (NSArray *array in groupings)
        {
            [firstObjectsInGroups addObject: [[array objectAtIndex:0] valueForKey:@"firstObject"]];
            [lastObjectsInGroups addObject:[[array objectAtIndex:0] valueForKey:@"lastObject"]];
        }
        NSLog(@"GROUPINGS IN CONVERSION : %@", groupings);
        NSMutableString *groupBoxOpeningDiv = nil;
        NSMutableString *postCode = nil;
        NSMutableString *groupBoxID = [NSMutableString string];
        NSMutableString *keyPathMarginTop = [NSMutableString string];
        NSMutableString *keyPathMarginRight = [NSMutableString string];
        NSMutableString *keyPathWidth = [NSMutableString string];
        NSMutableString *startRowCode = nil;
        NSMutableString *endRowCode = nil;
        NSMutableString *Cstyle = [NSMutableString string];
        NSMutableString *borderRadiusString = [NSMutableString string];
        NSMutableString *borderStrokeString = [NSMutableString string];
        NSString *elementLayoutType = [block objectForKey:@"layoutType"];
        NSString *groupingBoxLayoutType = [NSString new];
        
        Ckerning = 0;
        Cleading = 0;
        CfontSize = 12;
        
        CmarginTop = 0;
        CmarginRight = 0;
        CmarginBottom = 0;
        CmarginLeft = 0;
        
        CHeight = 0;
        CWidth = 0;
        
        
        blockid = [block valueForKey:@"id"];
        NSLog(@"BlockID is : %@", blockid);
        
        NSString *blockidAsString = [NSString string];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        if (![formatter numberFromString:[block objectForKey:@"id"]]) //if I can't get a number from the then it must be a user entered ID
            //BUG: numberFromString will parse 6men as a number so I need to correct this code.
        {
            blockidAsString = [[block objectForKey:@"id"] lowercaseString];
        }
        else
        {
            blockidAsString = [prefix stringByAppendingFormat:@"%@", [block valueForKey:@"id"]];
        }
        
        
        if ([firstObjectsInGroups containsObject:blockid])
        {
            NSLog(@"Inside firsts..");
            groupBoxOpeningDiv = [NSMutableString stringWithString: @"<div class=\"groupBox\" "];
            NSMutableDictionary *groupingBoxInQuestion = [NSMutableDictionary dictionary];
            for (NSArray *each in groupings)
            {
                if ([[[each objectAtIndex:0]valueForKey:@"firstObject"] isEqualToString:blockid] )
                {
                    groupBoxMarginTop = [[each objectAtIndex:0] valueForKey:@"GroupBoxMarginTop"];
                    groupBoxMarginRight = [[each objectAtIndex:0] valueForKey:@"GroupBoxMarginRight"];
                    if ([[each objectAtIndex:0] valueForKey:MARGIN_RIGHT_AS_A_PERCENTAGE])
                    {
                        groupBoxWidth = [[each objectAtIndex:0] valueForKey:MARGIN_RIGHT_AS_A_PERCENTAGE];
                        groupingBoxLayoutType = @"%";
                    }
                    else
                    {
                        groupBoxWidth = [[each objectAtIndex:0] valueForKey:@"width"];
                        groupingBoxLayoutType = @"px";
                    }
                    
                    groupingBoxInQuestion = [each objectAtIndex:0];
                    NSLog(@"NOW : %i", CblockCount);
                }
            }
            
            if ([groupingBoxInQuestion objectForKey:@"idPreviouslyKnownAs"])
            {
                NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
                [f setNumberStyle:NSNumberFormatterDecimalStyle];
                NSNumber * myNumber = [f numberFromString:[groupingBoxInQuestion objectForKey:@"idPreviouslyKnownAs"]];
                
                if (myNumber != nil) // so it's a number as a NSString
                {
                    groupBoxID = [NSMutableString stringWithString:previousElementId];
                }
                else // its an NSString with letters not just numbers
                {
                    groupBoxID = [groupingBoxInQuestion objectForKey:@"idPreviouslyKnownAs"];
                }
                
                
            }
            else
            {
                groupBoxID = [NSMutableString stringWithString:[@"groupBox" stringByAppendingFormat:@"%i", CblockCount]];
            }
            
            
            
            // keypaths below needed?
            keyPathMarginTop = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@.GroupBoxMarginTop", blockid]];
            keyPathMarginRight = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@.GroupBoxMarginRight", blockid]];
            keyPathWidth = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@.Width", blockid]];
            NSLog(@"At step : 5");
            
            if ([groupingBoxInQuestion objectForKey:@"idPreviouslyKnownAs"])
            {
                //
            }
            else
            {
                groupBoxBits = [NSMutableArray arrayWithObjects:
                                @"#",
                                groupBoxID,
                                @"{",
                                @"\n",
                                @"  margin:",
                                groupBoxMarginTop,
                                @"px",
                                
                                @" ",
                                groupBoxMarginRight,
                                @"px",
                                @" ",
                                @"0 0;",
                                @"\n",
                                
                                @"  width: ",
                                groupBoxWidth,
                                groupingBoxLayoutType,
                                @";",
                                @"\n",
                                
                                @"  float: left;",
                                @"\n",
                                @"}",
                                @"\n",
                                
                                nil];
            }
            
            
            groupBoxIDCode = [NSMutableString stringWithString:[groupBoxBits componentsJoinedByString:@""]];
            NSLog(@"TEST 4. Which is %@", groupBoxIDCode);
            Cstyle = [NSMutableString stringWithString:[Cstyle stringByAppendingString:groupBoxIDCode]];
            NSLog(@"CSTYLE AT THIS POINT SHOULD CONTAIN GB1 : %@",Cstyle);
            //Cstyle = groupBoxID;
        }
        
        //  Set the end of the GrouupBox code
        if ([lastObjectsInGroups containsObject:blockid])
        {
            postCode = [NSMutableString stringWithString:@"\n</div><!-- Closes the GroupBox -->"];
        }
        
        
        //  Row code
        if ([startRows containsObject:blockid])
        {
            startRowCode = [NSMutableString stringWithString:@"\n      <div class=\"row\">"];
            if ([block objectForKey:FIRST_IN_ROW_AND_CONTAINER]) {
                NSString *containerStartCode = @"\n      <div class=\"container\">";
                startRowCode = [NSMutableString stringWithString:[containerStartCode stringByAppendingString:startRowCode]];
            }
        }
        if ([endRows containsObject:blockid])
        {
            endRowCode = [NSMutableString stringWithString:@"\n</div><!-- Closes the row -->"];
            if ([block objectForKey:LAST_IN_ROW_AND_CONTAINER]) {
                NSString *containerEndCode = @"\n</div><!-- Closes the container -->";
                endRowCode = [NSMutableString stringWithString:[containerEndCode stringByAppendingString:endRowCode]];
            }
        }
        
        //  If
        if ([[block valueForKeyPath:@"borderRadius"] isEqualToNumber:[NSNumber numberWithInt:0]] == NO)
        {
            //the border radius has a value that is not 0
            NSLog(@"Border radius string is NOT nil");
            borderRadiusString = [block valueForKey:@"borderRadiusAsString"];
        }
        else
        {
            NSLog(@"Border radius string is nil");
            borderRadiusString = [NSMutableString stringWithString:@"0"];
            NSLog(@"DONE WITH BORDERRADIUS");
        }
        
        
        if ([[block valueForKeyPath:@"borderWidth"] isEqualToNumber:[NSNumber numberWithInt:0]] == NO)
        {
            NSLog(@"Border stroke string is NOT nil");
            if ([block valueForKey:@"borderWidth"] == [NSNull null])
            {
                [block setValue:[NSNumber numberWithInt:0] forKey:@"borderWidth"];
            }
            borderStrokeString = [NSString stringWithFormat:@"%@px ", [block valueForKey:@"borderWidth"]];
        }
        else
        {
            NSLog(@"Border stroke string is nil");
            borderStrokeString = [NSMutableString stringWithString:@"0"];
            
            
        }
        
        
        // ** STAGING GROUND: Create the attributes ready to be used below: ** //
        
        //1. Shadows
        NSMutableArray *shadowArray = [NSMutableArray array];
        NSMutableString *shadowCSS = [NSMutableString string];
        if ([block objectForKey:@"shadows"] != nil)
        {
            NSString *startingString = @"  box-shadow:";
            for (NSDictionary *dict in [block valueForKey:@"shadows"])
            {
                BOOL outsideShadow = [[dict valueForKey:@"Direction"] boolValue];
                NSString *hOffset = [[dict valueForKey:@"hOffset"] stringValue];
                NSString *vOffset = [[dict valueForKey:@"vOffset"] stringValue];
                NSString *distance = [[dict valueForKey:@"Distance"] stringValue];
                CGFloat RColor = [[dict valueForKey:@"RColor"] floatValue];
                CGFloat GColor = [[dict valueForKey:@"GColor"] floatValue];
                CGFloat BColor = [[dict valueForKey:@"BColor"] floatValue];
                CGFloat opacity = [[dict valueForKey:@"Opacity"] floatValue];
                NSString *blur = [[dict valueForKey:@"Blur"] stringValue];
                
                NSColor *rgba = [NSColor colorWithCalibratedRed:RColor green:GColor blue:BColor alpha:opacity];
                
                NSMutableString *shadowString = [NSMutableString stringWithFormat: @"%@ %@ %@ %@ %@ %@", startingString, hOffset, vOffset, blur, distance, rgba];
                if (!outsideShadow)
                {
                    [shadowString insertString:@"inset " atIndex:0];
                }
                [shadowString appendString:@", "];
                [shadowArray addObject:shadowString];
                
            }
            [shadowArray removeLastObject]; //clean up the trailing comma
            [shadowArray addObject:@";"]; // and add the ending semi-colon to terminate the css statement.
            shadowCSS = [NSMutableString stringWithString:[shadowArray componentsJoinedByString:@""]];
            
            /*
             The box-shadow property allows elements to have multiple shadows, specified by a comma seperated list.
             When more than one shadow is specified, the shadows are layered front to back, as in the following example.
             */
        }
        
        //2. DataSource, actions, and visibility
        NSString *actionCode = [block objectForKey:@"actionCode"];
        NSString *dataSourceCode = [block objectForKey:@"dataSourceCode"];
        
        
        
        
        
        // IMAGE CODE
        if ([[block valueForKey:@"tag"] isEqualToString:@"image"])
        {
            //width
            NSNumber *widthAsANumber = nil;
            if ([block objectForKey:@"widthAsPercentage"])
            {
                CWidth = [[block objectForKey:@"widthAsPercentage"]floatValue];
                widthAsANumber = [NSNumber numberWithFloat:CWidth];
            }
            else
            {
                CWidth = [[block valueForKey:@"width"] intValue];
                widthAsANumber =[NSNumber numberWithInt:CWidth];
            }
            
            //height
            NSString *heightAsAString = nil;
            if ([block objectForKey:@"height"])
            {
                CHeight = [[block valueForKey:@"height"] intValue];
                heightAsAString = [NSString stringWithFormat:@"%d", CHeight];
            }
            else
            {
                heightAsAString = @"auto";
            }
            
            
            //NSString *imageID = [@"groupBox" stringByAppendingFormat:@"%i", CblockCount];
            NSArray *codeArray = [NSArray arrayWithObjects:
                                  @"\n        ",
                                  @"<div id=\"",
                                  blockidAsString,
                                  @"\">",
                                  @"<img src=\"",
                                  [block valueForKey:@"content"],
                                  @"\" ",
                                  @"width=\"",
                                  widthAsANumber,
                                  @"\" height=\"",
                                  heightAsAString,
                                  @"\"",
                                  @" alt=\"",
                                  [block valueForKey:@"alt"],
                                  @"\"/>",
                                  @"</div>",
                                  @"\n",
                                  nil];
            NSLog(@" CODE ARRAY : %@", codeArray);
            NSString * tempString = [codeArray componentsJoinedByString:@""];
            code = [NSMutableString stringWithString:tempString];
            
            
            
            //if "marginTop" in block:
            if ([block valueForKey:@"marginTop"] != nil)
            {
                CmarginTop = [[block valueForKey:@"marginTop"]intValue];
            }
            
            if ([block valueForKey:@"marginRight"] != nil)
            {
                CmarginRight = [[block valueForKey:@"marginRight"]intValue];
            }
            
            if ([block valueForKey:@"marginBottom"] != nil)
            {
                CmarginBottom = [[block valueForKey:@"marginBottom"]intValue];
            }
            
            if ([block valueForKey:@"marginLeft"] != nil)
            {
                CmarginLeft = [[block valueForKey:@"marginLeft"]intValue];
            }
            
            
            NSMutableArray *styleArray = [NSMutableArray arrayWithObjects:
                                          @"#",
                                          blockidAsString,
                                          @" {\n  height:",
                                          //heightAsAString,
                                          @"auto",
                                          @";",
                                          @"\n"
                                          @"  width:",
                                          @"auto",
                                          //widthAsANumber,
                                          //@"px",
                                          @";",
                                          @"\n",
                                          @"  margin:",
                                          [NSNumber numberWithInt:CmarginTop],
                                          @"px ",
                                          [NSNumber numberWithInt:CmarginRight],
                                          @"px ",
                                          [NSNumber numberWithInt:CmarginBottom],
                                          @"px ",
                                          [NSNumber numberWithInt:CmarginLeft],
                                          @"px;",
                                          @"\n",
                                          @"  float:left;",
                                          @"\n",
                                          nil];
            NSArray *borderStrokeArray = [NSArray arrayWithObjects:
                                          @"  border: ",
                                          borderStrokeString,
                                          @"solid black;",
                                          @"\n",
                                          nil];
            NSArray *borderRadiusArray = [NSArray arrayWithObjects:
                                          @"border-radius: ",
                                          borderRadiusString,
                                          @";",
                                          @"-moz-border-radius: ",
                                          borderRadiusString,
                                          @";",
                                          @"\n",
                                          shadowCSS,
                                          @"\n",
                                          nil];
            
            if ( (borderStrokeString != nil) & ([borderStrokeString isEqualToString:@"0"] == NO) )
            {
                [styleArray addObjectsFromArray:borderStrokeArray];
            }
            if ( (borderRadiusString != nil) & ([borderRadiusString isEqualToString:@"0"] == NO) )
            {
                [styleArray addObjectsFromArray:borderRadiusArray];
            }
            [styleArray addObject:@"}\n\n"];
            Cstyle = [NSMutableString stringWithString:[Cstyle stringByAppendingString:[styleArray componentsJoinedByString:@""]]];
            //Cstyle = [NSMutableString stringWithString:[Cstyle stringByAppendingString:groupBoxIDCode]];
        }
        
        
        
        
        // PARAGRAPH CODE
        if ([[block valueForKey:@"tag"] isEqualToString:@"paragraph"])
        {
            NSLog(@"in para");
            NSLog(@"%@", textStyles);
            //if "marginTop" in block:
            if ([block valueForKey:@"marginTop"] != nil)
            {
                CmarginTop = [[block valueForKey:@"marginTop"]intValue];
            }
            
            if ([block valueForKey:@"marginRight"] != nil)
            {
                CmarginRight = [[block valueForKey:@"marginRight"]intValue];
            }
            
            if ([block valueForKey:@"marginBottom"] != nil)
            {
                CmarginBottom = [[block valueForKey:@"marginBottom"]intValue];
            }
            
            if ([block valueForKey:@"marginLeft"] != nil)
            {
                CmarginLeft = [[block valueForKey:@"marginLeft"]intValue];
            }
            
            //if "fontSize" in block.textStyles[0]:
			//fontSize = str(block.textStyles[0].fontSize)
            if ([[block valueForKeyPath:@"textStyles.fontSize"] objectAtIndex:0] != [NSNull null])
            {
                CfontSize = [[[block valueForKeyPath:@"textStyles.fontSize"] objectAtIndex:0] floatValue];
            }
            
            if ([[block valueForKeyPath:@"textStyles.kerning"] objectAtIndex:0] != [NSNull null])
            {
                Ckerning = [[[block valueForKeyPath:@"textStyles.kerning"] objectAtIndex:0] intValue];
            }
            
            if ([[block valueForKeyPath:@"textStyles.leading"] objectAtIndex:0] != [NSNull null])
            {
                Cleading = [[[block valueForKeyPath:@"textStyles.leading"] objectAtIndex:0] intValue];
            }
            
            NSString *blockText = [block valueForKey:@"content"];
            
            for (NSDictionary *style in [block valueForKey:@"textStyles"])
            {
                NSUInteger start = [[style valueForKey:@"startRange"] unsignedIntegerValue];
                NSUInteger end = [[style valueForKey:@"endRange"] unsignedIntegerValue]+1;
                NSRange range = NSMakeRange(start, end-start);
                
                
                NSString *a = [blockText substringWithRange:range];
                
                NSString *dataSourceString = @"";
                NSString *actionString = @"";
                if ([style valueForKey:@"dataSource"] != nil) // this statement needed??
                {
                    // data-bind=\"text:
                    dataSourceString = [NSString stringWithFormat:@"%@", dataSourceCode];
                }
                
                if ([style valueForKey:@"action"] != nil)
                {
                    /*
                     if ([[block valueForKey:@"action"] isEqualToString:@"remove row"])
                     {
                     actionString = [NSString stringWithFormat:@"<a href=\"#\" data-bind=\"click: $root.removeRow\">%@</a>", a];
                     }
                     */
                    
                    actionString = [style valueForKey:@"action"];
                    
                    // keep it generic
                    a = [NSString stringWithFormat:@"<a href=\"#\" %@\">%@</a>", [style valueForKey:@"action"], a];
                    
                }
                a = [NSMutableString stringWithString:[a stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"]];
                
                
                NSArray *arrayB = [NSArray arrayWithObjects:
                                   @"        <span id=\"",
                                   [style valueForKey:@"styleid"],
                                   @"\"",
                                   actionCode,
                                   dataSourceCode,
                                   @">",
                                   a,
                                   @"</span>",
                                   @"\n",
                                   nil];
                
                NSString *b = [arrayB componentsJoinedByString:@""];
                
                [s appendString:b];
                //s = [NSMutableString stringWithString:b];
                
                NSArray *arrayT = [NSArray arrayWithObjects:
                                   @"#",
                                   [style valueForKey:@"styleid"],
                                   @" {",
                                   @"\n",
                                   @"  font-family:",
                                   [style valueForKey:@"fontName"],
                                   @";",
                                   @"\n",
                                   nil];
                
                NSString *CtextStyles = [arrayT componentsJoinedByString:@""];
                if (CfontSize != 12)
                {
                    CfontSize = CfontSize/STANDARD_BROWSER_FONT_SIZE;
                    NSString *middleBit = [[@"font-size: " stringByAppendingFormat:@"%f", CfontSize] stringByAppendingString:@"em; "];
                    CtextStyles = [CtextStyles stringByAppendingString:middleBit];
                }
                NSArray *arrayE = [NSArray arrayWithObjects:
                                   @"\n",
                                   @"  letter-spacing: ",
                                   [NSNumber numberWithInt:Ckerning],
                                   @";",
                                   @"  line-height: ",
                                   [NSNumber numberWithInt:Cleading],
                                   @";",
                                   @"  color: rgba(",
                                   [style valueForKey:@"fontColor"],
                                   @");\n}",
                                   @"\n",
                                   nil];
                NSString *endBit = [arrayE componentsJoinedByString:@""];
                CtextStyles = [CtextStyles stringByAppendingString:endBit];
                styleString = [styleString stringByAppendingString:CtextStyles];
                
            }
            //s = [NSMutableString stringWithString:[s stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"]];
            
            NSArray *arrayF = [NSArray arrayWithObjects:
                               @"<p id=\"",
                               blockidAsString,
                               @"\">",
                               @"\n",
                               s,
                               @"</p>",
                               @"\n",
                               nil];
            
            code = [NSMutableString stringWithString:[arrayF componentsJoinedByString:@""]];
            
            //width
            NSNumber *widthAsANumber = nil;
            if ([block objectForKey:@"widthAsPercentage"])
            {
                CWidth = [[block objectForKey:@"widthAsPercentage"]floatValue];
                widthAsANumber = [NSNumber numberWithFloat:CWidth];
            }
            else
            {
                CWidth = [[block valueForKey:@"width"] intValue];
                widthAsANumber =[NSNumber numberWithInt:CWidth];
            }
            
            //height
            NSString *heightAsAString = nil;
            if ([block objectForKey:@"height"])
            {
                CHeight = [[block valueForKey:@"height"] intValue];
                heightAsAString = [NSString stringWithFormat:@"%d", CHeight];
            }
            else
            {
                heightAsAString = @"auto";
            }
            
            NSLog(@"At step : 10");
            NSArray *arrayG = [NSArray arrayWithObjects:
                               @"#",
                               blockidAsString,
                               @" {",
                               @"  margin: ",
                               [NSNumber numberWithInt:CmarginTop],
                               @"px ",
                               [NSNumber numberWithInt:CmarginRight],
                               @"px ",
                               [NSNumber numberWithInt:CmarginBottom],
                               @"px ",
                               [NSNumber numberWithInt:CmarginLeft],
                               @"px;",
                               @"\n",
                               @"  width: ",
                               widthAsANumber,
                               @"px;"
                               @"\n",
                               @"  height: ",
                               heightAsAString,
                               @"px;",
                               @"  float: left;",
                               @"}",
                               @"\n",
                               nil];
            Cstyle = [NSMutableString stringWithString:[Cstyle stringByAppendingString:[[arrayG componentsJoinedByString:@""] stringByAppendingString:styleString]]];
            
        }
        
        
        
        
        
        // RECTANGLE or ROW CODE
        if ( ([[block valueForKey:@"tag"] isEqualToString: @"div"]) || ([[block valueForKey:@"tag"] isEqualToString: DYNAMIC_ROW_TAG ]) )
        {
            NSArray *arrayH = [NSArray array];
            if ([block objectForKey:@"convertToGroupingbox"] == nil)
            {
                arrayH = [NSArray arrayWithObjects:
                          @"<div id=\"",
                          blockidAsString,
                          @"\">",
                          [block valueForKey:@"content"],
                          @"</div>",
                          nil];
            }
            
            code = [NSMutableString stringWithString:[arrayH componentsJoinedByString:@""]];
            
            //width
            NSNumber *widthAsANumber = nil;
            if ([block objectForKey:WIDTH_AS_A_PERCENTAGE])
            {
                CWidth = [[block objectForKey:WIDTH_AS_A_PERCENTAGE]floatValue];
                widthAsANumber = [NSNumber numberWithFloat:CWidth];
            }
            else
            {
                CWidth = [[block valueForKey:@"width"] intValue];
                widthAsANumber =[NSNumber numberWithInt:CWidth];
            }
            
            //height
            NSString *heightAsAString = nil;
            if ([block objectForKey:@"height"])
            {
                CHeight = [[block valueForKey:@"height"] intValue];
                heightAsAString = [NSString stringWithFormat:@"%d", CHeight];
            }
            else
            {
                heightAsAString = @"auto";
            }
            
            CmarginTop = [[block valueForKey:@"marginTop"]intValue];
            CmarginBottom = [[block valueForKey:@"marginBottom"]intValue];
            CmarginLeft = [[block valueForKey:@"marginLeft"]intValue];
            CmarginRight = [[block valueForKey:@"marginRight"]intValue];
            
            //margin Left
            NSNumber *marginLeftAsANumber = [NSNumber numberWithInt:0];
            if ([block objectForKey:MARGIN_LEFT_AS_A_PERCENTAGE])
            {
                marginLeftAsANumber = [block objectForKey:MARGIN_LEFT_AS_A_PERCENTAGE];
            }
            if ([block objectForKey:@"marginLeft"] && ![block objectForKey:MARGIN_LEFT_AS_A_PERCENTAGE])
            {
                marginLeftAsANumber = [NSNumber numberWithInt:CmarginLeft];
            }
            
            //margin Right
            NSNumber *marginRightAsANumber = [NSNumber numberWithInt:0];
            if ([block objectForKey:MARGIN_RIGHT_AS_A_PERCENTAGE])
            {
                marginRightAsANumber = [block objectForKey:MARGIN_RIGHT_AS_A_PERCENTAGE];
            }
            if ([block objectForKey:@"marginRight"] && ![block objectForKey:MARGIN_RIGHT_AS_A_PERCENTAGE])
            {
                marginRightAsANumber = [NSNumber numberWithInt:CmarginRight];
            }
            
            
            
            
            
            
            
            backgroundColor = [block valueForKey:@"backgroundColor"];
            NSMutableArray *arrayI = [NSMutableArray arrayWithObjects:
                                      @"#",
                                      blockidAsString,
                                      @"{",
                                      @"\n",
                                      @"  margin: ",
                                      [NSNumber numberWithInt:CmarginTop],
                                      @"px ",
                                      marginRightAsANumber,
                                      elementLayoutType,
                                      @" ",
                                      [NSNumber numberWithInt:CmarginBottom],
                                      @"px ",
                                      marginLeftAsANumber,
                                      elementLayoutType,
                                      @";",
                                      @"\n",
                                      @"  background-color: ",
                                      backgroundColor,
                                      @";",
                                      @"\n",
                                      @"  width: ",
                                      widthAsANumber,
                                      elementLayoutType,
                                      @";",
                                      @"\n",
                                      @"  height: ",
                                      heightAsAString,
                                      @"px;",
                                      @"\n",
                                      @"  float:left; ",
                                      @"\n",
                                      shadowCSS,
                                      @"\n",
                                      nil];
            
            NSArray *borderStrokeArray = [NSArray arrayWithObjects:
                                          @"  border: ",
                                          borderStrokeString,
                                          @" solid black; ",
                                          @"\n",
                                          nil];
            NSArray *borderRadiusArray = [NSArray arrayWithObjects:
                                          @"  border-radius: ",
                                          borderRadiusString,
                                          @"; ",
                                          @"\n",
                                          @"  -moz-border-radius: ",
                                          borderRadiusString,
                                          @"; ",
                                          @"\n",
                                          nil];
            
            if (borderStrokeString != nil)
            {
                [arrayI addObjectsFromArray:borderStrokeArray];
            }
            if (borderRadiusString != nil)
            {
                [arrayI addObjectsFromArray:borderRadiusArray];
            }
            [arrayI addObject:@"}\n\n"];
            
            Cstyle = [NSMutableString stringWithString:[Cstyle stringByAppendingString:[arrayI componentsJoinedByString:@""]]];
            
        }
        
        
        
        /* drop down code*/
        
        // DROPDOWN CODE
        if ( ([[block valueForKey:@"tag"] isEqualToString:DROP_DOWN_MENU_TAG])  )
        {
            
            NSArray *arrayH = [NSArray arrayWithObjects:
                               @"<select id=\"",
                               blockidAsString,
                               @"\" ",
                               dataSourceCode,
                               @">",
                               [block valueForKey:@"content"],
                               @"</select>",
                               nil];
            
            
            code = [NSMutableString stringWithString:[arrayH componentsJoinedByString:@""]];
            
            //width
            NSNumber *widthAsANumber = nil;
            if ([block objectForKey:WIDTH_AS_A_PERCENTAGE])
            {
                CWidth = [[block objectForKey:WIDTH_AS_A_PERCENTAGE]floatValue];
                widthAsANumber = [NSNumber numberWithFloat:CWidth];
            }
            else
            {
                CWidth = [[block valueForKey:@"width"] intValue];
                widthAsANumber =[NSNumber numberWithInt:CWidth];
            }
            
            //height
            NSString *heightAsAString = nil;
            if ([block objectForKey:@"height"])
            {
                CHeight = [[block valueForKey:@"height"] intValue];
                heightAsAString = [NSString stringWithFormat:@"%d", CHeight];
            }
            else
            {
                heightAsAString = @"auto";
            }
            
            CmarginTop = [[block valueForKey:@"marginTop"]intValue];
            CmarginBottom = [[block valueForKey:@"marginBottom"]intValue];
            CmarginLeft = [[block valueForKey:@"marginLeft"]intValue];
            CmarginRight = [[block valueForKey:@"marginRight"]intValue];
            
            //margin Left
            NSNumber *marginLeftAsANumber = [NSNumber numberWithInt:0];
            if ([block objectForKey:MARGIN_LEFT_AS_A_PERCENTAGE])
            {
                marginLeftAsANumber = [block objectForKey:MARGIN_LEFT_AS_A_PERCENTAGE];
            }
            if ([block objectForKey:@"marginLeft"] && ![block objectForKey:MARGIN_LEFT_AS_A_PERCENTAGE])
            {
                marginLeftAsANumber = [NSNumber numberWithInt:CmarginLeft];
            }
            
            //margin Right
            NSNumber *marginRightAsANumber = [NSNumber numberWithInt:0];
            if ([block objectForKey:MARGIN_RIGHT_AS_A_PERCENTAGE])
            {
                marginRightAsANumber = [block objectForKey:MARGIN_RIGHT_AS_A_PERCENTAGE];
            }
            if ([block objectForKey:@"marginRight"] && ![block objectForKey:MARGIN_RIGHT_AS_A_PERCENTAGE])
            {
                marginRightAsANumber = [NSNumber numberWithInt:CmarginRight];
            }
            
            
            
            
            
            
            
            backgroundColor = [block valueForKey:@"backgroundColor"];
            NSMutableArray *arrayI = [NSMutableArray arrayWithObjects:
                                      @"#",
                                      blockidAsString,
                                      @"{",
                                      @"\n",
                                      @"  margin: ",
                                      [NSNumber numberWithInt:CmarginTop],
                                      @"px ",
                                      marginRightAsANumber,
                                      elementLayoutType,
                                      @" ",
                                      [NSNumber numberWithInt:CmarginBottom],
                                      @"px ",
                                      marginLeftAsANumber,
                                      elementLayoutType,
                                      @";",
                                      @"\n",
                                      @"  background-color: ",
                                      backgroundColor,
                                      @";",
                                      @"\n",
                                      @"  width: ",
                                      widthAsANumber,
                                      elementLayoutType,
                                      @";",
                                      @"\n",
                                      @"  float:left; ",
                                      @"\n",
                                      nil];
            
            
            [arrayI addObject:@"}\n\n"];
            
            Cstyle = [NSMutableString stringWithString:[Cstyle stringByAppendingString:[arrayI componentsJoinedByString:@""]]];
            
        }
        
        
        /* end of dropdown code*/
        
        
        
        
        
        // TEXT INPUT FIELD CODE
        if ([[block valueForKey:@"tag"] isEqual: @"textInputField"])
        {
            NSArray *arrayH = [NSArray arrayWithObjects:
                               @"<input type=\"text\" id=\"",
                               blockidAsString,
                               @"\"",
                               @"placeholder=\"",
                               [block valueForKey:@"content"],
                               @"\">",
                               @"\n",
                               nil];
            code = [NSMutableString stringWithString:[arrayH componentsJoinedByString:@""]];
            NSNumber *widthAsANumber = nil;
            if ([block objectForKey:@"widthAsPercentage"])
            {
                CWidth = [[block objectForKey:@"widthAsPercentage"]floatValue];
                widthAsANumber = [NSNumber numberWithFloat:CWidth-(([borderStrokeString intValue]*2) )];
            }
            else
            {
                CWidth = [[block valueForKey:@"width"] intValue];
                widthAsANumber =[NSNumber numberWithInt:CWidth-(([borderStrokeString intValue]*2) )];
            }
            
            CHeight = [[block valueForKey:@"height"] intValue];
            CmarginTop = [[block valueForKey:@"marginTop"]intValue];
            CmarginBottom = [[block valueForKey:@"marginBottom"]intValue];
            CmarginLeft = [[block valueForKey:@"marginLeft"]intValue];
            CmarginRight = [[block valueForKey:@"marginRight"]intValue];
            backgroundColor = [block valueForKey:@"backgroundColor"];
            NSMutableArray *arrayI = [NSMutableArray arrayWithObjects:
                                      @"#",
                                      blockidAsString,
                                      @"{margin:",
                                      [NSNumber numberWithInt:CmarginTop],
                                      @"px ",
                                      [NSNumber numberWithInt:CmarginRight],
                                      @"px ",
                                      [NSNumber numberWithInt:CmarginBottom],
                                      @"px ",
                                      [NSNumber numberWithInt:CmarginLeft],
                                      @"px; ",
                                      @"width:",
                                      widthAsANumber, // check above for the calculation...
                                      // 24 because the TextInputField class is inset of x8/y8, has a padding of 4+4, and Bootstrap has a padding of 4+4 see files, but minus the borderwidth - so 8+8+8
                                      elementLayoutType,
                                      @";",
                                      @"height: ",
                                      [NSNumber numberWithInt:CHeight-(([borderStrokeString intValue]*2) )],
                                      // 8 because the TextInputField class is inset of x1/y1, has a padding of 0+0, and Bootstrap has a padding of 4+4 see files, but minus the borderwidth - so 1+0+8 - BUT the 1 isn't needed for some reason.
                                      @"px; height: ",
                                      @"px; float:left; ",
                                      @"\n",
                                      shadowCSS,
                                      @"\n",
                                      nil];
            NSLog(@"CHEIGHT : %d and borderStrokeString : %d", CHeight, [borderStrokeString intValue]);
            NSArray *borderStrokeArray = [NSArray arrayWithObjects:
                                          @"border: ",
                                          borderStrokeString,
                                          @"solid #CCC; ",
                                          @"\n",
                                          nil];
            
            if (borderStrokeString != nil)
            {
                [arrayI addObjectsFromArray:borderStrokeArray];
            }
            
            [arrayI addObject:@" }"];
            
            Cstyle = [NSMutableString stringWithString:[Cstyle stringByAppendingString:[arrayI componentsJoinedByString:@""]]];
        }
        
        
        
        
        
        
        
        // BUTTON
        if ([block valueForKey:@"tag"] == @"button")
        {
            
            //if "marginTop" in block:
            if ([block valueForKey:@"marginTop"] != nil)
            {
                CmarginTop = [[block valueForKey:@"marginTop"]intValue];
            }
            
            if ([block valueForKey:@"marginRight"] != nil)
            {
                CmarginRight = [[block valueForKey:@"marginRight"]intValue];
            }
            
            if ([block valueForKey:@"marginBottom"] != nil)
            {
                CmarginBottom = [[block valueForKey:@"marginBottom"]intValue];
            }
            
            if ([block valueForKey:@"marginLeft"] != nil)
            {
                CmarginLeft = [[block valueForKey:@"marginLeft"]intValue];
            }
            if ([block valueForKey:@"paddingTop"] != nil)
            {
                CPaddingTop = [[block valueForKey:@"paddingTop"]intValue];
            }
            if ([block valueForKey:@"paddingLeft"] != nil)
            {
                CPaddingLeft = [[block valueForKey:@"paddingLeft"] intValue];
            }
            
            CHeight = [[block valueForKey:@"height"] intValue];
            NSMutableArray *styleArray = [NSMutableArray arrayWithObjects:
                                          @"#",
                                          blockidAsString,
                                          @" {",
                                          @"\n",
                                          @"\n",
                                          @"  width: auto;",
                                          @"\n",
                                          @"  margin:",
                                          [NSNumber numberWithFloat:CmarginTop],
                                          @"px ",
                                          [NSNumber numberWithFloat:CmarginRight],
                                          elementLayoutType,
                                          @" ",
                                          [NSNumber numberWithFloat:CmarginBottom],
                                          @"px ",
                                          [NSNumber numberWithFloat:CmarginLeft],
                                          elementLayoutType,
                                          @";"
                                          @"\n",
                                          @"  float:left; ",
                                          @"\n",
                                          @"  padding: ",
                                          [NSNumber numberWithInt:CPaddingTop],
                                          @"px ",
                                          //@"  padding-left: ",
                                          [NSNumber numberWithFloat:CPaddingLeft],
                                          elementLayoutType,
                                          @";",
                                          @"\n",
                                          nil];
            NSArray *borderStrokeArray = [NSArray arrayWithObjects:
                                          @"  border: ",
                                          borderStrokeString,
                                          @"solid rgba(0,0,0 0.4);",
                                          @"\n",
                                          nil];
            NSArray *borderRadiusArray = [NSArray arrayWithObjects:
                                          @"  border-radius: ",
                                          borderRadiusString,
                                          @"; ",
                                          @"\n",
                                          @"  -moz-border-radius: ",
                                          borderRadiusString,
                                          @";",
                                          nil];
            NSArray *boxShadow = [NSArray arrayWithObject:@"-webkit-box-shadow: inset 0px 1px 0px 0px rgba(256,256,256,0.7);"];
            
            if (borderStrokeString != nil)
            {
                [styleArray addObjectsFromArray:borderStrokeArray];
            }
            if (borderRadiusString != nil)
            {
                [styleArray addObjectsFromArray:borderRadiusArray];
            }
            if (boxShadow !=nil)
            {
                [styleArray addObjectsFromArray:boxShadow];
            }
            [styleArray addObject:@"\n"];
            [styleArray addObject:@"}"];
            [styleArray addObject:@"\n"];
            Cstyle = [NSMutableString stringWithString:[Cstyle stringByAppendingString:[styleArray componentsJoinedByString:@""]]]; // BLOCKA
            NSLog(@" CSTYLE = %@", Cstyle);
            
            
            
            NSString *actionString = @"";
            if ([block valueForKey:@"action"])
            {
                actionString = [block valueForKey:@"action"];
            }
            
            NSArray *arrayJ = [NSArray arrayWithObjects:
                               @"<a id=\"",
                               blockidAsString,
                               @"\" class=\"btn btn-primary btn-large\">",
                               [block valueForKey:@"content"],
                               actionString, //data-bind goes here
                               @"</a>",
                               @"\n",
                               nil];
            
            code = [NSMutableString stringWithString:[arrayJ componentsJoinedByString:@""]];
            /*
             CWidth = [[block valueForKey:@"width"] intValue];
             NSLog(@"four");
             CHeight = [[block valueForKey:@"height"] intValue];
             NSLog(@"five");
             NSMutableArray *arrayK = [NSMutableArray arrayWithObjects:
             @"#",
             blockidAsString,
             @"{width:",
             [NSNumber numberWithInt:CWidth - 29],
             @"px; height: ",
             [NSNumber numberWithInt:CHeight - 14],
             @"px; ",
             nil];
             NSLog(@"six");
             NSArray *borderStrokeArray = [NSArray arrayWithObjects:
             @"border: ",
             borderStrokeString,
             @"solid black; ",
             nil];
             NSLog(@"seven");
             NSArray *borderRadiusArray = [NSArray arrayWithObjects:
             @"border-radius: ",
             borderRadiusString,
             @"-moz-border-radius: ",
             borderRadiusString,
             nil];
             
             if (borderStrokeString != nil)
             {
             [arrayK addObjectsFromArray:borderStrokeArray];
             }
             if (borderRadiusString != nil)
             {
             [arrayK addObjectsFromArray:borderRadiusArray];
             }
             [arrayK addObject:@" }"];
             
             
             Cstyle = [NSMutableString stringWithString:[arrayK componentsJoinedByString:@""]];
             */
            //[Cstyle appendString:@", "];
            //[Cstyle appendString:[NSMutableString stringWithString:[arrayK componentsJoinedByString:@""]]];
        }
        
        
        
        
        //  # This code will only be fired for the first element in each Grouping box.
        NSLog(@"THE VALUE IS : %@", groupBoxOpeningDiv); //INTERESTING... DOES THIS PRINT ALL GROUPINGBOXES CODE...
        if (groupBoxOpeningDiv != nil)
        {
            groupBoxOpeningDiv = [NSMutableString stringWithString:
                                  [[[[groupBoxOpeningDiv stringByAppendingString:@"id=\""] stringByAppendingString:groupBoxID] stringByAppendingString: @"\">"] stringByAppendingString:code]];
            code = groupBoxOpeningDiv;
        }
        
        if (postCode != nil)
        {
            code = [NSMutableString stringWithString:[code stringByAppendingString:postCode]];
        }
        
        //  Row code
        if (startRowCode != nil)
        {
            startRowCode = [NSMutableString stringWithString:[startRowCode stringByAppendingString:code]];
            code = startRowCode;
        }
        if (endRowCode != nil)
        {
            code = [NSMutableString stringWithString:[code stringByAppendingString:endRowCode]];
        }
        
        NSDictionary *codeDictionary = [NSDictionary dictionaryWithObject:code forKey:[NSNumber numberWithInt:CblockCount]];
        NSDictionary *styleDictionary = [NSDictionary dictionaryWithObject:Cstyle forKey:[NSNumber numberWithInt:CblockCount]];
        
        [gc setObject:code forKey:[NSNumber numberWithInt:CblockCount]];
        [gs setObject:Cstyle forKey:[NSNumber numberWithInt:CblockCount]];
        
        [codeStore addObject:codeDictionary];
        [styleStore addObject:styleDictionary];
        
        CblockCount++;
        
        previousElementId = [NSMutableString stringWithString:blockidAsString];
        
        
    } //end of cycling through each element.
    NSLog(@"CODE STORE HAS : %@", codeStore);
    NSMutableString *html = [NSMutableString string];
    NSMutableString *css = [NSMutableString string];
    NSMutableString *aStyle = [NSMutableString string];
    NSMutableString *aTag = [NSMutableString string];
    NSUInteger loopCount;
    NSString *rowCodeForNthChild = [NSMutableString string];
    NSString *backgroundColourAsString = [NSString stringWithString:[self hsla:self.stageBackgroundColor]];
    
    for (NSDictionary *d in styleStore)
    {
        for (NSString *key in d)
        {
            aStyle = [gs objectForKey:key];
            css = [NSMutableString stringWithString:[css stringByAppendingString:aStyle]];
        }
    }
    
    for (NSNumber *n in self.rowMargins)
    {
        loopCount = [self.rowMargins indexOfObject:n]+1;
        rowCodeForNthChild = [NSMutableString stringWithFormat:@".container .row:nth-child(%lu) {\n  margin-top: %@px;\n\n}", loopCount, n];
        css = [NSMutableString stringWithString:[css stringByAppendingString:rowCodeForNthChild]];
    }
    
    [css appendString:groupBoxIDCode];
    
    for (NSDictionary *d in codeStore)
    {
        for (NSString *key in d)
        {
            aTag = [gc objectForKey:key];
            html = [NSMutableString stringWithString:[html stringByAppendingString:aTag]];
        }
    }
    
    NSString *imgMaxWidth = [NSString stringWithFormat:@"%d%%", 100];
    start = [NSMutableString stringWithFormat: @"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"utf-8\">\n<title>%@</title>\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><meta name=\"description\" content=\"\"><meta name=\"author\" content=\"\">\n<!-- Le styles --><link href=\"bootstrap.css\" rel=\"stylesheet\"><style type=\"text/css\">\nbody { \n  font-size: 0.75em;\n  background-color: %@;\n} \n.groupBox {\n  height: auto;\n  padding: none;\n} \nimg {\n  max-width: %@;\n}  \n", pageTitle, backgroundColourAsString, imgMaxWidth];
    //[start stringByAppendingString:backgroundColourAsString];
    //[start stringByAppendingString:@""];
    
    middle = [NSMutableString stringWithString: @"\n</style></head>\n  <body>\n    <div class=\"container\">"];
    
    end = [NSMutableString stringWithString:@"\n</div><!-- /container -->\n</body>\n</html>"];
    
    doc = [NSMutableString stringWithString:
           [[[[start stringByAppendingString:css] stringByAppendingString:middle] stringByAppendingString:html] stringByAppendingString:end]];
    
    NSLog(@"OUTPUT IS: %@", doc);
    NSError *error = nil;
    if ([doc writeToURL:directoryURLToPlaceFiles atomically:YES encoding:NSUTF8StringEncoding error:&error])
    {
        NSLog(@"SUCCESS!");
        NSLog(@"Wrote doc to: %@", directoryURLToPlaceFiles);
    }
    else
    {
        NSLog(@"Error in writing document to file : %@", error);
    }
    
    
    
    /* Bootstrap amendments (to permanently make):
     .btn              textalign       now set to zero.
     .btn-large        padding         is set to 0.
     
     */
    
    
    
    
    
#pragma mark - END CONVERSION
    
    /*
     [sortedArray writeToFile:markupToSave atomically:YES];
     [finalGrouping writeToFile:groupBoxToSave atomically:YES];
     [self.rows writeToFile:rowsToSave atomically:YES];
     */
    
    NSLog(@"Nearly...");
    
    //[self setupPythonEnvironment];
    for (Element *ele in elementArray)
    {
        if (([ele isMemberOfClass:[Image class]]))
        {
            
            //  IMPROVE: EXPORT IN THE FORMAT THAT IT CAME AS, NOT NECESSARILY JPEG.
            NSLog(@"PATH IS - %@", outputFolderPath);
            NSMutableString *imagePath = [NSMutableString stringWithString:[outputFolderPath stringByDeletingLastPathComponent]];
            [imagePath appendString:@"/"];
            NSString *fileEnding = ((Image *)ele).filePath.lastPathComponent;
            [imagePath appendString:fileEnding];
            NSURL *folderPath = [NSURL fileURLWithPath:imagePath];
            NSData *imageData = [((Image*)ele).imageView.image TIFFRepresentation];
            NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
            NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
            
            NSUInteger fileTypeData = NSPNGFileType;
            if ([fileEnding isEqualToString:@"jpg"])
            {
                fileTypeData = NSJPEGFileType;
            }
            
            if ([fileEnding isEqualToString:@"jpeg"])
            {
                fileTypeData = NSJPEG2000FileType;
            }
            
            if ([fileEnding isEqualToString:@"gif"])
            {
                fileTypeData = NSGIFFileType;
            }
            
            if ([fileEnding isEqualToString:@"tiff"])
            {
                fileTypeData = NSTIFFFileType;
            }
            
            
            
            imageData = [imageRep representationUsingType:fileTypeData properties:imageProps];
            
            [imageData writeToURL:folderPath atomically:YES];
            NSLog(@"Writing image to file: %@", folderPath);
            
            
        }
    }
    NSArray *fileURLs = [NSArray arrayWithObjects:directoryURLToPlaceFiles, nil];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURLs];
    
    NSLog(@"exiting...");
}


-(void)actionsCompiler
{
    
    // get the actions
}

-(NSData *)dataSourceUsingHardcodedLocalValues:(NSString*)dataString
// purpose is to create the JSON data needed to act as a dataSource
// created from hardcoded values locally in the dataSource creator

{
    // get the master dataSource object
    NSData *dataSourceAsJSON = [NSData data];
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSMutableArray *masterData = [appDelegate masterDataSource];
    for (NSDictionary *key in masterData)
    {
        //check if this array contains a dataSet that contains the string/key passed to this function
        
        /*
         
         Package this into a dictionary for easy conversion into json string:
         
         { mealName: "Standard (sandwich)", price: 0 },
         { mealName: "Premium (lobster)", price: 34.95 },
         { mealName: "Ultimate (whole zebra)", price: 290 }
         
         */
        
        NSArray *dataSet = [masterData objectForKey:key];
        if ([[dataSet objectAtIndex:0] objectForKey:dataString]) // No need to do a loop as the data columns all repeats. First is fine.
        {
            // this is my dataSet so lets convert it to JSON for knockout.js!
            if ([NSJSONSerialization isValidJSONObject:dataSet])
            {
                NSError *errorObject;
                dataSourceAsJSON = [NSJSONSerialization dataWithJSONObject:dataSet
                                                                   options:NSJSONWritingPrettyPrinted
                                                                     error:&errorObject];
            };
        }
        
    }
    
    return dataSourceAsJSON;
    
}

// ASSUMPTION: THAT EVERY DATASOURCE HEADER ENTERED IS UNIQUE PER DOCUMENT.
-(NSString*)dataSourceNameContainingKey: (NSString *)dataSourceKey
{
    NSString *stringToReturn = [NSString string];
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSMutableArray *masterData = [appDelegate masterDataSource];
    for (NSDictionary *key in masterData)
    {
        // each key represents a dataSource.
        // each dataSource is made up of arrays
        NSArray *headerTitles = [[key objectForKey:@"DataSource"] objectAtIndex:0]; // This is the header information.
        for (NSString *header in headerTitles)
        {
            if ([header isEqualToString:dataSourceKey]) {
                NSLog(@"Gotcha!");
                stringToReturn = [key objectForKey:@"Name"]; // This is a string that was entered by the user into the Name field of the DataSource window.
            }
        }
        
        /*
         For each key
         Give me the first object in the array : returns dictionary
         Cycle through that dictionary looking for my keystring passed in
         If found, return key as a string.
         */
    }
    return stringToReturn;
}



-(IBAction)attributedStringToCSS:(id)sender
{
    int loopCount = 0;
    NSMutableDictionary *textStyles = [NSMutableDictionary dictionary];
    NSRange longestEffectiveRange;
    
    for (Element *ele in elementArray)
    {
        if (([ele isMemberOfClass:[TextBox class]]))
        {
            NSRange rangeOfString = NSMakeRange(0, [[ele contentText] length]);
            NSUInteger stringEndPoint = rangeOfString.location + rangeOfString.length;
            NSUInteger currentPoint = 0;
            while (stringEndPoint != currentPoint)
            {
                
                NSDictionary *style = [[ele contentText] attributesAtIndex:currentPoint longestEffectiveRange:&longestEffectiveRange inRange:rangeOfString];
                
                /*** STYLES ***/
                
                
                
                //The font name
                NSString *theFont = [[style objectForKey:NSFontAttributeName] fontName];
                [textStyles setObject:theFont forKey:@"fontName"];
                
                
                
                // The text color
                NSColor *textColor = [style objectForKey:NSForegroundColorAttributeName];
                CGFloat red = [textColor redComponent];
                CGFloat green = [textColor greenComponent];
                CGFloat blue = [textColor blueComponent];
                CGFloat alpha = [textColor alphaComponent];
                
                //[[style objectForKey:NSForegroundColorAttributeName] getRed:red green:green blue:blue alpha:alpha];
                NSString *fontColor = [NSString stringWithFormat:@"%f,%f,%f, %f", red, green, blue, alpha];
                [textStyles setObject:fontColor forKey:@"fontColor"];
                
                
                
                // The leading
                NSNumber *leading = [NSNumber numberWithFloat:[[style objectForKey:NSParagraphStyleAttributeName] lineSpacing]];
                if (leading != nil)
                {
                    [textStyles setObject:leading forKey:@"leading"];
                }
                
                
                
                //The kerning
                NSNumber *kerning = [style objectForKey:NSKernAttributeName];
                if (kerning != nil)
                {
                    [textStyles setObject:kerning forKey:@"kerning"];
                }
                
                
                
                
                // Underlined?
                NSNumber *underline = [style objectForKey:NSUnderlineStyleAttributeName];
                NSNumber *singleUnderline = [NSNumber numberWithInt:1];
                if ([underline isEqualToNumber:singleUnderline])
                {
                    [textStyles setObject:@"SingleUnderline" forKey:@"underline"];
                }
                
                
                // Character numbers
                
                
                
                NSLog(@"CurrentPoint: %lu", currentPoint);
                NSLog(@"End point: %lu", longestEffectiveRange.location + longestEffectiveRange.length -1);
                NSLog(@"LongestEffectiveRange: %lu", stringEndPoint);
                NSLog(@"Styles: %@", style);
                NSLog(@"Gonna package up: %@", textStyles);
                loopCount +=1;
                
                //At the end change the current point for the next loop...
                currentPoint = longestEffectiveRange.location + longestEffectiveRange.length;
                
            }
        }
    }
}


-(IBAction)groupElements:(id)sender
{
    if (groupItems.title == @"Group items")
    {
        NSLog(@"Entering groupElements with: %d", numberOfGroupings);
        for (Element *ele in selElementArray)
        {
            NSNumber *grouping = [NSNumber numberWithInt:numberOfGroupings+1];
            [ele setSpanGrouping:[grouping stringValue]];
        }
        numberOfGroupings = numberOfGroupings+1;
        NSLog(@"Exiting with: %d", numberOfGroupings);
    }
    else
    {
        [currentElement setSpanGrouping:@""];
    }
    
}



-(CGFloat)convertTarget:(float)target inContext:(float)context
{
    CGFloat flexibleMeasurement = (target/context)*100;
    return flexibleMeasurement;
}





@end
