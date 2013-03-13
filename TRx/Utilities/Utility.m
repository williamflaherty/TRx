
#import "Utility.h"

@implementation Utility

+(NSString *) getDatabasePath
{
    
     NSString *databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    
    return databasePath; 
}

@end
