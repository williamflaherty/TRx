//
//  LocalTalk.m
//  TRx
//
//  Created by John Cotham on 3/10/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "LocalTalk.h"
#import "DBTalk.h"

@implementation LocalTalk
+(BOOL)loadPatientRecord:(NSString *)recordId
{
    NSArray *recordInfo = [DBTalk getRecordData:recordId];
    
    if (recordInfo == NULL) {
        NSLog(@"Error retrieving patient record for recordId: %@", recordId);
        return false;
    }
    //iterate through dictionaries of recordInfo and load into sqlite
    return true;
}
@end
