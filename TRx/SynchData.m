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




+(BOOL)syncProfilePicture:(NSString *)patientId {
    
    FMResultSet *toSynch;
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    
    //check local database to see if image is synced
    toSynch = [db executeQuery:@"SELECT Synched FROM Images WHERE imageType = ?", @"portrait"]; //select portrait
    if (!toSynch) {
        NSLog(@"%@", [db lastErrorMessage]);
        [db close];
        return false;
    }
    
    [toSynch next];
    int picSynched = [toSynch intForColumnIndex:0];
    if (picSynched) {
        NSLog(@"Picture already synced");
        return true;
    }
    
    //if not synced, retrieve image from local and add to server
    UIImage *image = [LocalTalk localGetPortrait];
    if (!image) {
        NSLog(@"Didn't retrieve an image from LocalDatabase");
        [db close];
        return false;
    }
    
    [DBTalk addProfilePicture:image patientId:patientId];
    
    //update local table so that 'Synched' column = 1;
    BOOL result = [db executeUpdate:@"UPDATE Images SET Synched = 1 WHERE imageType = ?", @"portrait"];
    if (!result) {
        [db close];
        return false;
    }
    
    NSLog(@"Exiting SynchPatientData");
    [db close];
    return true;
}

+(BOOL)syncDataForRecord:(NSString *)recordId {
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
        BOOL result = [db executeUpdate:@"UPDATE Patient SET Synched = 1 WHERE QuestionId = ?", questionId];//@"REPLACE INTO Patient (Synched) VALUES (1) WHERE QuestionId = ?", questionId];
        if (!result) {
            NSLog(@"\tValues not set to 'Synched'");
            NSLog(@"%@", [db lastErrorMessage]);
            [db close];
            return false;
        }
    }
    
    NSLog(@"Synch Data returning successfully");
    [db close];
    return true;
}



/*---------------------------------------------------------------------------
 Summary:
    Checks if patient needs to be added or updated and calls add or update method
 Details:

 Notes:
    
 Returns:
    false if failure. true if patient synced
 TODO:
    See if there is a way to use AddUpdatePatient rather than if/else and two
    different methods.
    Change out hard-coded birthdays
 ----------------------------------------------------------------------------*/



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
        NSLog(@"addOrUpdatePatient. In the else with: %@", newPatient.firstName);
        patientId = [DBTalk addUpdatePatient:newPatient.firstName middleName:newPatient.middleName
                                    lastName:newPatient.lastName birthday:@"20081010" patientId:newPatient.patientId];
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

/*---------------------------------------------------------------------------
 Summary:
    Attempts to add new patient, new patient's record
    Then synchs data
 Details:
    First checks if patientId and recordId are temporary
    if temporary && there is a server connection
    call addPatient and addPatientRecord
    then synchronize Patient data and set Patient.Synched to true
 Notes:
    AddPatient and AddRecord run Synchronously. Others, asynchronously.
    Current version assumes connection to server
 Returns:
    true if all sync with no error
 TODO:
    Check if connected to internet. If not, cache.
    Double check that Data is synched asynchronously
 ----------------------------------------------------------------------------*/
+(BOOL)addPatientToDatabaseAndSyncData {
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
        NSLog(@"Error Syncing Patient Record");
        return false;
    }
    
    BOOL dataSynced = [self syncDataForRecord:newPatient.currentRecordId];
    if (!dataSynced) {
        NSLog(@"Error synching Data");
        return false;
    }
    
    /* added until testing with images is possible */
    if (newPatient.photoID == NULL) {
        return true;
    }
    
    BOOL imageSynced = [self syncProfilePicture:newPatient.patientId];
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
 TODO: ADD URL TO PHOTO TO PATIENT META DATA OBJECT? 
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
    NSURL *url;
    
    Patient *newPatient = [[Patient alloc] initWithPatientId:patientId currentRecordId:recordId firstName:fName MiddleName:mName LastName:lName birthday:bDay ChiefComplaint:chiefComplaint PhotoID:image PhotoURL:url];
    
    return newPatient;
}

@end
