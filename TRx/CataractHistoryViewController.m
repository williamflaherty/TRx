//
//  CataractHistoryViewController.m
//  TRx
//
//  Created by Mark Bellott on 3/27/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "CataractHistoryViewController.h"

@interface CataractHistoryViewController ()

@end

@implementation CataractHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - back button clicked
- (void)previousView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
