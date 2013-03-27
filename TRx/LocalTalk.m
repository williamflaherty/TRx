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


/*---------------------------------------------------------------------------
 * Checks local database for unsynched data and uploads it
 *
 * First checks if patientId and recordId are temporary
 *  if temporary && there is a server connection
 *      call addPatient and addPatientRecord
 *      then synchronize Patient data and set Patient.Synched to false
 *
 * Currently running SYNCHRONOUSLY !!!
 * 
 * returns true if no catastrophic error
 *---------------------------------------------------------------------------*/

+(BOOL)synchPatientData {
    NSLog(@"Beginning SynchPatientData");
    NSString *query, *recordId, *patientId, *questionId, *value;
    NSString *fName, *lName, *mName, *bDay, *surgeryTypeId, *doctorId;
    FMResultSet *toSynch;
    
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    
    
    //check if patientId is loaded into PatientMetaData
    patientId = [LocalTalk localGetPatientId];
    
    
    //if not loaded, either no communication with local, or patient not added yet
    if (!patientId) {
        NSLog(@"Failure to retrieve patientId from Local in synchPatientData");
        [db close];
        return false;
    }
    
    //check if recordId is loaded into PatientMetaData
    recordId = [LocalTalk localGetRecordId];
    if (!recordId) {
        NSLog(@"Failure to retrieve recordId from Local in synchPatientData");
        [db close];
        return false;
    }
    
    
    
    //if PATIENT not yet added, get necessary info from LocalDatabase and add
    if ([patientId isEqual: @"tmpPatientId"]) {
        fName = [LocalTalk localGetPatientMetaData:@"firstName"];
        mName = [LocalTalk localGetPatientMetaData:@"middleName"];
        lName = [LocalTalk localGetPatientMetaData:@"lastName"];
        bDay = [LocalTalk localGetPatientMetaData:@"birthDay"];
        
        patientId = [DBTalk addPatient:fName middleName:mName lastName:lName birthday:bDay];
        
        if (!patientId) {
            //error
            NSLog(@"In SynchPatient. DBTalk's addPatient failed");
            NSLog(@"fName: %@, mName: %@, lName: %@, bDay: %@", fName, mName, lName, bDay);
        }
        else {
            //success
            NSLog(@"SynchPatient's patientId: %@", patientId);
            BOOL retval = [self localStorePatientMetaData:@"recordId" value:recordId];
            if (!retval) {
                NSLog(@"In SynchPatient: Error updating PatientMetaData's recordId: %@", recordId);
            }
        }
    }
      
    
    
    //if RECORD not yet added, get necessary info from LocalDatabase and add
    if ([recordId isEqual: @"tmpRecordId"]) {
        surgeryTypeId = [LocalTalk localGetPatientMetaData:@"surgeryTypeId"];
        doctorId = [LocalTalk localGetPatientMetaData:@"doctorId"];
        
        recordId = [DBTalk addRecord:patientId
                       surgeryTypeId:surgeryTypeId
                            doctorId:doctorId
                            isActive:@"1"
                          hasTimeout:@"0"];
        
        if (!recordId) {
            //error
            NSLog(@"In SynchPatient. DBTalk's addRecord failed");
            NSLog(@"surgeryTypeId: %@, doctorId: %@, patientId: %@", surgeryTypeId, doctorId, patientId);
        }
        else {
            //success
            NSLog(@"SynchPatient's recordId: %@", recordId);
            
            //update PatientMetaData with new recordId
            BOOL retval = [self localStorePatientMetaData:@"recordId" value:recordId];
            if (!retval) {
                NSLog(@"In SynchPatient: Error updating PatientMetaData's recordId: %@", recordId);
            }
        }
    }

    //check if picture is to be added
    NSLog(@"In synchPatientData, checking if synch picture");
    toSynch = [db executeQuery:@"SELECT \"Synched\" FROM Images"];
    [toSynch next];
    int picSynched = [toSynch intForColumnIndex:0];
    if (!picSynched) {
        UIImage *image = [LocalTalk localGetPortrait];
        if (!image) {
            NSLog(@"Didn't retrieve an image from LocalDatabase");
        }
        else {
            NSLog(@"Synching picture...");
            [DBTalk addProfilePicture:image patientId:patientId];
        }
    }
    NSLog(@"...finished synch picture");
    
    NSLog(@"Synching questionData...");
    
    //Get all values that need to be updated
    query = @"SELECT QuestionId, Value FROM Patient WHERE Synched = 0";
    toSynch = [db executeQuery:query];
    
    if (!toSynch) {
        NSLog(@"%@", [db lastErrorMessage]);
        [db close];
        return false;
    }
    while ([toSynch next]) {
        
        questionId = [toSynch stringForColumn:@"QuestionId"];
        value = [toSynch stringForColumn:@"Value"];
        
        NSLog(@"For QuestionId: %@ adding Value: %@", questionId, value);
        
        //add data to server **CURRENTLY SYNCHRONOUS !! **
        [DBTalk addRecordData:recordId key:questionId value:value];
        
        //update local table so that 'Synched' column = 1;
        [db executeUpdate:@"INSERT INTO Patient (Synched) VALUES (1) where QuestionId = ?", questionId];
    }
    
    NSLog(@"Exiting SynchPatientData");   
    [db close];
    return true;
}

