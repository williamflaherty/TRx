
#import "Utility.h"

@implementation Utility

+(NSString *) getDatabasePath
{
    
    NSString *databasePath;
    databasePath = [(AppDelegate *)[[UIApplication sharedApplication] delegate] databasePath];
    
    return databasePath; 
}

/*---------------------------------------------------------------------------
 * method pops alert message to screen
 *---------------------------------------------------------------------------*/
+(void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

/*---------------------------------------------------------------------------
 * method encodes and returns a string formatted to pass in a url
 *---------------------------------------------------------------------------*/
+(NSString *) urlEncodeData:(NSString *)str {
    NSString *encodedString = (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)str,
                                            NULL,
                                            CFSTR("!*'();:@&=+$,/?%#[]"),
                                            kCFStringEncodingUTF8);
    return encodedString;
}

@end
