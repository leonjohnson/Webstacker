//
//  NSMutableArray+addBuilderScreenOptions.m
//  designer
//
//  Created by Leon Johnson on 07/04/2013.
//
//
#import "NSMutableArray+addBuilderScreenOptions.h"
#import "Common.h"

@implementation NSDictionary (addBuilderScreenOptions)

+(NSDictionary*)addStatement:(id)anObject icon:(NSImage*)icon elementid:(NSString*)elementid documentation:(NSString*)doc
{
    NSMutableDictionary *parameterArray = [NSMutableDictionary new];

    
    if (anObject == nil)
        [parameterArray setObject:[NSNull null] forKey:STATEMENT];
    else
        [parameterArray setObject:anObject forKey:STATEMENT];
    
    
    
    if (icon == nil)
        [parameterArray setObject:[NSNull null] forKey:ICON];
    else
        [parameterArray setObject:icon forKey:ICON];
    
    
    
    if (elementid == nil)
        [parameterArray setObject:[NSNull null] forKey:ELEMENT_ID];
    else
        [parameterArray setObject:elementid forKey:ELEMENT_ID];

    
    
    if (doc == nil)
        [parameterArray setObject:[NSNull null] forKey:DOCUMENTATION];
    else
        [parameterArray setObject:doc forKey:DOCUMENTATION];
    
    
    
    return [NSDictionary dictionaryWithDictionary:parameterArray];
}


@end
