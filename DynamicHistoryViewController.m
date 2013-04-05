//
//  DynamicHistoryViewController.m
//  TRx
//
//  Created by Mark Bellott on 4/2/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#define MAX_Y 900.0f
#define MIN_Y 200.0f

#import "DynamicHistoryViewController.h"

@interface DynamicHistoryViewController ()

@end

@implementation DynamicHistoryViewController

#pragma mark - IBAction Methods

-(IBAction)backPressed:(id)sender{
    if(pageCount == 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self loadPreviousQuestion];
        pageCount--;
    }
}

-(IBAction)nextPressed:(id)sender{
    [self loadNextQuestion];
    pageCount++;
}

#pragma mark - Init Methods

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initialSetup];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void) initialSetup{
    
    pageCount = 1;
    availableSpace = MAX_Y - MIN_Y;
    mainQuestion = [[HQLabel alloc]init];
    [mainQuestion setFont:[UIFont systemFontOfSize:20]];
    [mainQuestion setTextColor:[UIColor blackColor]];
    
    [self initializeQueue];
    [self loadNextQuestion];
}

#pragma mark - Question Loading Methods

-(void) initializeQueue{
    //Initialize the Question Queue
}

-(void) loadNextQuestion{
    //Load Question from the Queue, Hard coded for now...
    
    if(pageCount != 1){
        [self dismissCurrentQuestion];
    }
    
    mainQuestion.text = @"TEST QUESTION!";
    [self setPositionForQuestion:mainQuestion];
    
    [self.view addSubview:mainQuestion];
    
}

-(void) loadPreviousQuestion{
    if(pageCount == 1){
        return;
    }
    
    [self dismissCurrentQuestion];
    
}

-(void) dismissCurrentQuestion{
    [mainQuestion removeFromSuperview];
}

-(void) setPositionForQuestion:(HQLabel *)question{

}

@end
