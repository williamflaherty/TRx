//
//  LocalTalkWrapper.m
//  TRx
//
//  Created by John Cotham on 3/31/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "LocalTalkWrapper.h"

@implementation LocalTalkWrapper

+(void)addPatientObjectToLocal:(Patient *)newPatient {
    /*store essential Patient Meta Data into LocalDatabase before calling synchPatientData*/
    [LocalTalk localClearPatientData];
    
    [LocalTalk localStorePatientMetaData:@"birthDay" value:[NSString stringWithFormat:@"%d", newPatient.birthday]];
    [LocalTalk localStorePatientMetaData:@"firstName" value:newPatient.firstName];
    [LocalTalk localStorePatientMetaData:@"middleName" value:newPatient.middleName];
    [LocalTalk localStorePatientMetaData:@"lastName" value:newPatient.lastName];
    
    [LocalTalk localStorePatientMetaData:@"surgeryTypeId" value:@"1"];//hardcoded unless Mark verifies working
    [LocalTalk localStorePatientMetaData:@"doctorId" value:@"1"]; //hardcoded unless Mark verifies working
    
    BOOL storedPic = [LocalTalk localStorePortrait:newPatient.photoID];
    if (!storedPic) {
        NSLog(@"Error storing portrait in HistoryViewController nextView");
    }
    
    /*
     * temporary values. nothing gets synched unless addPatient and addRecord
     * get called successfully and return the patientId and recordId
     */
    [LocalTalk localStoreTempPatientId];
    [LocalTalk localStoreTempRecordId];
}

/*---------------------------------------------------------------------------
 Summary:
    Attempts to add new patient, new patient's record
    Then synchs data
 Details:
    First checks if patientId and recordId are temporary
    if temporary && there is a server connection
    call addPatient and addPatientRecord
    then synchronize Patient data and set Patient.Synched to false
 Notes:
    AddPatient and AddRecord run Synchronously. Others, asynchronously.
 Returns:
    true if no catastrophic error. false on failure
 TODO:
    Check if connected to internet. If not, cache.
    Double check that Data is synched asynchronously
 ----------------------------------------------------------------------------*/
+(BOOL)addNewPatientAndSynchData {
    return [SynchData addPatientToDatabaseAndSynchData];
}

@end
