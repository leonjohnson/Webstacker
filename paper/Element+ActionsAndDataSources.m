//
//  Element+ActionsAndDataSources.m
//  designer
//
//  Created by Leon Johnson on 12/01/2013.
//
//

#import "Element.h"
#import "DynamicRow.h"
#import "DropDown.h"
#import "Document.h"
#import "AppDelegate.h"






@implementation Element (ActionsAndDataSources)

// **** ROLE OF THE CODE BELOW IS TO TURN THE TEXT ENTERED INTO A DATASOURCE STRING AND/OR AN ACTION STRING. ****



-(void)setVisibilityActionStringEntered:(NSString *)theVisibilityActionStringEntered
{
    // This creates the string that will be saved as an iVar which will be used in the conversion script.
    // This does not have the full text 'data-bind=\"' so I can now chain data-binds to actions or dataSources more easily.
    self.visibilityActionStringEntered = [NSString stringWithFormat:@"visible: %@",theVisibilityActionStringEntered];
}


-(NSString *)actionCodeString
{    
    NSLog(@"starting point");
    NSString *actionsStringToReturn = [NSMutableString string];
    
    // Remove row
    if (([self.actionStringEntered caseInsensitiveCompare:@"Remove row"] == NSOrderedSame))
    {
        NSLog(@"IN REMOVE ROW");
        NSLog(@"ACTION STRING IS : %@", self.actionStringEntered);
        actionsStringToReturn = @"data-bind=\"click: $root.removeRow\"";
        return actionsStringToReturn;
    }
    
    
    
    // Add row
    if (([self.actionStringEntered caseInsensitiveCompare:@"Add row"] == NSOrderedSame)) //what if the dyRow element has an id of myRow and not row?
    {
        NSLog(@"grrh");
        // The default if 'add row' text found
        actionsStringToReturn = @"data-bind=\"click: addRow\"";
        
        // Now check if any 'max' or 'min' exists in the string entered
        NSString *substring = @"addRow";
        NSMutableString *copy = [NSMutableString stringWithString:self.actionStringEntered];
        [copy deleteCharactersInRange:NSMakeRange(0, 7)]; //The word Total has 7 characters in it including the space.
        
        NSPredicate *endsNumerically = [NSPredicate predicateWithFormat:@"SELF matches %@", @"\\d+$"];
        
        if ([endsNumerically evaluateWithObject:copy]) // returns TRUE if predicate succeeds
        {
            //get the last word in NSString
            __block NSString *lastWord = nil;
            [copy enumerateSubstringsInRange:NSMakeRange(0, [copy length]) options:NSStringEnumerationByWords | NSStringEnumerationReverse usingBlock:^(NSString *substring, NSRange subrange, NSRange enclosingRange, BOOL *stop) {
                lastWord = substring;
                *stop = YES;
            }];
            
            
            if ( ([copy hasPrefix:@"min"] || [copy hasPrefix:@"max"] ) && [endsNumerically evaluateWithObject:copy] )
            {
                NSString *mathSign = @"";
                if ([copy hasPrefix:@"min"])
                {
                    mathSign = @">";
                }
                if ([copy hasPrefix:@"max"])
                {
                    mathSign = @"<";
                }
                
                // 'enable: xxx' - the xxx represents the variable that represents the row - in this case self.seats()
                DynamicRow *rowImIn = [self dynamicRowForElement:self];
                
                if (rowImIn != nil)
                {
                    NSString *tagForRow = [rowImIn elementid];
                    
                    NSString *visibilityCodeString = @"";
                    if (self.visibilityActionStringEntered != nil)
                    {
                        visibilityCodeString = [NSString stringWithFormat:@"%@, ", self.visibilityActionStringEntered];
                    }
                    
                    actionsStringToReturn = [NSString stringWithFormat:@"data-bind=\"click: %@, enable: %@().length %@ %@%@\"", substring, tagForRow, mathSign, lastWord, visibilityCodeString];
                }
                
                
               
            }
        }
        NSLog(@"Returning : %@", actionsStringToReturn);
        return actionsStringToReturn;
    }
    
    
    if ([self.actionStringEntered isEqualToString:@"toggle"])
    {
        // actionsStringToReturn = 
        // enter jQuery string here
        // if string starts with 'jquery' then the stageView should pass this straight to the jsCode string and not include this as part of the knockout inline html code. This element should have a class of 'js-element12'.
        actionsStringToReturn = @"jquery toogle";
        return actionsStringToReturn;
    }
    
    
    
    return actionsStringToReturn;
    
}



