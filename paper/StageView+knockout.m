#import "Element.h"
#import "DynamicRow.h"
#import "DropDown.h"
#import "Document.h"
#import "AppDelegate.h"
#import "TextInputField.h"
#import "TextBox.h"
#import "StageView.h"
#import "StageView+conversion.m"

@implementation StageView (knockout)


// PURPOSE: Generate the ViewModel
-(NSString*)viewModelFrom:(NSMutableDictionary*)dyRow amongstElements:(NSArray*)sortedArray
{
    NSMutableString *stringToReturn = nil;
    if ([[dyRow objectForKey:@"tag"] isEqualTo:DYNAMIC_ROW_TAG])
    {
        // The Model
        // If you create a dataSource, you automatically get an observableArray, the ability to add a row, and delete a row. These are standard.
        NSString *className = [NSString stringWithFormat:@"\nfunction ReservationsViewModel() {\n"];
        NSString *selfStatement = @"    var self = this;\n\n    // Non-editable catalog data\n    ";
        NSArray *datasource = [self dataSourceUsingHardcodedLocalValues];
        if ([datasource count]  < 1) {
            return nil;
        }
        NSString *model = [NSString stringWithFormat:@"%@", [[self dataSourceUsingHardcodedLocalValues] objectAtIndex:0]];
        
        // Editable data
        NSString *observableArrayName = [NSString stringWithFormat:@"%@s", [dyRow objectForKey:@"id"]]; // lowercase elementid with an s on the end so 'seats'
        [dyRow setObject:observableArrayName forKey:OBSERVABLE_NAME_ARRAY];
        NSMutableString *observableArrayAsAString = [NSString stringWithFormat:@"\n//Editable Data\n self.%@ = ko.observableArray([]);", observableArrayName];
        
        // Operations
        NSMutableDictionary *rtFrameDictionary = [NSMutableDictionary dictionaryWithObject:[dyRow objectForKey:RT_FRAME] forKey:RT_FRAME];
        NSString *classStructureAsString = [self classStructureOf:rtFrameDictionary amongstElements:sortedArray];
        NSString *addRow1 = @"\n\n    // Operations\n self.addRow = function() {\n";
        NSMutableString *addRow2 = [NSMutableString stringWithFormat:@"self.%@.push(new %@(%@));\n}", observableArrayName, [[dyRow objectForKey:@"id"] capitalizedString], classStructureAsString];
        NSMutableString *deleteRow = [NSString stringWithFormat:@"\n    self.removeRow = function(%@) { self.%@.remove(%@) }\n    }\n\n", [dyRow objectForKey:@"id"], observableArrayName, [dyRow objectForKey:@"id"]];
        
        
        // Total function : Total numberic values of a given parameter in a class e.g. Total Surchage.
        NSMutableString *totalAnyNumericSetOfValuesInAModel = [NSMutableString string];
        if ([[dyRow objectForKey:DATA_SOURCE_STRING_ENTERED] hasPrefix:@"Total"]) //TODO: make this upper or lowercase // Could be Totalsurcharge
        {
            // Take the first word, and the second word (assumption: there are just two words)
            NSString *substring = @"total";
            NSMutableString *copy = [NSMutableString stringWithString:[dyRow objectForKey:DATA_SOURCE_STRING_ENTERED]];
            [copy deleteCharactersInRange:NSMakeRange(0, 5)]; //The word Total has 5 characters in it.
            [copy capitalizedStringWithLocale:[NSLocale currentLocale]]; // TODO: Trim whitespace around this string.
            
            //Join the two words together
            NSMutableString *nameOfTotal = [NSMutableString string];
            [nameOfTotal appendString:substring]; // 'total'
            [nameOfTotal appendString:copy]; //'Surchage' for example
            
            // Function to compute numeric totals
            totalAnyNumericSetOfValuesInAModel = [NSMutableString stringWithFormat:@"    // Computed data \n    self.%@ = ko.computed(function() { \n var total = 0; \n for (var i = 0; i < self.%@().length; i++) \n // meal2 is the id of the dropdown menu \n total += self.%@()[i].%@().%@; \n return total; \n});\n \n", nameOfTotal, observableArrayName, observableArrayName, @"chosenOption", copy];
            
        }
        
        // -(NSString *)dataSourceBindingCode: (Element*)ele
        
        // Put the string together
        stringToReturn = [NSMutableString new];
        [stringToReturn appendString:className];
        [stringToReturn appendString:selfStatement];
        [stringToReturn appendString:model];
        [stringToReturn appendString:observableArrayAsAString];
        [stringToReturn appendString:addRow1];
        [stringToReturn appendString:addRow2];
        [stringToReturn appendString:deleteRow];
        [stringToReturn appendString:totalAnyNumericSetOfValuesInAModel];
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
    NSLog(@"Model generated. : %@", stringToReturn);
    return stringToReturn;
}



// PURPOSE: Generate the Class
-(NSString*)generateClassFromDynamicRow: (NSMutableDictionary*)dyRowDict withElementsOnStage: (NSArray*)sortedArrayOnStage
{
    NSLog(@"starting class generation");
    //NSString *stringContainingClass = [NSString string];
    NSArray *elementsInsideMe = [self elementsInside:dyRowDict usingElements:sortedArrayOnStage];
    NSMutableArray *elementsInsideMeIDs = [NSMutableArray array];
    for (NSDictionary *ele in elementsInsideMe)
    {
        [elementsInsideMeIDs addObject:[ele objectForKey:@"id"]];
    }
    NSMutableString *openingString = [NSMutableString stringWithFormat:@"function %@(", [[dyRowDict objectForKey:@"id"] capitalizedString]];
    NSMutableString *classArray = [NSMutableString string];
    
    NSLog(@"Next loop");
    for (NSMutableDictionary *ele in elementsInsideMe)
    {
        // Firstly I need to check if this item has an action and/or a dataSource.
        // If so, then send the ds keyword to dataSourceStringForKeyword
        
        // check if this element is a plain text field, if so then filter out.
        // I only want elements that are capturing information or calculating a result.
        
        
        if ([ele objectForKey: DATA_SOURCE_STRING_ENTERED] == nil)
        {
            if ( [[ele objectForKey:@"tag"] isEqualTo:[TextBox class]] )
            {
                // the crap we don't want. These are text labels etc.
            }
            else
            {
                // so it doesn't have a dataSource but it's not a plain old textField used for labelling.
                [classArray appendString:[NSString stringWithFormat:@"self.%@ = %@;\n", [ele objectForKey:@"id"], [ele objectForKey:@"id"]]];
                
                // and add the elements elementID to the function definition
                [openingString appendString:[NSString stringWithFormat:@"%@,", [ele objectForKey:@"id"]]];
                
            }
        }
        else //So this element has a dataSource
        {
            
            NSString *dsString = [self dataSourceStringForElement:ele sittingAmongstElementIDs:elementsInsideMeIDs];
            [classArray appendString:dsString];
            
            // if dataSource is based solely off of an element that is is this dyRow then no parameter is needed and string is self.meal2().price e.g.
        }
        
    }
    NSLog(@"closing class generation");
    [openingString substringToIndex:[openingString length]-1]; // clean up, we remove the comma left over at the end
    [openingString appendString:@") {\n"];
    [classArray appendString:@"}\n"];
    [openingString appendString:classArray];
    [openingString appendString:@"\n\n\n"];
    
    // IF ANY ELEMENT USES DATASOURCE, THEN THE CONTROL THAT REPRESENTS THE DATASOURCE MUST BE KO.OBSERVABLE
    
    NSLog(@"Class generated done : %@", openingString);
    return openingString;
}




// PURPOSE: Return an array describing the parameters for the Model
-(NSString*)classStructureOf:(NSMutableDictionary*)dyRow amongstElements:(NSArray*)sortedArray
{
    NSArray *elementsInsideRow = [self elementsInside:dyRow usingElements:sortedArray];
    NSMutableArray *array = [NSMutableArray array];
    NSString *parameter = [NSString string];
    for (NSDictionary*ele in elementsInsideRow) {
        if ([[ele objectForKey:@"tag"] isEqual:TEXT_INPUT_FIELD_TAG])
        {
            parameter = @"\"\"";
        }
        if ([[ele objectForKey:@"tag"] isEqual:DROP_DOWN_MENU_TAG])
        {
            NSString *associatedModel = [ele objectForKey:ASSOCIATED_MODEL];
            NSString *dataSourceRef = [NSString stringWithFormat:@"self.%@[0]", associatedModel];
            parameter = dataSourceRef;
        }
        [array addObject:parameter];
    }
    NSString *classStructureAsString = [array componentsJoinedByString:@", "];
    classStructureAsString = [classStructureAsString substringFromIndex:2];
    NSLog(@"CLASS STRUCTURE IS : %@", classStructureAsString);
    return classStructureAsString;
    
}







// PURPOSE: Generate each line of the Model.
-(NSString*)dataSourceStringForElement:(NSMutableDictionary*)ele sittingAmongstElementIDs: (NSArray*)elementsIDs
{
    // TODO: Once up and running check the validation tab to ensure this method generates code that considers the validation rules entered by the user.
    
    // Should be returning something like: [NSString stringWithFormat:@"self.%@ = ko.observable(%@);\n", ele.elementid, ele.elementid]
    
    // All we know is that the element has a dataSource.
    NSMutableString *codeStringToReturn = [NSMutableString string];
    NSLog(@"SEE WHAT ELE IS : %@", ele);
    if ([[ele objectForKey:@"tag"] isEqualTo:DROP_DOWN_MENU_TAG])
    {
        NSLog(@"DROP DOWN WITH KO");
        return [NSString stringWithFormat:@"self.%@ = ko.observable(%@);\n", [ele objectForKey:@"id"], [ele objectForKey:@"id"]];
    }
    
    else if ( [[ele objectForKey:@"tag"] isEqualTo:TEXT_INPUT_FIELD_TAG] )
    {
        NSArray *wordsSeperatedBySpaces = [[ele objectForKey:DATA_SOURCE_STRING_ENTERED] componentsSeparatedByString:@" "];
        NSString *firstWord = [wordsSeperatedBySpaces objectAtIndex:0];
        NSString *secondWord = [wordsSeperatedBySpaces objectAtIndex:1];
        
        for (NSString *anID in elementsIDs)
        {
            if ([firstWord isEqualToString:anID])// FIRST WORD IS EQUAL TO A eleid OF AN ELEMENT IN THIS DY ROW e.g. 'meal2 price'
            {
                //THEN TAKE THE SECOND WORD 'PRICE' AND CREATE THE STRING AS PER MONEY3.html
                codeStringToReturn = [NSMutableString stringWithFormat:@"self.%@ = ko.computed(function() {\n var %@ = self.%@().%@; \n return %@ ? \"$\" + %@.toFixed(2) : \"None\"; \n });", [ele objectForKey:@"id"], secondWord, firstWord, secondWord, secondWord, secondWord];
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
        codeStringToReturn = [NSString stringWithFormat:@"self.%@ = %@;\n", [ele objectForKey:@"id"], [ele objectForKey:@"id"]];
    }
    
    return codeStringToReturn;
}





// PURPOSE: To generate code from the entered dataSource that sits inline with HTML tags.
-(NSString *)dataSourceBindingCode: (Element*)ele
{
    NSLog(@"being called ??");
    NSString *dataSourceCodeStringToReturn = [NSMutableString string];
    
    // The generic response
    NSString *startOfDataSourceCode = @"data-bind=\"text: ";
    dataSourceCodeStringToReturn = [NSString stringWithFormat:@"%@%@ \"", startOfDataSourceCode, ele.dataSourceStringEntered];
    
    
    // Overwrite with the following specific cases if relevant...
    
    // Total numberic values of a given parameter in a class e.g. Total Surchage.
    if ([ele.dataSourceStringEntered hasPrefix:@"Total"]) //TODO: make this upper or lowercase // Could be Totalsurcharge
    {
        NSString *substring = @"total";
        NSMutableString *copy = [NSMutableString stringWithString:ele.dataSourceStringEntered];
        [copy deleteCharactersInRange:NSMakeRange(0, 5)]; //The word Total has 5 characters in it.
        [copy capitalizedStringWithLocale:[NSLocale currentLocale]]; // TODO: Trim whitespace around this string.
        
        //Join the two words together
        NSMutableString *stringToReturn = [NSMutableString string];
        [stringToReturn appendString:substring]; // 'total'
        [stringToReturn appendString:copy]; //'Surchage' for example
        
        dataSourceCodeStringToReturn = [NSString stringWithFormat:@"%@%@().toFixed(2) \"", startOfDataSourceCode, stringToReturn];
    }
    
    NSString *visibilityCodeString = @"";
    if (ele.visibilityActionStringEntered != nil)
    {
        visibilityCodeString = [NSString stringWithFormat:@"%@, ", ele.visibilityActionStringEntered];
    }
    
    // DROP DOWN MENU
    if ([ele isMemberOfClass:[DropDown class]])
    {
        //PURPOSE: THIS GOES AND GETS THE DATASOURCE STRING TO BE APPENDED TO THE DROPDOWN MENU.
        //so firstly, I need to find the dataSource created that has '[block valueForKey:@"dataSource"]' as one of its keys.
        // Within each app, each key must be unique
        
        NSString *dataSourceName = [self dataSourceNameContainingKey:ele];
        dataSourceCodeStringToReturn = [NSString stringWithFormat: @"data-bind=\"options: $root.%@, optionsText: \'%@\', value: %@\"",
                                        dataSourceName,
                                        ele.dataSourceStringEntered,
                                        @"chosenOption"]; // the last choice was 'ele.elementid'but to make sure viewModel method can set the matching name, I've just used a static string.
        
    }
    
    
    return dataSourceCodeStringToReturn;
}






// PURPOSE: To generate code from the entered action that sits inline with HTML tags.
-(NSString *)actionCodeString: (Element*)ele
{
    NSLog(@"starting point");
    NSString *actionsStringToReturn = [NSMutableString string];
    
    // Remove row
    if (([ele.actionStringEntered caseInsensitiveCompare:@"Remove row"] == NSOrderedSame))
    {
        NSLog(@"IN REMOVE ROW");
        NSLog(@"ACTION STRING IS : %@", ele.actionStringEntered);
        actionsStringToReturn = @"data-bind=\"click: $root.removeRow\"";
        return actionsStringToReturn;
    }
    
    
    // Add row
    if (([ele.actionStringEntered caseInsensitiveCompare:@"Add row"] == NSOrderedSame)) //what if the dyRow element has an id of myRow and not row?
    {
        NSLog(@"grrh");
        // The default if 'add row' text found
        actionsStringToReturn = @"data-bind=\"click: addRow\"";
        
        // Now check if any 'max' or 'min' exists in the string entered
        NSString *substring = @"addRow";
        NSMutableString *copy = [NSMutableString stringWithString:ele.actionStringEntered];
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
                DynamicRow *rowImIn = [self dynamicRowForElement:ele];
                
                if (rowImIn != nil)
                {
                    NSString *tagForRow = [rowImIn elementid];
                    
                    NSString *visibilityCodeString = @"";
                    if (ele.visibilityActionStringEntered != nil)
                    {
                        visibilityCodeString = [NSString stringWithFormat:@"%@, ", ele.visibilityActionStringEntered];
                    }
                    
                    actionsStringToReturn = [NSString stringWithFormat:@"data-bind=\"click: %@, enable: %@().length %@ %@%@\"", substring, tagForRow, mathSign, lastWord, visibilityCodeString];
                }                
                
            }
        }
        NSLog(@"Returning : %@", actionsStringToReturn);
        return actionsStringToReturn;
    }
    
    
    if ([ele.actionStringEntered isEqualToString:@"toggle"])
    {
        // actionsStringToReturn =
        // enter jQuery string here
        // if string starts with 'jquery' then the stageView should pass this straight to the jsCode string and not include this as part of the knockout inline html code. This element should have a class of 'js-element12'.
        actionsStringToReturn = @"jquery toogle";
        return actionsStringToReturn;
    }
    
    
    
    return actionsStringToReturn;
    
}




// PURPOSE: Tell me which dyRow this element is inside.
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





// PURPOSE: is to create the JSON data needed to act as a dataSource
// created from hardcoded values locally in the dataSource creator
-(NSMutableArray *)dataSourceUsingHardcodedLocalValues

{
    // get the master dataSource object
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSMutableArray *dataModels = [NSMutableArray new];
    //__block NSString *dataSourceAsJSON = [NSString new];
    
    for (NSDictionary *dict in appDelegate.arrayDataSource)
    {
        
        
        
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
             
             NSMutableString *dataModel = [NSMutableString new];
             for (NSArray *row in dataSourceArray)
             {
                 if ([dataSourceArray indexOfObject:row] > 0) // not the first item
                 {
                     NSMutableArray *dataModelRow = [NSMutableArray new];
                     NSUInteger headerTitlesCount = [headerTitles count];
                     NSLog(@"here3");
                     NSUInteger numOfLoops = [dataSourceArray count];
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
                     [dataModel appendString:dataModelRowString];
                     
                     NSUInteger thisIteration = [dataSourceArray indexOfObject:row]+1;
                     
                     if (numOfLoops != thisIteration)
                     {
                         [dataModel appendString:@",\n"];
                     }
                 }
                 
             }
             NSString *dataModelAsAString = [NSString stringWithFormat:@"self.%@ = [\n %@\n];", dataSourceName, dataModel];
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

// PURPOSE: Get the name of the dataSource that contains a given column name such as 'mealName'.
// ASSUMPTION: THAT EVERY DATASOURCE HEADER ENTERED IS UNIQUE PER DOCUMENT.
// Method parameter: dataSourceKeyThis is the name of a header to make it easy for the user rather than typing dataSourceName.HeaderTitle
-(NSString*)dataSourceNameContainingKey: (Element*)ele
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
            if ([header isEqualToString:ele.dataSourceStringEntered]) {
                NSLog(@"Gotcha!");
                return [dict objectForKey:@"Name"]; // This is a string that was entered by the user into the Name field of the DataSource window.
            }
        }
    }
	
	NSLog(@"here16");
    return stringToReturn;
}

/*
-(NSString*)modelNameContainingAttribute: (NSString *) attribute
{
    // get the model 'seat' that contains a variable called 'attribute'.
    // Model is represented as a dataSource.
    
 
    // Look through each dataSources headers for 'mealNames', if not there then look through each headers values which be availableMeals and look through it's variables. If found return the name of that Model.
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    NSDictionary *dataSourceWithThisKey = [self dataSourceNameContainingKey:ele];
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
     
    
    //return @"";
    
    
}
*/

/*
 NOTES:
 The conversion process needs to ensure that firstly I inspect the dynamic row and then write code that says each row represents a 'Seat' which goes incside of the seats array.
 Therefore a for loop will have 'foreach: seats'.
 Once I know that I can say if the dyRow contains a Seat Class then look for the Seat Model, check its headers, if not present then check array[1]
 */
@end
