//
//  SynchData.m
//  TRx
//
//  Created by John Cotham on 3/25/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "SynchData.h"
#import "DBTalk.h"
#import "FMDatabase.h"
#import "Utility.h"
#import "LocalTalk.h"

@implementation SynchData

+(BOOL)synchProfilePicture {
    /*needs to happen asynchronously*/
    return false;
}

+(BOOL)synchAddNewPatient {
    /*needs to happen synchronously*/
    
    
    /*if fails, sends error message to user why*/
    /*(no connection, patient already in system., other*/
    /*if no connection failure, pass back "tmp_id" as patientId */
    return false;
}

+(BOOL)synchImagesForPatient:(NSString *)patientId {
    
    FMResultSet *toSynch;
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    
    NSLog(@"In synchImages, checking if synch picture");
    toSynch = [db executeQuery:@"SELECT \"Synched\" FROM Images"];
    
    if (!toSynch) {
        NSLog(@"%@", [db lastErrorMessage]);
        [db close];
        return false;
    }
    
    [toSynch next];
    int picSynched = [toSynch intForColumnIndex:0];
    if (picSynched) {
        NSLog(@"Picture already synched");
        return true;
    }
    UIImage *image = [LocalTalk localGetPortrait];
    if (!image) {
        NSLog(@"Didn't retrieve an image from LocalDatabase");
        [db close];
        return false;
    }
    
    [DBTalk addProfilePicture:image patientId:patientId];
    NSLog(@"...finished synch picture");
    
    //update local table so that 'Synched' column = 1;
    BOOL result = [db executeUpdate:@"INSERT INTO Images (Synched) VALUES (1)"];
    if (!result) {
        NSLog(@"\tValues not set to 'Synched'");
        [db close];
        return false;
    }
    
    NSLog(@"Exiting SynchPatientData");
    [db close];
    return true;
}

+(BOOL)synchDataForRecord:(NSString *)recordId {
    NSString *questionId, *value;
        
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    
    NSLog(@"Synching Data for Record: %@", recordId);
    
    //Get all values that need to be updated
    FMResultSet *toSynch = [db executeQuery:@"SELECT QuestionId, Value FROM Patient WHERE Synched = 0"];
    
    if (!toSynch) {
        NSLog(@"\t%@", [db lastErrorMessage]);
        [db close];
        return false;
    }
    
    while ([toSynch next]) {
        
        questionId = [toSynch stringForColumn:@"QuestionId"];
        value = [toSynch stringForColumn:@"Value"];
        
        NSLog(@"\tFor QuestionId: %@ adding Value: %@", questionId, value);
        
        //add data to server **CURRENTLY SYNCHRONOUS !! **
        [DBTalk addRecordData:recordId key:questionId value:value];
        
        //update local table so that 'Synched' column = 1;
        BOOL result = [db executeUpdate:@"INSERT INTO Patient (Synched) VALUES (1) where QuestionId = ?", questionId];
        if (!result) {
            NSLog(@"\tValues not set to 'Synched'");
            [db close];
            return false;
        }
    }
    
    NSLog(@"Synch Data returning successfully");
    [db close];
    return true;
}

+(BOOL)addOrUpdatePatient:(Patient *)newPatient {
    NSString *patientId;
    BOOL IDStored;
    if ([newPatient.patientId isEqual: @"tmpPatientId"]) {
        patientId = [DBTalk addPatient:newPatient.firstName
                            middleName:newPatient.middleName
                              lastName:newPatient.lastName
                              birthday:@"20081010"];//newPatient.birthday];
        if (!patientId) {
            NSLog(@"Failed to add patient: %@ %@", newPatient.firstName, newPatient.lastName);
            NSLog(@"middleName: %@  birthday: %@", newPatient.middleName, newPatient.birthday);
            return false;
        }
        
        //update Patient MetaData in Local
        IDStored = [LocalTalk localStorePatientMetaData:@"patientId" value:patientId];
        if (!IDStored) {
            NSLog(@"Error updating PatientMetaData's patientId: %@", patientId);
        }
        newPatient.patientId = patientId;
    }
    else {
        patientId = [DBTalk addUpdatePatient:newPatient.firstName middleName:newPatient.middleName
                                    lastName:newPatient.lastName birthday:newPatient.birthday patientId:newPatient.patientId];
        if (!patientId) {
            NSLog(@"Failed to update patient: %@ %@", newPatient.firstName, newPatient.lastName);
            return false;
        }
    }
    return true;
}

