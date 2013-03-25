//
//  PatientListViewController.h
//  TRx
//
//  Created by Mark Bellott on 3/7/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PatientListViewController : UITableViewController {
    NSArray *patientsArray;
    NSMutableArray *patients;
    IBOutlet UIBarButtonItem *addPatientsButton;
}

-(IBAction)addPatients:(id)sender;
-(IBAction)refreshPatients:(id)sender;

@end
