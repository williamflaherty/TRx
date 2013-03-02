//
//  DBTalk.m
//  TRx
//
//  Created by John Cotham on 2/24/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "DBTalk.h"

@implementation DBTalk

static NSString *host = nil;

+(void)initialize
{
    host = @"http://localhost:8888/TRxTalk/index.php/";
}


+(NSString *)addPatient:(NSString *)firstName: (NSString *)middleName: (NSString *)lastName:
(NSString *)birthday
{
    NSString *path = @"path";
    NSString *imageName = @"nameOfPicture";
    //NSString *url = [NSString stringWithFormat:@"%@TRxTalk/index.php/", host];
    NSString *encodedString = [NSString stringWithFormat:
                               @"%@add/addPatient/%@/%@/%@/%@/%@/%@", host,
                               firstName, middleName, lastName, birthday, path, imageName];
    
    NSLog(@"encodedString: %@", encodedString);
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];
    
    if (data) {
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSDictionary *dic = jsonArray[0];
        NSLog(@"Is getting patient data: %@\n", dic);
        NSString *retval = (NSString *)[dic objectForKey:@"@patientId"];
        NSLog(@"retval: %@\n", retval);
        NSLog(@"%@", jsonError);
        return retval;
    }
    return NULL;
}

+(NSString *)addRecord:(NSString *)patientId: (NSString *)surgeryTypeId
{
    
    NSString *encodedString = [NSString stringWithFormat:@"%@add/addRecord/%@/%@/%@/%@/%@", host,
                               patientId, surgeryTypeId, @"1", @"1", @"0"];
    NSLog(@"encodedString: %@", encodedString);
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedString]];
    
    if (data) {
        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        NSDictionary *dic = jsonArray[0];
        return [dic objectForKey:@"@recordId"];
    }
    return NULL;
}



-(BOOL)deletePatient: (NSString *)patientID
{
    return true;
}

/*void
 describeDictionary (NSDictionary *dict)
 {
 NSArray *keys;
 int i, count;
 id key, value;
 
 keys = [dict allKeys];
 count = [keys count];
 NSLog(@"In describeDictionary\n");
 for (i = 0; i < count; i++)
 {
 key = [keys objectAtIndex: i];
 value = [dict objectForKey: key];
 NSLog (@"Key: %@ for value: %@", key, value);
 }
 }*/

+(NSString *) urlEncodeData:(NSString *)str
{
    NSString *encodedString = (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)str,
                                            NULL,
                                            CFSTR("!*'();:@&=+$,/?%#[]"),
                                            kCFStringEncodingUTF8);
    return encodedString;
}


@end
