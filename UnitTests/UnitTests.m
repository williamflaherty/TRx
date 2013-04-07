//
//  UnitTests.m
//  UnitTests
//
//  Created by John Cotham on 3/28/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "UnitTests.h"


@implementation UnitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

-(void)testAddPatient {
    NSString *patientId = [DBTalk addPatient:@"Ftest" middleName:@"mTest" lastName:@"lTest" birthday:@"19850819"];
    STAssertNotNil(patientId, @"Failed to create new patient");

    //check that no duplicate patient is added
    NSString *failId = [DBTalk addPatient:@"Ftest" middleName:@"mTest" lastName:@"lTest" birthday:@"19850819"];
    STAssertEqualObjects(failId, nil, @"addPatient should fail");
    
    BOOL success = [DBTalk deletePatient:patientId];
    STAssertTrue(success, @"Unable to delete patient");
    
    //check that no last name fails
    failId = [DBTalk addPatient:@"" middleName:@"" lastName:@"lTest" birthday:@"20130912"];
    STAssertEqualObjects(failId, nil, @"addPatient should fail with no firstName");
    
    //check that no first name fails
    failId = [DBTalk addPatient:@"fName" middleName:@"" lastName:@"" birthday:@"20130912"];
    STAssertEqualObjects(failId, nil, @"addPatient should fail with no lastName");
    
    patientId = NULL;
    
    //check that addPatient works without a middle name
    patientId = [DBTalk addPatient:@"fTest" middleName:@"" lastName:@"lTest" birthday:@"19850819"]; //or with null instead of ""
    STAssertNotNil(patientId, @"Failed to add new patient no middle name");
    success = [DBTalk deletePatient:patientId];
    STAssertTrue(success, @"Unable to delete patient");
    
    //check that I can add names that have spaces and hyphens
    patientId = [DBTalk addPatient:@"f-Test" middleName:@"spaced mName" lastName:@"spaced lName" birthday:@"20081010"];
    STAssertNotNil(patientId, @"Failed to add patient with spaces and hyphens in name");
    success = [DBTalk deletePatient:patientId];
    STAssertTrue(success, @"Unable to delete patient");
}

-(void)testAddUpdatePatient {
    NSString *patientId = [DBTalk addPatient:@"Ftest" middleName:@"mTest" lastName:@"lTest" birthday:@"19850819"];
    STAssertNotNil(patientId, @"Failed to create new patient");
    
    //test update function
    NSString *newPatientId = [DBTalk addUpdatePatient:@"changeF" middleName:@"changeM" lastName:@"changeL"
                                             birthday:@"19921201" patientId:patientId];
    STAssertNotNil(patientId, @"Failed to update patient");
    STAssertEqualObjects(patientId, newPatientId, @"Same patientId returned");
    
    NSArray *metadata = [DBTalk getPatientMetaData:patientId];
    NSDictionary *dic = metadata[0];
    NSString *newFName = [dic objectForKey:@"FirstName"];
    STAssertEqualObjects(newFName, @"changeF", @"Name not updated as expected");
    
    BOOL success = [DBTalk deletePatient:patientId];
    STAssertTrue(success, @"Unable to delete patient");
}

-(void)testAddRecord {
    NSString *patientId = [DBTalk addPatient:@"fName" middleName:@"" lastName:@"lName" birthday:@"19751010"];
    STAssertNotNil(patientId, @"Failed to create patient");
    NSString *recordId = [DBTalk addRecord:patientId surgeryTypeId:@"1" doctorId:@"1" isActive:@"1" hasTimeout:@"0"];
    STAssertNotNil(recordId, @"Failed to add new record");
    
    //check  that multiple records can be added
    NSString *secondId = [DBTalk addRecord:patientId surgeryTypeId:@"2" doctorId:@"1" isActive:@"1" hasTimeout:@"0"];
    STAssertNotNil(secondId, @"failed to add second record for patient");
    STAssertFalse([recordId isEqualToString:secondId], @"Id's for different records should be different");
    
    NSString *thirdId = [DBTalk addRecord:patientId surgeryTypeId:@"-1" doctorId:@"1" isActive:@"1" hasTimeout:@"0"];
    STAssertEqualObjects(thirdId, @"0", @"addRecord should fail with invalid surgeryTypeId");
    
    NSString *fourthId = [DBTalk addRecord:patientId surgeryTypeId:@"1" doctorId:@"-1" isActive:@"1" hasTimeout:@"0"];
    STAssertEqualObjects(fourthId, @"0", @"addRecord should fail with invalid doctorId");
    
    NSString *fifthId = [DBTalk addRecord:patientId surgeryTypeId:@"1" doctorId:NULL isActive:@"1" hasTimeout:@"0"];
    STAssertNotNil(fifthId, @"Should be able to add record with NULL doctorId");
    
    BOOL success = [DBTalk deletePatient:patientId];
    STAssertTrue(success, @"Unable to delete patient");
}

-(void)testAddValueForQuestionId {
    //add patient to Database
//    NSString *patientId = [DBTalk addPatient:@"Ftest" middleName:@"mTest" lastName:@"lTest" birthday:@"19850819"];
//    STAssertNotNil(patientId, @"Failed to create new patient");
//    
//    //add patient record to Database
//    NSString *recordId = [DBTalk addRecord:patientId surgeryTypeId:@"1" doctorId:@"1" isActive:@"1" hasTimeout:@"0"];
//    STAssertNotNil(recordId, @"Failed to add new record");
//    
//    //Sync patient
//    
//    
//    //add value to local
//    BOOL added = [LocalTalk localStoreValue:@"OneWord" forQuestionId:@"preOp_HowLong"];
//    STAssertTrue(added, @"Failed to add value to local");
//    
//    //sync data
    
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}



@end