-(NSString *)dataSourceCodeString
{
    NSLog(@"being called ??");
    NSString *dataSourceCodeStringToReturn = [NSMutableString string];
    
    // The generic response
    NSString *startOfDataSourceCode = @"data-bind=\"text: ";
    dataSourceCodeStringToReturn = [NSString stringWithFormat:@"%@%@ \"", startOfDataSourceCode, self.dataSourceStringEntered]; 
    
    
    // Overwrite with the following specific cases if relevant...
    
    // Total numberic values of a given parameter in a class e.g. Total Surchage.
    if ([self.dataSourceStringEntered hasPrefix:@"Total"]) //TODO: make this upper or lowercase // Could be Totalsurcharge
    {
        NSString *substring = @"total";
        NSMutableString *copy = [NSMutableString stringWithString:self.dataSourceStringEntered];
        [copy deleteCharactersInRange:NSMakeRange(0, 5)]; //The word Total has 5 characters in it.
        [copy capitalizedStringWithLocale:[NSLocale currentLocale]]; // TODO: Trim whitespace around this string.
        
        //Join the two words together
        NSMutableString *stringToReturn = [NSMutableString string];
        [stringToReturn appendString:substring]; // 'total'
        [stringToReturn appendString:copy]; //'Surchage' for example
        
        dataSourceCodeStringToReturn = [NSString stringWithFormat:@"%@%@().toFixed(2) \"", startOfDataSourceCode, stringToReturn];
    }
    
    NSString *visibilityCodeString = @"";
    if (self.visibilityActionStringEntered != nil)
    {
        visibilityCodeString = [NSString stringWithFormat:@"%@, ", self.visibilityActionStringEntered];
    }
    
    // DROP DOWN MENU
    if ([self isMemberOfClass:[DropDown class]])
    {
        //PURPOSE: THIS GOES AND GETS THE DATASOURCE STRING TO BE APPENDED TO THE DROPDOWN MENU.
        //so firstly, I need to find the dataSource created that has '[block valueForKey:@"dataSource"]' as one of its keys.
        // Within each app, each key must be unique

        NSString *dataSourceName = [self dataSourceNameContainingKey:self.dataSourceStringEntered];
        dataSourceCodeStringToReturn = [NSString stringWithFormat: @"options:$root.%@, optionsText: \'%@\', value: %@",
                                        dataSourceName,
                                        self.dataSourceStringEntered,
                                        self.elementid];

    }
    
    
    return dataSourceCodeStringToReturn;
}



-(DynamicRow*)dynamicRowForElement: (Element*)elementToTest
{
    DynamicRow *dyRow = nil;
    Document *curDoc = [[NSDocumentController sharedDocumentController] currentDocument];
    id viewToTest = elementToTest;
    
    
    while (viewToTest != nil && viewToTest != curDoc.stageView ) // removed '&& ![viewToTest isMemberOfClass:[DynamicRow class]]'
    {
        if ( [viewToTest isMemberOfClass:[DynamicRow class]] )
        {
            dyRow = viewToTest;
            return dyRow;
        }
        else
        {
            viewToTest = [viewToTest superview];
        }        
    }
    NSLog(@"ERROR - ERROR - ERROR : Returning a nil based dyRow");
    return dyRow;
}



-(NSMutableArray *)dataSourceUsingHardcodedLocalValues
// purpose is to create the JSON data needed to act as a dataSource
// created from hardcoded values locally in the dataSource creator

