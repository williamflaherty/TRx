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


+(BOOL)addNewPatientAndSynchData {
    NSLog(@"Beginning SynchPatientData");
    NSString *recordId, *patientId;
    NSString *fName, *lName, *mName, *bDay, *surgeryTypeId, *doctorId;
    BOOL retval;
    
    //Get patientId, recordId from PatientMetaData

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
  
    
    //if PATIENT not yet added, get necessary info from LocalDatabase and add
    if ([patientId isEqual: @"tmpPatientId"]) {
        
        fName = [LocalTalk localGetPatientMetaData:@"firstName"];
        mName = [LocalTalk localGetPatientMetaData:@"middleName"];
        lName = [LocalTalk localGetPatientMetaData:@"lastName"];
        bDay  = [LocalTalk localGetPatientMetaData:@"birthDay"];
        
        patientId = [DBTalk addPatient:fName middleName:mName lastName:lName birthday:bDay];
        
        if (!patientId) {  //should check if != @"0"
            NSLog(@"In SynchPatient. DBTalk's addPatient failed");
            NSLog(@"fName: %@, mName: %@, lName: %@, bDay: %@", fName, mName, lName, bDay);
            return false;
        }
        else {
            NSLog(@"SynchPatient's patientId: %@", patientId);
            
            //update PatientMetaData with new patientId
            retval = [LocalTalk localStorePatientMetaData:@"recordId" value:recordId];
            if (!retval) {
                NSLog(@"In SynchPatient: Error updating PatientMetaData's recordId: %@", recordId);
            }
        }
    }
    
    
    //if RECORD not yet added, get necessary info from LocalDatabase and add
    if ([recordId isEqual: @"tmpRecordId"]) {
        surgeryTypeId = [LocalTalk localGetPatientMetaData:@"surgeryTypeId"];
        doctorId = [LocalTalk localGetPatientMetaData:@"doctorId"];                 //doctorId not necessarily set
        
        recordId = [DBTalk addRecord:patientId
                       surgeryTypeId:surgeryTypeId
                            doctorId:doctorId
                            isActive:@"1"
                          hasTimeout:@"0"];
        
        if (!recordId) {
            NSLog(@"In SynchPatient. DBTalk's addRecord failed");
            NSLog(@"surgeryTypeId: %@, doctorId: %@, patientId: %@", surgeryTypeId, doctorId, patientId);
            return false;
        }
        else {
            NSLog(@"SynchPatient's recordId: %@", recordId);
            
            //update PatientMetaData with new recordId
            retval = [LocalTalk localStorePatientMetaData:@"recordId" value:recordId];
            if (!retval) {
                NSLog(@"In SynchPatient: Error updating PatientMetaData's recordId: %@", recordId);
            }
        }
    }
    
    
    retval = [self synchDataForRecord:recordId];
    if (!retval) {
        NSLog(@"Error synching Data");
        return false;
    }
    
    retval = [self synchImagesForPatient:patientId];
    if (!retval) {
        NSLog(@"Error synching Image");
    }

    return true;
}


@end
