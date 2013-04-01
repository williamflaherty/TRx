
#import <Foundation/Foundation.h>
#import "AppDelegate.h" 

@interface Utility : NSObject
{
    
}

+(NSString *) getDatabasePath; 
+(void)alertWithMessage:(NSString *)message;
+(NSString *) urlEncodeData:(NSString *)str;
@end