{
    // get the master dataSource object
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSMutableArray *dataModels = [NSMutableArray new];
    __block NSString *dataSourceAsJSON = [NSString new];
    
    for (NSDictionary *dict in appDelegate.arrayDataSource)
    {
        
        NSMutableString *dataModel = [NSMutableString new];
        
        /*
         Package this into a dictionary for easy conversion into json string:
         
         { mealName: "Standard (sandwich)", price: 0 },
         { mealName: "Premium (lobster)", price: 34.95 },
         { mealName: "Ultimate (whole zebra)", price: 290 }
         
         */
        // each dataSource is made up of arrays
        
        [appDelegate.arrayDataSource enumerateObjectsUsingBlock:^(id dictionarys, NSUInteger index, BOOL *stop)
        {
            NSLog(@"dictionarys is : %@", dictionarys);
            NSString *dataSourceName = [dictionarys objectForKey:@"Name"];
            NSArray *dataSourceArray = [dictionarys objectForKey:@"DataSource"];
            NSLog(@"ds = %@", dataSourceArray);
            NSArray *headerTitles = [dataSourceArray objectAtIndex:0]; // This is the header information.
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            NSLocale *l_en = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
            [f setLocale: l_en];
            [f setAllowsFloats: YES];
            
            NSLog(@"here");
            
            for (NSArray *row in dataSourceArray)
            {
                if ([dataSourceArray indexOfObject:row] > 0) // not the first item
                {
                    NSMutableArray *dataModelRow = [NSMutableArray new];
                    NSUInteger headerTitlesCount = [headerTitles count];
                    NSLog(@"here3");
                    for (NSString *title in headerTitles)
                    {
                        
                        BOOL firstObject = NO;
                        BOOL lastObject = NO;
                        NSLog(@"here4");
                        NSUInteger indexa = [headerTitles indexOfObject:title];
                        if (headerTitlesCount == indexa+1)
                        {
                            // This is the last
                            lastObject = YES;
                        }
                        if (indexa == 0)
                        {
                            // This is the first
                            firstObject = YES;
                        }
                        
                        NSLog(@"here5");
                        NSString *stringToInsert = [row objectAtIndex:indexa];
                        NSNumber *possibleNumber = [f numberFromString: stringToInsert];
                        NSMutableString *subRow = [NSMutableString new];
                        if (possibleNumber != nil)
                        {
                            subRow =  [NSMutableString stringWithString:[NSString stringWithFormat:@" %@: %@ ",title,possibleNumber]];
                        }
                        else
                        {
                           subRow =  [NSMutableString stringWithString:[NSString stringWithFormat:@" %@: \"%@\"",title,[row objectAtIndex:indexa]]];
                        }
                        
                        if (firstObject) {
                            [subRow insertString:@"{" atIndex:0];
                        }
                        if (lastObject) {
                            NSLog(@"IN HEREEE");
                            [subRow insertString:@"}" atIndex:[subRow length]-1];
                            
                        }
                        NSLog(@"here6 : %@", subRow);
                        [dataModelRow addObject:subRow];
                    }
                    NSString *dataModelRowString = [dataModelRow componentsJoinedByString:@","];
                    NSLog(@"here7 : %@", dataModelRowString);
                    [dataModel stringByAppendingString:dataModelRowString];
                }
                
            }
            NSString *dataModelAsAString = [NSString stringWithFormat:@"self.%@ = [ \n %@ ];", dataSourceName, dataModel];
            NSLog(@"here10 : %@", dataModelAsAString);
            /* convert it to JSON for knockout
            if ([NSJSONSerialization isValidJSONObject:dataModel])
            {
                NSError *errorObject;
                NSData *data = [NSJSONSerialization dataWithJSONObject:dataModel
                                                         options:0
                                                           error:&errorObject];
                dataSourceAsJSON = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            };
             
            [dataModels addObject:dataSourceAsJSON];
             */
            [dataModels addObject:dataModelAsAString];
            NSLog(@"12 : %@", dataModels);
            
        } ];
        
        
        
    }
    
    return dataModels;
    
}


