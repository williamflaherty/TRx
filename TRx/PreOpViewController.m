//
//  PreOpViewController.m
//  TRx
//
//  Created by Mark Bellott on 3/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "PreOpViewController.h"
#import "DBTalk.h"

@interface PreOpViewController ()

@end

@implementation PreOpViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    /*
    pickerArray = [[NSMutableArray alloc] init];
    [pickerArray addObject:@"Cleft Lip"];
    [pickerArray addObject:@"Cataracts"];
    [pickerArray addObject:@"Hernia"];
    [pickerArray addObject:@"Not Specified"];
    */
    
    _complaintsArray = [DBTalk getSurgeryList];

}

-(void) addPatient:(id)sender{
    NSString *bday = [NSString stringWithFormat:@"%d", newPatient.birthday];
    NSString *patientId = [DBTalk addUpdatePatient:newPatient.firstName middleName:newPatient.middleName
                                          lastName:newPatient.lastName birthday:bday patientId:NULL];
    
    //Alert -- have hard-coded surgeryTypeId and doctorId for now
    NSString *recordId = [DBTalk addRecord:patientId surgeryTypeId:@"1" doctorId:@"1" isActive:@"1" hasTimeout:@"0"];
    [DBTalk addPicture:photoID pictureId:NULL patientId:patientId customPictureName:NULL isProfile:@"1"];
    
    NSLog(@"AddPatient button pressed:\npatientId: %@\nrecordId:%@\n", patientId, recordId);
}

- (void) useCamera:(id)sender
{
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

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    //Store the image for the patient 
    photoID = image;
    
    _imageView.image = image;
    if (_newMedia)
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       @selector(image:finishedSavingWithError:contextInfo:),
                                       nil);
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
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

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    
    NSLog(@"Selected Color: %@. Index of selected color: %i", [_complaintsArray objectAtIndex:row], row);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
