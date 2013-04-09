//
//  TestAddPatientThenLoad.m
//  TRx
//
//  Created by John Cotham on 4/4/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "TestAddPatientThenLoad.h"
#import "Question.h"

@implementation TestAddPatientThenLoad


//-(void)testAddPatientThenLoadFromServer {
//
//    //Clear the local database
//    [LocalTalk localClearPatientData];
//    
//    //Initialize with temporary Ids
//    [LocalTalk localStoreTempRecordId];
//    [LocalTalk localStoreTempPatientId];
//    
//    //Initialize a patient object
//    Patient *patientBeforeSync = [self createPatient];
//    
//    //Add the patient object to the local database
//    [LocalTalkWrapper addPatientObjectToLocal:patientBeforeSync];
//    
//    //initialize patient object with data from local database
//    patientBeforeSync = [LocalTalkWrapper initPatientFromLocal];
//    
//    //add patient to server database
//    BOOL success = [LocalTalkWrapper addNewPatientAndSynchData];
//    STAssertTrue(success, @"Was not able to add or update patient");
//    
//    //refresh patient object after synch. retrieve new patientId and store in oldId
//    Patient *patientAfterSync = [LocalTalkWrapper initPatientFromLocal];
//    
//    //check that patientId is not nil and has been changed form temporary value
//    STAssertNotNil(patientAfterSync.patientId, @"patientId shouldn't be nil after insert");
//    STAssertFalse([patientAfterSync.patientId isEqualToString:@"tmpPatientId"], @"should have Id from server");
//    
//    //check that recordId is not nil and not temporary
//    NSString *recordId = [LocalTalk localGetRecordId];
//    STAssertNotNil(recordId, @"recordId shouldn't be nil after insert");
//    STAssertFalse([recordId isEqualToString:@"tmpRecordId"], @"should have recordId from server");
//    
//    //Check that values were saved and restored properly
//    patientAfterSync.firstName = patientBeforeSync.firstName;
//    patientAfterSync.lastName = patientBeforeSync.lastName;
//    
//    /*
//     check whether question and answer data gets stored in local
//     */
//    NSString *val1 = @"value";
//    NSString *val2 = @"value with spaces";
//    success = [LocalTalk localStoreValue:val1 forQuestionId:@"QuestionId1"];
//    STAssertTrue(success, @"value not stored locally");
//    success = [LocalTalk localStoreValue:val2 forQuestionId:@"QuestionId2"];
//    STAssertTrue(success, @"value not stored locally");
//    
//    success = [SynchData syncDataForRecord:recordId];
//    STAssertTrue(success, @"Data not synced");
//    
//    [LocalTalk localClearPatientData];
//    
//    success = [LocalTalk loadPatientRecordIntoLocal:recordId];
//    STAssertTrue(success, @"patient record data not loaded");
//    
//    NSString *returnValue = [Question getValueForQuestionId:@"QuestionId1"];
//    STAssertEqualObjects(val1, returnValue, @"stored and retrieved value with no spaces");
//    
//    returnValue = [Question getValueForQuestionId:@"QuestionId2"];
//    STAssertEqualObjects(val2, returnValue, @"stored and retrieved value with spaces");
//    
//    [LocalTalk printLocal];
//    
//    /*
//     test whether recordings can be saved
//     */
//    
//    
//    /* Next step
//        -- delete patient from all tables and check whether load patient brings it back
//     */
//    
//    success = [DBTalk deletePatient:patientAfterSync.patientId];
//    STAssertTrue(success, @"Unable to delete patient");
//    
//    [LocalTalk localClearPatientData];
//}
//
//
//
//
//-(Patient *)createPatient {
//    NSBundle *myBundle = [NSBundle mainBundle];
//    NSString *imagePath = [myBundle pathForResource:@"Icon-72@2x" ofType:@"png"];
//    UIImage *image = [UIImage imageNamed:imagePath];
//    
//    Patient *patient = [[Patient alloc] initWithFirstName:@"Jean" MiddleName:@"Luc" LastName:@"Picard" ChiefComplaint:@"1" PhotoID:image];
//    return patient;
//}

@end
