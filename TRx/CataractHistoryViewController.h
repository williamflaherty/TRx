//
//  CataractHistoryViewController.h
//  TRx
//
//  Created by Mark Bellott on 3/27/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CataractHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UIButton *previous;
}

- (IBAction)previousView:(id)sender;
@end
