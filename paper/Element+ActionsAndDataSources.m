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






















@end