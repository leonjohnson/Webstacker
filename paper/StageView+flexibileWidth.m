#import "StageView.h"
#import "Common.h"

@implementation StageView (flexibileWidth)



-(CGSize)sizeAsPercentageOfHighestContainingElement: (Element*)selElement
{
    // The business
    
    
    NSMutableArray *contenders = [NSMutableArray array];
    float x = selElement.rtFrame.origin.x;
    float y = selElement.rtFrame.origin.y;
    float w = selElement.rtFrame.size.width;
    float h = selElement.rtFrame.size.height;
    
    NSRect insideRect = NSMakeRect(x, y, w, h);
    for (Element *possiblyContainerElement in elementArray)
    {
        if (possiblyContainerElement != selElement)
        {
            
            NSRect possiblyContainingRect = NSMakeRect(possiblyContainerElement.rtFrame.origin.x, possiblyContainerElement.rtFrame.origin.y, possiblyContainerElement.rtFrame.size.width, possiblyContainerElement.rtFrame.size.height);
            if (CGRectContainsRect(possiblyContainingRect, insideRect))
            {
                NSLog(@"Found an element that contains me with an id : %@!", [possiblyContainerElement elementid]);
                // This places an NSNumber in the contenders array stating the index of where the element is in the layers panel.
                //[contenders addObject:[NSNumber numberWithInteger:[orderOfLayers indexOfObject:possiblyContainerElement]]];
                [contenders addObject:possiblyContainerElement];
            }
        }
    }
    
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [contenders sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    Element *myContainer = nil;
    float wp;   //  width as a percentage
    float hp;   //  height as a percentage
    if ([contenders count] > 0)
    {
        NSLog(@"Order of layers in sizeAsPercentageOfHighestContainingElement: %@", orderOfLayers);
        //myContainer = [orderOfLayers objectAtIndex:[[contenders objectAtIndex:0] integerValue]];
        myContainer = [contenders objectAtIndex:0];
        NSLog(@"myContainer id : %@", myContainer.elementid);
        wp = (selElement.rtFrame.size.width/myContainer.rtFrame.size.width)*100;      //  width as a percentage
        hp = (selElement.rtFrame.size.height/myContainer.rtFrame.size.height)*100;    //  height as a percentage
    }
    else
    {
        wp = (selElement.rtFrame.size.width/self.frame.size.width)*100;      //  width as a percentage
        hp = (selElement.rtFrame.size.height/self.frame.size.height)*100;    //  height as a percentage
    }
    
    NSLog(@"made it back");
    return NSMakeSize(wp, hp);
}

-(CGSize)sizeOfHighestContainingElement: (Element*)selElement
{
    NSMutableArray *contenders = [NSMutableArray array];
    float x = selElement.rtFrame.origin.x;
    float y = selElement.rtFrame.origin.y;
    float w = selElement.rtFrame.size.width;
    float h = selElement.rtFrame.size.height;
    
    NSRect insideRect = NSMakeRect(x, y, w, h); // Improve: just use selElement.rtFrame
    for (Element *possiblyContainerElement in elementArray)
    {
        if (possiblyContainerElement != selElement)
        {
            
            NSRect possiblyContainingRect = NSMakeRect(possiblyContainerElement.rtFrame.origin.x, possiblyContainerElement.rtFrame.origin.y, possiblyContainerElement.rtFrame.size.width, possiblyContainerElement.rtFrame.size.height);
            if (CGRectContainsRect(possiblyContainingRect, insideRect))
            {
                NSLog(@"Found an element that contains me with an id : %@!", [possiblyContainerElement elementid]);
                // This places an NSNumber in the contenders array stating the index of where the element is in the layers panel.
                //[contenders addObject:[NSNumber numberWithInteger:[orderOfLayers indexOfObject:possiblyContainerElement]]];
                [contenders addObject:possiblyContainerElement];
            }
        }
    }
    
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
    [contenders sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    Element *myContainer = nil;
    float containersWidth;   //  width as a percentage
    float containersHeight;   //  height as a percentage
    if ([contenders count] > 0)
    {
        NSLog(@"Order of layers: %@", orderOfLayers);
        myContainer = [contenders objectAtIndex:0];
        //myContainer = [orderOfLayers objectAtIndex:[[contenders objectAtIndex:0] integerValue]];
        
        containersWidth = (selElement.rtFrame.size.width/myContainer.rtFrame.size.width)*100;      //  width as a percentage
        containersHeight = (selElement.rtFrame.size.height/myContainer.rtFrame.size.height)*100;    //  height as a percentage
    }
    else
    {
        containersWidth = (selElement.rtFrame.size.width/self.frame.size.width)*100;      //  width as a percentage
        containersHeight = (selElement.rtFrame.size.height/self.frame.size.height)*100;    //  height as a percentage
    }
    
    
    return NSMakeSize(containersWidth, containersHeight);
}



-(CGSize)updateElementWithPercentagesAndAttributesPanelWithElementAttributes:(Element*)selElement
{
    // UPDATES THE ELEMENT, AND THEN UPDATES THE ATTRIBUTEPANEL
    CGFloat elementWidth = ((Element *)[selElementArray lastObject]).rtFrame.size.width;
    CGFloat elementHeight = ((Element *)[selElementArray lastObject]).rtFrame.size.height;
    CGSize elementsSize = CGSizeMake(elementWidth, elementHeight);
    
    // The business
    if ([selElement.layoutType isEqualToString:PERCENTAGE_BASED_LAYOUT])
    {
        NSSize w_h = [self sizeAsPercentageOfHighestContainingElement:selElement];
        
        [selElement setWidth_as_percentage:w_h.width];
        [selElement setHeight_as_percentage:w_h.height];
        
        NSLog(@"MoveSelectedElements. Width = %f. Height = %f.", w_h.width, w_h.height);
        
        elementsSize = CGSizeMake(w_h.width, w_h.height);
        //elementWidth = w_h.width;     OLD ivars
        //elementHeight = w_h.height;   OLD ivars
        
        
    }
    else
    {
        [selElement setWidth_as_percentage:0];
        [selElement setHeight_as_percentage:0];
    }
    // TODO:
    /*
     1. If the percentage dropdown menu is selected
     2. Get all views that contain this element and select the highest one through the stageView array named 'orderOfLayers'.
     3. If there is one, get its size/dimension and then calculate my width and height as a percentage of this superview.
     4. Update the elements ivar width_as_percentage and height_as_percentage
     5. Update the Attribute panels W and H values with the respective percentages in the SetAttributeOfShapeToPanel method below.
     6. If there isn't one, use the stageview as the containing view
     */
    
    // set the current shape's attribute to the attribute panel
    [attributeDelegate SetAttributeOfShapeToPanel:((Element *)[selElementArray lastObject]).rtFrame.origin.x
                                             yPos:((Element *)[selElementArray lastObject]).rtFrame.origin.y
                                            Width:elementsSize.width
                                           Height:elementsSize.height];
    return elementsSize;
}


@end



