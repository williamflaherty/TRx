//
//  DynamicHistoryViewController.h
//  TRx
//
//  Created by Mark Bellott on 4/2/13.
//  Copyright (c) 2013 Team Ecuador. All rights reserved.
// 

#import <UIKit/UIKit.h>
#import "HistoryQuestionLabel.h"

@interface DynamicHistoryViewController : UIViewController{
    
    float availableSpace;
    NSInteger pageCount;
    NSString *questionText;
    HistoryQuestionLabel *mainQuestion;
    //UILabel *mainQuestion;
    
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
-(void) setPositionForQuestion:(HistoryQuestionLabel*)question;

@end
