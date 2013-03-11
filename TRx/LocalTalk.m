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



+(BOOL)insertUpdatePatientData:(NSString *)questionId
                         value:(NSString *)value {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    NSString *query = [[NSString alloc] initWithFormat:
                 @"INSERT OR REPLACE INTO Patient (questionId, Values, Synched) values (%@, 0)", value];
    
    BOOL result = [db executeUpdate:query];
    if (!result) {
        NSLog(@"Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    return result;
}

+(BOOL)insertUpdateField:(NSString *)columnName
               tableName:(NSString *)tableName
              questionID:(NSString *)questionId
                   value:(NSString *)value {
    

}

/*---------------------------------------------------------------------------
 * Wrappers for getField :
 * A hopefully updated list of questionId's is in Google Drive 
 * Returns label text as NSString
 *---------------------------------------------------------------------------*/
+(NSString *)getValue:(NSString *)questionId {
    return [self getField:@"Value" tableName:@"Patient" questionId:questionId];
}
+(NSString *)getEnglishLabel:(NSString *)questionId {
    return [self getField:@"English" tableName:@"Questions" questionId:questionId];
}
+(NSString *)getSpanishLabel:(NSString *)questionId {
    return [self getField:@"Spanish" tableName:@"Questions" questionId:questionId];
}

/*---------------------------------------------------------------------------
 * Function that gets the value of a single field from tables in LocalDatabase
 * Returns label text as NSString
 *---------------------------------------------------------------------------*/
+(NSString *)getField:(NSString *)columnName
            tableName:(NSString *)tableName
           questionId:(NSString *)questionId {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    NSString *query = [[NSString alloc] initWithFormat:
                       @"SELECT %@ FROM %@ WHERE QuestionId = \"%@\"", columnName, tableName, questionId];

    FMResultSet *results = [db executeQuery:query];
    
    if (!results) {
        NSLog(@"%@", [db lastErrorMessage]);;
        return nil;
    }
    [results next];
    return [results stringForColumnIndex:0];
}


+(BOOL)loadPatientRecord:(NSString *)recordId {
    
    NSArray *recordInfo = [DBTalk getRecordData:recordId];
    if (recordInfo == NULL) {
        NSLog(@"Error retrieving patient record for recordId: %@", recordId);
        return false;
    }
    //iterate through dictionaries of recordInfo and load into sqlite
    return true;
}


@end
