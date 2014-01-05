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


@implementation StageView (conversion)



#define STR_LEFT   @"Left Edge"
#define STR_RIGHT  @"Right Edge"
#define STR_TOP    @"Top Edge"
#define STR_BOTTOM @"Bottom Edge"

#define xcoordinate @"xcoordinate"
#define ycoordinate @"ycoordinate"
#define bottomYcoordinate @"bottomYcoordinate"

#pragma mark - ASSOCIATIVE GENERATION METHODS

-(NSMutableDictionary*)dcWithID: (NSString *)stringID
{
    for (NSMutableDictionary *e in self.sortedArray)
    {
        if ([stringID isEqualToString:[e objectForKey:ID_KEYWORD]])
            return e;
    }
    return nil;
}

-(NSArray *)elementsToMyRightInGroupingBox:(NSDictionary *)element
{
    // Takes an element and finds all other elements in the same groupingBox as it and orders it by xcoordinate.
    NSMutableArray *inMyRange = [NSMutableArray array];
    NSMutableArray *elementsChecked = [NSMutableArray array];
    //NSMutableArray *orderedElementsAboveMe = [NSMutableArray array];
    
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
    
    
    for (NSMutableDictionary *compare in objectsToLoopThrough)
    {
        if ([compare isEqualToDictionary:element] == NO && [compare objectForKey:@"tag"] != [Container class])    //  If not me
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
        if ([compare isEqualToDictionary:element] == NO && [compare objectForKey:@"tag"] != [Container class])    //  If not me
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

// TODO: Check this method as it's not even called anymore.
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
            if ([elementsChecked containsObject:compare] == NO && [compare objectForKey:@"tag"] != [Container class]) //  if this object hasn't been checked
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
    NSUInteger rowImIn = nil;
    for (NSArray *r in self.rows)
    {
        if ([r containsObject:element])
        {
            rowImIn = [self.rows indexOfObject:r];
        }
    }
    
    return rowImIn;
}

-(NSMutableDictionary *)highestElementWithEmptyLeft:(NSArray *)array
{
    //  This function receives an array sorted by height.
    
    // Puts together an array of elements with an empty left ordered by height, and returns the highest
    NSMutableArray *contestants = [NSMutableArray array];
    NSMutableArray *inMyLeftRange = nil;
    NSMutableArray *elementsChecked = nil;
    for (NSMutableDictionary *test in array)
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



-(int)isThereAGroupBoxInPath:(NSRect)masterRect marginType:(NSString *)marginType comparatorRect:(NSRect)comparatorRect // Question for later - unnecessary code?
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
    __block GroupingBox *myGroupingBox = nil;
    
    [self.groupingBoxes enumerateObjectsUsingBlock:^(GroupingBox *box, NSUInteger index, BOOL *stop)
     {
         if ([box.idPreviouslyKnownAs isEqualToString:[[element objectForKey:PARENT_ID] objectForKey:DIV_TAG]])
         {
             NSLog(@"%@ Found his daddy: %@", [element valueForKey:ID_KEYWORD], box.idPreviouslyKnownAs);
             myGroupingBox = box;
             *stop = YES;
         }
         
     } ];
    
    
    if (myGroupingBox == nil)
    {
        myGroupingBox = [self whichGroupingBoxIsElementIn:element];
    }
    NSLog(@"Element: %@ is inside groupingBox: %@", [element objectForKey:ID_KEYWORD], myGroupingBox.idPreviouslyKnownAs);
    
    
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
        NSLog(@"Element object is : %@. GroupingBox is y: %f, x:%f, w:%f", [element objectForKey:ID_KEYWORD], myGroupingBox.rtFrame.origin.y, myGroupingBox.rtFrame.origin.x, myGroupingBox.rtFrame.size.width );
        NSLog(@"Border distance to the TOP is :%i", borderDistance);
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
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:ycoordinate ascending:YES];
    NSSortDescriptor *horizontally = [[NSSortDescriptor alloc] initWithKey:xcoordinate ascending:YES];
    NSArray *horizontalSortDescriptor = [NSArray arrayWithObject: horizontally];
    NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
    if ([groubingBoxesInPath count] > 0)
    {
        [groubingBoxesInPath sortedArrayUsingDescriptors:horizontalSortDescriptor];
    }
    
    
    
    //are there other elements in this rect, order them by closest distance
    for (NSDictionary *dc in myGroupingBox.insideTheBox)
    {
        if ([dc isEqualToDictionary:element] == NO)
        {
            NSRect dcRect = NSMakeRect([[dc objectForKey:xcoordinate]floatValue],
                                       [[dc objectForKey:ycoordinate]floatValue],
                                       [[dc objectForKey:@"width"] floatValue],
                                       [[dc objectForKey:@"height"]floatValue]);
            contained = CGRectIntersectsRect(rectToTest, dcRect);
            if (contained)
            {
                NSLog(@"IT intersects");
                [elementsInPath addObject:dc];
            }
        }
        
    }
    if ([elementsInPath count] > 0)
    {
        elementsInPath = [NSMutableArray arrayWithArray: [elementsInPath sortedArrayUsingDescriptors:horizontalSortDescriptor]];
        if ([groubingBoxesInPath count] > 0)
        {
            NSLog(@"ERROR IN 1");
            nearest = MIN([[groubingBoxesInPath objectAtIndex:0]intValue], [[elementsInPath objectAtIndex:0]intValue]);
        }
        else
        {
            NSLog(@"ERROR IN 2?");
            //nearest = [[[elementsInPath objectAtIndex:0]objectForKey:xcoordinate]intValue] - [[element objectForKey:@"farRight"]intValue];
            
            
            if (sideToTest == TOP)
            {
                [elementsInPath sortedArrayUsingDescriptors:verticalSortDescriptor];
                nearest = [[element objectForKey:ycoordinate] intValue] - ( [[[elementsInPath lastObject]objectForKey:ycoordinate]intValue] + [[[elementsInPath lastObject]objectForKey:@"height"]intValue] );
            }
            
            if (sideToTest == RIGHT)
            {
                NSLog(@"Testing against object to the right : %@", [elementsInPath objectAtIndex:0]);
                nearest = [[[elementsInPath objectAtIndex:0]objectForKey:xcoordinate]intValue] - [[element objectForKey:FAR_RIGHT_X]intValue];
            }
            
            if (sideToTest == LEFT)
            {
                nearest = [[element objectForKey:xcoordinate]intValue] - [[[elementsInPath lastObject]objectForKey:FAR_RIGHT_X]intValue];
            }
            NSLog(@"Nope");
        }
        
    }
    else
    {
        if ([groubingBoxesInPath count] > 0)
        {
            nearest = [[groubingBoxesInPath objectAtIndex:0]intValue];
        }
        else
        {
            NSLog(@"Write some magic - nearest is border so set to 0?");
            nearest = borderDistance;
            //nearest = 0;
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


-(GroupingBox*)whichGroupingBoxIsElementIn:(NSDictionary*)elementBeingTested // update this so that it returns the gb closest to it
{
    
    NSArray *ag = nil;
    GroupingBox *closestGB = nil;
    
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
    
    
    return closestGB;
}





-(BOOL)isClosestObjectToMyLeftAnElement: (NSDictionary *)elementBeingTested
{
    //This method is used to determine whether or not
    NSLog(@"isClosestObjectToMyLeftAnElement just got %@", [elementBeingTested objectForKey:ID_KEYWORD]);
    BOOL overlap,isElementClosest;
    NSMutableArray *overlappingItems = [NSMutableArray array];
    GroupingBox *grb = [self whichGroupingBoxIsElementIn:elementBeingTested];
    /*
    NSRect rectToTest = NSMakeRect([[elementBeingTested objectForKey:xcoordinate]floatValue],
                                   [[elementBeingTested objectForKey:ycoordinate]floatValue],
                                   ([[elementBeingTested objectForKey:xcoordinate]floatValue] - grb.bounds.origin.x),
                                   [[elementBeingTested objectForKey:@"height"]floatValue]);
    */
    NSRect rectToTest = NSMakeRect(
                                   grb.bounds.origin.x,
                                   [[elementBeingTested objectForKey:ycoordinate]floatValue],
                                   ([[elementBeingTested objectForKey:xcoordinate]floatValue] - grb.bounds.origin.x),
                                   [[elementBeingTested objectForKey:@"height"]floatValue]);
    NSLog(@"isClosestObjectToMyLeftAnElement Returning rect : %@", NSStringFromRect(rectToTest));
    for (NSDictionary *dc in grb.insideTheBox)
    {
        NSRect dcRect = NSMakeRect(
                                   [[dc objectForKey:xcoordinate]floatValue],
                                   [[dc objectForKey:ycoordinate]floatValue],
                                   [[dc objectForKey:@"width"]floatValue],
                                   [[dc objectForKey:@"height"]floatValue]);
        overlap = CGRectIntersectsRect(rectToTest, dcRect);
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
    NSLog(@"isClosestObjectToMyLeftAnElement returning value of %i", isElementClosest);
    return isElementClosest;
    
}




-(NSMutableDictionary *)nearestElementDirectlyAboveMeInMyRow: (NSDictionary *)elementBeingTested
{
    // This gets elements above me based on the bottom y-coordinate.
    
    NSUInteger elementBeingTestedY = [[elementBeingTested valueForKey:bottomYcoordinate] unsignedIntegerValue];
    NSUInteger elementBeingTestedW = [[elementBeingTested valueForKey:@"width"] unsignedIntegerValue];
    NSUInteger elementBeingTestedX = [[elementBeingTested valueForKey:@"xcoordinate"] unsignedIntegerValue];
    NSRange elementBeingTestedRange = NSMakeRange(elementBeingTestedX, elementBeingTestedW);
    NSUInteger rowImIn = nil;
    NSLog(@"start 1");
    for (NSArray *r in self.rows)
    {
        if ([r containsObject:elementBeingTested])
        {
            rowImIn = [self.rows indexOfObject:r];
        }
    }
    NSLog(@"start 2: ROW I'M IN: %lu and row count is: %lu", rowImIn, self.rows.count);
    if ([NSNumber numberWithInteger:rowImIn] == nil)
    {
        NSLog(@"NearestElementDirectlyAboveMeInMyRow RETURNED NIL");
        return nil;
    }
    
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
    NSLog(@"lowest element id : %@", [lowestElement objectForKey:ID_KEYWORD]);
    NSLog(@"yCoordinateOfLowestElement : %@", yCoordinateOfLowestElement);
    return lowestElement;
    
    
}



-(NSMutableDictionary *)nearestElementDirectlyCleanAboveMeInMyRow: (NSDictionary *)elementBeingTested
{
    // This gets elements above me based on the bottom y-coordinate.
    
    NSUInteger elementBeingTestedY = [[elementBeingTested valueForKey:ycoordinate] unsignedIntegerValue];
    NSUInteger elementBeingTestedW = [[elementBeingTested valueForKey:@"width"] unsignedIntegerValue];
    NSUInteger elementBeingTestedX = [[elementBeingTested valueForKey:@"xcoordinate"] unsignedIntegerValue];
    NSRange elementBeingTestedRange = NSMakeRange(elementBeingTestedX, elementBeingTestedW);
    NSUInteger rowImIn = nil;
    NSLog(@"start 1");
    for (NSArray *r in self.rows)
    {
        if ([r containsObject:elementBeingTested])
        {
            rowImIn = [self.rows indexOfObject:r];
        }
    }
    NSLog(@"start 2: ROW I'M IN: %lu and row count is: %lu", rowImIn, self.rows.count);
    if ([NSNumber numberWithInteger:rowImIn] == nil)
    {
        NSLog(@"NearestElementDirectlyAboveMeInMyRow RETURNED NIL");
        return nil;
    }
    
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
                NSUInteger compareY = [[compare valueForKey:ycoordinate] unsignedIntegerValue];
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
    NSLog(@"lowest element id : %@", [lowestElement objectForKey:ID_KEYWORD]);
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



-(NSNumber*)highestYcoordinateInMyRow: (NSDictionary *)elementBeingTested //which now means the smallest when view isFlipped.
{
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:ycoordinate ascending:NO];
    NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
    if ([[elementBeingTested objectForKey:@"tag"] isEqual:CONTAINER_TAG])
    {
        NSLog(@"RETURNING AS THIS IS A CONTAINER TAG");
        return nil;
    }
    
    NSUInteger rowImIn = nil;
    for (NSArray *r in self.rows)
    {
        if ([r containsObject:elementBeingTested])
        {
            rowImIn = [self.rows indexOfObject:r];
        }
    }
    
    if ([NSNumber numberWithInteger:rowImIn] == nil) {
        NSLog(@"highestYcoordinateInMyRow method RETURNING NIL");
        return nil;
    }
    NSMutableArray *itemsInMyRow = [NSMutableArray array];
    NSArray *sortedItemsInRow = [NSArray array];
    itemsInMyRow = [self.rows objectAtIndex:rowImIn];
    
    
    //  Sort itemsInRowAbove to get the item with the highest Y value
    sortedItemsInRow = [itemsInMyRow sortedArrayUsingDescriptors:verticalSortDescriptor];
    
    NSDictionary *highestElement = [sortedItemsInRow lastObject];
    NSNumber *rowMarginTop = [highestElement valueForKey:@"ycoordinate"];
    NSLog(@"  **** Returning fom highestYcoordinateInMyRow : %@", rowMarginTop);
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
    self.solos = [NSMutableArray array];
    for (NSDictionary *elementia in initalSorting)
    {
        NSMutableArray *inMyRightRange = [NSMutableArray array];
        NSUInteger xco = [[elementia valueForKey:@"xcoordinate"] unsignedIntegerValue];
        NSUInteger yco = [[elementia valueForKey:ycoordinate] unsignedIntegerValue];
        NSUInteger vSide = [[elementia valueForKey:@"height"] unsignedIntegerValue];
        NSRange eleRange = NSMakeRange(yco, vSide);
        
        for (NSDictionary *testObject in initalSorting)
        {
            if (![[testObject objectForKey:@"tag"] isEqual:CONTAINER_TAG])
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
            
            
        }
        if ([inMyRightRange count] == 0)
        {
            [self.solos addObject:elementia];
            NSLog(@"SOLO IS: %@", [elementia objectForKey:ID_KEYWORD]);
        }
    }
    
    return self.solos;
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
            [gb setValue:[NSNumber numberWithFloat:ceil(width)] forKey:@"width"];
            [gb setValue:[NSNumber numberWithFloat:ceil(height)] forKey:@"height"];
            [gb setRtFrame:NSMakeRect(firstX, topY, ceil(width), ceil(height))];
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
        
        for (NSDictionary *ele in self.sortedArray)
        {
            NSLog(@"2. sorted array marginTop: %@", [ele objectForKey:@"marginTop"]);
        }
        
        
        AG = [box insideTheBox];
        NSMutableDictionary *highest = [[AG sortedArrayUsingDescriptors:verticalSortDescriptor] lastObject];
        
        // PLACE ELSEWHERE IN SCRIPT - WRONG METHOD.
        int boxMarginTop = [[box valueForKey:ycoordinate]intValue] - [[self highestYcoordinateInMyRow:highest] intValue]; //was [self marginToElementAboveMe:highest];
        NSLog(@"TEST3 TEST3 : %i and %i", boxMarginTop, [[box valueForKey:ycoordinate]intValue] );
        [box setMarginTop:boxMarginTop];
        NSLog(@"pla2: %i", boxMarginTop);
        [highest setObject:[NSNumber numberWithInt:0] forKey:@"marginTop"]; //The row will take care of marginTops for me
        // PLACE ELSEWHERE IN SCRIPT - WRONG METHOD.
        
        /*
        
         ** ** NOW ADD CODE HERE THAT SETS THE MARGIN TOP ACCORRDING TO THE GROUPING BOX I'M IN!!
        
        
         ** ** OTHERWISE IT'S JUST THE ROW I'M IN
         
         */
        
        for (NSDictionary *ele in self.sortedArray)
        {
            NSLog(@"3. sorted array marginTop: %@", [ele objectForKey:@"marginTop"]);
        }
        
        
        if ([box idPreviouslyKnownAs] == nil)
        {
            // GET THE HIGHEST OBJECT and use its Y Coordinate to set the highest y coordinate of the grouping box
            NSLog(@"idPreviouslyKnownAs = NIL");
            
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
                    if ([element objectForKey:PARENT_ID] != nil)
                    {
                        NSLog(@"Element %@ has a parent id of : %@", [element objectForKey:ID_KEYWORD], [element objectForKey:PARENT_ID]);
                        marginTop = [NSNumber numberWithInt: [self marginToObjectWithinTransformedGroupingBox:element onSide:TOP]];
                    }
                    
                    /*
                    if (marginTop != nil)
                    {
                        [element setObject:marginTop forKey:@"marginTop"];
                    }
                     */
                
                    
                }
            }
        }
        
        for (NSDictionary *ele in self.sortedArray)
        {
            NSLog(@"4. sorted array marginTop: %@", [ele objectForKey:@"marginTop"]);
        }
        
        //  Set all objects within this Grouping that does not have anything above it (thats inside the Grouping) to have the necessary marginTops
        if ( ([box idPreviouslyKnownAs] != nil) )
        {
            
            // get all of the solos
            // get the objects to their right
            // get the next one highest with an empty left
            // set its margin top right and possibly left if its closest left object is the wall
            
            NSLog(@"idPreviouslyKnownAs != NIL");
            
            
            NSMutableArray *sortedArrayInsideGroupingBox = [NSMutableArray array];
            self.solos = [[NSMutableArray alloc]init];
            box.insideTheBox = [NSMutableArray arrayWithArray:[box.insideTheBox sortedArrayUsingDescriptors:verticalSortDescriptor]];
            
            for (NSDictionary *ele in self.sortedArray)
            {
                NSLog(@"1. sorted array marginTop: %@", [ele objectForKey:@"marginTop"]);
            }
            
            
            
            self.solos = [self arrayOfSoloItems:box.insideTheBox];
            for (NSMutableDictionary *g in self.solos)
            {
                
                NSLog(@"Just checking. But id = %@", [g objectForKey:ID_KEYWORD]);
                
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
                    NSMutableDictionary *next = [self highestElementWithEmptyLeft:toMyRightInThisGroupingBox];//THIS EVENTUALLY WILL HAVE TO CHANGE TO BE HIGHESTELE IN GROUP.*
                    NSDictionary *previous = [sortedArrayInsideGroupingBox lastObject];
                    NSLog(@"toMyRightInThisGroupingBox are %lu", toMyRightInThisGroupingBox.count);
                    
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
                    
                    int marginTop2, marginRight2, marginLeft2;
                    if ([sortedArrayInsideGroupingBox containsObject:next] == NO) // As if might not hit the big if statement above and so next object may already exist in the SortedArray dataset.
                    {
                        [sortedArrayInsideGroupingBox addObject:next];
                        marginTop2 = [self marginToObjectWithinTransformedGroupingBox:next onSide:TOP];
                        marginRight2 = [self marginToObjectWithinTransformedGroupingBox:next onSide:RIGHT];
                        if ([self isClosestObjectToMyLeftAnElement:next] == NO)
                        {
                            marginLeft2 = [self marginToObjectWithinTransformedGroupingBox:next onSide:LEFT];
                            //[next setObject:[NSNumber numberWithInt:marginLeft] forKey:@"marginLeft"];
                        }
                        NSLog(@"TOP = %i\n RIGHTZ = %i \n. LEFT = %i \n", marginTop2, marginRight2, marginLeft2);
                        //[next setObject:[NSNumber numberWithInt:marginRight] forKey:@"marginLeft"];
                        NSLog(@"Now settt");
                        
                    }
                    NSLog(@"toMyRightInThisGroupingBox: 0 %lu", toMyRightInThisGroupingBox.count);
                    
                    [toMyRightInThisGroupingBox removeObject:next];
                    
                    NSLog(@"toMyRightInThisGroupingBox: 1 %lu", toMyRightInThisGroupingBox.count);
                    
                    elementsNotCountedYet = toMyRightInThisGroupingBox;
                    
                    NSLog(@"elements not counted yet %lu", elementsNotCountedYet.count);
                    
                    if (marginTop2)
                        [next setObject:[NSNumber numberWithInt:marginTop2] forKey:@"marginTop"];
                    
                    if (marginRight2 && (elementsNotCountedYet.count > 0) )
                        [next setObject:[NSNumber numberWithInt:marginRight2] forKey:@"marginRight"];
                        NSLog(@"yes it is");
                    
                    if (marginLeft2)
                        [next setObject:[NSNumber numberWithInt:marginLeft2] forKey:@"marginLeft"];
                    
                }
                
            }
            
        }
        
        for (NSDictionary *ele in self.sortedArray)
        {
            NSLog(@"100. Element %@ has a marginTop of: %@", [ele objectForKey:ID_KEYWORD], [ele objectForKey:@"marginTop"]);
        }
        
    }
    
    
}


