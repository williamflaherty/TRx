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
#import "LocalTalkWrapper.h"
#import "LocalTalk.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

@synthesize complaintPicker = _complaintPicker, birthdayPicker = _birthdayPicker;


- (void)viewDidLoad{
    [super viewDidLoad];

    newPatient = [[Patient alloc] initWithFirstName:@"Rob" MiddleName:@"D" LastName:@"woMan" ChiefComplaint:@"1" PhotoID:NULL];
    newPatient.birthday = @"20010203";
    _complaintsArray = [AdminInformation getSurgeryNames];
    
    _imageView.image = [UIImage imageNamed:@"PatientPhotoBlank.png"];
    
    firstNameText.delegate = self;
    middleNameText.delegate = self;
    lastNameText.delegate = self;
    
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
    
    [self storeNames];
    
    if([firstName isEqualToString:@""] || [lastName isEqualToString:@""]){
        [Utility alertWithMessage:@"First and Last name must be filled out"];
        return;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterShortStyle;
    //NSInteger day = _birthdayPicker;
    pBirthday = [NSString stringWithFormat:@"%@", [df stringFromDate:_birthdayPicker.date]];
                 

    
    /* Take patient Object and add its information to the local database */
    [LocalTalkWrapper addPatientObjectToLocal:newPatient];
    [LocalTalkWrapper addNewPatientAndSynchData];
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

//NOTE: Temporarily disconnected from the next button....
- (void)nextView:(id)sender {
 
    [self storeNames];
    
    //Take patient Object and add its information to the local database
    [LocalTalkWrapper addPatientObjectToLocal:newPatient];
    [LocalTalkWrapper addNewPatientAndSynchData];

    [LocalTalk localStorePatientMetaData:@"surgeryTypeId" value:@"1"];//hardcoded unless Mark verifies working
    [LocalTalk localStorePatientMetaData:@"doctorId" value:@"1"]; //hardcoded unless Mark verifies working
    
    BOOL storedPic = [LocalTalk localStorePortrait:newPatient.photoID];
    if (!storedPic) {
        NSLog(@"Error storing portrait in HistoryViewController nextView");
    }
    
    //temporary values. nothing gets synched unless addPatient and addRecord
    //get called successfully and return the patientId and recordId
    [LocalTalk localStoreTempPatientId];
    [LocalTalk localStoreTempRecordId];
    
    
    //Worse comes to worst, we comment this out before the presentation 
    [LocalTalkWrapper addNewPatientAndSynchData];
    


    //[self performSegueWithIdentifier:@"nextViewController" sender:nil];
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

