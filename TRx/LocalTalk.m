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


+(BOOL)localStoreTempRecordId {
    return [self localStoreValue:@"tempId" forQuestionId:@"recordId"];
}
+(BOOL)localStoreTempPatientId {
    return [self localStoreValue:@"tempId" forQuestionId:@"patientId"];
}

+(NSString *)localGetPatientId {
    return [self localGetValueForQuestionId:@"patientId"];
}
+(NSString *)localGetRecordId {
    return [self localGetValueForQuestionId:@"recordId"];
}

+(BOOL)localStoreValue:(NSString *)value forQuestionId:(NSString *)questionId {
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    //NSString *insert = [NSString stringWithFormat:
    //  @"INSERT INTO Patient (QuestionId, Value, Synched) VALUES (?, ?, 0)", questionId, value];
    BOOL retval = [db executeUpdate:@"INSERT INTO Patient (QuestionId, Value, Synched) VALUES (?, ?, 0)", questionId, value];
    [db close];
    return retval;
    //return [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO Patient (QuestionId, Value, Synched) VALUES (\"%@\", \"%@\", 0)", questionId, value]];
}

+(BOOL)localStorePortrait:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    BOOL retval = [db executeUpdate:@"INSERT INTO Images (imageType, imageBlob) VALUES (?, ?)", @"portrait", imageData];
    [db close];
    
    return retval;
}
+(UIImage *)localGetPortrait {
    NSString *query = [NSString stringWithFormat:@"SELECT imageBlob FROM Images WHERE imageType = \"portrait\""];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    NSLog(@"db path is now:%@\n", db.databasePath);
    [db open];
    FMResultSet *results = [db executeQuery:query];
    if (!results) {
        NSLog(@"Error retrieving image\n");
        NSLog(@"%@", [db lastErrorMessage]);
        return nil;
    }
    [results next];
    NSData *data = [results dataForColumnIndex:0];//[results stringForColumnIndex:0];
    UIImage *image = [[UIImage alloc] initWithData:data];
    [db close];
    
    return image;
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
    NSString *retval = [results stringForColumnIndex:0];
    [db close];
    return retval;
}
+(void)localClearPatientData {
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    
    [db executeUpdate:@"DELETE FROM Patient"];
    [db close];
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
    NSString *retval = [results stringForColumnIndex:0];
    [db close];
    return retval;
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