+(BOOL)addOrUpdateRecord:(Patient *)newPatient {
    NSString *recordId;
    BOOL IDStored;
    //if RECORD not yet added, get necessary info from LocalDatabase and add
    if ([newPatient.currentRecordId isEqual: @"tmpRecordId"]) {
        NSString *doctorId = [LocalTalk localGetPatientMetaData:@"doctorId"];                 //doctorId not necessarily set
        
        recordId = [DBTalk addRecord:newPatient.patientId
                       surgeryTypeId:newPatient.chiefComplaint
                            doctorId:doctorId
                            isActive:@"1"
                          hasTimeout:@"0"];
        
        if (!recordId) {
            NSLog(@"Failed to synch record");
            return false;
        }
        
        NSLog(@"SynchPatient's recordId: %@", recordId);
        
        //update PatientMetaData with new recordId
        IDStored = [LocalTalk localStorePatientMetaData:@"recordId" value:recordId];
        if (!IDStored) {
            NSLog(@"In SynchPatient: Error updating PatientMetaData's recordId: %@", recordId);
        }
        newPatient.currentRecordId = recordId;
    }
    return true;
}


+(BOOL)addPatientToDatabaseAndSynchData {
    NSLog(@"Beginning SynchPatientData");
    
    //load Patient data from Local Database into Patient object
    Patient *newPatient = [self initPatientFromLocal];
    
    BOOL patientSynced = [self addOrUpdatePatient:newPatient];
    if (!patientSynced) {
        NSLog(@"Error Syncing Patient");
        return false;
    }
    
    BOOL recordSynced = [self addOrUpdateRecord:newPatient];
    if (!recordSynced) {
        NSLog(@"Error Syncing Patient");
        return false;
    }
    
    BOOL dataSynced = [self synchDataForRecord:newPatient.currentRecordId];
    if (!dataSynced) {
        NSLog(@"Error synching Data");
        return false;
    }
    
    BOOL imageSynced = [self synchImagesForPatient:newPatient.patientId];
    if (!imageSynced) {
        NSLog(@"Error synching Image");
        return false;
    }

    return true;
}

/*---------------------------------------------------------------------------
 Summary:
    Loads Patient metadata from Local and initializes Patient object
 Details:
 
 Returns:
    Patient Object
 *---------------------------------------------------------------------------*/

+(Patient *)initPatientFromLocal {
    NSString *patientId, *recordId, *fName, *mName, *lName, *bDay, *chiefComplaint;
    
    patientId = [LocalTalk localGetPatientId];
    if (!patientId) {
        NSLog(@"Failure to retrieve patientId from Local in synchPatientData");
        return false;
    }
    
    recordId = [LocalTalk localGetRecordId];
    if (!recordId) {
        NSLog(@"Failure to retrieve recordId from Local in synchPatientData");
        return false;
    }
    
    fName = [LocalTalk localGetPatientMetaData:@"firstName"];
    mName = [LocalTalk localGetPatientMetaData:@"middleName"];
    lName = [LocalTalk localGetPatientMetaData:@"lastName"];
    bDay  = [LocalTalk localGetPatientMetaData:@"birthDay"];
    chiefComplaint = [LocalTalk localGetPatientMetaData:@"surgeryTypeId"];
    UIImage *image = [LocalTalk localGetPortrait];
    
    Patient *newPatient = [[Patient alloc] initWithPatientId:patientId currentRecordId:recordId firstName:fName MiddleName:mName LastName:lName birthday:bDay ChiefComplaint:chiefComplaint PhotoID:image];
    
    return newPatient;
}

@end
