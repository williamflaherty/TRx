//
//  DynamicHistoryViewController.m
//  TRx
//
//  Created by Mark Bellott on 4/2/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
//

#define MAX_Y 50.0f
#define MIN_Y 500.0f
#define ENG_X 50.0f
#define TRANS_X 550.0f

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
    pageCount++;
    [self loadNextQuestion];
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
    
    mainQuestion = [[HQView alloc]init];
    
    currentPage = [[NSMutableArray alloc] init];
    previousPages = [[NSMutableArray alloc] init];
    
    [self initializeQueue];
    [self loadNextQuestion];
    //pageCount++;
}

#pragma mark - Question Loading Methods

-(void) initializeQueue{
    
}

-(void) loadNextQuestion{
    //Load Question from the Queue, Hard coded for now...
    
    if(pageCount != 0){
        [previousPages addObject:mainQuestion];
    }
    
    HQView *newQuestion = [[HQView alloc] init];
    
    if(pageCount != 1){
        [self dismissCurrentQuestion];
    }
    
    if(pageCount == 1){
        newQuestion.type = TEXT_ENTRY;
        [newQuestion setQuestionLabelText:[Question getEnglishLabel:@"preOp_HowLong"]];
    }
    else if(pageCount == 2){
        newQuestion.type = YES_NO;
        [newQuestion setQuestionLabelText:[Question getEnglishLabel:@"preOp_PreventWorking"]];
    }
    else if(pageCount == 3){
        newQuestion.type = MULTIPLE_SELECTION;
        [newQuestion setQuestionLabelText:[Question getEnglishLabel:@"preOp_HaveMedicalProblems"]];
    }
    else{
        return;
    }
    
    [newQuestion buildQuestionOfType:newQuestion.type];
    [self setPositionForQuestion:newQuestion];
    
    mainQuestion = newQuestion;
    
    [self.view addSubview:mainQuestion];
    
}

-(void) loadPreviousQuestion{
    if(pageCount == 1){
        return;
    }
    
    [self dismissCurrentQuestion];
    
    mainQuestion = [previousPages lastObject];
    [previousPages removeLastObject];
    [self.view addSubview:mainQuestion];
    
}

-(void) dismissCurrentQuestion{
    [mainQuestion removeFromSuperview];
}

-(void) setPositionForQuestion:(HQView *)q{
    q.frame = CGRectMake(ENG_X, MAX_Y, q.frame.size.width, q.frame.size.height);
}

@end