-(void)setGroupingBoxMargin: (GroupingBox*)g
{
    NSLog(@"ADJUSTMENTS SECTION. CURRENT MARGINTOP : %d FOR OBJECT WITH ID :%@", g.marginTop, g.idPreviouslyKnownAs );
    
    // find the closest element above me in this row
    int offset;
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:@"ycoordinate" ascending:NO];
    NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
    NSArray *vSortedArrayOfGroupingBoxElements = [[g insideTheBox] sortedArrayUsingDescriptors:verticalSortDescriptor];
    
    NSMutableDictionary *firstObjectinGroupBox =[vSortedArrayOfGroupingBoxElements lastObject];
    NSLog(@"The highest box in the gb has id of: %@", [firstObjectinGroupBox objectForKey:@"id"]);
    NSMutableDictionary *directlyAboveMeInThisRow = [self nearestElementDirectlyCleanAboveMeInMyRow:firstObjectinGroupBox];
    NSLog(@"directlyAboveMeInThisRow is: %@", directlyAboveMeInThisRow);
    
    // either it exists or it doesn't
    if (directlyAboveMeInThisRow == nil)
    {
        // if there is nothing above me in this row
        offset = [[g valueForKey:ycoordinate]intValue] - [[self highestYcoordinateInMyRow:firstObjectinGroupBox] intValue];
        NSLog(@"if statement : %i", offset);
    }
    else
    {
        // if there is something above me, get its gbox and offset against the lowesty in the gbox.
        GroupingBox *thegbAboveMe = [self whichGroupingBoxIsElementIn:directlyAboveMeInThisRow]; //lastBox.
        NSString *a = [firstObjectinGroupBox objectForKey:ID_KEYWORD]; // lastbox.
        float b = thegbAboveMe.rtFrame.origin.y;
        float c = thegbAboveMe.rtFrame.size.height;
        
        NSLog(@"a = %@. b = %f. c = %f. d = %@", a, b, c, thegbAboveMe.idPreviouslyKnownAs);
        
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





-(NSString*)actionStringForElement:(Element*)keyword
{
    return nil;
}


/*
-(NSString *)hsla:(NSColor *)color
{
    NSString *hexValue = [color hexadecimalValueOfAnNSColor];
    if (hexValue == nil)
    {
        hexValue = @"#FFFFFF";
    }
    return hexValue;
    
}
 */

-(NSArray*)elementsInside: (NSMutableDictionary *)elementBeingTested usingElements: (NSArray*) sortedArrayOnStage
{
    //This method returns an array containing: elements that are within its bounds or nil.
    
    NSRect containingRect = NSRectFromString([elementBeingTested objectForKey:RT_FRAME]);
    NSMutableArray *cleanInsideMe = [NSMutableArray array];
    
    for (NSDictionary *ele in sortedArrayOnStage)
    {
        if (![ele isEqualToDictionary:elementBeingTested])
        {
            NSRect elementRect = NSRectFromString([ele valueForKey:RT_FRAME]);
            if (CGRectContainsRect(containingRect, elementRect))
            {
                [cleanInsideMe addObject:ele];
            }
        }
        
    }
    NSLog(@"Returning %@", cleanInsideMe);
    return cleanInsideMe;
}


-(NSDictionary*)containerContaining:(NSDictionary *)elementBeingTested usingElements:(NSArray*) sortedArrayOnStage
{
    //This method returns an array containing: elements that are within its bounds or nil.
    NSDictionary *matchingContainer = nil;
    if ([[elementBeingTested objectForKey:@"tag"] isEqual:CONTAINER_TAG])
    {
        return matchingContainer;
    }
    NSMutableArray *arrayOfContainers = [NSMutableArray new];
    NSRect elementRect = NSRectFromString([elementBeingTested valueForKey:RT_FRAME]);
    
    //Get a list of all containers
    for (NSDictionary *ele in sortedArrayOnStage)
    {
        if ([[ele objectForKey:@"tag"] isEqualTo:CONTAINER_TAG])
        {
            [arrayOfContainers addObject:ele];
        }
    }
    
    for (NSDictionary *container in arrayOfContainers)
    {
        NSRect containerRect = NSRectFromString([container valueForKey:RT_FRAME]);
        
        if (CGRectContainsRect(containerRect, elementRect))
        {
            matchingContainer = container;
        }
        
    }
    
    if (matchingContainer != nil)
        NSLog(@"Container found.");
    else
        NSLog(@"CONTAINER NOT FOUND.");
    
    
    return matchingContainer;
    
}

-(NSMutableString*)containerThatContainsRow:(NSUInteger *)rowOrder usingElements:(NSArray*) sortedArrayOnStage
{
    NSMutableString *containerID = nil;
    
    // get the markup id of the Container this row sits within, and then place that id where .container currently is in the code below. If Nil then replace it with 'body'.
    NSArray *elementsInsideRow = [self.rows objectAtIndex:rowOrder];
    NSDictionary *firstElementWilldo = [elementsInsideRow objectAtIndex:0];
    NSDictionary *containerContaingMyRow = [self containerContaining:firstElementWilldo usingElements:sortedArrayOnStage];
    if (containerContaingMyRow != nil)
        containerID = [NSMutableString stringWithString:[containerContaingMyRow objectForKey:@"markupid"]];
    
    return containerID;
}



-(NSNumber*)distanceFromContainerToElementDirectlyAboveIt:(NSDictionary*)container usingElements:(NSArray*) sortedArrayOnStage
{
    NSMutableArray *inMyRange = [NSMutableArray array];
    NSUInteger containerW = [[container valueForKey:@"width"] unsignedIntegerValue];
    NSUInteger containerX = [[container valueForKey:@"xcoordinate"] unsignedIntegerValue];
    NSUInteger containerY = [[container valueForKey:@"ycoordinate"] unsignedIntegerValue];
    NSRange containerXRange = NSMakeRange(containerX, containerW);
    for (NSDictionary *element in sortedArrayOnStage)
    {
        if ([element isEqualToDictionary:container] == NO)    //  If not me
        {
            NSUInteger compareY = [[element valueForKey:bottomYcoordinate] unsignedIntegerValue];
            NSUInteger compareW = [[element valueForKey:@"width"] unsignedIntegerValue];
            NSUInteger compareX = [[element valueForKey:@"xcoordinate"] unsignedIntegerValue];
            NSRange compareWidthRange = NSMakeRange(compareX, compareW); //X location and the length
            
            NSRange comparison = NSIntersectionRange(containerXRange, compareWidthRange);
            
            if ((compareY < containerY) & (comparison.length!=0)) //    We have a match
            {
                NSLog(@"start 4");
                [inMyRange addObject:element]; //   Add the comparison object so it now has an order.
            }
            else
                NSLog(@"start 5");
        }
    }
    NSNumber *distance = nil;
    if ([inMyRange count] > 0)
    {
        NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:@"ycoordinate" ascending:YES];
        NSSortDescriptor *horizontally = [[NSSortDescriptor alloc] initWithKey:@"xcoordinate" ascending:YES];
        
        NSArray *sortDescriptorA = [NSArray arrayWithObjects: vertically, horizontally, nil];
        NSArray *aboveMe = [inMyRange sortedArrayUsingDescriptors:sortDescriptorA];
        distance = [[aboveMe objectAtIndex:0] objectForKey:bottomYcoordinate];
    }
    else
    {
        distance = [container objectForKey:ycoordinate];
    }
    
    return distance;
}



BOOL hasLeadingNumberInString(NSString* s)
{
    if (s==nil)
        return NO;
    if (s)
        return [s length] && isnumber([s characterAtIndex:0]);
    else
        return NO;
}


