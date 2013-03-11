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

@synthesize complaintPicker = _complaintPicker;

- (void)viewDidLoad{
    [super viewDidLoad];

    newPatient = [[Patient alloc] initWithFirstName:@"Jeff" MiddleName:@"The" LastName:@"Man" ChiefComplaint:@"" PhotoID:NULL];
    
    _complaintsArray = [AdminInformation getSurgeryNames];
    
    _imageView.image = [UIImage imageNamed:@"PatientPhotoBlank.png"];

    NSString *testLabel = [LocalTalk getEnglishLabel:@"preOp_ReasonForVisit"];
    NSLog(@"testing database get methods: English Label --> %@", testLabel);
    
    testLabel = [LocalTalk getSpanishLabel:@"preOp_ReasonForVisit"];
    NSLog(@"testing database get methods: Spanish Label --> %@", testLabel);

    
    //_complaintsArray = [DBTalk getSurgeryList];
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
    
    NSString *bday = [NSString stringWithFormat:@"%d", newPatient.birthday];
    NSString *patientId = [DBTalk addUpdatePatient:newPatient.firstName middleName:newPatient.middleName
                                          lastName:newPatient.lastName birthday:bday patientId:NULL];
    
    //Alert -- have hard-coded surgeryTypeId and doctorId for now
    NSString *recordId = [DBTalk addRecord:patientId surgeryTypeId:@"1" doctorId:@"1" isActive:@"1" hasTimeout:@"0"];
    //The below method causes the appilication to crash
    //[DBTalk addPicture:newPatient.photoID pictureId:NULL patientId:patientId customPictureName:NULL isProfile:@"1"];
    
    NSLog(@"AddPatient button pressed:\npatientId: %@\nrecordId:%@\n", patientId, recordId);
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
        //imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = YES;
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //Crop and flip the image
    CGRect cropRect = CGRectMake(256, 152, 750, 750);
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    UIImage *finalImage =   [UIImage imageWithCGImage:croppedImage.CGImage scale:1.0 orientation:UIImageOrientationDownMirrored];
    
    //Store the image for the patient
    photoID = finalImage;
    newPatient.photoID = finalImage;
    
    //Display the final image
    _imageView.image = finalImage;
    
   /* if (_newMedia)
        UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:finishedSavingWithError:contextInfo:),nil);
   */
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

#pragma mark - Picker Methods

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

#pragma mark 

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end

