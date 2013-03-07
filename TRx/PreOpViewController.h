//
//  PreOpViewController.h
//  TRx
//
//  Created by Mark Bellott on 3/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Patient.h"

@interface PreOpViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    Patient *newPatient;
    
    NSString *pName;
    complaint pComplaint;
    UIImage *photoID;
}

@property BOOL newMedia;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)useCamera:(id)sender;
- (IBAction)addPatient:(id)sender;

@end
