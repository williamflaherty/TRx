//
//  TestLocalTalk.m
//  TRx
//
//  Created by John Cotham on 4/2/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "TestLocalTalk.h"

@implementation TestLocalTalk

-(void)testEntryInPatientMetaData {
    /* tests that entryInPatientMetaData returns whether
       there exists an entry in 
    [LocalTalk localClearPatientData];
    [LocalTalk entryInPatientMetaData:@"patientId"];
    [LocalTalk localStoreTempPatientId];
    [LocalTalk localStoreTempRecordId];
    [LocalTalk entryInPatientMetaData:@"patientId"];
    [LocalTalk entryInPatientMetaData:@"recordId"];
    [LocalTalk localClearPatientData]; */
}

/*---------------------------------------------------------------------------
 Summary:
    Tests the addPatient button. Verifies it adds a patient 
    and that patient can be updated
 *---------------------------------------------------------------------------*/

-(void)testAddNewPatientAndSyncData {
    //Clear the local database
    [LocalTalk localClearPatientData];
    
    //Initialize with temporary Ids
    [LocalTalk localStoreTempRecordId];
    [LocalTalk localStoreTempPatientId];
    
    //Initialize a patient object
    Patient *patient = [TestLocalTalk initPatient];
    
    //Add the patient object to the local database
    [LocalTalkWrapper addPatientObjectToLocal:patient];
    
    //initialize patient object with data from local database
    patient = [SynchData initPatientFromLocal];
    
    //add patient to database
    BOOL success = [LocalTalkWrapper addNewPatientAndSynchData];
    STAssertTrue(success, @"Was not able to add or update patient");
    
    //retrieve new patientId from local and store in oldId
    patient = [SynchData initPatientFromLocal];
    NSString *oldId = patient.patientId;
    
    //check that patientId is not nil and has been changed form temporary value
    STAssertNotNil(patient.patientId, @"patientId shouldn't be nil after insert");
    STAssertFalse([patient.patientId isEqualToString:@"tmpPatientId"], @"should have Id from server");
    
    //reset first and last name
    patient.firstName = @"badfname";
    patient.lastName = @"badlname";
    
    //add changes to local database
    [LocalTalkWrapper addPatientObjectToLocal:patient];
    
    //update patient with a second call to addNewPatientAndSynchData
    //this simulates pressing the button again
    success = [LocalTalkWrapper addNewPatientAndSynchData];
    STAssertTrue(success, @"able to update patient");
    
    //test that patient is updated and not created anew
    STAssertTrue([patient.patientId isEqualToString:oldId], @"Patient was not updated");
    
    success = [DBTalk deletePatient:patient.patientId];
    STAssertTrue(success, @"Unable to delete patient");
    
    
}
+(Patient *)initPatient {
    NSBundle *myBundle = [NSBundle mainBundle];
    NSString *imagePath = [myBundle pathForResource:@"Icon-72@2x" ofType:@"png"];
    UIImage *image = [UIImage imageNamed:imagePath];
    Patient *patient = [[Patient alloc] initWithFirstName:@"bad fname" MiddleName:@"middle" LastName:@"bad lname" ChiefComplaint:@"1" PhotoID:image];
    return patient;
}
     


@end
