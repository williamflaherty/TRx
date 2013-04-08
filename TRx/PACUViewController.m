//
//  PACUViewController.m
//  TRx
//
//  Created by Mark Bellott on 3/9/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#import "PACUViewController.h"
#import "LocalTalk.h"

@interface PACUViewController ()

@end

@implementation PACUViewController

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
	patientThumbnail = [LocalTalk localGetPortrait];
    [LocalTalk localGe]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