-(void)sortElements
{
    
    
    //JS code
    NSMutableString *jsCode = [NSMutableString string];
    
    self.rowMargins = [NSMutableArray array];
    NSMutableArray *whiteSpacesFound = [NSMutableArray array];
     self.textStyles = [NSMutableDictionary dictionary];
    //NSMutableDictionary *allStyles = [NSMutableDictionary dictionary];
    NSMutableArray *allStyles = [NSMutableArray array];
    NSDictionary *newDict = [NSDictionary dictionary];
    
    NSRange longestEffectiveRange;
    
    NSMutableArray *arrayOfElementDetails = [[NSMutableArray alloc]init];
    NSString *tagType = [[NSString alloc]init];
    NSString *tagContent = [[NSString alloc]init];
    int span = 0;
    
    
    int numberOfImages = 0;
    
    for (Element *ele in elementArray)
    {
        if ([ele isMemberOfClass:[Image class]])
        {
            numberOfImages+=1;
        }
    }
    
    
    
    self.totalNumberOfCycles = 9; //(float)(2*elementArray.count) + (float)(1 * numberOfImages) + 5;
    // 5 steps +  4 cycles, 1 cycle that counts just the images
    
    
     NSDictionary *msg = [NSDictionary dictionaryWithObject:@"Locating all the elements on the page..." forKey:@"string"];
    [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CONVERSION_PROGRESS_SCREEN object:self userInfo:msg];
    
    for (Element *ele in elementArray)
    {
        //if no id then let's stop this straight away
        if (ele.elementid == nil || [ele.elementid isEqualToString:@""])
        {
            NSLog(@"NO elementID given");
            abortConversion = YES;
            return;
        }
        
        //  Clean out any styles or markers for whiteSpaceFound from the last cycle.
        [allStyles removeAllObjects];
        [whiteSpacesFound removeAllObjects];
        
        //Get the tag
        NSLog(@"In the array: %@", ele.elementTag);
        
        //Get the HTML tag to use and its content
        tagType = nil;
        tagContent = nil;
        
        //Set the JS_ID tag just in case
        if (hasLeadingNumberInString(ele.elementid)) //if the id starts with a number
            ele.jsid= [NSString stringWithFormat:@"element%@", ele.elementid];
        else
            ele.jsid = ele.elementid;
        
        [ele.jsid lowercaseStringWithLocale:[NSLocale currentLocale]];
        [ele.jsid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
         
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
            NSLog(@"Container found with id: %@", ele.elementid);
        }
        
        if (([ele isMemberOfClass:[DropDown class]]))
        {
            tagContent = @"";
            tagType = DROP_DOWN_MENU_TAG;
            //NSLog(@"OUPUT FROM DATASOURCE IS : %@", [ele dataSourceUsingHardcodedLocalValues]);
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
            tagType = PARAGRAPH_TAG;
            
            
            NSRange rangeOfString = NSMakeRange(0, [[ele contentText] length]);
            NSUInteger stringEndPoint = rangeOfString.location + rangeOfString.length;
            NSUInteger currentPoint = 0;
            int loopCount = 0;
            while (stringEndPoint != currentPoint)
            {
                
                NSDictionary *style = [[ele contentText] attributesAtIndex:currentPoint longestEffectiveRange:&longestEffectiveRange inRange:rangeOfString];
                
                /*** STYLES ***/
                //Now clear the dictionary ready for the loop...
                [self.textStyles removeAllObjects];
                
                
                //The font name
                NSString *theFont = [[style objectForKey:NSFontAttributeName] fontName];
                [self.textStyles setObject:theFont forKey:@"fontName"];
                
                
                //The font size
                NSNumber *fontSize = [NSNumber numberWithInt:(int)[[style objectForKey:NSFontAttributeName] pointSize]];
                [self.textStyles setObject:fontSize forKey:@"fontSize"];
                
                
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
                [self.textStyles setObject:fontColor forKey:@"fontColor"];
                
                
                
                // The leading
                NSNumber *leading = [NSNumber numberWithInt:(int)[[style objectForKey:NSParagraphStyleAttributeName] lineSpacing]];
                if (leading != nil)
                {
                    [self.textStyles setObject:leading forKey:@"leading"];
                }
                
                
                
                //The kerning
                NSNumber *kerning = [style objectForKey:NSKernAttributeName];
                if (kerning != nil)
                {
                    [self.textStyles setObject:kerning forKey:@"kerning"];
                }
                
                
                
                
                // Underlined?
                NSNumber *underline = [style objectForKey:NSUnderlineStyleAttributeName];
                NSNumber *singleUnderline = [NSNumber numberWithInt:1];
                if ([underline isEqualToNumber:singleUnderline])
                {
                    [self.textStyles setObject:@"SingleUnderline" forKey:@"underline"];
                }
                
                
                
                // Character numbers
                //NSString *startRange = [NSString stringWithFormat:@"%lu", currentPoint];
                //NSString *endRange = [NSString stringWithFormat:@"%lu", longestEffectiveRange.location + longestEffectiveRange.length -1];
                NSUInteger startRange = currentPoint;
                NSUInteger endRange = longestEffectiveRange.location + longestEffectiveRange.length -1;
                [self.textStyles setObject:[NSNumber numberWithInteger:startRange] forKey:@"startRange"];
                [self.textStyles setObject:[NSNumber numberWithInteger:endRange] forKey:@"endRange"];
                
                
                
                
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
                NSUInteger deletionIndexPoint = 10;
                NSLog(@"Testing it");
                deletionIndexPoint = [whiteSpacesFound indexOfObject: [NSNumber numberWithUnsignedInteger:[tagContent length]+1]]+1;
                NSRange deleteRange = NSMakeRange(deletionIndexPoint, [whiteSpacesFound count] - deletionIndexPoint);
                NSLog(@"The deleteIndexPoint is:%lu", deletionIndexPoint);
                [whiteSpacesFound removeObjectsInRange:deleteRange];
                
                
                
                
                //At the end change the current point for the next loop...
                currentPoint = longestEffectiveRange.location + longestEffectiveRange.length;
                loopCount+=1;
                NSLog(@"Loop Count : %i", loopCount);
                NSString *subStringName = [NSString stringWithFormat:@"%@-substring-%i",ele.elementid,loopCount];
                [self.textStyles setObject:subStringName forKey:@"styleid"];
                newDict = [NSDictionary dictionaryWithDictionary:self.textStyles];
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
            
            numberOfImages=+1;
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
        
        
        
        NSLog(@"about to export");
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
                                        //[self dataSourceBindingCode:ele], DATA_SOURCE_CODE,
                                        [self actionCodeString:ele], ACTION_CODE,
                                        [self dataSourceNameContainingKey:ele], ASSOCIATED_MODEL,
                                        ele.dataSourceStringEntered, DATA_SOURCE_STRING_ENTERED,
                                        ele.visibilityActionStringEntered, VISIBILITY_CODE,
                                        ele.URLString, URLSTRING,
                                        //[[ele valueForKeyPath:@"opacity"] valueForKey:@"body"], @"opacity",
                                        //Also get the NSColor as a hex value
                                        nil];
        NSLog(@"export DONE");
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
            [export setObject:[NSNumber numberWithInt:paddingLeft] forKey:@"paddingLeft"];
            
            /*
            if (ele.width_as_percentage)
            {
                paddingLeft = (paddingLeft/ele.frame.size.width)*100; //flexible padding
                [export setObject:[NSNumber numberWithInt:paddingLeft] forKey:@"flexiblePaddingLeft"];
                
            }
             */
            
            
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
        
        if (hasLeadingNumberInString(ele.elementid)) //if the id starts with a number
        {
            [export setObject:[NSString stringWithFormat:@"element%@", ele.elementid] forKey:JS_ID];
        }
        else
        {
            [export setObject:ele.elementid forKey:JS_ID];
        }
        
        if ([ele isMemberOfClass:[DynamicRow class]] && [ele topMarginForRow] != nil)
        {
            [export setObject:ele.topMarginForRow forKey:TOP_MARGIN_FOR_ROW];
        }
        
        if ([ele extracss] != nil)
        {
            [export setObject:ele.extracss.string forKey:CSS_CODE];
        }
        
        [arrayOfElementDetails addObject:export];
        NSLog(@"Exporting: %@", export);
        
    }
    
    
    
    /************ ************ ************ ************ ************ ************ ************ ************ ************ ************ ************/
    
    
    
    
    

    
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
    self.solos = [NSMutableArray array];
    NSLog(@"GOT : %lu items", [initalSorting count]);
    
    
    msg = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Sorting elements"] forKey:@"string"];
    [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CONVERSION_PROGRESS_SCREEN object:self userInfo:msg];
    
    
    // GET SOLOS
    NSMutableArray *initialSortingWithoutContainer = [NSMutableArray arrayWithArray:initalSorting];
    NSMutableArray *removeTheseContainerObjects = [NSMutableArray new];
    for (NSDictionary *element in initalSorting) {
        if ([[element objectForKey:@"tag"] isEqualTo:CONTAINER_TAG])
        {
            [removeTheseContainerObjects addObject:element];
        }
    }
    [initialSortingWithoutContainer removeObjectsInArray:removeTheseContainerObjects];
    
    self.solos = [self arrayOfSoloItems:[initalSorting sortedArrayUsingDescriptors:verticalSortDescriptor2]];
    
    NSLog(@"Solo has : %lu items", [self.solos count]); //THESE ARE OBJECTS WITH NOTHING TO THE LEFT OF THEM. CORRECT. - 03/11/2012
    self.sortedArray = [NSMutableArray array];
    self.idsInsideDyRow = [NSMutableArray array];
    self.rows = [NSMutableArray array];
    for (NSDictionary *g in self.solos)
    {
        if (![[g objectForKey:@"tag"] isEqual:CONTAINER_TAG])
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
            [self.sortedArray addObject:g]; //   Add myself
            
            while ([elementsNotCountedYet count] != 0)
            {
                NSDictionary *next = [self highestElementWithEmptyLeft:toMyRight];//THIS EVENTUALLY WILL HAVE TO CHANGE TO BE HIGHESTELE IN GROUP.*
                NSLog(@"calling next on : %@", [next objectForKey:@"id"]);
                NSDictionary *previous = [self.sortedArray lastObject];
                
                
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
                if ([self.sortedArray containsObject:next] == NO) // As if might not hit the big if statement above and so next object may already exist in the SortedArray dataset.
                {
                    [self.sortedArray addObject:next];
                    NSLog(@"Just added : %@", [next objectForKey:@"id"]);
                }
                [toMyRight removeObject:next];
                elementsNotCountedYet = toMyRight;
            }
            NSLog(@"SORTED ARRAY AT 0 : %@", self.sortedArray);
            NSMutableArray *filteredSortedArray = [NSMutableArray arrayWithArray: self.sortedArray]; // WHICH WE'LL NOW FILTER TO ONLY INCLUDE THOSE TO MY RIGHT
            // **&*() AT THIS POINT,  CONVERT THE DIVS IN FILTEREDSORTEDARRAY WITH OVERLAPS TO GROUPINGBOXES ***&*() //
            for (NSDictionary *dict in self.sortedArray)
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
            //if (![[g objectForKey:@"tag"] isEqual: DYNAMIC_ROW_TAG])
            //{
                NSMutableArray *eachRow = [NSMutableArray arrayWithObject:g];
                [eachRow addObjectsFromArray:filteredSortedArray];
                [self.rows addObject:eachRow];
            //}
            
        }
        else
        {
            [self.sortedArray addObject:g];
        }
        
        
    } // END OF SOLO LOOP
    
    /// SUMMARY OF WHAT HAPPENED :
    NSLog(@"HERE WE GO:.... %lu ROWS!", self.rows.count);
    for (NSDictionary *d in self.rows)
    {
        NSLog(@"This row contains: %@", d);
    }
    
    NSLog(@"UPDATE GB : %lu", groupingBoxes.count);
    
    
    msg = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Checking for overlapping elements"] forKey:@"string"];
    [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CONVERSION_PROGRESS_SCREEN object:self userInfo:msg];
    
    
    ///  Let's account for objects that are neither solo's nor in the right range or solos
    NSMutableArray *elementsCounted = [NSMutableArray array];
    NSMutableArray *elementsToAdd = [NSMutableArray array];
    for (NSMutableDictionary *elem in self.sortedArray)
    {
        
        float x = [[elem objectForKey:@"xcoordinate"] floatValue];
        float w = [[elem objectForKey:@"width"] floatValue];
        NSNumber *combinedWidth = [NSNumber numberWithFloat:x+w];
        //[elem setValue:combinedHeight forKey:ycoordinate];
        [elem setValue:combinedWidth forKey:@"farRight"];
        
        if ([elementsCounted containsObject:elem] == NO) // Not counted
        {
            
            NSLog(@"DOES THIS SCENARIO EVER GET CALLED?");
            NSUInteger priorElementsIndex = [self.sortedArray indexOfObject:elem];
            
            NSMutableArray *elemsToMyRight = [NSMutableArray arrayWithArray:[self elementsToMyRight:elem]];
            for (NSDictionary *newRightie in elemsToMyRight)
            {
                if ([self.sortedArray containsObject: newRightie] == NO)
                {
                    [elementsToAdd addObject:newRightie];
                }
            }
            while ([elementsToAdd count] != 0)
            {
                
                NSDictionary *next = [self highestElementWithEmptyLeft:elemsToMyRight];
                
                if ([self.sortedArray containsObject:next] == NO) // add it to the sorted array at the right point.
                {
                    
                    //if it's the last entry then becareful not to raise an NSRangeException
                    if ( ([self.sortedArray count] - 1) == (priorElementsIndex) )
                    {
                        [self.sortedArray addObject:next];
                    }
                    else
                    {
                        [self.sortedArray insertObject:next atIndex:priorElementsIndex+1];
                    }
                    
                }
                priorElementsIndex = [self.sortedArray indexOfObject:next];
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
        for (NSMutableDictionary *elementToCheck in [self.sortedArray copy]) // Use a copy of the array so I can mutate it whilst enumerating it
        {
            CGRect rect2 = CGRectMake(
                                      [[elementToCheck objectForKey:xcoordinate] floatValue],
                                      [[elementToCheck objectForKey:ycoordinate]floatValue],
                                      [[elementToCheck objectForKey:@"width"]floatValue],
                                      [[elementToCheck objectForKey:@"height"]floatValue]);
            
            NSLog(@"Rect 1 (tag = %@) : %@", [elem objectForKey:@"tag"], NSStringFromRect(rect1));
            NSLog(@"Rect 2 (tag = %@) : %@", [elementToCheck objectForKey:@"tag"], NSStringFromRect(rect2));
            
            
            
            BOOL condition1 = [elem isEqualToDictionary:elementToCheck] == NO;
            
            BOOL condition2 = ([[elem objectForKey:@"tag"] isEqualToString:@"div"]) || ([[elem objectForKey:@"tag"] isEqualToString:DYNAMIC_ROW_TAG])  || ([[elem objectForKey:@"tag"] isEqualToString:CONTAINER_TAG]);
            
            BOOL condition3 = [[elementToCheck objectForKey:@"tag"] isEqualToString:PARAGRAPH_TAG] || [[elementToCheck objectForKey:@"tag"] isEqualToString:@"image"] || [[elementToCheck objectForKey:@"tag"] isEqualToString:DYNAMIC_IMAGE_TAG] || [[elementToCheck objectForKey:@"tag"] isEqualToString:DROP_DOWN_MENU_TAG] || [[elementToCheck objectForKey:@"tag"] isEqualToString:TEXT_INPUT_FIELD_TAG] || [[elementToCheck objectForKey:@"tag"] isEqualToString:TEXT_BOX_TAG] || [[elementToCheck objectForKey:@"tag"] isEqualToString:BUTTON_TAG] || [[elementToCheck objectForKey:@"tag"] isEqualToString:@"div"];
            
            BOOL condition4 = CGRectContainsRect(rect1, rect2);
            
            NSLog(@"Conditions: %d, %d, %d, %d", condition1, condition2, condition3, condition4);
            
            
            if ( condition1 && condition2 && condition3 && condition4 )
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
                NSLog(@"%@ contains: %@", [elem objectForKey:@"id"], [elementToCheck objectForKey:@"id"]);
                // check if this element has a dictionary under PARENT_ID, if so then add a key, if not then create the dictionary
                
                if ( [elementToCheck objectForKey:PARENT_ID] != nil)
                {
                    // the parentID dictionary already exists inside of this element
                    // ASSUMPTION: AN ELEMENT CAN ONLY OVERLAP A BOX, DYROW, OR CONTAINER ONCE
                    NSLog(@"Crashed 1");
                    NSLog(@"Object: %@", [elem objectForKey:@"id"]);
                    NSLog(@"Key: %@", [elem objectForKey:@"tag"]);
                    [[elementToCheck objectForKey:PARENT_ID] setObject:[elem objectForKey:@"id"] forKey:[elem objectForKey:@"tag"]];
                    NSLog(@"Crashed 2");
                }
                else
                {
                    // the parentID dictionary for this element does not currently exist
                    NSMutableDictionary *parentIDDictionary = [NSMutableDictionary dictionaryWithObject:[elem objectForKey:@"id"] forKey:[elem objectForKey:@"tag"]];
                    NSLog(@"Crashed 3");
                    [elementToCheck setObject:parentIDDictionary forKey:@"parentID"];
                    NSLog(@"Crashed 4");
                }
                
                // if it's in a dyRow then give it a tag so we know to convert elementid to class
                
                
                //[elementToCheck setObject:[elem objectForKey:@"id"] forKey:@"parentID"];
                [elementsToGoInGroupingBox addObject:elementToCheck];
                [elem setObject:[NSNumber numberWithBool:YES] forKey:@"convertToGroupingbox"];
                NSLog(@"Crashed 5");
                
                if ([[elem objectForKey:@"tag"] isEqual:CONTAINER_TAG])
                {
                    NSLog(@"NO CONVERSION!");
                    [elem removeObjectForKey:@"convertToGroupingbox"];
                    [elementsToGoInGroupingBox removeObject:elementToCheck]; // CONTAINER ELEMENTS SHOULD NOT BE PUT INTO A GROUPING BOX.
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
            [self updateNestedGroupingBoxesVariable];
            [groupingBoxes addObject:convertedGroupingBox];
            NSLog(@"idprevknownas : %@", convertedGroupingBox.idPreviouslyKnownAs);
            NSLog(@"About to add: %@", convertedGroupingBox);
            
        }
        
        
        
        // record the elements that are inside the dyRow
        if ([[elem objectForKey:@"tag"] isEqualToString:DYNAMIC_ROW_TAG])
        {
            NSArray *elementsInsideRow = [self elementsInside:elem usingElements:self.sortedArray];
            NSLog(@"ELEMENTS INSIDE ROW : %@", elementsInsideRow);
            for (NSDictionary*ele in elementsInsideRow)
            {
                [self.idsInsideDyRow addObject:[ele objectForKey:JS_ID]];
            }
        
        }
        
    } //FINISHED OF SOLO LOOP
    NSLog(@"SELF.IDS INSIDE DYROW = %@", self.idsInsideDyRow);
    
    
    
    /// SUMMARY OF WHAT HAPPENED :
    NSLog(@"GroupingBoxes Count is : %lu", [groupingBoxes count]);
    if ([self.sortedArray count] != [leftToRightTopToBottom count])
    {
        NSLog(@"ERROR -- ERROR -- ERROR -- ERROR");
    }
    NSLog(@"SORTED ARRAY AT POINT 2 : %@", self.sortedArray);
    for (GroupingBox *g in groupingBoxes)
    {
        NSLog(@"CONTENTS OF GROUPINGBOX IS : %@", g.insideTheBox);
    }
    
#pragma sorting finished.
    
    
    /// SET THE BOUNDS RECT FOR EACH GROUPINGBOX
    [self setGroupingBoxesBoundsRect];
}


-(void)generateAttr
{
    if (self.pageTitle == nil)
        [self.pageTitle stringByAppendingString: @"You ought to change the title!"];
    
    NSLog(@"page title is : %@", self.pageTitle);
    
    NSSortDescriptor *vertically = [[NSSortDescriptor alloc] initWithKey:ycoordinate ascending:NO];
    NSSortDescriptor *horizontally = [[NSSortDescriptor alloc] initWithKey:xcoordinate ascending:YES];
    NSSortDescriptor *horizontallyFar = [[NSSortDescriptor alloc] initWithKey:FAR_RIGHT_X ascending:YES];
    
    NSArray *horizontalSortDescriptor = [NSArray arrayWithObject: horizontally];
    NSArray *horizontalFarSortDescriptor = [NSArray arrayWithObject: horizontallyFar];
    NSArray *verticalSortDescriptor = [NSArray arrayWithObject: vertically];
    
    
    /// CALCLULATE TOP (AND BOTTOM MARGINS WHEN NEEDED) FOR EACH OBJECT ON THE PAGE
    
    
     NSDictionary*msg = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Calculating the margins and paddings"] forKey:@"string"];
    [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CONVERSION_PROGRESS_SCREEN object:self userInfo:msg];
    
    NSLog(@"STAGE1");
    NSMutableDictionary *shapeAboveMe = [NSMutableDictionary dictionary];
    NSMutableArray *lefties = [NSMutableArray array];
    NSMutableArray *righties = [NSMutableArray array];
    float lastY;
    int marginTop;
    
    
    NSUInteger indexCount = 0;
    for (NSMutableDictionary *dc in self.sortedArray) //  Was LeftToRightTopToBottom
    {
        NSLog(@"I am : %@", [dc objectForKey:ID_KEYWORD]);
        NSLog(@"Index =%lu and count=%lu", indexCount+1, [self.sortedArray count]); //  Was LeftToRightTopToBottom
        NSUInteger myXlength = [[dc valueForKey:@"width"] unsignedIntegerValue];
        NSUInteger myYlength = [[dc valueForKey:@"height"] unsignedIntegerValue];
        NSUInteger myXCoordinate = [[dc valueForKey:xcoordinate] unsignedIntegerValue];
        NSUInteger myYCoordinate = [[dc valueForKey:ycoordinate] unsignedIntegerValue];
        NSRange myXranges = NSMakeRange(myXCoordinate, myXlength);
        NSRange myYranges = NSMakeRange(myYCoordinate, myYlength);
        NSRect dRect = NSMakeRect(myXCoordinate,myYCoordinate,myXlength,myYlength);
        
        NSMutableDictionary *nextOne = nil;
        float nextX;
        if (indexCount+1 < [self.sortedArray count])
        {
            nextOne = [self.sortedArray objectAtIndex:indexCount+1];     //  Was LeftToRightTopToBottom
            nextX = [[nextOne valueForKey:@"xcoordinate"] floatValue];
        }
        
        
        NSMutableDictionary *lastOne = [NSMutableDictionary dictionary];
        float lastX;
        float lastW;
        if (indexCount != 0)
        {
            lastOne = [self.sortedArray objectAtIndex:indexCount-1];
            lastX = [[lastOne valueForKey:@"xcoordinate"] floatValue];
            lastW = [[lastOne valueForKey:@"width"] floatValue];
        }
        
        //nextY and lastY are special cases, see below
        
        
        //Last Y
        [dc setObject:[NSMutableArray array] forKey:@"elementsAboveMe"];
        NSMutableArray *elementsAboveMe = [dc objectForKey:@"elementsAboveMe"];
        NSMutableArray *elementsBelowMe = [NSMutableArray array];
        
        for (NSMutableDictionary *item in self.sortedArray)
        {
            NSLog(@"ITEM = %@", [item valueForKey:ID_KEYWORD]);
            NSLog(@"DC = %f", [[dc valueForKey:bottomYcoordinate] floatValue]);
            
            if ( [[item valueForKey:bottomYcoordinate] floatValue] < [[dc valueForKey:bottomYcoordinate] floatValue] && ![[item objectForKey:@"tag"] isEqual:CONTAINER_TAG]) //   if it's Y coordinate is above me (and in my northern range, see below)
            {
                
                //  Check if its in my Northern Range
                NSUInteger compareToXCoordinate = [[item valueForKey:xcoordinate] unsignedIntegerValue];
                NSUInteger compareToXlength = [[item valueForKey:@"width"] unsignedIntegerValue];
                NSRange compareToXranges = NSMakeRange(compareToXCoordinate, compareToXlength);
                
                NSRange comparison = NSIntersectionRange(myXranges, compareToXranges);
                
                
                if (comparison.length!=0)
                {
                    //  So the two X coordinate ranges do have an overlap - they share x coordinates
                    [elementsAboveMe addObject:item];
                    NSLog(@"Found an element above me");
                    
                }
            }
            
            if ( [[item valueForKey:bottomYcoordinate] floatValue] > [[dc valueForKey:bottomYcoordinate] floatValue] && ![[item objectForKey:@"tag"] isEqual:CONTAINER_TAG]) //if it's Y coordinate is below mine
            {
                
                NSUInteger compareToXCoordinate = [[item valueForKey:xcoordinate] unsignedIntegerValue];
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
        
        if ( ([elementsAboveMe count] > 0) && ([verticallyAboveMeSortedArray count] > 0) )
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
                    if (([self.sortedArray indexOfObject:otherDictionaryInGroup] < [self.sortedArray indexOfObject:dc])
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
                int a = [[dc objectForKey:ycoordinate]intValue];
                int b = [[self highestYcoordinateInMyRow:[[self.rows objectAtIndex:myRowId] objectAtIndex:0] ]intValue];
                marginTop = a - b;
                
                /** WRITE CODE FOR THIS: BUT IF IT'S IN A GROUPING BOX, MARGINTOP IS EQUAL TO DISTANCE FROM ME TO GROUPINGBOX YCOORDINATE **/
                GroupingBox *gb = [self whichGroupingBoxIsElementIn:dc];
                if (gb!= nil)
                {
                    NSLog(@"In here for : %@", [dc objectForKey:ID_KEYWORD]);
                    marginTop = [[dc objectForKey:ycoordinate]intValue] - [[gb valueForKey:ycoordinate] intValue];
                }
                NSLog(@"Object I'm using to measure against: %@", [[[self.rows objectAtIndex:myRowId] objectAtIndex:0] objectForKey:@"id"]);
                NSLog(@"Returning: %i", marginTop);
                NSLog(@"Distance to my margin: %i with id: %@", marginTop, [dc objectForKey:@"id"]);
            }
            
            //question - could two objects be in different grouping boxes but the same row? If so the above code may not work.
            
        }
        else    //  There's nothing above me
        {
            //  **      Set the margin of the element, which may be readjusted LATER DOWN THE METHOD if it's inside a groupingBox    **
            if ([[dc objectForKey:@"tag"] isEqual:CONTAINER_TAG])
            {
                marginTop = [[self distanceFromContainerToElementDirectlyAboveIt:dc usingElements:self.sortedArray] intValue];
                NSLog(@"In special case: %d", marginTop);
            }
            else
            {
                NSNumber *highestYPoint = [self highestYcoordinateInMyRow:dc]; // this is the rows y coordinate
                if (highestYPoint == [dc objectForKey:ycoordinate])
                {
                    //if it's the highest object in the row then set it to 0.
                    highestYPoint = [NSNumber numberWithInt:0];
                }
                NSNumber *myHighestYPoint = [dc valueForKey:@"ycoordinate"];
                NSLog(@"HEIGHT IS %@ - %@", myHighestYPoint, highestYPoint);
                marginTop =  [myHighestYPoint intValue] - [highestYPoint intValue];
            }
            
            
            
            
        }
        NSLog(@"About to set id: %@ with marginTop:%i", [dc valueForKey:@"id"], marginTop);
        if ([dc objectForKey:PARENT_ID] != nil)
        {
            NSLog(@"Better  : %i", [self marginToObjectWithinTransformedGroupingBox:dc onSide:TOP]);
        }
        
        [dc setValue:[NSNumber numberWithInt:marginTop] forKey:@"marginTop"];
        NSLog(@"dc has margintop of : %@", [dc objectForKey:@"marginTop"]);
        
        // **** @@ END OF QUESTION TO DELETE THE ABOVE ******** //
        
        
        
        
        NSLog(@"SORTED ARRAY NOVEMBER 1 : %@", self.sortedArray);
        
        
        
        // ********************************* //
        
        
        NSDictionary*msg = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Calculating the left and right margins"] forKey:@"string"];
        //[[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CONVERSION_PROGRESS_SCREEN object:self userInfo:msg];
        
        //  3. Find out whether there are objects to my left or right AND if they're in my range
        BOOL objectToMyLeft;
        BOOL objectToMyRight;
        
        righties = [NSMutableArray array];
        for (NSMutableDictionary *objectToTheRight in self.sortedArray) //  Was LeftToRightTopToBottom
        {
            if ([objectToTheRight isEqualToDictionary:dc] == NO && [objectToTheRight objectForKey:@"tag"] != [Container class]) // If it's not me, nor a container
            {
                
                //  If the object is to the right of me
                if ([[objectToTheRight valueForKey:@"xcoordinate"] floatValue] > ( [[dc valueForKey:@"xcoordinate"] floatValue] +[[dc valueForKey:@"width"] floatValue]) )
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
        for (NSMutableDictionary *objectToTheLeft in self.sortedArray) //check this... //  Was LeftToRightTopToBottom
        {
            
            if ([objectToTheLeft isEqualToDictionary:dc] == NO && ![[objectToTheLeft objectForKey:@"tag"] isEqual: CONTAINER_TAG])
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
                        NSLog(@"elenetid. To the left of %@ is: %@", [dc valueForKey:ID_KEYWORD], [objectToTheLeft valueForKey:ID_KEYWORD] );
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
                
                //int marginRight2 = [self isThereAGroupBoxInPath:dcRect marginType:@"y" comparatorRect:closestRect];
                int marginRight2 = nil;
                
                if (marginRight2)
                {
                    NSLog(@"Using MARGINRIGHT2 : %d", marginRight2);
                    [dc setValue:[NSNumber numberWithInt:marginRight2] forKey:@"marginRight"];
                }
                else
                {
                    NSLog(@"Using MARGINRIGHT : %d", marginRight);
                    [dc setValue:[NSNumber numberWithInt:marginRight] forKey:@"marginRight"];
                    NSLog(@"just set %@ with marginRIGHT of %@", [dc objectForKey:ID_KEYWORD], [NSNumber numberWithInt:marginLeft]);
                }
                
                
            }
            
        }
        
        if (objectToMyLeft == YES)
        {
            //NSArray *horizontalSortDescriptor = [NSArray arrayWithObject: horizontally];
            NSArray *horizontallySortedArray = [lefties sortedArrayUsingDescriptors:horizontalFarSortDescriptor];
            //NSDictionary *shapeToMyImmediateLeft = [verticallyAboveMeSortedArray lastObject]; //    If there are multiple objects above me, get the one lowest on the y coordinate axis
            
            //  Find the closest item in my leftRange
            NSDictionary *closest = [horizontallySortedArray lastObject];   //THIS IS THE CLOSEST OBJECT TO MY LEFT THAT IS IN MY RANGE
            NSLog(@"Closest object to me is id %@ and my width is: %d", [closest valueForKey:ID_KEYWORD], [[dc valueForKey:@"width"] intValue]);
            
            for (NSDictionary *l in lefties)
            {
                NSLog(@"Lefties are: %@", [l objectForKey:@"xcoordinate"]);
            }
            //  LEFT MARGIN LOGIC: Get its marginRight, if I'm offset by more or less than that amount the give me a marginLeft. *** THIS IS ONLY THE CASE IN A GROUPING BOX ***
            for (NSDictionary *check in self.sortedArray)
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
                            NSLog(@"just set %@ with marginleft of %@", [dc objectForKey:ID_KEYWORD], [NSNumber numberWithInt:marginLeft]);
                            //}
                            
                        }
                    }
                    
                    NSLog(@"%@ parent is: %@", [dc objectForKey:PARENT_ID], [[dc objectForKey:PARENT_ID] objectForKey:DIV_TAG]);
                    
                    NSLog(@"closest is: %@", [closest objectForKey:ID_KEYWORD]);
                    
                    if ([[[dc objectForKey:PARENT_ID] objectForKey:DIV_TAG] isEqualTo:[closest objectForKey:ID_KEYWORD]])
                    {
                        float marginInsideGB = [[dc objectForKey:xcoordinate] floatValue] - [[closest objectForKey:xcoordinate] floatValue];
                        [dc setValue:[NSNumber numberWithInt:marginInsideGB] forKey:@"marginLeft"];
                        NSLog(@"trying it.");
                    }
                    
                }
            }
            
            
            
        }
        
        if ( (objectToMyLeft == NO) & ([self.solos containsObject:dc] == YES) )
        {
# pragma mark -  CONTAINER CODE ADDED.
            
            NSLog(@"IN THIS");
            NSDictionary *myContainer = [self containerContaining:dc usingElements:self.sortedArray];
            NSLog(@"dc = %@ and myContainer = %@", [dc objectForKey:xcoordinate], [myContainer objectForKey:xcoordinate]);
            if (myContainer == nil)
            {
                //This is for solo objects with nothing to the left of it that isn't number one object on the page
                marginLeft = [[dc valueForKey:@"xcoordinate"] intValue];
                NSLog(@"MARGIN LEFT SET ???");
            }
            
            else
            {
                marginLeft = [[dc objectForKey:xcoordinate]intValue] - [[myContainer objectForKey:xcoordinate]intValue];
            }
            
            
            [dc setValue:[NSNumber numberWithInt:marginLeft] forKey:@"marginLeft"];
        }
        
        
        
        
        
        //NSLog(@"SORTED ARRAY NOVEMBER 2 : %@", self.sortedArray);
        
        /*
         Make adjustments to marginTops for elements that need to float as their tops need to calc against the lowest in  the minirow above it.
         
         1. Get all elements above me, in my groupingBox, not in my left range (or in the leftrange of them) and before me in sortedArray (mini-row above, as HTML will naturally float me next to those in my mini row, so I must set my margin based the bottom of the mini-row above.)
         
         2. Get the lowest of those elements and set my margin against that element.
         
         // * New approach is to base margin off of the highest element in my row and then apply a margin to my row. * //
         */
        
        
        GroupingBox *boxImIn = [self whichGroupingBoxIsElementIn:dc];
        NSMutableArray *newMarginContenders = [NSMutableArray array];
        NSUInteger myIndexInSortedArray = [self.sortedArray indexOfObject:dc];
        for (NSDictionary * d in boxImIn.insideTheBox)
        {
            
            NSUInteger loopsIndexInSortedArray = [self.sortedArray indexOfObject:d];
            
            
            if ([[d valueForKey:bottomYcoordinate]intValue] > [[dc valueForKey:bottomYcoordinate]intValue] & [lefties containsObject:d] == NO & loopsIndexInSortedArray < myIndexInSortedArray)
            {
                [newMarginContenders addObject:d];
                
                // and if elements width for the object behind me in the sorted arrays width + my width, plus margins is not equal to or gthan groupingbox xco then flag as 'no float'
                NSUInteger myIndex = [self.sortedArray indexOfObject:dc];
                NSDictionary *objectBeforeMe = [self.sortedArray objectAtIndex:myIndex-1];
                
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
    
    
    
    NSLog(@"SORTED ARRAY NOVEMBER 3 : %@", self.sortedArray);
    
    [self setMarginsForElementInGroupingBox];
    
    NSLog(@"SORTED ARRAY NOVEMBER 10 : %@", self.sortedArray);
    
    
    
    NSMutableArray *firstAndLastRowsInContainer = [NSMutableArray array];
    for (NSMutableDictionary *each in [self.sortedArray reverseObjectEnumerator])
    {
        // Calclulate its bottom margin if it's the last item in the sorted Array
        if ([each valueForKeyPath:@"parentID.div"] == nil)
        {
            NSNumber *marginBottom = [NSNumber numberWithInt:(int)self.bounds.size.height - [[each objectForKey:bottomYcoordinate]intValue]];
            NSLog(@"marginBottom is : %@ for object with id: %@", marginBottom, [each objectForKey:@"id"]);
            //[each setObject:marginBottom forKey:@"marginBottom"];
            //break;
        }
        
        // Calculate the contents of Container - ASSUMPTION: ROWS ARE CLEAN INSIDE A CONTAINER (IF ONE EXISTS)
        if ([[each objectForKey:@"tag"] isEqualToString:CONTAINER_TAG])
        {
            NSLog(@"inside firstAndLastRowsInContainer");
            NSArray *elementsInsideMe = [self elementsInside:each usingElements:self.sortedArray];
            NSLog(@"elementsInsideMe : %@", elementsInsideMe);
            NSMutableArray *idArray = [NSMutableArray array];
            for (NSDictionary *element in elementsInsideMe)
            {
                [idArray addObject:[element objectForKey:@"id"]];
            }
            
            NSLog(@"idArray : %@", idArray);
            NSMutableOrderedSet *rowsInThisContainer = [NSMutableOrderedSet new];
            
            
            [self.rows enumerateObjectsUsingBlock:^(id row, NSUInteger index, BOOL *stop)
             {
                 for (NSDictionary *ele in row)
                 {
                     if ([idArray containsObject:[ele objectForKey:@"id"]])
                     {
                         //if this row contains an elementID from idArray then add this row to my list of contents
                         [rowsInThisContainer addObject:[NSNumber numberWithInteger:index]];
                         NSLog(@"Matching element found at index: %li", (unsigned long)index);
                         //*stop = YES;
                     }
                 }
             } ];
            NSNumber *min = [rowsInThisContainer valueForKeyPath:@"@min.intValue"];
            NSNumber *max = [rowsInThisContainer valueForKeyPath:@"@max.intValue"];
            [firstAndLastRowsInContainer addObject: [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [each objectForKey:@"id"], CONTAINER_ID,
                                                     min, FIRST,
                                                     max, LAST,
                                                     nil]];
            NSLog(@"rowsInThisContainer = %@", rowsInThisContainer);
            NSLog(@"PRINTING firstAndLastRowsInContainer : %@", firstAndLastRowsInContainer);
            
        }
        
        
        
        
    }
    
    
    
    
        
    msg = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Setting up a location to write files to..."] forKey:@"string"];
    [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CONVERSION_PROGRESS_SCREEN object:self userInfo:msg];
    
    
    NSError *errorMsg;
    self.outputFolderPath = NSHomeDirectory();
    
    self.outputFolderPath =[self.outputFolderPath stringByAppendingPathComponent:@"Documents"];
    self.outputFolderPath = [self.outputFolderPath stringByAppendingPathComponent:@"code"];
    NSString *pathToCSS = [[NSBundle mainBundle] pathForResource:@"bootstrap" ofType:@"css"];
    NSURL *urlToCSS = [[NSBundle mainBundle] URLForResource:@"bootstrap" withExtension:@"css"];
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL exists = [fm fileExistsAtPath:self.outputFolderPath isDirectory:&isDir];
    if (exists)
    {
        NSLog(@"It does exist");
        
    }
    else
    {
        NSLog(@"Does not exist");
        [fm createDirectoryAtPath:self.outputFolderPath withIntermediateDirectories:YES attributes:nil error:&errorMsg];
        
        
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
            NSString *cssFullPath = [NSString stringWithString:self.outputFolderPath];
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
    
    self.outputFolderPath = [self.outputFolderPath stringByAppendingPathComponent:pageTitle];
    self.outputFolderPath = [self.outputFolderPath stringByAppendingPathExtension:@"html"];
    
    NSLog(@"Path thus far : %@", self.outputFolderPath);
    
    
    self.directoryURLToPlaceFiles = [NSURL fileURLWithPath:self.outputFolderPath isDirectory:NO];
    
    
    
    
    
    if (self.directoryURLToPlaceFiles == nil)
    {
        NSLog(@"COULD NOT GET DIRECTORY URL. Error");
    }
    else
    {
        NSLog(@"DirectoryURL is: %@", self.directoryURLToPlaceFiles);
    }
    
    
    NSString *documentsDirectory = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        documentsDirectory = [paths objectAtIndex:0];
    }
    
    for (NSMutableDictionary *d in self.sortedArray)
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
    
    NSLog(@"SORTED ARRAY CONTAINS: %@", self.sortedArray);
    self.finalGrouping = [NSMutableArray array];
    
    
    
    
    
    
    /***    CALCLUATE MARGINTOPS FOR ROWS    ***/
    NSLog(@"SELF.ROWS = %@", self.rows);
    for (NSArray *row in self.rows)
    {
        NSLog(@"In the loop with row : %@.", row);
        // get the highest item (top left) inside that row
        NSDictionary *highestElementInRow = [self highestElementInMyRow:[row objectAtIndex:0]];
        NSUInteger rowNumber = [self elementRow:highestElementInRow];
        // Alternatively: NSUInteger rowNumber = [self.rows indexOfObject:row];
        NSLog(@"RowNumber is : %lu", rowNumber);
        
        // calculate the distance to the lowest item in the row above, or to the top of the page if this is row 0
        int calculatedMarginTop;
        if (rowNumber != 0)
        {
            int largestYcoordinateInRowAbove = [self largestYcoordinateInMyRow:[[self.rows objectAtIndex:rowNumber-1]objectAtIndex:0]];
            NSLog(@"Lowest coordinate in the row above me is : %d", largestYcoordinateInRowAbove);
            NSLog(@"Highest element in row : %@", highestElementInRow);
            calculatedMarginTop = [[highestElementInRow valueForKey:ycoordinate]intValue] - largestYcoordinateInRowAbove;
            NSLog(@"CALCULATED MARGINTOP IS : %d", calculatedMarginTop);
        }
        else
        {
# pragma mark -  CONTAINER CODE IS!! NEEDED.
            // THIS IS THE FIRST ROW IN THE ARRAY
            // CHECK IF THIS ROW IS IN A CONTAINER
            NSDictionary *rowsContainer = [self containerContaining:highestElementInRow usingElements:self.sortedArray];
            if ( rowsContainer != nil)
            {
                NSLog(@"LOGGING the first row");
                NSLog(@"CONTAINER DICTIONARY IS : %@", rowsContainer);
                calculatedMarginTop = [[rowsContainer objectForKey:ycoordinate] intValue];
                // IF FIRST ENTRY THEN MEASURE AGAINST THE CONTAINERS Y COORDINATE
            }
            else
            {
                // if it's not in a container then the rows marginTop should be measured against the top of the document.
                calculatedMarginTop = [[highestElementInRow valueForKey:ycoordinate]intValue];
            }
            
            
            
            //calculatedMarginTop = highestPoint - [[highestElementInRow valueForKey:ycoordinate]intValue];
            //calculatedMarginTop = [[highestElementInRow valueForKey:ycoordinate]intValue];
            NSLog(@"CALCULATED MARGINTOP IS (2) : %d", calculatedMarginTop);
            
            // todo: Get the distance from the top of this row to the top of its container (if it has one), that is the margin
            
        }
        
        NSLog(@"Row number is : %lu. MarginTop is : %i", rowNumber, calculatedMarginTop);
        [self.rowMargins insertObject:[NSNumber numberWithInt:calculatedMarginTop] atIndex:rowNumber];
        NSLog(@"Just inserted %@ as the rowMarginTop for row : %lu",[NSNumber numberWithInt:calculatedMarginTop], rowNumber);
        
    }
    
    
    
    
    
    
    
    
    
    
    
    /***    CALCULATE MARGINTOPS FOR ELEMENTS NOT IN GROUPINGBOX..., BUT ALSO CONVERT MARGIN TO %    ***/
    
    for (NSMutableDictionary *dc in self.sortedArray)
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
        NSNumber *hiy = [self highestYcoordinateInMyRow:dc];
        if (hiy == nil) {
            hiy = [NSNumber numberWithInt:0];
        }
        NSLog(@"HIY is %@", hiy);
        int highestItemsYco = [[self highestYcoordinateInMyRow:dc] intValue];
        NSLog(@"highestItemsYco : %d", highestItemsYco);
        
        
        // Assuming neither are minus, use the lowest of the two
        NSLog(@"MIN IS : %i", MIN([distanceToNearestElementAboveMeInThisRow intValue], highestItemsYco));
        
        if ((insideGroupingBoxFlag == NO) & (distanceToNearestElementAboveMeInThisRow == nil) ) //this is not in a groupingbox nor does it have anything in its y range in this row.
        {
            int marginTopTop = [[dc valueForKey:@"ycoordinate"] intValue] - highestItemsYco;
            [dc setValue:[NSNumber numberWithInt:marginTopTop] forKey:@"marginTop"];
            NSLog(@"I JUST SET MARGINTOP TO: %i", marginTopTop);
        }
        
        
        ///////////////
        // if the highest point in my row is equal to my height then I'm the tallest in the row and thus no margnTop is needed
        
        if ([dc objectForKey:ycoordinate] == hiy)
        {
            NSLog(@"So the highest element in the GroupingBox is the highest element in the row. 0. \n");
            [dc setObject:[NSNumber numberWithInt:0] forKey:@"marginTop"];
            NSLog(@"Set marginTop to zero for highest element in row. ");
            
        }
        
    }
    
    
    
    
    
    NSLog(@"Any goodnesss? : %@", self.sortedArray);
    
    
    
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
            for (NSDictionary *elements in self.sortedArray)
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
                                         [NSNumber numberWithInt:g.marginTop], @"GroupBoxMarginTop",
                                         [NSNumber numberWithInt:g.marginRight], @"GroupBoxMarginRight",
                                         [NSString stringWithString:[[[g insideTheBox] objectAtIndex:0] valueForKey:@"id"]], @"firstObject",
                                         [NSString stringWithString:[[[g insideTheBox] lastObject] valueForKey:@"id"]], @"lastObject",
                                         [NSNumber numberWithFloat:(g.rtFrame.size.width)], @"width",
                                         [NSNumber numberWithInt:ceilf(g.rtFrame.size.height)], @"height",
                                         g.idPreviouslyKnownAs, @"idPreviouslyKnownAs",
                                         paddingAsNumber, @"padding",
                                         nil]
                               atIndex:0];
        
        
        
        // TODO: Not vital, but check this bit is correct.
        // if the highest point in my row is equal to my height then I'm the tallest in the row and thus no margnTop is needed, so set it to zero
        int gYco = [[g valueForKey:@"ycoordinate"] intValue];
        NSLog(@"gYco is %i", gYco);
        if (gYco == [[self highestYcoordinateInMyRow:highestElement] intValue] )
        {
            NSLog(@"So the highest element in the GroupingBox is the highest element in the row");
            [[[g insideTheBox] objectAtIndex:0] setObject:[NSNumber numberWithInt:0] forKey:@"GroupBoxMarginTop"];
            NSLog(@"Set GroupBoxMarginTop to zero as it's the highest in the row.");
            
        }
        
        
        
        [self.finalGrouping addObject:[g insideTheBox]];
        //NSLog(@"FG = %@", finalGrouping);
        
    }
    
    BOOL allElementsAreFlexible = YES;
    // Set flexible margins - for elements with % and - widths if inside a gb; any margin lefts; and any margin rights for
    for (NSMutableDictionary *dc in [self.sortedArray copy])
    {
        if ([[dc objectForKey:LAYOUT_KEY] isEqualToString:@"%"])
        {
            // CHANGE THE MARGIN-LEFT AND MARGIN-RIGHT TO %
            NSNumber *marginLeft = [dc objectForKey:@"marginLeft"];
            NSNumber *marginRight = [dc objectForKey:@"marginRight"];
            NSNumber *paddingLeft = [dc objectForKey:@"paddingLeft"];
            NSNumber *flexibleWidth = [dc objectForKey:WIDTH_AS_A_PERCENTAGE];
            
            if (marginLeft)
            {
                CGFloat target = [[dc objectForKey:@"marginLeft"]floatValue];
                CGFloat parent;
                
                //if the element has a container then it's context is the container, else it's the stage
                if ([dc valueForKeyPath:[NSString stringWithFormat:@"%@.%@", PARENT_ID, DIV_TAG]])
                {
                    //get the parent object
                    
                    for (NSDictionary *checking in self.sortedArray) {
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
#pragma mark - CONTAINER CODE ADDED.
                    
                    NSDictionary *container = [self containerContaining:dc usingElements:self.sortedArray];
                    if (container == nil)
                        parent = self.frame.size.width;
                    else
                        parent = [[container objectForKey:@"width"] floatValue];
                    
                    NSLog(@"Parent width is: %f", parent);
                    
                }
                CGFloat context = parent;
                // (target/context)*100;
                
                NSLog(@"target is : %f", target);
                NSLog(@"context is : %f", context);
                
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
                    
                    for (NSDictionary *checking in self.sortedArray) {
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
#pragma mark - CONTAINER CODE ADDED.
                    
                    NSDictionary *container = [self containerContaining:dc usingElements:self.sortedArray];
                    if (container == nil)
                        parent = self.frame.size.width;
                    else
                        parent = [[container objectForKey:@"width"] floatValue];
                    
                    NSLog(@"Parent width 2 is: %f", parent);
                    
                }
                
                
                
                if (parent) // if I found a parent object
                {
                    CGFloat context = parent;
                    CGFloat flexibleMargin = (target/context)*100;
                    [dc setObject:[NSNumber numberWithFloat:flexibleMargin] forKey:MARGIN_RIGHT_AS_A_PERCENTAGE];
                }
                
            }
            
            CGFloat parentWidth;
            if (paddingLeft)
            {
                
                NSDictionary *container = [self containerContaining:dc usingElements:self.sortedArray];
                if (container == nil)
                    parentWidth = self.frame.size.width;
                else
                    parentWidth = [[container objectForKey:@"width"] floatValue];
                
                NSLog(@"ParentWidth is: %f", parentWidth);
                CGFloat flexiblePadding = [self convertTarget:[paddingLeft floatValue] inContext:parentWidth];
                [dc setObject:[NSNumber numberWithFloat:flexiblePadding] forKey:FLEXIBLE_PADDING_LEFT];
            }
            
            GroupingBox *imInAGroupingBox = [self whichGroupingBoxIsElementIn:dc];
            if (flexibleWidth && imInAGroupingBox)
            {
                NSLog(@"AH! Speaking to id: %@", [dc objectForKey:@"elementid"]);
                CGFloat target = [[dc objectForKey:@"width"]floatValue];
                CGFloat context = [[[[imInAGroupingBox insideTheBox] objectAtIndex:0] objectForKey:@"width"] floatValue]; // get it's width
                CGFloat flexibleWidthWhenInsideGroupingBox = (target/context)*100;
                [dc setObject:[NSNumber numberWithFloat:flexibleWidthWhenInsideGroupingBox] forKey:WIDTH_AS_A_PERCENTAGE];
                NSLog(@"Just set: %@ with a new flexWidth of: %f", [dc objectForKey:@"elementid"], flexibleWidthWhenInsideGroupingBox);
            }
            
            
            // (target/context)*100
        }
        
        if ([[dc objectForKey:LAYOUT_KEY] isEqualToString:@"px"])
        {
            allElementsAreFlexible = NO;
            
        }
        
        NSString *myKeyPath = [NSString stringWithFormat:@"%@.%@", PARENT_ID, DYNAMIC_ROW_TAG];
        if ([dc valueForKeyPath:myKeyPath] != nil || [[dc valueForKey:@"tag"] isEqualToString:DYNAMIC_ROW_TAG]) // if my parent is a dyRow or I'm a dyRow...
        {
            [dc setObject:CLASS_SYMBOL forKey:CLASS_OR_ID_SYMBOL];
            [dc setObject:@"class" forKey:CLASS_OR_ID_WORD];
        }
        else
        {
            [dc setObject:ID_SYMBOL forKey:CLASS_OR_ID_SYMBOL];
            [dc setObject:@"id" forKey:CLASS_OR_ID_WORD];
        }
        
    }
    
    if (allElementsAreFlexible)
    {
        NSLog(@"ALL ELEMENTS ARE FLEXII!");
        for (GroupingBox *g in groupingBoxes)
        {
            NSMutableDictionary *header = [g.insideTheBox objectAtIndex:0]; // get the header inforation
            
            //Set the flexible margin Right
            Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
            CGFloat containingElementWidth = [[curDoc stageView] sizeOfHighestContainingElement:g].width; // just changed to make it work with categories
            CGFloat mRight = [[[g.insideTheBox objectAtIndex:0] objectForKey:@"GroupBoxMarginRight"] floatValue];
            NSNumber *flexibleMarginRight = [NSNumber numberWithFloat:(mRight/containingElementWidth)*100];
            [header setObject:flexibleMarginRight forKey:MARGIN_RIGHT_AS_A_PERCENTAGE];
            
            //Set the flexible width of the element
            CGFloat fw = [self sizeAsPercentageOfHighestContainingElement:g].width; // this is the size of my containing element. Even a grouping box will work here as it inherits from Element class and has an rtFrame. If nothing is enclosing this element then it uses the stageView as the enclosing element.
            NSNumber *newFlexibleWidth = [NSNumber numberWithFloat:fw];
            NSLog(@"GOT HERE THREE.. trying to add %@... to %@", newFlexibleWidth, header);
            [header setObject:newFlexibleWidth forKey:WIDTH_AS_A_PERCENTAGE];
            NSLog(@"WE OUT");
        }
    }
    else
    {
        for (GroupingBox *g in groupingBoxes)
        {
            NSMutableDictionary *header = [g.insideTheBox objectAtIndex:0]; // get the header inforation as each groupingBox now has item 0 as
            
            for (NSDictionary *d in g.insideTheBox)
            {
                if ([[d objectForKey:LAYOUT_KEY] isEqualToString:@"%"])
                {
                    
                    //Set the flexible width of the element
                    CGFloat fw = [self sizeAsPercentageOfHighestContainingElement:g].width; // Get the width as a percentage of it's parent
                    NSNumber *newFlexibleWidth = [NSNumber numberWithFloat:fw];
                    NSLog(@"GOT HERE Setting flexible width to GROUPINGBOX.. Flexi width: %@... header: %@", newFlexibleWidth, header);
                    
                    [header setObject:newFlexibleWidth forKey:WIDTH_AS_A_PERCENTAGE]; // Set the groupingBoxes width as flexible
                }
            }
            
        }
    }
    
    
    
    
    
    NSLog(@"Row margins : %@", rowMargins);
}

-(void)generatejs
{
#pragma JS CONVERSION
    
    NSDictionary*msg = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Generating javascript"] forKey:@"string"] ;
    [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CONVERSION_PROGRESS_SCREEN object:self userInfo:msg];
    
    // ASSUMPTION, YOU CAN ONLY HAVE ONE DYROW ON THE PAGE
    NSMutableArray *bucket = [NSMutableArray new];
    self.jsCode2 = [NSMutableString string];
    // write method here that gets the app delegate datasource and gives me back an array of headers and makes it avaiable to visibility method
    for (NSMutableDictionary *element in [self.sortedArray copy])
    {
        if ([[element objectForKey:@"tag"] isEqual:DYNAMIC_ROW_TAG]) {
            [bucket addObject:element];
        }
        
        if ( [element objectForKey:DATA_SOURCE_CODE] == nil && [element objectForKey:DATA_SOURCE_STRING_ENTERED] != nil)
        {
            // This is called if the element has a dataSource string to be converted into code,
            
            // but the element is positioned before the element that provides the reference to the ko.observeredArray (aMeal) - aka koObservableMapped
            NSLog(@"We're in the DATA_SOURCE_CODE zone!");
            Element * e = [self elementWithID:[element objectForKey:@"id"]];
            NSString *dataSourceString = [self dataSourceBindingCode:e];
            [element setObject:dataSourceString forKey:DATA_SOURCE_CODE];
        }
    }
    
    if ([bucket count] > 0)
    {
        NSString *theClass = [self generateClassFromDynamicRow:[bucket objectAtIndex:0] withElementsOnStage:self.sortedArray];
        NSString *viewModel = [self viewModelFrom:[bucket objectAtIndex:0] amongstElements:self.sortedArray];
        
        
        if (theClass != nil) {
            [self.jsCode2 appendString:theClass];
        }
        if (viewModel != nil) {
            [self.jsCode2 appendString:viewModel];
        }
    }
    
    NSLog(@"jscode2 = %@", self.jsCode2);
}






-(void)pieceItTogether
{
#pragma mark - CONVERSION
    
    
    int CblockCount = 0;
    int CmarginTop, CmarginBottom, Ckerning, CHeight, CPaddingTop = 0;
    float CWidth, CPaddingLeft, CmarginLeft, CmarginRight;
    int Cleading = 1;
    float CfontSize = 12;
    
    
    NSMutableDictionary *gc = [NSMutableDictionary dictionary];
    NSMutableDictionary *gs = [NSMutableDictionary dictionary];
    NSMutableArray *codeStore = [NSMutableArray array];
    NSMutableArray *styleStore = [NSMutableArray array];
    NSMutableString *s = [NSMutableString string];
    NSArray *groupings = [NSArray arrayWithArray:self.finalGrouping];
    
    //  1.Get the Start and End rows
    
    NSMutableArray *startRows = [NSMutableArray array];
    NSMutableArray *endRows = [NSMutableArray array];
    
    NSLog(@"Self rows contains: %@", self.rows);
    
    [self.rows enumerateObjectsUsingBlock:^(NSArray *row, NSUInteger indexCounter, BOOL *stop){
        
        //So we know which element IDs are the first and last in each row.
        [startRows addObject:[[row objectAtIndex:0] valueForKey:@"id"]]; //object 0 is a dictionary containing the values for various attribtes for this element.
        [endRows addObject:[[row lastObject] valueForKey:@"id"]];
        
        
        for (NSDictionary *eachContainer in self.firstAndLastRowsInContainer)
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
        
        NSLog(@"PRINTING EACH MODIFIED ROW: %@", row);
        
    } ];
    
    
    NSLog(@"START ROW: %@. END ROWS: %@", startRows, endRows);
    
    
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
    NSString *groupBoxWidth = @"";
    
    
    NSMutableArray *firstObjectsInGroups = [NSMutableArray array]; // We need to know when to open a groupbox div...
    NSMutableArray *lastObjectsInGroups  = [NSMutableArray array]; // and when to close one
    
    NSString *blockid = [NSString string];
    
    
    for (NSArray *array in groupings)
    {
        [firstObjectsInGroups addObject: [[array objectAtIndex:0] valueForKey:@"firstObject"]];
        [lastObjectsInGroups addObject:[[array objectAtIndex:0] valueForKey:@"lastObject"]];
    }
    NSLog(@"GROUPINGS IN CONVERSION : %@", groupings);
    NSLog(@"Last objects in groupings : %@", lastObjectsInGroups);
    
    
    
    for (NSMutableDictionary *block in [self.sortedArray copy])
    {
        NSString *msgString = [NSString stringWithFormat:@"Configuring attributes for %@", [block objectForKey:@"id"]];
        NSDictionary*msg = [NSDictionary dictionaryWithObject:msgString forKey:@"string"];
        //[[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CONVERSION_PROGRESS_SCREEN object:self userInfo:msg];
        
        
        s = [NSMutableString string];
        NSString *styleString = [NSString string];
        NSUInteger indexOfLastObject = nil;
        NSUInteger indexOfNextObject = nil;
        if ([self.sortedArray indexOfObject:block] != 0)
        {
            indexOfLastObject = [self.sortedArray indexOfObject:block]-1;
            indexOfNextObject = [self.sortedArray indexOfObject:block]+1;
        }
        
        
        
        NSLog(@"THE LAST INDEX WAS : %lu", indexOfLastObject);
        
        
        NSMutableString *groupBoxOpeningDiv = nil;
        NSMutableString *postCode = [NSMutableString string];
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
        NSString *urlLink = [NSString new];
        
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
            blockidAsString = [block objectForKey:@"id"]; // was lowercase, but not sure why
        }
        else
        {
            blockidAsString = [prefix stringByAppendingFormat:@"%@", [block valueForKey:@"id"]];
        }
        [block setObject:blockidAsString forKey:@"markupid"];
        
        if ([firstObjectsInGroups containsObject:blockid])
        {
            NSLog(@"Inside firsts..");
            groupBoxOpeningDiv = [NSMutableString stringWithString: @"\n    <div "];
            NSUInteger myIndex = [self.sortedArray indexOfObject:block];
            NSMutableDictionary *oneBefore = [self.sortedArray objectAtIndex:myIndex-1];
            if ([[oneBefore objectForKey:@"tag"] isEqualTo:DYNAMIC_ROW_TAG])
            {
                [groupBoxOpeningDiv appendFormat:@"data-bind=\"foreach: %@s\"> \n <div  ", [oneBefore objectForKey:@"id"]]; //plural is the name of the ko.observable
            }
            //[groupBoxOpeningDiv appendString:@"class=\"groupBox\" "];
            NSMutableDictionary *groupingBoxInQuestion = [NSMutableDictionary dictionary];
            __block NSArray *each = [NSArray array];
            
            [groupings enumerateObjectsUsingBlock:^(id groupB, NSUInteger index, BOOL *stop)
             {
                 if ([[[groupB objectAtIndex:0]valueForKey:@"firstObject"] isEqualToString:blockid] )
                 {
                     each = groupB;
                 }
             } ];
            
            //for (NSArray *each in groupings)
            //{
                NSLog(@"EACH CONTAINS : %@", each);
                if ([[[each objectAtIndex:0]valueForKey:@"firstObject"] isEqualToString:blockid] )
                {
                    groupBoxMarginTop = [[each objectAtIndex:0] valueForKey:@"GroupBoxMarginTop"];
                    NSLog(@"SHAMON ! %@", groupBoxMarginTop);
                    groupBoxMarginRight = [[each objectAtIndex:0] valueForKey:@"GroupBoxMarginRight"];
                    if ([[each objectAtIndex:0] valueForKey:MARGIN_RIGHT_AS_A_PERCENTAGE])
                    {
                        groupBoxWidth = [[each objectAtIndex:0] valueForKey:MARGIN_RIGHT_AS_A_PERCENTAGE];
                        groupingBoxLayoutType = @"%";
                    }
                    else
                    {
                        if ([[each objectAtIndex:0] valueForKey:WIDTH_AS_A_PERCENTAGE] != nil) // if the groupingBox has a value for the width_as_% attribute, then use that.
                        {
                            groupBoxWidth = [[each objectAtIndex:0] valueForKey:WIDTH_AS_A_PERCENTAGE]; // so each has a valueforkey of widthas% but each[0] doe not. Check this
                            groupingBoxLayoutType = @"%";
                            NSLog(@"in it");
                        }
                        else
                        {
                            groupBoxWidth = [[each objectAtIndex:0] valueForKey:@"width"];
                            groupingBoxLayoutType = @"px";
                        }
                        
                    }
                    
                    groupingBoxInQuestion = [each objectAtIndex:0];
                    NSLog(@"NOW : %i", CblockCount);
                    
                    
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
                    NSLog(@"At step : 5 gbiq = %@", groupingBoxInQuestion);
                    
                    if ([groupingBoxInQuestion objectForKey:@"idPreviouslyKnownAs"])
                    {
                        //
                    }
                    else
                    {
                        NSLog(@"GROUPINGBOX IN HERE!! : %@ and %@ ! and width: %@", groupBoxMarginTop, groupBoxMarginRight, groupBoxWidth);
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
                        
                        groupBoxIDCode = [NSMutableString stringWithString:[groupBoxBits componentsJoinedByString:@""]];
                        NSLog(@"TEST 4. Which is %@", groupBoxIDCode);
                        Cstyle = [NSMutableString stringWithString:[Cstyle stringByAppendingString:groupBoxIDCode]];
                        NSLog(@"CSTYLE AT THIS POINT SHOULD CONTAIN GB1 : %@",Cstyle);
                    }
                    
                    // ABOVE FOUR LINES REMOVED FROM HERE.
                    
                }
            //}
            

        } // end of if ([firstObjectsInGroups containsObject:blockid])
        
        //  Set the end of the GrouupBox code
        if ([lastObjectsInGroups containsObject:blockid])
        {
            
            bool seen = NO;
            for (NSString *objid in lastObjectsInGroups)
            {
                if ([objid isEqualToString:blockid])
                {
                    
                    if (seen == NO)
                    {
                        if ([block valueForKeyPath:@"parentID.div"] != nil) 
                        {
                           NSString *str = [block valueForKeyPath:@"parentID.div"];
                           [postCode appendString:[NSString stringWithFormat:@"\n</div><!-- Closes %@ -->", str]];
                        }
                        else
                        {
                           [postCode appendString:[NSString stringWithFormat:@"\n</div><!-- Closes %@ -->", blockid]];
                        }
                    }
                        
                    else
                    {
                        [postCode appendString:@"\n</div><!-- Closes groupbox -->"];
                    }
                    
                    seen = YES;
                    
                }
            
            }
             
            
            
            
            //postCode = [NSMutableString stringWithString:@"\n</div><!-- Closes the GroupBox -->"];
            if ([[block objectForKey:@"tag"] isEqualTo:DYNAMIC_ROW_TAG])
            {
                [postCode appendString:@"\n    </div><!-- Closes the dyRow -->"];
            }
            
        }
        
        
        //  Row code
        if ([startRows containsObject:blockid])
        {
            startRowCode = [NSMutableString stringWithString:@"\n      <div class=\"row\">        "];
            
        }
        if ([endRows containsObject:blockid])
        {
            endRowCode = [NSMutableString stringWithString:@"\n</div><!-- Closes the row -->"];
            if ([block objectForKey:LAST_IN_ROW_AND_CONTAINER])
            {
                NSString *containerEndCode = @"\n</div><!-- Closes the container -->";
                endRowCode = [NSMutableString stringWithString:[endRowCode stringByAppendingString:containerEndCode]];
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
        
        
        if ([block valueForKeyPath:URLSTRING])
        {
            NSLog(@"Block: %@ has a URL!", block);
            
            if ([block valueForKey:URLSTRING] == [NSNull null])
            {
                [block setValue:[NSNumber numberWithInt:0] forKey:URLSTRING];
            }
            urlLink = [NSString stringWithFormat:@"%@px", block];
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
            
            if (shadowCSS == nil) {
                [shadowCSS setString:@""];
            }
            
            /*
             The box-shadow property allows elements to have multiple shadows, specified by a comma seperated list.
             When more than one shadow is specified, the shadows are layered front to back, as in the following example.
             */
        }
        
        //2. DataSource and actions -  visibility has been tacked on to the end of dataSource
        NSString *actionCode = [block objectForKey:ACTION_CODE];
        NSString *dataSourceCode = [block objectForKey:DATA_SOURCE_CODE];
        
        if (actionCode==nil) {
            actionCode = [NSString string];
        }
        
        if (dataSourceCode==nil) {
            dataSourceCode = [NSString string];
        }
        NSLog(@"DATA SOURCE CODE = %@", dataSourceCode);
        
        
        
        //3. if the last object was in dyRow but this element is not then
        NSString *closeTheLoop = @"";
        NSMutableDictionary *theNextObject = nil;
        NSString *theNextObjectInDyRow = nil;
        NSString *thisObjectInDyRow = nil;
        
        if ([self.sortedArray indexOfObject:block] != [self.sortedArray count]-1)
        {
            theNextObject = [self.sortedArray objectAtIndex:indexOfNextObject];
            theNextObjectInDyRow = [[theNextObject objectForKey:PARENT_ID] objectForKey:DYNAMIC_ROW_TAG];
            thisObjectInDyRow = [[block objectForKey:PARENT_ID] objectForKey:DYNAMIC_ROW_TAG];
            
            NSLog(@"nextObjectInDyRow IS %@", theNextObject);
            NSLog(@"nextObjectInDyRow IS %@", theNextObject[PARENT_ID]);
            NSLog(@"nextObjectInDyRow = %@ AND thisObjectInDyRow = %@", theNextObjectInDyRow, thisObjectInDyRow);
        }
        
        
        
        if ( thisObjectInDyRow && theNextObjectInDyRow == nil )
        {
            NSLog(@"CLOSING THE LOOP...");
            closeTheLoop =  @"\n</div><!--Closes the loop-->\n";
        }
        
        
        
        
        
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
            
            
                // put it all together
            NSArray *codeArray = [NSArray array];
            
            if (widthAsANumber && heightAsAString)
            {
                codeArray = [NSArray arrayWithObjects:
                             @"\n        ",
                             @"<div id=\"",
                             blockidAsString,
                             @"\">",
                             @"<img src=\"",
                             [block valueForKey:@"content"],
                             @"\" ",
                             @" alt=\"",
                             [block valueForKey:@"alt"],
                             @"\"/>",
                             @"</div>",
                             @"\n",
                             nil];
            }
            else
            {
                codeArray = [NSArray arrayWithObjects:
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
            }
            
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
        if ([[block valueForKey:@"tag"] isEqualToString:PARAGRAPH_TAG])
        {
            
            NSLog(@"in para");
            NSLog(@"%@", self.textStyles);
            NSString *floatType = @"left";
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
                                   //actionCode,
                                   //dataSourceCode,
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
            
            NSArray *arrayF = [NSArray array];
            
            NSLog(@"Trying to show : %@", [block objectForKey:CLASS_OR_ID_WORD]);
            
            if ([[block objectForKey:URLSTRING] isEqualToString:@"#"])
            {
            arrayF = [NSArray arrayWithObjects:
                      @"<a href=\"#\" ",
                      [block objectForKey:CLASS_OR_ID_WORD],
                      @"=\"",
                      blockidAsString,
                      @"\" ",
                      dataSourceCode,
                      actionCode,
                      @">",
                      @"\n",
                      s,
                      @"</a>",
                      @"\n",
                      nil];
            }
            
            arrayF = [NSArray arrayWithObjects:
                      @"<p ",
                      [block objectForKey:CLASS_OR_ID_WORD],
                      @"=\"",
                      blockidAsString,
                      @"\" ",
                      dataSourceCode,
                      actionCode,
                      @">",
                      @"\n",
                      s,
                      @"</p>",
                      @"\n",
                      nil];
            
            NSLog(@"p completed : %@", arrayF);
            NSLog(@"block class or id : %@", [block objectForKey:CLASS_OR_ID_WORD]);
            NSLog(@"S STRING IS : %@", s);
            
            code = [NSMutableString stringWithString:[arrayF componentsJoinedByString:@""]];
            
            NSLog(@"after concatenating : %@", code);
            
            
            
            
            
            
            
            
            
            
            
            
            
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
            
            if ([block objectForKey:TOP_MARGIN_FOR_ROW] != nil) {
                CmarginTop = [[block objectForKey:TOP_MARGIN_FOR_ROW] integerValue] + CmarginTop;
            }
            
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
            NSMutableArray *arrayG = [NSMutableArray arrayWithObjects:
                                      [block objectForKey:CLASS_OR_ID_SYMBOL],
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
                                      //@"  background-color: ",
                                      //backgroundColor,
                                      //@";",
                                      //@"\n",
                                      @"  width: ",
                                      widthAsANumber,
                                      elementLayoutType,
                                      @";",
                                      @"\n",
                                      @"  height: ",
                                      heightAsAString,
                                      @"px;",
                                      @"\n",
                                      @"  float:",
                                      floatType,
                                      @"; ",
                                      @"\n",
                                      nil];
            
            if (shadowCSS != nil) {
                [arrayG addObject:shadowCSS];
                [arrayG addObject:@"\n"];
            }
            [arrayG addObject:@"}\n\n"];
            
            NSLog(@"At step : 10 with classorid as : %@", [block objectForKey:CLASS_OR_ID_WORD]);

            Cstyle = [NSMutableString stringWithString:[Cstyle stringByAppendingString:[[arrayG componentsJoinedByString:@""] stringByAppendingString:styleString]]];
            
        }
        
        
        
        
        
        // RECTANGLE or ROW CODE or CONTAINER or DYNAMIC ROW
        if ( ([[block valueForKey:@"tag"] isEqualToString: @"div"]) || ([[block valueForKey:@"tag"] isEqualToString: DYNAMIC_ROW_TAG ])  || ([[block valueForKey:@"tag"] isEqualToString: CONTAINER_TAG ]) )
        {
            NSMutableArray *arrayH = [NSMutableArray array];
             NSString *floatType = @"left";
            if ([block objectForKey:@"convertToGroupingbox"] == nil)
            {
                if ([[block objectForKey:@"tag"] isEqual:CONTAINER_TAG])
                {
                    arrayH = [NSArray arrayWithObjects:
                              @"<div class=\"container\" id=\"",
                              blockidAsString,
                              @"\">",
                              [block valueForKey:@"content"],
                              
                              nil];
                    //NSString *containerStartCode = [NSString stringWithFormat:@"\n      <div class=\"container\" id=\"%@\">", previousElementId];
                    //startRowCode = [NSMutableString stringWithString:[containerStartCode stringByAppendingString:startRowCode]];
                }
                
               
                if ([[block objectForKey:@"tag"] isEqual:DYNAMIC_ROW_TAG])
                {
                    floatType = @"none";
                }
                
                else
                {
                    arrayH = [NSArray arrayWithObjects:
                              @"<div ",
                              [block objectForKey:CLASS_OR_ID_WORD],
                              @"=\"",
                              blockidAsString,
                              @"\">",
                              [block valueForKey:@"content"],
                              @"</div>",
                              nil];
                    
                }
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
            
            if ([block objectForKey:TOP_MARGIN_FOR_ROW] != nil) {
                CmarginTop = [[block objectForKey:TOP_MARGIN_FOR_ROW] integerValue] + CmarginTop;
            }
            
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
                                      [block objectForKey:CLASS_OR_ID_SYMBOL],
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
                                      @"  float:",
                                      floatType,
                                      @"; ",
                                      @"\n",
                                      shadowCSS,
                                      @"\n",
                                      nil];
            if (shadowCSS != nil)
            {
                [arrayI addObjectsFromArray:@[shadowCSS, @"\n"]];
            }
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
        
        
        
        
        // DROPDOWN CODE
        if ( ([[block valueForKey:@"tag"] isEqualToString:DROP_DOWN_MENU_TAG])  )
        {
            
            NSArray *arrayH = [NSArray arrayWithObjects:
                               @"\n      <select ",
                               [block objectForKey:CLASS_OR_ID_WORD],
                               @"=\"",
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
                                      [block objectForKey:CLASS_OR_ID_SYMBOL],
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
        
        
        
        
        
        
        // TEXT INPUT FIELD CODE
        if ([[block valueForKey:@"tag"] isEqual: @"textInputField"])
        {
            NSArray *arrayH = [NSArray arrayWithObjects:
                               @"<input type=\"text\" ",
                               [block objectForKey:CLASS_OR_ID_WORD],
                               @"=\"",
                               blockidAsString,
                               @"\" ",
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
                // The width of the textfield in the app includes padidng and border so the printed value should also.
                widthAsANumber = [NSNumber numberWithFloat:CWidth];
            }
            else
            {
                CWidth = [[block valueForKey:@"width"] intValue];
                widthAsANumber =[NSNumber numberWithInt:CWidth-(([TEXT_FIELD_PADDING_LEFT intValue] + [TEXT_FIELD_PADDING_RIGHT intValue]) + [borderStrokeString intValue]*2)];
            }
            
            CHeight = [[block valueForKey:@"height"] intValue] - ( [TEXT_FIELD_PADDING_TOP intValue] + [TEXT_FIELD_PADDING_BOTTOM intValue] );
            CmarginTop = [[block valueForKey:@"marginTop"]intValue];
            CmarginBottom = [[block valueForKey:@"marginBottom"]intValue];
            CmarginLeft = [[block valueForKey:@"marginLeft"]intValue];
            CmarginRight = [[block valueForKey:@"marginRight"]intValue];
            backgroundColor = [block valueForKey:@"backgroundColor"];
            NSMutableArray *arrayI = [NSMutableArray arrayWithObjects:
                                      [block objectForKey:CLASS_OR_ID_SYMBOL],
                                      blockidAsString,
                                      @"{margin: ",
                                      [NSNumber numberWithInt:CmarginTop],
                                      @"px ",
                                      [NSNumber numberWithInt:CmarginRight],
                                      @"px ",
                                      [NSNumber numberWithInt:CmarginBottom],
                                      @"px ",
                                      [NSNumber numberWithInt:CmarginLeft],
                                      @"px; ",
                                      @"\n",
                                      @"width: ",
                                      widthAsANumber, // check above for the calculation...
                                      // 24 because the TextInputField class is inset of x8/y8, has a padding of 4+4, and Bootstrap has a padding of 4+4 see files, but minus the borderwidth - so 8+8+8
                                      elementLayoutType,
                                      @";",
                                      @"height: ",
                                      [NSNumber numberWithInt:CHeight-(([borderStrokeString intValue]*2) )],
                                      // 8 because the TextInputField class is inset of x1/y1, has a padding of 0+0, and Bootstrap has a padding of 4+4 see files, but minus the borderwidth - so 1+0+8 - BUT the 1 isn't needed for some reason.
                                      @"px;",
                                      @"\n",
                                      @"float: left; ",
                                      @"\n",
                                      nil];
            if (shadowCSS)
                // Make it neater so there are no extra gaps.
                [arrayI insertObject:shadowCSS atIndex:arrayI.count-1];
                [arrayI insertObject:@"\n" atIndex:arrayI.count-1];
            
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
            
            [arrayI addObject:@" }\n"];
            
            Cstyle = [NSMutableString stringWithString:[Cstyle stringByAppendingString:[arrayI componentsJoinedByString:@""]]];
        }
        
        
        
        
        
        
        
        // BUTTON
        if ([[block valueForKey:@"tag"] isEqual: @"button"])
        {
            
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
            
            // Left margin
            if ([block valueForKey:MARGIN_LEFT_AS_A_PERCENTAGE])
            {
                CmarginLeft = [[block valueForKey:MARGIN_LEFT_AS_A_PERCENTAGE] floatValue];
                NSLog(@"flexi b :%f", CmarginLeft);
            }
            else
            {
                CmarginLeft = [[block valueForKey:@"marginLeft"]intValue];
                NSLog(@"flexi a :%f", CmarginLeft);
            }
            
            //Top paddings
            if ([block valueForKey:@"paddingTop"] != nil)
            {
                CPaddingTop = [[block valueForKey:@"paddingTop"]intValue];
            }
            
            // Side padding
            if ([block valueForKey:FLEXIBLE_PADDING_LEFT] != nil)
            {
                CPaddingLeft = [[block valueForKey:FLEXIBLE_PADDING_LEFT] floatValue];
                NSLog(@"cp = %f", CPaddingLeft);
            }
            else if ([block valueForKey:@"paddingLeft"] != nil)
            {
                CPaddingLeft = [[block valueForKey:@"paddingLeft"] intValue];
                NSLog(@"cp2 = %f", CPaddingLeft);
            }
            
            NSLog(@"cp3 = %f", CPaddingLeft);
            
            CHeight = [[block valueForKey:@"height"] intValue];
            NSMutableArray *styleArray = [NSMutableArray arrayWithObjects:
                                          @"#",
                                          blockidAsString,
                                          @" {",
                                          @"\n",
                                          @"\n",
                                          @"  width: ",
                                          widthAsANumber,
                                          elementLayoutType,
                                          @";",
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
                                          @"0",
                                          @";",
                                          @"\n",
                                          @"text-align: center;",
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
                                          @"\n",
                                          nil];
            NSArray *boxShadow = [NSArray arrayWithObjects:@"  ", @"-webkit-box-shadow: inset 0px 1px 0px 0px rgba(256,256,256,0.7);", nil];
            
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
                //[styleArray addObjectsFromArray:boxShadow];
            }
            if ([block valueForKey:@"backgroundColor"] !=nil)
            {
                [styleArray addObject:[NSString stringWithFormat:@"background-color: %@",[block valueForKey:@"backgroundColor"]]];
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
                               @"<a ",
                               actionCode,
                               @"id=\"",
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
        
        // if the code just generated code from the last element in a dyRow then close the loop.
        NSLog(@"just about to add closetheloop code: %@", closeTheLoop);
        [code appendString:closeTheLoop];
        
        
        //  # This code will only be fired for the first element in each Grouping box.
        NSLog(@"THE VALUE IS : %@", groupBoxOpeningDiv); //INTERESTING... DOES THIS PRINT ALL GROUPINGBOXES CODE...
        if (groupBoxOpeningDiv != nil)
        {
            //groupBoxOpeningDiv = [NSMutableString stringWithString:
                                  //[[[[groupBoxOpeningDiv stringByAppendingString:@"id=\""] stringByAppendingString:groupBoxID] stringByAppendingString: @"\">"] stringByAppendingString:code]];
            groupBoxOpeningDiv = [NSString stringWithFormat:@"%@%@%@%@%@%@", groupBoxOpeningDiv, [block objectForKey:CLASS_OR_ID_WORD], @"=\"", groupBoxID, @"\">", code];
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
        
        NSLog(@"JUST ADDED : %@", Cstyle);
        
        [gc setObject:code forKey:[NSNumber numberWithInt:CblockCount]];
        [gs setObject:Cstyle forKey:[NSNumber numberWithInt:CblockCount]];
        
        [codeStore addObject:codeDictionary];
        [styleStore addObject:styleDictionary];
        
        CblockCount++;
        
        previousElementId = [NSMutableString stringWithString:blockidAsString];
        
        
    } //end of cycling through each element.
    NSLog(@"CODE STORE HAS : %@", codeStore);
    
    
    NSDictionary*msg = [NSDictionary dictionaryWithObject:@"Piecing together the HTML, CSS, and JavaScript code" forKey:@"string"];
    [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CONVERSION_PROGRESS_SCREEN object:self userInfo:msg];
    
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
        // get the id of the Container this row sits within, and then place that id where .container currently is in the code below. If Nil then replace it with 'body'.
        NSMutableString *containerID = [self containerThatContainsRow:loopCount-1 usingElements:self.sortedArray];
        if (containerID != nil)
            [containerID insertString:@"#" atIndex:0]; //ASSUMPTION: This is an id not a class
        else
            containerID = [NSMutableString stringWithString:@"body"];
        
        
        rowCodeForNthChild = [NSMutableString stringWithFormat:@"%@ .row:nth-child(%lu) {\n  margin-top: %@px;\n\n}", containerID, loopCount, n];
        css = [NSMutableString stringWithString:[css stringByAppendingString:rowCodeForNthChild]];
    }
    
    //[css appendString:groupBoxIDCode]; THIS HAS BEEN ADDED ALREADY WHEN CHECKING if ([firstObjectsInGroups containsObject:blockid])
    
    for (NSDictionary *d in codeStore)
    {
        for (NSString *key in d)
        {
            aTag = [gc objectForKey:key];
            html = [NSMutableString stringWithString:[html stringByAppendingString:aTag]];
        }
    }
    
    NSString *koScriptTag, *jQueryScriptTag = @"";
    if (self.jsCode2)
        //koScriptTag = @"<script src=\"http://cdnjs.cloudflare.com/ajax/libs/knockout/2.2.0/knockout-min.js\"></script>\n";
        koScriptTag = @"<script src=\"knockout.js\"></script>\n";
        jQueryScriptTag = @"<script src=\"jquery.js\"></script>\n";
    
    
    

    NSString *imgMaxWidth = [NSString stringWithFormat:@"%d%%", 100];
    start = [NSMutableString stringWithFormat: @"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"utf-8\">\n<title>%@</title>\n%@%@\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n<meta name=\"description\" content=\"\"><meta name=\"author\" content=\"\">\n<!-- Le styles --><link href=\"bootstrap.css\" rel=\"stylesheet\"><style type=\"text/css\">\n body { \n  font-size: 0.75em;\n  background-color: %@;\n} \n.groupBox {\n  height: auto;\n  padding: none;\n} \nimg {\n  max-width: %@;\n}  \n", self.pageTitle, koScriptTag, jQueryScriptTag, backgroundColourAsString, imgMaxWidth];
    //[start stringByAppendingString:backgroundColourAsString];
    //[start stringByAppendingString:@""];
    
    middle = [NSMutableString stringWithString: @"\n</style>\n</head>\n  <body>\n    "];
    
    end = [NSMutableString stringWithString:[NSString stringWithFormat:@"\n<script>%@</script> \n</body>\n</html>", self.jsCode2]];
    
    doc = [NSMutableString stringWithString:
           [[[[start stringByAppendingString:css] stringByAppendingString:middle] stringByAppendingString:html] stringByAppendingString:end]];
    
    NSLog(@"OUTPUT IS: %@", doc);
    NSError *error = nil;
    if ([doc writeToURL:self.directoryURLToPlaceFiles atomically:YES encoding:NSUTF8StringEncoding error:&error])
    {
        NSLog(@"SUCCESS!");
        NSLog(@"Wrote doc to: %@", self.directoryURLToPlaceFiles);
        
        
        NSDictionary*msg = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Saving the generated files to your computer."] forKey:@"string"] ;
        [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CONVERSION_PROGRESS_SCREEN object:self userInfo:msg];
    }
    else
    {
        NSLog(@"Error in writing document to file : %@", error);
    }
    
    
    
    /* Bootstrap amendments (to permanently make):
     .btn              textalign       now set to zero.
     .btn-large        padding         is set to 0.
     .row              margin-left     now commented out.
     
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
                        
            NSDictionary*msg = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Saving the generated image files to your computer."] forKey:@"string"] ;
            [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CONVERSION_PROGRESS_SCREEN object:self userInfo:msg];
            
            NSLog(@"PATH IS - %@", self.outputFolderPath);
            NSMutableString *imagePath = [NSMutableString stringWithString:[self.outputFolderPath stringByDeletingLastPathComponent]];
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
    
    
    NSDictionary*di = [NSDictionary dictionaryWithObject:@"Finished the conversion!" forKey:@"string"] ;
    [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_CONVERSION_PROGRESS_SCREEN object:self userInfo:di];
    
    NSArray *fileURLs = [NSArray arrayWithObjects:self.directoryURLToPlaceFiles, nil];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURLs];
    
    NSLog(@"exiting...");
}




#pragma mark - Generate Code
-(IBAction)generateCode:(id)sender
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    [[appDelegate conversionProgressScreen] setIsVisible:YES];
    
    
    [self sortElements];
    if (abortConversion) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"NO Tag given for an element." defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please provide a Tag to all elements on the page."];
        [alert runModal];
        return;
    }
    [self generateAttr];
    NSLog(@"self.sorted 2 = %@", self.sortedArray);
    [self generatejs];
    NSLog(@"self.sorted 3 = %@", self.sortedArray);
    [self pieceItTogether];
    
    //NSLog(@"Last message = %@", self.currentMessage);
}


-(void)actionsCompiler
{
    
    // get the actions
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
    if ([groupItems.title isEqual: @"Group items"])
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
