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
#import "SynchData.h"

@implementation LocalTalk






#pragma mark - Local Store Methods

/*---------------------------------------------------------------------------
 Summary:
    Stores a temporary RecordId in the local database
 Details:
    New Patients are given temporary recordIds and patientIds
    until they are synched with the server
 Returns:
    true on success, false otherwise
 *---------------------------------------------------------------------------*/
+(BOOL)localStoreTempRecordId {
    return [self localStorePatientMetaData:@"recordId" value:@"tmpRecordId"];
}
+(BOOL)localStoreTempPatientId {
    return [self localStorePatientMetaData:@"patientId" value:@"tmpPatientId"];
}

/*---------------------------------------------------------------------------
 Summary:
    Stores keys and values in PatientMetaData table
 Details:
    keys: patientId, recordId, firstName, middleName, lastName, birthday,
          doctorId, surgeryTypeId
 Returns:
    true on success, false otherwise
 *---------------------------------------------------------------------------*/
+(BOOL)localStorePatientMetaData:(NSString *)key
                           value:(NSString *)value {
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    //NSLog(@"In localStorePatientMetaData key: %@ value: %@", key, value);
    NSString *query = [NSString stringWithFormat:@"REPLACE INTO PatientMetaData (Key, Value) VALUES (\"%@\", \"%@\")", key, value];
    BOOL retval = [db executeUpdate:query];//@"INSERT INTO
    if (!retval) {
        NSLog(@"Error storing into patientMetaData");
        NSLog(@"%@", [db lastErrorMessage]);
    }
    [db close];
    return retval;
}


/*---------------------------------------------------------------------------
 Summary:
    Store QuestionIds and values in the Patient database for the current patient
 Details:
 
 Returns:
    true on success, false otherwise
 *---------------------------------------------------------------------------*/
+(BOOL)localStoreValue:(NSString *)value forQuestionId:(NSString *)questionId {
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    BOOL retval = [db executeUpdate:@"INSERT INTO Patient (QuestionId, Value, Synched) VALUES (?, ?, 0)", questionId, value];
    [db close];
    
    return retval;
    
}

/*---------------------------------------------------------------------------
 Summary:
    Stores a portrait in the Images table of local database
 Details:
    Reduces size of image by 1/10 before storing. Not sure if I should do this here
 Returns:
    true on success, false otherwise
 *---------------------------------------------------------------------------*/
