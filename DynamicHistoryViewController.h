//
//  DynamicHistoryViewController.h
//  TRx
//
//  Created by Mark Bellott on 4/2/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "Question.h"
#import "HQView.h"

@interface DynamicHistoryViewController : UIViewController{
    
    float availableSpace;
    NSInteger pageCount;
    NSString *questionText;
    HQView *mainQuestion;
    
    
    //Arrays of Questions for storage
    NSMutableArray *currentPage;
    NSMutableArray *previousPages;
    
    IBOutlet UIButton *backButton, *nextButton;
    
}

//IBActions
-(IBAction)nextPressed:(id)sender;
-(IBAction)backPressed:(id)sender;

//Initial Methods
-(void) initialSetup;
-(void) initializeQueue;

//Question Handling Methods
-(void) loadNextQuestion;
-(void) loadPreviousQuestion;
-(void) dismissCurrentQuestion;
-(void) setPositionForQuestion:(HQView*)question;

@end
