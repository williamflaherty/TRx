//
//  HistoryViewController.m
//  TRx
//
//  Created by Mark Bellott on 3/9/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "HistoryViewController.h"
#import "DBTalk.h"
#import "AdminInformation.h"
#import "LocalTalk.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

@synthesize complaintPicker = _complaintPicker, birthdayPicker = _birthdayPicker;


- (void)viewDidLoad{
    [super viewDidLoad];

    newPatient = [[Patient alloc] initWithFirstName:@"Rob" MiddleName:@"D" LastName:@"woMan" ChiefComplaint:@"1" PhotoID:NULL];
    newPatient.birthday = 20010203;
    _complaintsArray = [AdminInformation getSurgeryNames];
    
    //_imageView.image = [UIImage imageNamed:@"PatientPhotoBlank.png"];
    
    firstNameText.delegate = self;
    middleNameText.delegate = self;
    lastNameText.delegate = self;


    //[LocalTalk localClearPatientData];
    //[LocalTalk localStorePatientId:@"3333"];
    //[LocalTalk localStoreRecordId:@"4444"];
//    NSString *patId = [LocalTalk localGetPatientId];
//    NSString *recId = [LocalTalk localGetRecordId];
//    
//    NSLog(@"HistViewCont : viewDidLoad --> patientId: %@", patId);
//    NSLog(@"HistViewCont : viewDidLoad --> recordId: %@", recId);
    //_complaintsArray = [DBTalk getSurgeryList];
    
    
    
    [LocalTalk localClearPatientData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIApplication* application = [UIApplication sharedApplication];
    
    if (application.statusBarOrientation != UIInterfaceOrientationLandscapeRight)
    {
        application.statusBarOrientation = UIInterfaceOrientationLandscapeRight;
    }
}

-(void) addPatient:(id)sender{
    //Idealy, I think we should call a DBTalk function called "addPatient" from here, passing it the newPatient object...
    //[DBTalk addPatient:newPatient];
    
    [self storeNames];
    if([firstName isEqualToString:@""] || [lastName isEqualToString:@""]){
        //return;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    //NSInteger day = _birthdayPicker;
    pBirthday = [NSString stringWithFormat:@"%@", [df stringFromDate:_birthdayPicker.date]];
                 
    
    /*
    NSString *bday = [NSString stringWithFormat:@"%d", newPatient.birthday];
    NSString *patientId = [DBTalk addUpdatePatient:newPatient.firstName middleName:newPatient.middleName
                                          lastName:newPatient.lastName birthday:bday patientId:NULL];
    */
    
    //Alert -- have hard-coded surgeryTypeId and doctorId for now
    //NSString *recordId = [DBTalk addRecord:patientId surgeryTypeId:@"1" doctorId:@"1" isActive:@"1" hasTimeout:@"0"];
    //The below method causes the appilication to crash
    
    //NSString *fakeId = @"31n000";
    //newPatient.photoID = [DBTalk getThumbFromServer:(fakeId)];
    //[DBTalk addPicture:newPatient.photoID pictureId:NULL patientId:@"40" customPictureName:NULL isProfile:@"1"];
    //[DBTalk addProfilePicture:newPatient.photoID patientId:@"50"];
    
    //NSLog(@"AddPatient button pressed:\npatientId: %@\nrecordId:%@\n", patientId, recordId);
}

#pragma mark - Camera Methods

- (void) useCamera:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
/*
    Crop and flip the image
    CGRect cropRect = CGRectMake(256, 152, 750, 750);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    UIImage *finalImage =   [UIImage imageWithCGImage:croppedImage.CGImage scale:1.0 orientation:UIImageOrientationDownMirrored];
*/
   
    //Store the image for the patient
    photoID = image;
    newPatient.photoID = image;
    
    //Display the final image
    _imageView.image = image;
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Complaint Picker Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return [_complaintsArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_complaintsArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //Set the newPatient's complaint to the picker 
    newPatient.chiefComplaint = [NSString stringWithFormat:@"%i",row];
    
}

#pragma mark - Text Field Methods

//Hide Keyboard on Touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[firstNameText resignFirstResponder];
    [middleNameText resignFirstResponder];
    [lastNameText resignFirstResponder];
}

//Store text in NSStrings
-(void) storeNames{
    firstName = [NSString stringWithFormat:@"%@",firstNameText.text];
    newPatient.firstName = firstName;
   
    middleName = [NSString stringWithFormat:@"%@",middleNameText.text];
    newPatient.middleName = middleName;
   
    lastName = [NSString stringWithFormat:@"%@",lastNameText.text];
    newPatient.lastName = lastName;
}

#pragma mark - Next button segues to next view controller

- (void)nextView:(id)sender {
    
    /*store essential Patient Meta Data into LocalDatabase before calling synchPatientData*/
    [LocalTalk localClearPatientData];
    
    [LocalTalk localStorePatientMetaData:@"birthDay" value:[NSString stringWithFormat:@"%d", newPatient.birthday]];
    [LocalTalk localStorePatientMetaData:@"firstName" value:newPatient.firstName];
    [LocalTalk localStorePatientMetaData:@"middleName" value:newPatient.middleName];
    [LocalTalk localStorePatientMetaData:@"lastName" value:newPatient.lastName];
//    [LocalTalk localStorePatientMetaData:@"firstName" value:@"Jerome"];
//    [LocalTalk localStorePatientMetaData:@"middleName" value:@"P"];
//    [LocalTalk localStorePatientMetaData:@"lastName" value:@"Armstrong"];
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
    
    
    /* Worse comes to worst, we comment this out before the presentation */
    [LocalTalk synchPatientData];

    
    [self performSegueWithIdentifier:@"nextViewController" sender:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"nextViewController"]){
        //UIViewController *vc = [segue destinationViewController];
        //this is where the code will go to "push" the data to the database on the
        //next button click
    }
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end

