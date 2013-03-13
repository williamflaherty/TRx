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


+(BOOL)localStoreRecordId:(NSString *)recordId {
    return [self localStoreValue:recordId forQuestionId:@"recordId"];
}

+(BOOL)localStorePatientId:(NSString *)patientId {
    return [self localStoreValue:patientId forQuestionId:@"patientId"];
}
+(BOOL)localStoreValue:(NSString *)value forQuestionId:(NSString *)questionId {
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    //NSString *insert = [NSString stringWithFormat:
                      //  @"INSERT INTO Patient (QuestionId, Value, Synched) VALUES (?, ?, 0)", questionId, value];
    return [db executeUpdate:@"INSERT INTO Patient (QuestionId, Value, Synched) VALUES (\"%@\", \"%@\", 0)", questionId, value];
}


+(NSString *)localGetPatientId {
    return [self localGetValueForQuestionId:@"patientId"];
}
+(NSString *)localGetRecordId {
    return [self localGetValueForQuestionId:@"recordId"];
}

+(NSString *)localGetValueForQuestionId:(NSString *)questionId {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    NSString *query = [NSString stringWithFormat:@"SELECT Value FROM Patient WHERE QuestionId = \"%@\"", questionId];
    
    FMResultSet *results = [db executeQuery:query];
    
    if (!results) {
        NSLog(@"%@", [db lastErrorMessage]);;
        return nil;
    }
    [results next];
    return [results stringForColumnIndex:0];
}

+(BOOL)localClearPatientData {
    
}


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