+(BOOL)addNewPatientAndSynchData {
    return [SynchData addNewPatientAndSynchData];
}


/*---------------------------------------------------------------------------
 * stores portrait image into LocalDatabase's Images table
 * returns t or f
 *---------------------------------------------------------------------------*/
+(BOOL)localStoreTempRecordId {
    return [self localStorePatientMetaData:@"recordId" value:@"tmpRecordId"];
}
+(BOOL)localStoreTempPatientId {
    return [self localStorePatientMetaData:@"patientId" value:@"tmpPatientId"];
}


/* non-essential methods may delete later. called from synch at the moment. self explanatory */
+(NSString *)localGetPatientId {
    return [self localGetPatientMetaData:@"patientId"];
}
+(NSString *)localGetRecordId {
    return [self localGetPatientMetaData:@"recordId"];
}

/*---------------------------------------------------------------------------
 * Retrieves data stored in LocalDatabase's PatientMetaData table
 * keys: patientId, recordId, firstName, middleName, lastName, birtyday,
         doctorId, surgeryTypeId
 *
 * returns Strings of data OR NULL
 *---------------------------------------------------------------------------*/
+(NSString *)localGetPatientMetaData:(NSString *)key {
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    //db.traceExecution = true;
    [db open];
    NSString *query;
    query = [NSString stringWithFormat:@"SELECT Value FROM PatientMetaData WHERE key = \"%@\"", key];
    
    //NSLog(@"localGetPatientMetaData query: %@", query);
    FMResultSet *results = [db executeQuery:query];
    
    if (!results) {
        NSLog(@"%@", [db lastErrorMessage]);;
        return nil;
    }
    [results next];
    NSString *retval = [results stringForColumnIndex:0];
    [db close];
    //NSLog(@"localPatientMetaData returning: %@", retval);
    return retval;
}


/*---------------------------------------------------------------------------
 * Stores data in LocalDatabase's PatientMetaData table
 * takes key and value as parameters
 * keys: patientId, recordId, firstName, middleName, lastName, birtyday,
         doctorId, surgeryTypeId
 *
 * returns success or failure (t or f)
 *---------------------------------------------------------------------------*/
+(BOOL)localStorePatientMetaData:(NSString *)key
                                 value:(NSString *)value {
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    NSString *query = [NSString stringWithFormat:@"INSERT INTO PatientMetaData (Key, Value) VALUES (\"%@\", \"%@\")", key, value];
    BOOL retval = [db executeUpdate:query];//@"INSERT INTO PatientMetaData (Key, Value) VALUES (?, ?)", key, value];
    if (!retval) {
        NSLog(@"Error storing into patientMetaData");
        NSLog(@"%@", [db lastErrorMessage]);
    }
    [db close];
    return retval;
}


/*---------------------------------------------------------------------------
 * Stores values in LocalDatabase's Patient table
 * this is where all the answers to preOp (and other form) questions go
 *
 * takes value and QuestionId as parameters
 *
 * current QuestionId's stored in drive
 *
 * returns success or failure (t or f)
 *---------------------------------------------------------------------------*/
+(BOOL)localStoreValue:(NSString *)value forQuestionId:(NSString *)questionId {
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    
    BOOL retval = [db executeUpdate:@"INSERT INTO Patient (QuestionId, Value, Synched) VALUES (?, ?, 0)", questionId, value];
    [db close];
    return retval;
    
}


/*---------------------------------------------------------------------------
 * stores portrait image into LocalDatabase's Images table
 * returns t or f
 *---------------------------------------------------------------------------*/
+(BOOL)localStorePortrait:(UIImage *)image {
    if (!image) {
        NSLog(@"in localStorePortrait -- No image to store");
        return false;
    }
    else {
        NSLog(@"localStorePortrait is receiving a non-null value -- hopefully an image");
    }
    NSData *imageData = UIImageJPEGRepresentation(image, .1);
    if (!imageData) {
        NSLog(@"Error in localStorePortrait converting UIImage to NSData object");
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    //NSString *query = [NSString stringWithFormat:@"INSERT INTO Images (imageType, imageBlob) VALUES (\"portrait\", \"%@\")", imageData];
    BOOL retval = [db executeUpdate:@"INSERT OR REPLACE INTO Images (imageType, imageBlob) VALUES (?,?)", @"portrait", imageData];
    [db close];
    
    return retval;
}


/*---------------------------------------------------------------------------
 * gets portrait image from LocalDatabase's Images table
 * returns UIImage or NULL
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
    }
    
    [db close];

    return image;
}


/*---------------------------------------------------------------------------
 * gets value stored in QuestionId
 * returns string or NULL
 *---------------------------------------------------------------------------*/
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
    [db close];
}

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

/*Bad implementation at the moment so I didn't have to break localStorePortrait (insert query)*/

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

@end







