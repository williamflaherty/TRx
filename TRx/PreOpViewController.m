//
//  PreOpViewController.m
//  TRx
//
//  Created by Mark Bellott on 3/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "PreOpViewController.h"

@interface PreOpViewController ()

@end

@implementation PreOpViewController

- (void)viewDidLoad{
    [super viewDidLoad];
}

-(void) addPatient:(id)sender{
    
    //newPatient = [newPatient initWithName:pName ChiefComplaint:pComplaint PhotoID:photoID];
    //photoID;
    //newPatient.
    
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

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
