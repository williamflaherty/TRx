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
}

@property (nonatomic, strong) NSArray *patientsArray;
//@property (nonatomic, strong) NSMutableArray *patients;  //this was causing warnings am going to leave it commented for now -John



@end
