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


/*---------------------------------------------------------------------------
 * Checks local database for unsynched files and uploads them
 * Currently running SYNCHRONOUSLY !!!
 * 
 * returns true if no catastrophic error
 *---------------------------------------------------------------------------*/

+(BOOL)synchPatientData {
    NSString *query = @"SELECT QuestionId, Value FROM Patient WHERE Synched = 0";
    NSString *patientId, *questionId, *value;
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    
    FMResultSet *toSynch = [db executeQuery:query];
    
    if (!toSynch) {
        NSLog(@"%@", [db lastErrorMessage]);
        [db close];
        return false;
    }
    while ([toSynch next]) {
        questionId = [toSynch stringForColumn:@"QuestionId"];
        value = [toSynch stringForColumn:@"Value"];
        
        //add data to server **CURRENTLY SYNCHRONOUS !! **
        [DBTalk addRecordData:patientId key:questionId value:value];
        
        //update local table so that 'Synched' column = 1;
        [db executeUpdate:@"INSERT INTO Patient (Synched) VALUES (1) where QuestionId = ?", questionId];
        
    }
        
    [db close];
    return true;
}

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
    [db executeUpdate:@"DELETE FROM Images"];
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


/*---------------------------------------------------------------------------
 * Clears database tables Images and Patient
 * Loads data from the server into LocalDatabase
 * 
 * returns success or failure
 *---------------------------------------------------------------------------*/

+(BOOL)clearLocalThenLoadPatientRecordIntoLocal:(NSString *)recordId {
    [LocalTalk localClearPatientData];
    return [LocalTalk loadPatientRecordIntoLocal:recordId];
}


/*---------------------------------------------------------------------------
 * Loads data from the server into LocalDatabase
 * generally, clearLocalThenLoadPatientRecordIntoLocal should be called
 * returns success or failure
 *---------------------------------------------------------------------------*/

+(BOOL)loadPatientRecordIntoLocal:(NSString *)recordId {
    
    NSArray *dataArr = [DBTalk getRecordData:recordId];
    
    if (dataArr != NULL) {
        FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
        [db open];
        for (NSDictionary *dic in dataArr) {
            NSString *questionId = [dic objectForKey:@"Key"];
            NSString *value = [dic objectForKey:@"Value"];
            
            [db executeUpdate:@"INSERT INTO Patient (QuestionId, Value, Synched) VALUES (?, ?, 1)", questionId, value]; 
        }
        [db close];
        return true;
    }
    else {
        NSLog(@"Error retrieving doctorNamesList");
        return false;
    }
}

@end
