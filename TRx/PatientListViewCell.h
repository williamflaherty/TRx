//
//  PatientListViewCell.h
//  TRx
//
//  Created by Dwayne Flaherty on 3/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientListViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *patientName;
@property (strong, nonatomic) IBOutlet UIImageView *patientPicture;
@property (strong, nonatomic) IBOutlet UILabel *chiefComplaint;

@end
