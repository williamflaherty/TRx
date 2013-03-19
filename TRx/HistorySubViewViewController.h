//
//  HistorySubViewViewController.h
//  TRx
//
//  Created by Dwayne Flaherty on 3/12/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistorySubViewViewController : HistoryViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UIButton *previous;
}
- (IBAction)previousView:(id)sender;
@end
