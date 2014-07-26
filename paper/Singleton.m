#import "Singleton.h"

@implementation Singleton

@synthesize currentElement;
@synthesize mynumber;
@synthesize contextref;
@synthesize lastSelectedFont;


static Singleton *sharedSingletonManager = nil;

+ (Singleton*)sharedInstance
{
    if (sharedSingletonManager == nil) 
    {
        sharedSingletonManager = [[super allocWithZone:NULL] init];
    }
    return sharedSingletonManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

-(id)init
{
    mynumber = [NSNumber numberWithInt:101];
    lastSelectedFont = [NSFont fontWithName:@"Helvetica" size:12];
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}



@end