-(NSString*)dataSourceNameContainingKey: (NSString *)dataSourceKey
    // ASSUMPTION: THAT EVERY DATASOURCE HEADER ENTERED IS UNIQUE PER DOCUMENT.
    // Method parameter: dataSourceKeyThis is the name of a header to make it easy for the user rather than typing dataSourceName.HeaderTitle
{
    NSString *stringToReturn = [NSString new];
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    for (NSDictionary *dict in appDelegate.arrayDataSource)
    {
        // each dataSource is made up of arrays
        //NSString *nameOfDataSource = [dict objectForKey:@"Name"];
        NSLog(@"here13");
        NSArray *dataSourceArray = [dict objectForKey:@"DataSource"];
        NSLog(@"here14");
        NSArray *headerTitles = [dataSourceArray objectAtIndex:0]; // This is the header information.
        NSLog(@"here15");
        for (NSString *header in headerTitles)
        {
            if ([header isEqualToString:dataSourceKey]) {
                NSLog(@"Gotcha!");
                return [dict objectForKey:@"Name"]; // This is a string that was entered by the user into the Name field of the DataSource window.
            }
        }
    }
	
	NSLog(@"here16");
    return stringToReturn;
}


-(NSString*)modelNameContainingAttribute: (NSString *) attribute
{
    // get the model 'seat' that contains a variable called 'attribute'.
    // Model is represented as a dataSource.
    
    /*
        Look through each dataSources headers for 'mealNames', if not there then look through each headers values which be availableMeals and look through it's variables. If found return the name of that Model.
     */
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSDictionary *dataSourceWithThisKey = [self dataSourceNameContainingKey:attribute];
    NSMutableArray *arrayToSearchThrough = [dataSourceWithThisKey objectForKey:@"DataSource"];
    NSArray *headerTitles = [arrayToSearchThrough objectAtIndex:0]; //header info
    for (NSString *header in headerTitles)
    {
        if ([header isEqualToString:attribute]) {
            return [dataSourceWithThisKey objectForKey:@"Name"];
        }
    }
    NSLog(@"I could not find a DataSource with a header/variable of %@... but let's keep looking.", attribute);
    
    
    // look through each headers values which be availableMeals and look through it's variables. If found return the name of that Model.
    [arrayToSearchThrough removeObjectAtIndex:0]; // remove the headers and we now only search through the one row remaining (most probably
    /*
    for (NSArray *array in arrayToSearchThrough)
    {
        for (NSString *value in array) 
     {
            if ([value isEqualToString:attribute])
            {
                return <#expression#>
            }
        }
    }
     */
    
    return @"";
    
    
}


/*
 NOTES:
 The conversion process needs to ensure that firstly I inspect the dynamic row and then write code that says each row represents a 'Seat' which goes incside of the seats array.
 Therefore a for loop will have 'foreach: seats'.
 Once I know that I can say if the dyRow contains a Seat Class then look for the Seat Model, check its headers, if not present then check array[1]
 */







-(NSString*)classFromDynamicRow
{
    NSString *stringToReturn = nil;
    if ([self isMemberOfClass:[DynamicRow class]])
    {
        // If you create a dataSource, you automatically get an observableArray, the ability to add a row, and delete a row. These are standard.
        NSString *className = [NSString stringWithFormat:@"function ReservationsViewModel() {\n"];
        NSString *selfStatement = @"    var self = this;\n    // Non-editable catalog data\n    ";
        NSString *model = [NSString stringWithFormat:@"%@", [[self dataSourceUsingHardcodedLocalValues] objectAtIndex:0]];
        NSString *observableArrayName = [NSString stringWithFormat:@"%@s", self.elementid]; // lowercase elementid with an s on the end so 'seats'
        NSMutableString *observableArray = [NSString stringWithFormat:@"//Editable Data\n self.%@ = ko.observableArray([]);", observableArrayName];
        NSString *addRow1 = @"// Operatsions\n self.addRow = function() {\n";
        NSMutableString *addRow2 = [NSMutableString stringWithFormat:@"%@ self.%@.push(new %@());\n}"];
        NSMutableString *deleteRow = [NSString stringWithFormat:@"//Editable Data\n self.%@ = ko.observableArray([]);", observableArrayName];
        
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
    
    return stringToReturn;
}












@end