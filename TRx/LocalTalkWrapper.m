//
//  LocalTalkWrapper.m
//  TRx
//
//  Created by John Cotham on 3/31/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "LocalTalkWrapper.h"

@implementation LocalTalkWrapper

/*---------------------------------------------------------------------------
 Summary:
    Takes a patient object and adds its data to the local database's
    PatientMetaData table. Also gives a temporary patientId and recordId
 Details:
    Method should only be called once for a new patient
 Notes:
    AddPatient and AddRecord run Synchronously. Others, asynchronously.
 Returns:
    void (currently)
 TODO:
    Maybe add error testing and return true or false
    Make sure this only ever gets called once
        --method clears patient table and puts in tmpIds, overwriting previous data
 ----------------------------------------------------------------------------*/
+(void)addPatientObjectToLocal:(Patient *)newPatient {
    /*store essential Patient Meta Data into LocalDatabase before calling synchPatientData*/
    [LocalTalk localStorePatientMetaData:@"birthDay" value:newPatient.birthday];
    [LocalTalk localStorePatientMetaData:@"firstName" value:newPatient.firstName];
    [LocalTalk localStorePatientMetaData:@"middleName" value:newPatient.middleName];
    [LocalTalk localStorePatientMetaData:@"lastName" value:newPatient.lastName];
    
    [LocalTalk localStorePatientMetaData:@"surgeryTypeId" value:@"1"];//hardcoded unless Mark verifies working
    [LocalTalk localStorePatientMetaData:@"doctorId" value:@"1"]; //hardcoded unless Mark verifies working
    
    BOOL storedPic = [LocalTalk localStorePortrait:newPatient.photoID];
    if (!storedPic) {
        NSLog(@"Error storing portrait in HistoryViewController nextView");
    }
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
 Returns:
    true if no catastrophic error. false on failure
 TODO:
    Check if connected to internet. If not, cache.
    Double check that Data is synched asynchronously
 ----------------------------------------------------------------------------*/
+(BOOL)addNewPatientAndSynchData {
    return [SynchData addPatientToDatabaseAndSyncData];
}

+(Patient *)initPatientFromLocal {
    return [SynchData initPatientFromLocal];
}

@end
