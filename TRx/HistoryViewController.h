//
//  HistoryViewController.h
//  TRx
//
//  Created by Mark Bellott on 3/9/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Patient.h"
#import "PatientListViewController.h"

@interface HistoryViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    
    Patient *newPatient;

    NSString *pName;
    NSString *pComplaint;
    UIImage *photoID;
    
    IBOutlet UIPickerView *complaintPicker;
    PatientListViewController *p;
}

@property BOOL newMedia;
@property (nonatomic, strong) NSMutableArray *complaintsArray;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UITextField *firstNameText;
@property (nonatomic, retain) IBOutlet UITextField *middleNameText;
@property (nonatomic, retain) IBOutlet UITextField *lastNameText;
@property (nonatomic, retain) IBOutlet UIPickerView *complaintPicker;

- (IBAction)useCamera:(id)sender;
- (IBAction)addPatient:(id)sender;

@end