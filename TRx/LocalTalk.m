//
//  LocalTalk.m
//  TRx
//
//  Created by John Cotham on 3/10/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "LocalTalk.h"
#import "DBTalk.h"
#import "FMDatabase.h"
#import "Utility.h"

@implementation LocalTalk




+(NSString *)getEnglishLabel:(NSString *)questionId {
    return [self getLabel:questionId columnName:@"English"];
}
+(NSString *)getSpanishLabel:(NSString *)questionId {
    return [self getLabel:questionId columnName:@"Spanish"];
}

+(NSString *)getLabel:(NSString *)questionId
           columnName:(NSString *)columnName {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    NSString *query = [[NSString alloc] initWithFormat:
                       @"SELECT %@ FROM Questions WHERE QuestionId = \"%@\"", columnName, questionId];

    FMResultSet *results = [db executeQuery:query];
    
    if (!results) {
        NSLog(@"%@", [db lastErrorMessage]);;
        return nil;
    }
    [results next];
    return [results stringForColumnIndex:0];
}


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
