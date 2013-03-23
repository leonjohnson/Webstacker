#import "Element.h"
#import "DynamicRow.h"
#import "DropDown.h"
#import "Document.h"
#import "AppDelegate.h"

@implementation StageView (knockout)

-(NSString*)viewModelFrom:(Element*)dyRow withClassStructure:(NSArray*)classStructure
{
    NSString *stringToReturn = nil;
    if ([dyRow isMemberOfClass:[DynamicRow class]])
    {
        // If you create a dataSource, you automatically get an observableArray, the ability to add a row, and delete a row. These are standard.
        NSString *className = [NSString stringWithFormat:@"function ReservationsViewModel() {\n"];
        NSString *selfStatement = @"    var self = this;\n    // Non-editable catalog data\n    ";
        NSString *model = [NSString stringWithFormat:@"%@", [[self dataSourceUsingHardcodedLocalValues] objectAtIndex:0]];
        NSString *observableArrayName = [NSString stringWithFormat:@"%@s", dyRow.elementid]; // lowercase elementid with an s on the end so 'seats'
        NSMutableString *observableArray = [NSString stringWithFormat:@"//Editable Data\n self.%@ = ko.observableArray([]);", observableArrayName];
        NSString *addRow1 = @"// Operatsions\n self.addRow = function() {\n";
        NSMutableString *addRow2 = [NSMutableString stringWithFormat:@"%@ self.%@.push(new %@());\n}"];
        NSMutableString *deleteRow = [NSString stringWithFormat:@"self.removeRow = function(%@) { self.%@.remove(%@) }", dyRow.elementid, observableArrayName, dyRow.elementid];
        
        
        
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
    
    return stringToReturn;
}

-(NSArray*)classStructureOf:(NSMutableDictionary*)dyRow amongstElements:(NSArray*)sortedArray
{
    NSArray *elementsInsideRow = [self elementsInside:dyRow usingElements:sortedArray];
    NSMutableArray *array = [NSMutableArray array];
    NSString *parameter = [NSString string];
    for (NSDictionary*ele in elementsInsideRow) {
        if ([[ele objectForKey:@"tag"] isEqual:TEXT_INPUT_FIELD_TAG])
        {
            parameter = @" ";
        }
        if ([[ele objectForKey:@"tag"] isEqual:DROP_DOWN_MENU_TAG])
        {
            NSString *associatedModel = [ele objectForKey:ASSOCIATED_MODEL];
            NSString *dataSourceRef = [NSString stringWithFormat:@"self.%@[0]", associatedModel];
            parameter = dataSourceRef;
        }
        [array addObject:parameter];
    }
    
    return array;
    
}


@end