+(BOOL)localStorePortrait:(UIImage *)image {
    
    NSData *imageData = UIImageJPEGRepresentation(image, .1);    //should I be reducing size here?
    if (!imageData) {
        NSLog(@"Error in localStorePortrait converting UIImage to NSData object");
        return false;
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    BOOL retval = [db executeUpdate:@"INSERT OR REPLACE INTO Images (imageType, imageBlob) VALUES (?,?)", @"portrait", imageData];
    [db close];
    
    return retval;
}

/*---------------------------------------------------------------------------
 Summary:
    Stores image data and filename to the Audio table of local database
 Details:
    File Names can be any unique string -- custom user names or just 
    (strings of) numbers to identify
 Returns:
    true on success, false otherwise
 TODO:
    does not sync with database yet.
 *---------------------------------------------------------------------------*/
+(BOOL)localStoreAudio:(id)audioData fileName:(NSString *)fileName {
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    BOOL retval = [db executeUpdate:@"INSERT INTO Audio (Name, Data) VALUES (?, ?)", fileName, audioData];
    if (!retval) {
        NSLog(@"%@", [db lastErrorMessage]);
    }
    [db close];
    return retval;                                        
}

#pragma mark - Local Get Methods

/*---------------------------------------------------------------------------
 Summary:
    Helper methods for retrieving patientId and recordId from local database 
 Details:
    Methods wrap localGetPatientMetaData
 Returns:
    nil - failure to communicate with database
    NSString of Id
 *---------------------------------------------------------------------------*/
+(NSString *)localGetPatientId {
    return [self localGetPatientMetaData:@"patientId"];
}
+(NSString *)localGetRecordId {
    return [self localGetPatientMetaData:@"recordId"];
}


/*---------------------------------------------------------------------------
 Summary:
    Retrieves data stored in LocalDatabase's PatientMetaData table
 Details:
    keys: patientId, recordId, firstName, middleName, lastName, birthday,
          doctorId, surgeryTypeId
 Returns:
    nil - failure to communicate with local database
    NSString with appropriate metadata for current patient
 *---------------------------------------------------------------------------*/
+(NSString *)localGetPatientMetaData:(NSString *)key {
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    
    NSString *query;
    query = [NSString stringWithFormat:@"SELECT Value FROM PatientMetaData WHERE key = \"%@\"", key];
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
 Summary:
    Retrieves a portrait of current patient from the Images table of local database
 Details:
    
 Returns:
    nil - on failure to retrieve image
    UIImage of current patient otherwise
 *---------------------------------------------------------------------------*/
+(UIImage *)localGetPortrait {
    NSString *query = [NSString stringWithFormat:@"SELECT imageBlob FROM Images WHERE imageType = \"portrait\""];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    FMResultSet *results = [db executeQuery:query];
    if (!results) {
        NSLog(@"Error retrieving image\n");
        NSLog(@"%@", [db lastErrorMessage]);
        return nil;
    }
    [results next];
    NSData *data = [results dataForColumnIndex:0];

    UIImage *image = [UIImage imageWithData:data];
    if (!image) {
        NSLog(@"In localGetPortrait: image is NULL");
        return nil;
    }
    
    [db close];

    return image;
}

+(id)localGetAudio:(NSString *)fileName {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    FMResultSet *results = [db executeQuery:@"SELECT Data FROM Audio WHERE Name = ?", fileName];
    
    if (!results) {
        NSLog(@"Error retrieving image\n");
        NSLog(@"%@", [db lastErrorMessage]);
        return nil;
    }
    [results next];
    id data = [results dataForColumnIndex:0];
    
    [db close];
    
    return data;
}



/*---------------------------------------------------------------------------
 Summary:
    gets value stored with key QuestionId
  Returns:
    nil or NSString with value
 *---------------------------------------------------------------------------*/

+(NSString *)getValueForQuestionId:(NSString *)questionId {
    
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

#pragma mark - Get Label Methods

/*---------------------------------------------------------------------------
 * Takes a questionId and returns appropriate English Label or NULL
 *---------------------------------------------------------------------------*/
+(NSString *)getEnglishLabel:(NSString *)questionId {
    return [self getLabel:questionId columnName:@"English"];
}

/*---------------------------------------------------------------------------
 * Takes a questionId and returns appropriate Spanish Label or NULL
 *---------------------------------------------------------------------------*/
+(NSString *)getSpanishLabel:(NSString *)questionId {
    return [self getLabel:questionId columnName:@"Spanish"];
}

+(NSString *)getQuestionType:(NSString *)questionId {
    return [self getLabel:questionId columnName:@"QuestionType"];
}

/*---------------------------------------------------------------------------
 * Base method for getEnglishLabel and getSpanishLabel
 *---------------------------------------------------------------------------*/
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

#pragma mark - Clear Patient Data

/*---------------------------------------------------------------------------
 * clears local patient data. Needs to be called before new Patient data inserted
 * no retval
 *---------------------------------------------------------------------------*/
+(void)localClearPatientData {
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    [db executeUpdate:@"DELETE FROM Images"];
    [db executeUpdate:@"DELETE FROM Patient"];
    [db executeUpdate:@"DELETE FROM PatientMetaData"];
    [db executeUpdate:@"DELETE FROM Audio"];
    [db close];
}


#pragma mark - Load Data from Server into Local

/*---------------------------------------------------------------------------
 Summary:
    clears local database and loads record data
 Details:
    clears Images, Patient and PatientMetaData
 Returns:
    true on success, false otherwise
 TODO:
    Might want to go ahead and add loadPortraitImage and 
    loadMetaData to this method
 *---------------------------------------------------------------------------*/

+(BOOL)clearLocalThenLoadPatientRecordIntoLocal:(NSString *)recordId {
    [LocalTalk localClearPatientData];
    return [LocalTalk loadPatientRecordIntoLocal:recordId];
}


/*---------------------------------------------------------------------------
 Summary:
    Loads all QuestionIds and values for a patient record and stores in local
 Details:
     
 Returns:
    true on success, false otherwise
 TODO:
    check whether DBTalk's getRecordData actually ever returns null
 *---------------------------------------------------------------------------*/

+(BOOL)loadPatientRecordIntoLocal:(NSString *)recordId {
    BOOL success;
    NSArray *dataArr = [DBTalk getRecordData:recordId];
    
    if (dataArr != NULL) {
        FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
        [db open];
        NSLog(@"%@", dataArr);
        for (NSDictionary *dic in dataArr) {
            NSString *questionId = [dic objectForKey:@"Key"];
            NSString *value = [dic objectForKey:@"Value"];
            
            success = [db executeUpdate:@"INSERT INTO Patient (QuestionId, Value, Synched) VALUES (?, ?, 1)", questionId, value];
            if (!success) {
                NSLog(@"Unable to add: %@", [db lastErrorMessage]);
                
            }
        }
        [db close];
        return true;
    }
    else {
        NSLog(@"Error retrieving patient record data");
        return false;
    }
}

/*---------------------------------------------------------------------------
 Summary:
    Retrieves portrait image from Server and stores in Local
 Details:
    Should make sure table is cleared before inserting new image
 Returns:
    true on success, false otherwise
 *---------------------------------------------------------------------------*/

+(BOOL)loadPortraitImageIntoLocal:(NSString *)patientId {
    UIImage *image = [DBTalk getPortraitFromServer:patientId];
    if (!image) {
        NSLog(@"Error loading Portrait Image");
        return false;
    }
    BOOL retval = [LocalTalk localStorePortrait:image];
    if (retval) {
        FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
        [db open];
        retval = [db executeUpdate:@"INSERT INTO Images (Synched) VALUES (1)"];
        [db close];
    }
    return retval;
}

#pragma mark - Helper methods


/*---------------------------------------------------------------------------
 Summary:
    Helper method for testing. Prints Patient data from localDatabase
 *---------------------------------------------------------------------------*/
+(void)printLocal {
    NSString *key, *value;
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM Patient"];
    while ([results next]) {
        key = [results stringForColumn:@"QuestionId"];
        value = [results stringForColumn:@"Value"];
        NSLog(@"Key: %@  Value: %@", key, value);
    }
    
    [db close];
}

@end







